From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext3_dx_add_entry complains about Directory index full
Date: Thu, 5 Feb 2015 23:52:35 -0700
Message-ID: <DAB575EA-AC51-468F-AFB1-76CD455DE2D7@dilger.ca>
References: <20150204090447.GA20003@aepfle.de> <FCD1EFFD-330A-4953-8CF4-AC88D297F433@dilger.ca> <20150204135215.GA15159@aepfle.de> <D7ACB97A-5960-4D68-868A-7547B36160C4@dilger.ca> <20150205091933.GA32546@aepfle.de>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52681 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbbBFGwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Feb 2015 01:52:38 -0500
Received: by mail-pa0-f54.google.com with SMTP id kx10so209471pab.13
        for <linux-ext4@vger.kernel.org>; Thu, 05 Feb 2015 22:52:37 -0800 (PST)
In-Reply-To: <20150205091933.GA32546@aepfle.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 5, 2015, at 2:19 AM, Olaf Hering <olaf@aepfle.de> wrote:
> On Wed, Feb 04, Andreas Dilger wrote:
>> 
>> Finding the largest directories with something like:
>> 
>>    find /media/BACKUP_OLH_500G -type d -size +10M -ls
>> 
>> would tell us how big your directories actually are.  The fsstats data
>> will also tell you what the min/max/avg filename length is, which may
>> also be a factor.
> 
> There is no output from this find command for large directories.

I tested a 1KB blocksize filesystem, and the actual directory size was
only about 1.8MB when it ran out of space in the htree.  That worked
out to be about 250k 12-character filenames in a single directory.

Even doubling the blocksize to 2KB you would get 2^3=8x as many
entries in the directory (twice as many internal blocks in each of
the two htree levels, and the leaf blocks are twice as large).
That would give you about 2M entries in a single directory, and I
doubt it would significantly impact the space usage unless you are
mostly backing up small files.

>>> Block size:               1024
>> 
>> AH! This is the root of your problem.  Formatting with 1024-byte
>> blocks means that the two-level directory hash tree can only hold
>> about 128^2 * (1024 / filename_length * 3 / 4) entries, maybe 500k
>> entries or less if the names are long.
>> 
>> This wouldn't be the default for a 500GB filesystem, but maybe you
>> picked that to optimize space usage of small files a bit?  Definitely
>> 1KB blocksize is not optimal for performance, and 4KB is much better.
> 
> Yes, I used 1024 blocksize to not waste space for the many small files.

>>> Inode count:              26214400
>>> Block count:              419430400
>>> Reserved block count:     419430
>>> Free blocks:              75040285
>>> Free inodes:              24328812

You are using (419430400 - 75040285 - 419430) = 343970685 blocks
for (26214400 - 24328812) = 1885588 files, which is an average
file size of 182KB.  You currently "waste" about half a block per
file (0.5KB/file), so 1885588 * 0.5 = 920MB = 1/500 = 0.2% of your
filesystem due to partially-used blocks at the end of every file.
With a 2KB blocksize this would increase to about 1840MB or 0.4%,
which really isn't very much space on a modern drive.

>>>   # of inodes with ind/dind/tind blocks: 163156/45817/319


However, there would also be increased efficiency because of fewer
index blocks. These indirect blocks are currently at least
163156 + 45817 * (1024 / 4 / 2 + 1) + 319 * (1024 / 4 + 1) = 6155532 KB
or 6011MB of space, which is much more than you have saved due to
having the small blocksize.

If you formatted the filesystem with "-t ext4" (enables "extents" among
other things) there would likely be no indirect/index blocks at all since
extent-mapped inodes can directly address 256MB directly from the inode
(assuming fragmentation is not too bad) on a 2KB blocksize filesystem.

You get other benefits from reformatting with "-t ext4" like flex_bg
and uninit_bg that can speed up e2fsck times significantly.

> I wonder what other filesystem would be able to cope? Does xfs or btrfs
> do any better for these kind of data?

I can't really say, since I've never used those filesystems.  I suspect
you could do much better to increase the blocksize on ext4 than what
you have now.

Cheers, Andreas





