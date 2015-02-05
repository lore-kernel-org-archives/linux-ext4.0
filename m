From: Olaf Hering <olaf@aepfle.de>
Subject: Re: ext3_dx_add_entry complains about Directory index full
Date: Thu, 5 Feb 2015 10:19:33 +0100
Message-ID: <20150205091933.GA32546@aepfle.de>
References: <20150204090447.GA20003@aepfle.de>
 <FCD1EFFD-330A-4953-8CF4-AC88D297F433@dilger.ca>
 <20150204135215.GA15159@aepfle.de>
 <D7ACB97A-5960-4D68-868A-7547B36160C4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:20302 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbbBEJTg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2015 04:19:36 -0500
Content-Disposition: inline
In-Reply-To: <D7ACB97A-5960-4D68-868A-7547B36160C4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 04, Andreas Dilger wrote:

> On Feb 4, 2015, at 6:52 AM, Olaf Hering <olaf@aepfle.de> wrote:
> > On Wed, Feb 04, Andreas Dilger wrote:
> > 
> >> How many files/subdirs in this directory?  The old ext3 limit was 32000
> >> subdirs, which the dir_index fixed, but the new limit is 65000 subdirs
> >> without "dir_index" enabled.
> > 
> > See below:
> > 
> >>> # for t in d f l ; do echo "type $t: `find /media/BACKUP_OLH_500G/ -xdev -type $t | wc -l`" ; done
> >>> type d: 1051396
> >>> type f: 20824894
> >>> type l: 6876
> 
> Is "BACKUP_OLH_500G" a single large directory with 1M directories and
> 20M files in it?  In that case, you are hitting the limits for the
> current ext4 directory size with 20M+ entries.

Its organized in subdirs named hourly.{0..23} daily.{0.6} weekly.{0..3}
monthly.{0..11}.

> Finding the largest directories with something like:
> 
>     find /media/BACKUP_OLH_500G -type d -size +10M -ls
> 
> would tell us how big your directories actually are.  The fsstats data
> will also tell you what the min/max/avg filename length is, which may
> also be a factor.

There is no output from this find command for large directories.

> > Block size:               1024
> 
> AH! This is the root of your problem.  Formatting with 1024-byte
> blocks means that the two-level directory hash tree can only hold
> about 128^2 * (1024 / filename_length * 3 / 4) entries, maybe 500k
> entries or less if the names are long.
> 
> This wouldn't be the default for a 500GB filesystem, but maybe you
> picked that to optimize space usage of small files a bit?  Definitely
> 1KB blocksize is not optimal for performance, and 4KB is much better.

Yes, I used 1024 blocksize to not waste space for the many small files.

I wonder what other filesystem would be able to cope? Does xfs or btrfs
do any better for these kind of data?

Thanks for the feedback!

Olaf
