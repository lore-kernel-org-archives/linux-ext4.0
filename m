From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH -V2 5/5] ext4: Fix the race between read_inode_bitmap
	and ext4_new_inode
Date: Sun, 23 Nov 2008 23:05:24 -0500
Message-ID: <20081124040524.GD2163@mit.edu>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60613 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbYKXEKf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2008 23:10:35 -0500
Content-Disposition: inline
In-Reply-To: <1227285875-18011-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 10:14:35PM +0530, Aneesh Kumar K.V wrote:
> We need to make sure we update the inode bitmap and clear
> EXT4_BG_INODE_UNINIT flag with sb_bgl_lock held. We look
> at EXT4_BG_INODE_UNINIT and reinit the inode bitmap each
> time in ext4_read_inode_bitmap (introduced by
> c806e68f5647109350ec546fee5b526962970fd2 )

OK, I believe I've checked in all of your patches in this series into
the ext4 patch queue

Some of them have comments that still need to be cleared; this one in
particular needs a better commit comment, and ideally a comment for
the new function ext4_claim_inode().

Also, please don't rename variables unnecessarily; if you really think
it's needed, please do so in a separate patch.  The renaming of
variables makes it much harder to review the patch, since it bloats
the patch, and obscures the true changes happening in the patch.
Please explain why you are making some of the changes you made in the
patch.  In particular, why does it matter the order in which you
unlock the bh and sb_bgl_lock in balloc.c, mballoc.c and inode.c?


Thanks,

					- Ted
