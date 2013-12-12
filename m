From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/74] libext2fs: use ext2fs_punch() to truncate quota
 file
Date: Thu, 12 Dec 2013 15:56:10 -0500
Message-ID: <20131212205610.GA23888@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011843.30655.22033.stgit@birch.djwong.org>
 <20131212172840.GD13547@thunk.org>
 <20131212173634.GE13547@thunk.org>
 <20131212200709.GG10150@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39508 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab3LLU4R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 15:56:17 -0500
Content-Disposition: inline
In-Reply-To: <20131212200709.GG10150@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 12, 2013 at 12:07:09PM -0800, Darrick J. Wong wrote:
> 
> Hmm, I'll try to reproduce it here; which test is failing?
> 
> It's possible that I fubar'd the ordering when I resorted the patches just
> prior to sending them out. :/

It's failing when I apply this patch against both maint and next, so
you may be quite right that it's commit ordering issue.

The failing test was t_quota_2off; it looks like punch wasn't
adjusting the block bitmap correctly?

					- Ted

tune2fs 1.43-WIP (8-Jul-2013)
e2fsck 1.43-WIP (8-Jul-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(12--15)
Fix? yes

Free blocks count wrong for group #0 (84, counted=88).
Fix? yes

Free blocks count wrong (84, counted=88).
Fix? yes


/tmp/e2fsprogs-tmp.fMP6jN: ***** FILE SYSTEM WAS MODIFIED *****
/tmp/e2fsprogs-tmp.fMP6jN: 11/64 files (0.0% non-contiguous), 12/100 blocks


