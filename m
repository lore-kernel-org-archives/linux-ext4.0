From: Olaf Hering <olaf@aepfle.de>
Subject: Re: ext3_dx_add_entry complains about Directory index full
Date: Wed, 4 Feb 2015 14:52:16 +0100
Message-ID: <20150204135215.GA15159@aepfle.de>
References: <20150204090447.GA20003@aepfle.de>
 <FCD1EFFD-330A-4953-8CF4-AC88D297F433@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:39506 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbbBDN6e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2015 08:58:34 -0500
Content-Disposition: inline
In-Reply-To: <FCD1EFFD-330A-4953-8CF4-AC88D297F433@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 04, Andreas Dilger wrote:

> How many files/subdirs in this directory?  The old ext3 limit was 32000
> subdirs, which the dir_index fixed, but the new limit is 65000 subdirs
> without "dir_index" enabled.

See below:

> > # for t in d f l ; do echo "type $t: `find /media/BACKUP_OLH_500G/ -xdev -type $t | wc -l`" ; done
> > type d: 1051396
> > type f: 20824894
> > type l: 6876

> The 65000 subdir limit can be exceeded by turning on the "dir_nlink"
> feature of the filesystem with "tune2fs -O dir_nlink", to allow an
> "unlimited" number of subdirs (subject to other directory limits, about
> 10-12M entries for 16-char filenames).

I enabled this using another box, which turned the thing into an ext4
filesystem. Now ext4_dx_add_entry complains.

> The other potential problem is if you create and delete a large number
> of files from this directory, then the hash tables can become full and
> the leaf blocks are imbalanced and some become full even when many others
> are not (htree only has an average leaf fullness of 3/4 of each block).
> This could probably happen if you have more than 5M files in a long-lived
> directory in your backup fs.  This can be fixed (for some time at least)
> via "e2fsck -fD" on the unmounted filesystem to compact the directories.

Ok, will try that. Thanks.

Olaf
