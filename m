From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Sat, 26 Jul 2014 21:46:20 +0800
Message-ID: <53D3B12C.5040703@fnarfbargle.com>
References: <53CBA75B.2030102@fnarfbargle.com> <53CC66DA.2080804@fnarfbargle.com> <20140725081312.GO6397@azat> <53D24307.6050903@fnarfbargle.com> <20140725140715.GR1865@thunk.org> <53D320F6.40809@fnarfbargle.com> <20140726124557.GB6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Azat Khuzhin <a3at.mail@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([103.4.17.7]:33315 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaGZNq1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 09:46:27 -0400
In-Reply-To: <20140726124557.GB6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 26/07/14 20:45, Theodore Ts'o wrote:
> OK, it looks like the e2fsprogs patch got you through the first
> hurdle, but the failure is something that made no sense at first:
>
>> [489412.650430] EXT4-fs (md0): resizing filesystem from 5804916736 to
>> 5860149888 blocks
>> [489412.700282] EXT4-fs warning (device md0): verify_reserved_gdb:713:
>> reserved GDT 2769 missing grp 177147 (5804755665)
> The code path which emitted the above warning something that should
> ever be entered for file systems greater than 16TB.  But then I took a
> look at the first message that you sent on this thread, and I think
> see what's going wrong.  From your dumpe2fs -h output:
>
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
> extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
> extra_isize
> Block count:              5804916736
> Reserved GDT blocks:      585
>
> If the block count is greater than 2**32 (4294967296), resize_inode
> must not be set, and reserved GDT blocks should be zero.  So this is
> definitely not right.
>
> I'm going to guess that this file system was originally a smaller size
> (and probably smaller than 16T), and then was resized to 22TB,
> probably using an earlier version of the kernel and/or e2fsprogs.  Is
> my guess correct?  If so, do you remember the history of what size the
> file system was, and in what steps it was resized, and what version of
> the e2fsprogs and the kernel that was used at each stage, starting
> from the original mke2fs and each successive resize?
>
This was the first resize of this FS. Initially this array was about 
15T. About 12 months ago I attempted to resize it up to 19T and bumped 
up against the fact I had not created the initial filesystem with 64 bit 
support, so I cobbled together some storage and did a 
backup/create/restore. At that point I would probably have specified 
resize_inode manually as an option (as reading the man page it looked 
like a good idea as I always had plans to expand in future) to mke2fs 
along with 64bit. Fast forward 12 months and I've added 2 drives to the 
array and bumped up against this issue. So it was initially 4883458240 
blocks. It would have been created with e2fsprogs from Debian Stable (so 
1.42.5).

I can't test this to verify my memory however as I don't seem to be able 
to create a sparse file large enough to create a filesystem in. I appear 
to be bumping up against a 2T filesize limit.

-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

