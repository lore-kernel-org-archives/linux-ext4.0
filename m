From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 fails on ext2 filesystems
Date: Tue, 20 Jan 2009 09:51:00 -0500
Message-ID: <20090120145100.GD10037@mit.edu>
References: <20090118013516.GA4876@alea.gnuu.de> <20090118023841.GD25943@mit.edu> <20090118100458.GA22064@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51165 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbZATOvD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Jan 2009 09:51:03 -0500
Content-Disposition: inline
In-Reply-To: <20090118100458.GA22064@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 18, 2009 at 11:04:59AM +0100, J=F6rg Sommer wrote:
> > > [  203.082300] EXT4 FS on hda3, no journal
> > > [  205.746713] EXT4-fs error (device hda3): ext4_free_data: circu=
lar indirect block detected, inode=3D165056, block=3D184476
> > >=20

Hi, this patch should fix your problem.

						- Ted

commit bf3baec2b4529dcf47ee422a48b8c0e83df7f0a0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Jan 20 09:50:19 2009 -0500

    ext4: Fix ext4_free_blocks() w/o a journal when files have indirect=
 blocks
   =20
    When trying to unlink a file with indirect blocks on a filesystem
    without a journal, the "circular indirect block" sanity test was
    getting falsely triggered.
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 49484ba..b4386da 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3622,7 +3622,7 @@ static void ext4_free_data(handle_t *handle, stru=
ct inode *inode,
 		 * block pointed to itself, it would have been detached when
 		 * the block was cleared. Check for this instead of OOPSing.
 		 */
-		if (bh2jh(this_bh))
+		if ((EXT4_JOURNAL(inode) =3D=3D NULL) || bh2jh(this_bh))
 			ext4_handle_dirty_metadata(handle, inode, this_bh);
 		else
 			ext4_error(inode->i_sb, __func__,
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
