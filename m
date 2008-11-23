From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Sun, 23 Nov 2008 09:00:38 -0500
Message-ID: <20081123140038.GC26473@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38344 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775AbYKWOA4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 09:00:56 -0500
Content-Disposition: inline
In-Reply-To: <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 10:14:33PM +0530, Aneesh Kumar K.V wrote:
> We need to make sure we update the block bitmap and clear
> EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held. We look
> at EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each
> time in ext4_read_block_bitmap (introduced by
> c806e68f5647109350ec546fee5b526962970fd2 )

You are changing mb_clear_bits() and and mb_set_bits() so they take
the spinlock over the entire operaiton, instead of over each
particular bit.  These function are used in a largish number of
places, not just for updating the block bitmap, but also the mb buddy
bitmaps, etc.  So there may be a scalability impact here, although
taking the spinlock once instead of multiple times is probably a win.

My bigger concern is given that we are playing games like *this*:

		if ((cur & 31) == 0 && (len - cur) >= 32) {
			/* fast path: set whole word at once */
			addr = bm + (cur >> 3);
			*addr = 0xffffffff;
			cur += 32;
			continue;
		}

without taking a lock, I'm a little surprised we haven't been
seriously burned by other race conditions.  What's the point of
calling mb_set_bit_atomic() and passing in a spinlock if we are doing
this kind of check without the protection of the same spinlock?!?

Andreas, if you are using mb_clear_bits() and mb_set_bits() in
Lustre's mballoc.c with this in production, you may want to take a
look at this patch.

						- Ted
