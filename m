From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: correctly deallocate invalid extent-mapped symlinks
Date: Sun, 28 Jul 2013 22:08:30 -0400
Message-ID: <1375063710-22787-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45891 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab3G2D0l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Jul 2013 23:26:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function deallocate_inode() in e2fsck/pass2.c was buggy in that it
would clear out the inode's mode and flags fields before trying to
deallocate any blocks which might belong to the inode.

The good news is that deallocate_inode() is mostly used to free inodes
which do not have blocks: device inodes, FIFO's, Unix-domain sockets.

The bad news is that if deallocate_inode() tried to free an invalid
extent-mapped inode, it would try to interpret the root of the extent
node as block numbers, and would therefore mark various file system
metadata blocks (the superblock, block group descriptors, the root
directory, etc.) as free and available for allocation.  This was
unfortunate.

(Try running an older e2fsck against the test file system image in the
new test f_invalid_extent_symlink, and then run e2fsck a second time
on the fs image, and weep.)

Fortunately, this kind of file system image corruption appears to be
fairly rare in actual practice, since it would require a very unlucky
set of bits to be flipped, or a buggy file system implementation.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass2.c                          |   7 +++++--
 tests/f_invalid_extent_symlink/expect.1 |  12 ++++++++++++
 tests/f_invalid_extent_symlink/expect.2 |   7 +++++++
 tests/f_invalid_extent_symlink/image.gz | Bin 0 -> 1115 bytes
 tests/f_invalid_extent_symlink/name     |   1 +
 5 files changed, 25 insertions(+), 2 deletions(-)
 create mode 100644 tests/f_invalid_extent_symlink/expect.1
 create mode 100644 tests/f_invalid_extent_symlink/expect.2
 create mode 100644 tests/f_invalid_extent_symlink/image.gz
 create mode 100644 tests/f_invalid_extent_symlink/name

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 749d264..bceadfe 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1189,7 +1189,6 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	struct del_block	del_block;
 
 	e2fsck_read_inode(ctx, ino, &inode, "deallocate_inode");
-	e2fsck_clear_inode(ctx, ino, &inode, 0, "deallocate_inode");
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
 
@@ -1224,7 +1223,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	}
 
 	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
-		return;
+		goto clear_inode;
 
 	if (LINUX_S_ISREG(inode.i_mode) && EXT2_I_SIZE(&inode) >= 0x80000000UL)
 		ctx->large_files--;
@@ -1239,6 +1238,10 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
+clear_inode:
+	/* Inode may have changed by block_iterate, so reread it */
+	e2fsck_read_inode(ctx, ino, &inode, "deallocate_inode");
+	e2fsck_clear_inode(ctx, ino, &inode, 0, "deallocate_inode");
 }
 
 /*
diff --git a/tests/f_invalid_extent_symlink/expect.1 b/tests/f_invalid_extent_symlink/expect.1
new file mode 100644
index 0000000..7bda0b7
--- /dev/null
+++ b/tests/f_invalid_extent_symlink/expect.1
@@ -0,0 +1,12 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Symlink /a (inode #12) is invalid.
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16 files (9.1% non-contiguous), 21/100 blocks
+Exit status is 1
diff --git a/tests/f_invalid_extent_symlink/expect.2 b/tests/f_invalid_extent_symlink/expect.2
new file mode 100644
index 0000000..41ceefb
--- /dev/null
+++ b/tests/f_invalid_extent_symlink/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16 files (0.0% non-contiguous), 21/100 blocks
+Exit status is 0
diff --git a/tests/f_invalid_extent_symlink/image.gz b/tests/f_invalid_extent_symlink/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d4a6eef7e21483cb945052c6603173761702a89a
GIT binary patch
literal 1115
zc-oWi=3sbw@M|Cw^V_>;^KYlf94J&jEAUY(x5u-<u_{6{^U}4qS|5#C6?f@=alNqB
zcY9%X&~MMAi8l|H2{8IfsmJ}}Y&jBtLD<~l@KjHkAL0V+Gmhxm^viBPXH}MPb;Y&!
z?zNMCeBbkH<NW3OOiXzg)UQTPm6__d^2<Ii)~Q7|nUp-!-P>nZf8WlNY_aD5#O~9o
z$2+&&%bfad)t6;n;h)+J1K#WV?Ei9=|NFK0-@h);pI7-b=Kbmak7M@#{MtM}I{JOh
zmhZJcw^wJ!uX+8^ukVwZ@$<qdMf{yFE$ik+^B+IZ;&pztiRk+OO%waypZj9B_p6pM
zi_PA)!^Xe&Gyj)kvhe)$(YQb_f93Zl#di6TCyoD99zIk4*I-ue&)V~z^QP9%Jn?i^
z&g=uh55F+K{=dF6<u9{^B9{;2fnV%+5Cg;Un@&eXL_coiak~CpC;H6!^WC|UUzz<~
zWM`&v>=%_k<-bVvVrhAEnnA$VlB=uh@&$Ih^;1b(H|^+A@9FmhtYu$X*C`zJi}<uQ
zaOX?yO>e6{uio_XL_(B%nN^-fR9<-3?X!(HrYcS7lXh#|eY<~&@~?SX65pjxJ}8^P
zmzesvts=jkCCRnQD5LCXTK)Fdx3rE=i_>`ijeTFr(Ye=c)GvQ+%Jkbg@9tacpqLG{
z>z{60dyZ8!yYuSP*;|kG_HO-kZtJmEjw`qSnkO|Yx%8gd@+HrAto4~Dx9NJ{W+TJn
zUynPNnY{3nJ@sYn^UW8zCZF4UP-Plt)U~Exp6e%{<6fM$<Xi-=eNW5XOtwXf*7+#g
zemuQs+n2oB;@`i#_7-m578}2NU*O;ER({5ll110)zQ3|+*~_Yl9&VRkm^KG2>ouPg
zJn!VT#hct7Zu&Vh@=V&zy{jUx<jVHs7W!G#UD@z=AJ=N<tC1U@vL_vTxAJiFwpE3>
ziQm)GPdk}LhfL2{wun1cOm+2?Baa@`6|Y*-CtA*Y^UsD=_NVeR9#4=8c~Vuoa&fs^
z@7_0UeYeY$?`B!9+Zq2cVTbX{<6S#;M2KxZDe=rTb7M%DYG}0MrZl&wtDeag=lr^5
zl+|<1*Qzsl^YoefEN$5)N@y=yA5_-$^~L7RaXM*Hfz9Xc@LpZ=C4zg^4lB8N5Azo^
zPWI}1FJ9Gtq55Nnb@i2J^KZtTs@nfJl8XTwu+W+e%mSCbsQmt0d$VJI{hNaS!XN)D
zoAsnW4*z`q&W-C+p7QM5#?$})-Sbze8v`tA{y%m5e!u>^%;oAge^-2;f3*FredXh$
z?r-cTYt6N4`nUi0HG^xRhgYw<Z?g1zeBzq_e-{3If9FN)^3O3|3^WD(FXhd(*REoi
Hz{mgq9nc_3

literal 0
Hc-jL100001

diff --git a/tests/f_invalid_extent_symlink/name b/tests/f_invalid_extent_symlink/name
new file mode 100644
index 0000000..3792aac
--- /dev/null
+++ b/tests/f_invalid_extent_symlink/name
@@ -0,0 +1 @@
+extent-mapped symlink with two blocks
-- 
1.7.12.rc0.22.gcdd159b

