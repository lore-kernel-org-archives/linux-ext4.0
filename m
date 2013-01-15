From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] lib/ext2fs: Add ext2fs_symlink
Date: Tue, 15 Jan 2013 14:17:14 -0500
Message-ID: <20130115191714.GE17719@thunk.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
 <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43558 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3AOTR0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:17:26 -0500
Content-Disposition: inline
In-Reply-To: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2013 at 12:00:58PM -0800, Darren Hart wrote:

Applied, thanks.

> Note the one remaining FIXME. Do I need to use ext2fs_bmap2() for the
> slowlink without extents? If not, how is the 0 block associated with the
> inode?

No, you don't need to use ext2fs_bmap2().  The 0 block was set here in
the else clause:

+		if (fs->super->s_feature_incompat &
+		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
+			/*
+			 * The extent bmap is setup after the inode and block
+			 * have been written out below.
+			 */
+			inode.i_flags |= EXT4_EXTENTS_FL;
+		} else {
+			inode.i_block[0] = blk;
+		}

						- Ted
