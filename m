From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/25] dumpe2fs: display external journal feature flags
Date: Mon, 08 Sep 2014 16:12:28 -0700
Message-ID: <20140908231228.25904.49070.stgit@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38956 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460AbaIHXMe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2014 19:12:34 -0400
In-Reply-To: <20140908231135.25904.66591.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Display the feature flags of an external journal.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 misc/dumpe2fs.c               |   14 ++++++++++
 tests/j_ext_dumpe2fs/expect   |   55 +++++++++++++++++++++++++++++++++++++++++
 tests/j_ext_dumpe2fs/image.gz |  Bin
 tests/j_ext_dumpe2fs/name     |    1 +
 tests/j_ext_dumpe2fs/script   |   40 ++++++++++++++++++++++++++++++
 5 files changed, 109 insertions(+), 1 deletion(-)
 create mode 100644 tests/j_ext_dumpe2fs/expect
 create mode 100644 tests/j_ext_dumpe2fs/image.gz
 create mode 100644 tests/j_ext_dumpe2fs/name
 create mode 100644 tests/j_ext_dumpe2fs/script


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 25dce9c..4c7bf46 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -433,8 +433,9 @@ static void print_journal_information(ext2_filsys fs)
 	errcode_t	retval;
 	char		buf[1024];
 	char		str[80];
-	unsigned int	i;
+	unsigned int	i, j, printed = 0;
 	journal_superblock_t	*jsb;
+	__u32			*mask_ptr, mask, m;
 
 	/* Get the journal superblock */
 	if ((retval = io_channel_read_blk64(fs->io,
@@ -465,6 +466,17 @@ static void print_journal_information(ext2_filsys fs)
 		       journal_checksum_type_str(jsb->s_checksum_type),
 		       ext2fs_be32_to_cpu(jsb->s_checksum));
 
+	printf("%s", _("Journal features:        "));
+	for (i = 0, mask_ptr = &jsb->s_feature_compat; i < 3; i++, mask_ptr++) {
+		mask = be32_to_cpu(*mask_ptr);
+		for (j = 0, m = 1; j < 32; j++, m <<= 1) {
+			if (mask & m) {
+				printf(" %s", e2p_jrnl_feature2string(i, m));
+				printed++;
+			}
+		}
+	}
+
 	printf(_("\nJournal block size:       %u\n"
 		 "Journal length:           %u\n"
 		 "Journal first block:      %u\n"
diff --git a/tests/j_ext_dumpe2fs/expect b/tests/j_ext_dumpe2fs/expect
new file mode 100644
index 0000000..c75f74c
--- /dev/null
+++ b/tests/j_ext_dumpe2fs/expect
@@ -0,0 +1,55 @@
+e2fsck external journal
+../e2fsck/e2fsck: Filesystem has unsupported feature(s) while trying to open test.img
+
+The superblock could not be read or does not describe a valid ext2/ext3/ext4
+filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
+filesystem (and not swap or ufs or something else), then the superblock
+is corrupt, and you might try running e2fsck with an alternate superblock:
+    e2fsck -b 8193 <device>
+ or
+    e2fsck -b 32768 <device>
+
+Exit status is 8
+dumpe2fs external journal
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      journal_dev metadata_csum
+Default mount options:    user_xattr acl block_validity
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              0
+Block count:              2048
+Reserved block count:     0
+Free blocks:              0
+Free inodes:              0
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         0
+Inode blocks per group:   0
+Mount count:              0
+Check interval:           0 (<none>)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          256
+Required extra isize:     28
+Desired extra isize:      28
+Default directory hash:   half_md4
+Checksum type:            crc32c
+Checksum:                 0x3a9935ab
+Journal checksum type:    crc32c
+Journal checksum:         0x661e816f
+Journal features:         journal_64bit journal_checksum_v3
+Journal block size:       1024
+Journal length:           2048
+Journal first block:      3
+Journal sequence:         0x00000003
+Journal start:            0
+Journal number of users:  1
+Journal users:            117f752e-f27d-4f6f-a652-072586a29b82
diff --git a/tests/j_ext_dumpe2fs/image.gz b/tests/j_ext_dumpe2fs/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..781b591c0f81778a4209096878b15bc0be99e04e
GIT binary patch
literal 2963
zcmeIu{ZpC+00(euw^_RI&`eE((a35qap@MVrQV{cx#nCr=F8OE(saJ$Is<VK&u&i1
zbLpJ3@`ah+rb}g=3JAX8sZ)b+Y6BD;hz=1D*;s)3@H|hu{)~?APv7tN#}Bsh6^{+E
zSK`Y%EGov2iDyDQpE9zQG)`CIIHqBNbdsCQJ&*>HjK|}0Lvw+$Oz)v{aRGR2%Pkxl
zLdW`|lNPYM(6I!CGO7l>3p$e!{W*TWYV5U&tCl8CeZfbC>9Ga3Am-2Ey@m~@lUQuc
z+c?sQAGxAf6gMhp6O@$W%G=AWc%xBdZRa_u%}xhsnEu1~4{VyiZ(WuS@=LR2X*QSX
zF4$Iw(k55S*XJX_%{1@T0+tiX^6U=~i-^MyaAmfKxyqIAgWehrD;qs2qa8KnP4c*0
zM)ova#Jom9J+h(I2^ab0lkDp&Lanj&Sx5>Z_%K+-j(B`}oBG)0uy{946sR1MXvWSR
zU+6chCoc(o+iE+c8T6brD2PBvOtH!5_y=|NJ_^_j&q80Wy(k<r>W3P9DY#v{{w;j}
ztM))p9r^3!kqoSf4h3uHXNzWkhpI43P1I!J+o!y^hj~6RwDvl+?#}aN4mj}lsyAX0
zYU!E!o135RdlJfaoX&}=s!(n>sLMxNVv4Laq>cV0@yyZbr`4`1gU$8}d)?m6!ga#L
z>L>ciYx(ah3a2`dk)}bHKThpyCT7Z;H!10?{Hgc~dvLGGDk2hqtf}~){u|c6q#6D_
z#PRLY9+Q~2p8!y&G=XLxNe41^b<lMf#~^nB=@iH!vI6I(;w$ap&uhyK`bqY>teZuq
zuylSUTd(36C%T&Jqc#iDVbu)|#!SrCSEkx*ek5A-i(h*P%7<Ou)U#o~$s%ZPEFv<L
z4_UI(FQ*L22kv}xNk~6nAqv9ry!z5pTn9OCIna3RJYU*BJ@WDTpM%{kF6N;}T*2@$
zm1Ntg;bB1Q*QrhyoV8lAwz2XZ6d;BTI=l94Y8SQ{u|iAZ7GO0(*b9S5&4T`z^uC_}
zAeAh&7J^PKveKg<FCsDGfIj5jiB9z}1_UCg*Wa8sAj(h72*zv3VB;m2z~O}V>Lf+<
zy*DrDx*c_$p?&<~uB7xx12A`^O}d*ia^zr$)KjT}^NY7w=i}xSlvvFNe7xBHdXE9|
z27u_eyj5f%J`BOW>luj>vB%273vYAv&-^>%$8zu1BiS>Fu&y?MDPR`s1Tq53v`D-F
zN#qy9ItyX3dAAH{50VCtjjGAu9=qMtu=POV%FqsK9u{e~-XZke6B=^NGo-!H&X+vg
gaSONw+yZU^w}4yVe<^UKcQ&KvGxI(Vk3Am$0x-=eNB{r;

literal 0
HcmV?d00001

diff --git a/tests/j_ext_dumpe2fs/name b/tests/j_ext_dumpe2fs/name
new file mode 100644
index 0000000..60d276c
--- /dev/null
+++ b/tests/j_ext_dumpe2fs/name
@@ -0,0 +1 @@
+dumpe2fs of external journal device
diff --git a/tests/j_ext_dumpe2fs/script b/tests/j_ext_dumpe2fs/script
new file mode 100644
index 0000000..1611c45
--- /dev/null
+++ b/tests/j_ext_dumpe2fs/script
@@ -0,0 +1,40 @@
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
+gunzip < $test_dir/image.gz > $TMPFILE
+
+echo "e2fsck external journal" >> $OUT
+$FSCK -fy -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+echo "dumpe2fs external journal" >> $OUT
+$DUMPE2FS $TMPFILE > $OUT.new 2>&1
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+rm -f $OUT.new
+
+rm -f $TMPFILE
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

