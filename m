From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/25] e2fsck: detect and repair external journal superblock
 checksum errors
Date: Mon, 08 Sep 2014 16:12:15 -0700
Message-ID: <20140908231215.25904.49603.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49036 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIHXMV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:21 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the (ext4) superblock checksum of an external journal device
and prompt to correct the checksum if nothing else is wrong with the
superblock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: TR Reardon <thomas_reardon@hotmail.com>
---
 e2fsck/journal.c                               |   25 ++++++++++++++
 e2fsck/problem.c                               |    5 +++
 e2fsck/problem.h                               |    3 ++
 tests/j_corrupt_ext_jnl_sb_block/expect        |    5 +++
 tests/j_corrupt_ext_jnl_sb_block/image.tar.bz2 |  Bin
 tests/j_corrupt_ext_jnl_sb_block/name          |    1 +
 tests/j_corrupt_ext_jnl_sb_block/script        |   36 +++++++++++++++++++++
 tests/j_corrupt_ext_jnl_sb_csum/expect         |   25 ++++++++++++++
 tests/j_corrupt_ext_jnl_sb_csum/image.tar.bz2  |  Bin
 tests/j_corrupt_ext_jnl_sb_csum/name           |    1 +
 tests/j_corrupt_ext_jnl_sb_csum/script         |   42 ++++++++++++++++++++++++
 11 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 tests/j_corrupt_ext_jnl_sb_block/expect
 create mode 100644 tests/j_corrupt_ext_jnl_sb_block/image.tar.bz2
 create mode 100644 tests/j_corrupt_ext_jnl_sb_block/name
 create mode 100644 tests/j_corrupt_ext_jnl_sb_block/script
 create mode 100644 tests/j_corrupt_ext_jnl_sb_csum/expect
 create mode 100644 tests/j_corrupt_ext_jnl_sb_csum/image.tar.bz2
 create mode 100644 tests/j_corrupt_ext_jnl_sb_csum/name
 create mode 100644 tests/j_corrupt_ext_jnl_sb_csum/script


diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index a19d40b..16bd757 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -456,7 +456,6 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 		}
 		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + SUPERBLOCK_OFFSET,
 		       sizeof(jsuper));
-		brelse(bh);
 #ifdef WORDS_BIGENDIAN
 		if (jsuper.s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
 			ext2fs_swap_super(&jsuper);
@@ -465,6 +464,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 		    !(jsuper.s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
 			fix_problem(ctx, PR_0_EXT_JOURNAL_BAD_SUPER, &pctx);
 			retval = EXT2_ET_LOAD_EXT_JOURNAL;
+			brelse(bh);
 			goto errout;
 		}
 		/* Make sure the journal UUID is correct */
@@ -472,9 +472,32 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			   sizeof(jsuper.s_uuid))) {
 			fix_problem(ctx, PR_0_JOURNAL_BAD_UUID, &pctx);
 			retval = EXT2_ET_LOAD_EXT_JOURNAL;
+			brelse(bh);
 			goto errout;
 		}
 
+		/* Check the superblock checksum */
+		if (jsuper.s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+			struct struct_ext2_filsys fsx;
+			struct ext2_super_block	superx;
+			void *p;
+
+			p = start ? bh->b_data : bh->b_data + SUPERBLOCK_OFFSET;
+			memcpy(&fsx, ctx->fs, sizeof(fsx));
+			memcpy(&superx, ctx->fs->super, sizeof(superx));
+			fsx.super = &superx;
+			fsx.super->s_feature_ro_compat |=
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
+			if (!ext2fs_superblock_csum_verify(&fsx, p) &&
+			    fix_problem(ctx, PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID,
+					&pctx)) {
+				ext2fs_superblock_csum_set(&fsx, p);
+				mark_buffer_dirty(bh);
+			}
+		}
+		brelse(bh);
+
 		maxlen = ext2fs_blocks_count(&jsuper);
 		journal->j_maxlen = (maxlen < 1ULL << 32) ? maxlen : (1ULL << 32) - 1;
 		start++;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 99ca7cb..4b41a21 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -459,6 +459,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("First_meta_bg is too big.  (%N, max value %g).  "),
 	  PROMPT_CLEAR, 0 },
 
+	/* External journal has corrupt superblock */
+	{ PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID,
+	  N_("External @j @S checksum does not match @S.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 5c92d0a..f86c531 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -264,6 +264,9 @@ struct problem_context {
 /* The first_meta_bg is too big */
 #define PR_0_FIRST_META_BG_TOO_BIG		0x000049
 
+/* External journal has corrupt superblock */
+#define PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID	0x00004A
+
 /*
  * Pass 1 errors
  */
diff --git a/tests/j_corrupt_ext_jnl_sb_block/expect b/tests/j_corrupt_ext_jnl_sb_block/expect
new file mode 100644
index 0000000..e638e11
--- /dev/null
+++ b/tests/j_corrupt_ext_jnl_sb_block/expect
@@ -0,0 +1,5 @@
+External journal does not support this filesystem
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+Exit status is 12
diff --git a/tests/j_corrupt_ext_jnl_sb_block/image.tar.bz2 b/tests/j_corrupt_ext_jnl_sb_block/image.tar.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..efb382fafeb26de434c8d182fa155abe803e3d02
GIT binary patch
literal 939
zcmV;c162G%T4*^jL0KkKSz<fD_W**WfB*mg{mfbo|Lyj@{%QaJ-@)M(+E(B<X47Hk
zDTgOh>|ekG2LLG)kd#R@WKUFi2x+0}Jtw5~2GlV$&>Cm~>H+EofEqMt4X6Ma8Uxe~
z9!(~XYMOeVst7d5$TDIy(*kLN448}rWYMD#Vi^pYGGK;ACWZ)P$j~&zGz^BBFd)+-
zAjyc+ObMn4GGZ_hlSYg|h-5No$$}XeniwIIBS6y-&@viiz$8$FDL)YOQ`FKnqiTAX
z5$Ge(jW(u+nW_4w6F>$Lk?K7(XhQ_`Gyq{RO{Dc2F+DVqhfapJ9@oAhS;CWf=SQ~a
zuQoD6kcXKJiz*~_ZXx8j*}Yucz26L#7jq9SE?xC|wg$ngaj8~*y3`^O*Dj(sEt;Yb
zkq*`!ju+iJ64CqcO8J06hRZ;a1X^vRj3$s$!3i(%q_P?SMe6_rfhDhKNg(klGBovh
zRqjrdY>+_~5puf)sKbV_sOjJ<o^HA(4!ZHX8vifMqZ45~T<{ga`1JAY$S7@yJ}*k_
zLh*&;1cZP9oussF2(Q=2h>4hMFW}gs^iHe4YL<mr34#Ft0fIG%(NJ<2uo}{`EEQHv
zGy%J5D7pp`dwWm|A&g^Pu1zq-QHZM5k%GW#EjA<}00Cya0+UMtXFE*sT-vj|RQl!u
zhj4xdblm)?7MM~<fn};Qk|BpSg#UA9K_|v$ihLs6gU+#DJw^@Ik*2pKi|@{2F&+!@
zI7mb&?%T}HNSP2SPEvB6@7pi|Q4A4N@4aDbax+eOMkgg^V5KZSwXC6R5Hiiy&cWeh
zhNvLG$;rheDGFvlVTxgpQ6&L!<HYP#CL;=lsM?}H+-M;pX3-<Fl(Q8Awd)^*eami&
z+bt4%0>!e*r8|eYggc?+WlaspJ{tNCYn(D|l0r*WQ81JVr28xRF?NG!CYeCG?8Bdr
zJ=4@)7h%>R7R?k)Qi!8;RPYMWzC2dWYKsWHGM}c?r2zO2rGcxizBrfn!EszVfuJFe
zO$J9ys&5bIq>Sf>wK~KK-w*ReW2$iJ3}M8Y`wCNixB&*I8YNpr9GMFpWWV^NAFM0N
z&PS%6Aghy*UE)^yo5Vx;kd;;WJwo;^d~8991x?h+&FTl^HT^^&fNMsih01_0QX`4a
z2q8`lVY|9a@Qy9-vu;}+`3+l0(gs-skFzQXAV2^V3%?Be2@sLUV4yHFd=ZLKMq)So
NUC9*TLP3b{1KjPKr%M0;

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_ext_jnl_sb_block/name b/tests/j_corrupt_ext_jnl_sb_block/name
new file mode 100644
index 0000000..a5188be
--- /dev/null
+++ b/tests/j_corrupt_ext_jnl_sb_block/name
@@ -0,0 +1 @@
+corrupt external journal fs superblock block (metadata_csum)
diff --git a/tests/j_corrupt_ext_jnl_sb_block/script b/tests/j_corrupt_ext_jnl_sb_block/script
new file mode 100644
index 0000000..02b8e65
--- /dev/null
+++ b/tests/j_corrupt_ext_jnl_sb_block/script
@@ -0,0 +1,36 @@
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+bzip2 -dc < $test_dir/image.tar.bz2 | tar x
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp $test_name.img "$JOURNAL_DUMP_DIR/$test_name.img"
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp $test_name.img.jnl "$JOURNAL_DUMP_DIR/$test_name.img.jnl"
+
+$FSCK $FSCK_OPT -N test_filesys -j $test_name.img.jnl $test_name.img > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE $test_name.img $test_name.img.jnl
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
diff --git a/tests/j_corrupt_ext_jnl_sb_csum/expect b/tests/j_corrupt_ext_jnl_sb_csum/expect
new file mode 100644
index 0000000..70a4fe7
--- /dev/null
+++ b/tests/j_corrupt_ext_jnl_sb_csum/expect
@@ -0,0 +1,25 @@
+External journal superblock checksum does not match superblock.  Fix? yes
+
+test_filesys: recovering journal
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  +(1--31) +34 +(50--82)
+Fix? yes
+
+Inode bitmap differences:  +(1--11)
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/128 files (0.0% non-contiguous), 66/2048 blocks
+Exit status is 1
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 66/2048 blocks
+Exit status is 0
diff --git a/tests/j_corrupt_ext_jnl_sb_csum/image.tar.bz2 b/tests/j_corrupt_ext_jnl_sb_csum/image.tar.bz2
new file mode 100644
index 0000000000000000000000000000000000000000..d04d584c0389112d09a7427fd967a9d9605e68ac
GIT binary patch
literal 929
zcmV;S177?>T4*^jL0KkKS#@A;5dea(|NsC0{mj`}|L^_xUmpMW-qr2{7r{S85b04)
ztBp5X?Rmfh9ZCfiQ9@A?dPIk&iRm=aiRx`bO*DF$sp<_400*c5Xda*d4^T7!Xc~Hr
z1Jnj;V2=|}KpJVLnrVbGWHJmUhKvCX3<;wn2r_A-Kn4iV#4$9<rXvWznlxcF2m?(t
z(@ijjOol;((9wV)p@B4HVFpb!XaK<)7=|X9G{j*T6Gn_CfJmeeMyHh8jWqQ%4FDQ6
z05ll}hJXM713(6VGynhq8UPv<MB{@dgRy8L@@dqU12~~<oe2xv*oqL8pJ6tWl41I|
zt16?CKWB<YmgibSkI1ZrT1#w^v8*bjUOtf2N5#vkAy$ZRIM@6rjzU{%kV>(DM8h#u
zkpxQHNfr$ttYCzf*`&N}03wqB1c4=F(2_yotT>pN-8vPrq-|Kh8lcyix>U8%GD4$m
zSS5Yc!%W@8MOb$-bdSo?vC6W+7~$B*3VgaT#w22GH1P!{6q-U300LH$sM0G~j%J(R
z5Q`}wrZf%T+~-lMZA#Ez5SSnk02pzsvqa&>F<{!TWK0Pfp5+*T)-hlhh}?q-9k!kV
zq#9w{&?5+jiH#H*DGd|Yn*@-60IFd~uz;)GHelSC^YTr!kO_{of982yy!aH_D+tI@
zWY5|}F66$SSnk*nvyi2eqO>x3CQndRg7FUvD*y?Kk5F*di-ft&S_m=?G)42@8Yqn2
zJ9dkfUBA2E(+CK*8J%U2@uyUR+B;hKSNGC9q1oYB_H5=2mqx065%9v-7!fcywbuk<
zj0P~X83N7%gxLs)XK`vv)G8}@21Y|cXF#M+C^D`XGhD8L2z+UX3i2I{!aDI3?XSz3
z%ELdf5|kfve+B6}Y*6-n`P!0k`ADd)TVlFkZFE<b*a_C8s96RD&|P$ctocsI0PPn+
zdN^T!@jV3KnD2t6@xFjidNYlM1`K%F8&7m66`?U&+#9j_0=Zj<oWJs@%sk}NU|xtu
zO)6y%NdgxxwWJ!Nd8(`kKSKnzv#x-e8Z4dnsetthVUf;ATgsnJ5OIu6`zAIBQM5hz
zOi;7WELoxIJ+Ua{dE2(H`GZVMI+i%`@xlF1uKJVK0@7W%QJJ8~#Rh;`QDHBLh%!aJ
zK$%?$(y5FEtUWMD>)wAV;}3&K1ONg3o+vY?{U8b<fhYXdqBRScfAM!DQ-ui!RtDh^
DW^tU{

literal 0
HcmV?d00001

diff --git a/tests/j_corrupt_ext_jnl_sb_csum/name b/tests/j_corrupt_ext_jnl_sb_csum/name
new file mode 100644
index 0000000..c182f81
--- /dev/null
+++ b/tests/j_corrupt_ext_jnl_sb_csum/name
@@ -0,0 +1 @@
+corrupt external journal fs superblock csum (metadata_csum)
diff --git a/tests/j_corrupt_ext_jnl_sb_csum/script b/tests/j_corrupt_ext_jnl_sb_csum/script
new file mode 100644
index 0000000..7a110bf
--- /dev/null
+++ b/tests/j_corrupt_ext_jnl_sb_csum/script
@@ -0,0 +1,42 @@
+FSCK_OPT=-fy
+OUT=$test_name.log
+if [ -f $test_dir/expect.gz ]; then
+	EXP=$test_name.tmp
+	gunzip < $test_dir/expect.gz > $EXP1
+else
+	EXP=$test_dir/expect
+fi
+
+cp /dev/null $OUT
+
+bzip2 -dc < $test_dir/image.tar.bz2 | tar x
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp $test_name.img "$JOURNAL_DUMP_DIR/$test_name.img"
+test -d "$JOURNAL_DUMP_DIR" -a -w "$JOURNAL_DUMP_DIR" && cp $test_name.img.jnl "$JOURNAL_DUMP_DIR/$test_name.img.jnl"
+
+$FSCK $FSCK_OPT -N test_filesys -j $test_name.img.jnl $test_name.img > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+$FSCK $FSCK_OPT -N test_filesys -j $test_name.img.jnl $test_name.img > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE $test_name.img $test_name.img.jnl
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+
+unset IMAGE FSCK_OPT OUT EXP

