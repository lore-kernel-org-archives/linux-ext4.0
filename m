From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext3_dx_add_entry complains about Directory index full
Date: Wed, 4 Feb 2015 14:32:35 -0700
Message-ID: <D7ACB97A-5960-4D68-868A-7547B36160C4@dilger.ca>
References: <20150204090447.GA20003@aepfle.de> <FCD1EFFD-330A-4953-8CF4-AC88D297F433@dilger.ca> <20150204135215.GA15159@aepfle.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37469 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbbBDVci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2015 16:32:38 -0500
Received: by pdbfp1 with SMTP id fp1so3184850pdb.4
        for <linux-ext4@vger.kernel.org>; Wed, 04 Feb 2015 13:32:38 -0800 (PST)
In-Reply-To: <20150204135215.GA15159@aepfle.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 4, 2015, at 6:52 AM, Olaf Hering <olaf@aepfle.de> wrote:
> On Wed, Feb 04, Andreas Dilger wrote:
> 
>> How many files/subdirs in this directory?  The old ext3 limit was 32000
>> subdirs, which the dir_index fixed, but the new limit is 65000 subdirs
>> without "dir_index" enabled.
> 
> See below:
> 
>>> # for t in d f l ; do echo "type $t: `find /media/BACKUP_OLH_500G/ -xdev -type $t | wc -l`" ; done
>>> type d: 1051396
>>> type f: 20824894
>>> type l: 6876

Is "BACKUP_OLH_500G" a single large directory with 1M directories and
20M files in it?  In that case, you are hitting the limits for the
current ext4 directory size with 20M+ entries.

Otherwise, I would expect you have subdirectories, and the link/count
limits are per directory so getting these numbers for the affected
directory are what is important.

Running something like http://www.pdsi-scidac.org/fsstats/ can give
you a good idea of what the file/directory size/age/counts min/max/avg
distributions are like for your filesystem.

Finding the largest directories with something like:

    find /media/BACKUP_OLH_500G -type d -size +10M -ls

would tell us how big your directories actually are.  The fsstats data
will also tell you what the min/max/avg filename length is, which may
also be a factor.

It would be surprising that you have such a large directory in a single
backup.  We typically test up to 10M files in a single directory.

> root@linux-fceg:~ # time env -i /sbin/e2fsck -fDvv /dev/mapper/luks-861f1f73-7037-486a-9a8a-8588367fcf33
> e2fsck 1.42.12 (29-Aug-2014)
>      859307 regular files
>     1026949 directories
>    19504583 links

This implies that you have only 1.8M in-use files, while the above
reports 20M filenames, almost all of them hard links (about 23 links
per file).  That said, the error being reported is on the name insert
and not on the link counts, so either there are some directories with
huge numbers of files or the file names are so long that it causes
the directory leaves to fill up very quickly. 

> Block size:               1024

AH! This is the root of your problem.  Formatting with 1024-byte
blocks means that the two-level directory hash tree can only hold
about 128^2 * (1024 / filename_length * 3 / 4) entries, maybe 500k
entries or less if the names are long.

This wouldn't be the default for a 500GB filesystem, but maybe you
picked that to optimize space usage of small files a bit?  Definitely
1KB blocksize is not optimal for performance, and 4KB is much better.

Unfortunately, you need to reformat to get to 4kB blocks.

Cheers, Andreas





