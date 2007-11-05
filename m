From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 5 Nov 2007 10:15:33 +0800
Message-ID: <20071105021533.GA3055@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:47842 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXKECPz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Nov 2007 21:15:55 -0500
Content-Disposition: inline
In-Reply-To: <E1IooAl-0006SJ-Ki@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 04, 2007  17:42 -0500, Theodore Ts'o wrote:
> * js/uninit (Sun Oct 21 21:04:24 2007 -0500) 14 commits
>  - Add m_uninit test case.
>  - Add new mm_lazy test case.
>  - Fix test cases.

Do you have all of the f_uninit test cases we made?

f_uninit_bad_free_inodes
f_uninit_blk_used_not_set
f_uninit_checksum_bad
f_uninit_disable
f_uninit_enable
f_uninit_inode_past_unused
f_uninit_last_uninit
f_uninit_set_inode_not_set

>  - Update uninit block group documetation for some of the utilities.
>  - Make e2fsck uninit block group aware.
>  - Make debugfs uninit block group aware.
>  - Make resize2fs uninit block group aware.
>  - Make dumpe2fs uninit block group aware.
>  - Make tune2fs uninit block group aware.
>  - Add support for creating filesystems using uninit block group.
>  - Rename feature name from gdt_checksum to uninit_groups.
>  - Add uninit block group support on libe2fs.
>  - Add initial checksum support.
>  + Reorder some of the $(SRCS) in alphabetical order.
> 
> 	This still doesn't pass "make check" in lib/ext2fs, but I'll
> 	take a closer look at this in the near future.

That's a bit of a surprise, since the e2fsprogs-uninit patches in
our own CVS repo pass "make check".

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
