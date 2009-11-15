From: Theodore Tso <tytso@mit.edu>
Subject: Re: s_first_meta_bg treatment incompatibility between kernel and
	e2fsprogs
Date: Sat, 14 Nov 2009 23:20:57 -0500
Message-ID: <20091115042057.GC4323@mit.edu>
References: <4AFAA95C.5000304@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50987 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZKOEU4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Nov 2009 23:20:56 -0500
Content-Disposition: inline
In-Reply-To: <4AFAA95C.5000304@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 11, 2009 at 01:09:00PM +0100, Damien Guibouret wrote:
> Hello,
>
> I have taken a look at META_BG feature and think there is some
> incoherency between kernel and e2fsprogs about s_first_meta_bg handling.
>
> When considering initialisation of unitialised block bitmaps for groups  
> before first meta group one:
> - kernel considers that descriptors blocks occupy  
> EXT4_SB(sb)->s_gdb_count blocks (see ext4_bg_num_gdb_nometa at  
> balloc.c:764 that is indirectly called from ext4_init_block_bitmap),  
> s_gdb_count being the number of blocks to store all descriptors  
> (computed from super.c).
> - e2fsprogs considers that descriptors blocks occupy s_first_meta_bg
> (see ext2fs_reserve_super_and_bgd at alloc_sb.c:55-68).

Yup, you're right.  Ouch.  That is a kernel bug, and it means that if
we resize a filesystem to the point where we need to use meta_bg
(because we've run out of blocks to reserve), if there are
uninitialized block bitmaps, kernels that don't have a fix will
misbehave by reserving too many file system metadata blocks.  This
will waste bit of disk space, which fsck will fix.

(s_first_meta_bg by definition is always less than or equal to
s_gdb_count.)

I think this patch should fix things up.

					- Ted

commit b33c339814f97fc48a843f45f6068f84bc735141
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Nov 14 23:20:30 2009 -0500

    ext4: Fix uninit block bitmap initialization when s_meta_first_bg is non-zero
    
    The number of old-style block group descriptor blocks is
    s_meta_first_bg when the meta_bg feature flag is set.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1d04189..f3032c9 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -761,7 +761,13 @@ static unsigned long ext4_bg_num_gdb_meta(struct super_block *sb,
 static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
 					ext4_group_t group)
 {
-	return ext4_bg_has_super(sb, group) ? EXT4_SB(sb)->s_gdb_count : 0;
+	if (!ext4_bg_has_super(sb, group))
+		return 0;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb,EXT4_FEATURE_INCOMPAT_META_BG))
+		return le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
+	else
+		return EXT4_SB(sb)->s_gdb_count;
 }
 
 /**
