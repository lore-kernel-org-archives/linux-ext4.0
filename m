From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext3: bogus i_mode errors with 2.6.18.1
Date: Mon, 23 Oct 2006 10:44:16 -0600
Message-ID: <20061023164416.GM3509@schatzie.adilger.int>
References: <20061023144556.GY22487@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932175AbWJWQoT@vger.kernel.org>
To: Andre Noll <maan@systemlinux.org>
Content-Disposition: inline
In-Reply-To: <20061023144556.GY22487@skl-net.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 23, 2006  16:45 +0200, Andre Noll wrote:
> stress tests on a 6.3T ext3 filesystem which runs on top of software
> raid 6 revealed the following:
> 
> [663594.224641] init_special_inode: bogus i_mode (4412)
> [663596.355652] init_special_inode: bogus i_mode (5123)
> [663596.355832] init_special_inode: bogus i_mode (71562)

This would appear to be inode table corruption.

> [663763.319514] EXT3-fs error (device md0): ext3_new_block: Allocating block in system zone - blocks from 517570560, length 1

This is bitmap corruption.

> [663763.339423] EXT3-fs error (device md0): ext3_free_blocks: Freeing blocks in system zones - Block = 517570560, count = 1

Hmm, this would appear to be a buglet in error handling.  If the block just
allocated above is in the system zone it should be marked in-use in the
bitmap but otherwise ignored.  We definitely should NOT be freeing it on
error.

Yikes!  It seems a patch I submitted to 2.4 that fixed the behaviour
of ext3_new_block() so that if we detect this block shouldn't be
allocated it is skipped instead of corrupting the filesystem if it
is running with errors=continue...

It looks like ext3_free_blocks() needs a similar fix - i.e. report an
error and don't actually free those blocks.

> This system is currently not in production use, so I can use it for tests ATM.

I would suggest that you give this a try on RAID5, just for starters.
I'm not aware of any problems in the existing ext3 code for anything
below 8TB.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
