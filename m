From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/54] e2fsck: decrement bad count _after_ remapping a
 duplicate block
Date: Mon, 26 Jan 2015 23:37:18 -0800
Message-ID: <20150127073718.13308.99370.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45955 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbA0HhX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:23 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Decrement the bad count *after* we've shown that (a) we can allocate a
replacement block and (b) remap the file block.  Unfortunately,
the only way to tell if the remapping succeeded is to wait until the
next clone_file_block() call or block_iterate3() returns.

Otherwise, there's a corruption error: we decrease the badcount once in
preparation to remap, then the remap fails (either we can't find a
replacement block or we have to split the extent tree and can't find a
new extent block), so we delete the file, which decreases the badcount
on the block a second time.  Later on e2fsck will think that it's
straightened out all the duplicate blocks, which isn't true.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1b.c                         |   32 +++++++++++++++++++++++++---
 tests/f_cloneblock_alloc_error/expect.1 |   36 +++++++++++++++++++++++++++++++
 tests/f_cloneblock_alloc_error/expect.2 |    7 ++++++
 tests/f_cloneblock_alloc_error/image.gz |  Bin
 tests/f_cloneblock_alloc_error/name     |    1 +
 5 files changed, 73 insertions(+), 3 deletions(-)
 create mode 100644 tests/f_cloneblock_alloc_error/expect.1
 create mode 100644 tests/f_cloneblock_alloc_error/expect.2
 create mode 100644 tests/f_cloneblock_alloc_error/image.gz
 create mode 100644 tests/f_cloneblock_alloc_error/name


diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 2d1b448..cd967f4 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -725,8 +725,30 @@ struct clone_struct {
 	char	*buf;
 	e2fsck_t ctx;
 	struct ext2_inode	*inode;
+
+	struct dup_cluster *save_dup_cluster;
+	blk64_t save_blocknr;
 };
 
+/*
+ * Decrement the bad count *after* we've shown that (a) we can allocate a
+ * replacement block and (b) remap the file blocks.  Unfortunately, there's no
+ * way to find out if the remap succeeded until either the next
+ * clone_file_block() call (an error when remapping the block after returning
+ * BLOCK_CHANGED will halt the iteration) or after block_iterate() returns.
+ * Otherwise, it's possible that we decrease the badcount once in preparation
+ * to remap, then the remap fails (either we can't find a replacement block or
+ * we have to split the extent tree and can't find a new extent block), so we
+ * delete the file, which decreases the badcount again.
+ */
+static void deferred_dec_badcount(struct clone_struct *cs)
+{
+	if (!cs->save_dup_cluster)
+		return;
+	decrement_badcount(cs->ctx, cs->save_blocknr, cs->save_dup_cluster);
+	cs->save_dup_cluster = NULL;
+}
+
 static int clone_file_block(ext2_filsys fs,
 			    blk64_t	*block_nr,
 			    e2_blkcnt_t blockcnt,
@@ -734,7 +756,7 @@ static int clone_file_block(ext2_filsys fs,
 			    int ref_offset EXT2FS_ATTR((unused)),
 			    void *priv_data)
 {
-	struct dup_cluster *p;
+	struct dup_cluster *p = NULL;
 	blk64_t	new_block;
 	errcode_t	retval;
 	struct clone_struct *cs = (struct clone_struct *) priv_data;
@@ -744,6 +766,7 @@ static int clone_file_block(ext2_filsys fs,
 	int is_meta = 0;
 
 	ctx = cs->ctx;
+	deferred_dec_badcount(cs);
 
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
@@ -768,8 +791,6 @@ static int clone_file_block(ext2_filsys fs,
 		}
 
 		p = (struct dup_cluster *) dnode_get(n);
-		if (!is_meta)
-			decrement_badcount(ctx, *block_nr, p);
 
 		cs->dup_cluster = c;
 		/*
@@ -819,6 +840,8 @@ cluster_alloc_ok:
 			cs->errcode = retval;
 			return BLOCK_ABORT;
 		}
+		cs->save_dup_cluster = (is_meta ? NULL : p);
+		cs->save_blocknr = *block_nr;
 		*block_nr = new_block;
 		ext2fs_mark_block_bitmap2(ctx->block_found_map, new_block);
 		ext2fs_mark_block_bitmap2(fs->block_map, new_block);
@@ -848,6 +871,8 @@ static errcode_t clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	cs.ctx = ctx;
 	cs.ino = ino;
 	cs.inode = &dp->inode;
+	cs.save_dup_cluster = NULL;
+	cs.save_blocknr = 0;
 	retval = ext2fs_get_mem(fs->blocksize, &cs.buf);
 	if (retval)
 		return retval;
@@ -860,6 +885,7 @@ static errcode_t clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	if (ext2fs_inode_has_valid_blocks2(fs, &dp->inode))
 		pctx.errcode = ext2fs_block_iterate3(fs, ino, 0, block_buf,
 						     clone_file_block, &cs);
+	deferred_dec_badcount(&cs);
 	ext2fs_mark_bb_dirty(fs);
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
diff --git a/tests/f_cloneblock_alloc_error/expect.1 b/tests/f_cloneblock_alloc_error/expect.1
new file mode 100644
index 0000000..24fe1ff
--- /dev/null
+++ b/tests/f_cloneblock_alloc_error/expect.1
@@ -0,0 +1,36 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12, i_size is 0, should be 2015232.  Fix? yes
+
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 13: 8
+Multiply-claimed block(s) in inode 14: 8
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 2 inodes containing multiply-claimed blocks.)
+
+File /b (inode #13, mod time Wed Jan 21 03:41:55 2015) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/c (inode #14, mod time Wed Jan 21 03:42:37 2015)
+Clone multiply-claimed blocks? yes
+
+clone_file: Could not allocate block in ext2 filesystem returned from clone_file_block
+Couldn't clone file: Could not allocate block in ext2 filesystem
+Delete file? yes
+
+File /c (inode #14, mod time Wed Jan 21 03:42:37 2015) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/b (inode #13, mod time Wed Jan 21 03:41:55 2015)
+Multiply-claimed blocks already reassigned or cloned.
+
+Pass 2: Checking directory structure
+Entry 'b' in / (2) has deleted/unused inode 13.  Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 13/128 files (7.7% non-contiguous), 512/512 blocks
+Exit status is 1
diff --git a/tests/f_cloneblock_alloc_error/expect.2 b/tests/f_cloneblock_alloc_error/expect.2
new file mode 100644
index 0000000..f7781ec
--- /dev/null
+++ b/tests/f_cloneblock_alloc_error/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/128 files (7.7% non-contiguous), 512/512 blocks
+Exit status is 0
diff --git a/tests/f_cloneblock_alloc_error/image.gz b/tests/f_cloneblock_alloc_error/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..ed01df1b9fb7a10f49338cd994ca4ef4cf646bba
GIT binary patch
literal 3441
zcmeH{X;4#l5Ws^6bgBfaRi{$GYNyn(k~#_sX`qVASmjU*F@X>Ulq2EL(wE?)AyO;e
zF!hQDhoC}|mjpG22$)2xLXiqZ-%$cVl<|7cc;O%FQ}T+_Z~fFS{l<RSot-^q=Qq0>
zu<rv__H6rxapPUR8HbZLdu+ew^!~7R%7hhHGslH2{^F<It5!@tbvR{bO60ui-Lv+5
z`{mx$RFCP)4$qOtY2_1EteiT<ckjf+r{3p^KVEiq`H$-C(qo4tb36tHpW5<=pY<+M
z*pG)Q>|Ab!m*;jyFj&GV@$|&~gb^v5LKol8@%`PmJIEBc;8^I_=L%lN5N!7323zL+
z7xdH}bK4iroqwk!@3e2I{(&bqPkv{=DI*)c`Cz8O(tfc`-8((ax#^{rTPl)K!oVtf
z*Cp@PY}>;Zom_cl8)OM+Rki;d?x`Le;gh|5-Y|=`@nuP!UB>S0j7n!BEw^ISm6O&U
zqx{FQSlb!pK95mzr0>ODrj<RJ9qqS`bLG$C>S}Gg`tmM?tGFxD^yt&2idW(JY)4-G
zJu0_HzNPHwz$#lM_C07ydDq`xnH=-JMf2H(?d8nfrA2LTB3LZexr4%M;!(@$U`C^?
zN6e_Y;_S{;y!ZZ#%rCwXD@ykpP2KpUVB&;-l{|xo5lCijQblXL(DAa=XdR$F3U2fl
z#!IC<U5M@g)n#7Is|_)<;sa6<&lZ9Nq7T7!M@<O>`d>RPH0TUe8#wH!Z7{f`Z%?e_
zqVZG~cnz=OnJW2QJSNyAH)as|WFxo?7rEARG&6CdInk9|i0U1tA)QrL1+Q}@a*S$p
zjZALU4<Vu8mBY@~jF;v5ZSW#KgEFl($--S2LSj&Xwe}(Q4$iR}lO=hYx#VwfnpNAE
z6on;{kHc#FM6Gxa>4K8{B!TE2P#UJ~6F%1|h(gi|Y_O^#sSfobcYx|Ja}08a+8<`>
z(D@Ki<Y{o8E>PBl3p0p1vOLVvfy5GTz;QZTX$;bI5<AVOX5cHKt;*^kEeBVV?cfM4
z6^kTDJ+T=apwpFzO{^vqWHYeRMI)zXU_Mk77@${=Tr5h6sF$D|N&u*)8lxT|mw+Bx
zJYsXl35a0O+SFh~D5`{xcWzvQRZ$!$-??68uw!?r07&K>>RjUaR$o1fkDxrV(kwM3
z4C}grYg_P3B5MmV3wkax;W{%FZjNzUo(U)%hL{s^J{m9l`iTt`;R#N`TX<*uMLvi(
zbr0-5kyNIi7i{+D`(iENvEz(?{7F2G+8S)|mz>0=NeAK7oOQ9fC+5vL{6yjqHP0NK
zlh}g|1)r8{>hL?{6R;mn=OJ=^g*4rj)M<Q#=2P3iJIC4NIF4Q{vpB3n8lgGE#V;hn
zL5;(boW#+p@u#rRCCDcqm{oppUU+YqhHZ=_|A1FoFR&2-hEOly=v&Ae;DE(eTVGrh
z`U_}*<E@RQIt$tbt+kp<4Hm42x)f%M(M+TKp!HT$AOE>=7%ilfz#Y~YqxC_(s7Od!
zkx)l`0;N~*1B_*86qN>E(kqk~I*hScD3n_vs4@;xi$FJ>B#x`9pCnthK);W?PcIj*
zm*_c|nwk%=ri-=&Nqsx%3vST~%I2W@=cs}z1S9ma1-bydjBEvm=&TWaQL<el!Rtu^
zS}7I^usqTNnrY=owb3Xe%b*;wfFQg<UDNqoT?8Q^A2ywJi&Ti6h#+y%H<|ALdaW#$
z;(E=VN$Ei@Caago?!Gar-Ivi6W4RWmhMUDqJ36?uAY|P9UoXEAe^qWPAGq6Z_ha1C
z(vAuPet5T|`N+;|gH=!3PcoCe*ETuj|7;KW-C`y*&wcO#=2B#>DNA@;$`JDR`_#~a
zk-<f6=+^!|bAmxUtc6G$bMLSE<f{V_8SaAvuQaPiC&}5?%3#mVjBvPal}mMl=e{;j
ub-PF{7nG`Qer|vNkH%z-z!-rs0%HWm2#gW<KM3@f(t)g$<=rgSY}ViS*fH|}

literal 0
HcmV?d00001

diff --git a/tests/f_cloneblock_alloc_error/name b/tests/f_cloneblock_alloc_error/name
new file mode 100644
index 0000000..9196e89
--- /dev/null
+++ b/tests/f_cloneblock_alloc_error/name
@@ -0,0 +1 @@
+decrement badcount after remapping duplicate block

