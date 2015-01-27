From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 20/54] e2fsck: add a 'yes to all' response in interactive
 mode
Date: Mon, 26 Jan 2015 23:37:44 -0800
Message-ID: <20150127073744.13308.73411.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46131 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbbA0Hht (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:49 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a mechanism for a user to switch fsck into '-y' mode if they
start an interactive session and then get tired of pressing 'y' in
response to numerous prompts.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.8.in        |   13 +++++++++
 e2fsck/unix.c             |    2 +
 e2fsck/util.c             |   36 ++++++++++++++++++++++----
 tests/f_no/expect         |   48 +++++++++++++++++++++++++++++++++++
 tests/f_no/script         |   27 ++++++++++++++++++++
 tests/f_yes/expect        |   45 +++++++++++++++++++++++++++++++++
 tests/f_yes/script        |   27 ++++++++++++++++++++
 tests/f_yesall/expect     |   62 +++++++++++++++++++++++++++++++++++++++++++++
 tests/f_yesall/image.gz   |  Bin
 tests/f_yesall/script     |   27 ++++++++++++++++++++
 tests/f_yesthenall/expect |   52 ++++++++++++++++++++++++++++++++++++++
 tests/f_yesthenall/script |   27 ++++++++++++++++++++
 tests/f_yesthenno/expect  |   50 ++++++++++++++++++++++++++++++++++++
 tests/f_yesthenno/script  |   27 ++++++++++++++++++++
 14 files changed, 436 insertions(+), 7 deletions(-)
 create mode 100644 tests/f_no/expect
 create mode 100644 tests/f_no/script
 create mode 100644 tests/f_yes/expect
 create mode 100644 tests/f_yes/script
 create mode 100644 tests/f_yesall/expect
 create mode 100644 tests/f_yesall/image.gz
 create mode 100644 tests/f_yesall/script
 create mode 100644 tests/f_yesthenall/expect
 create mode 100644 tests/f_yesthenall/script
 create mode 100644 tests/f_yesthenno/expect
 create mode 100644 tests/f_yesthenno/script


diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index f5ed758..3367f4f 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -68,6 +68,19 @@ are not valid if the filesystem is mounted.   If
 asks whether or not you should check a filesystem which is mounted, 
 the only correct answer is ``no''.  Only experts who really know what
 they are doing should consider answering this question in any other way.
+.PP
+If
+.B e2fsck
+is run in interactive mode (meaning that none of
+.BR \-y ,
+.BR \-n ,
+or
+.BR \-p
+are specified), the program will ask the user to fix each problem found in the
+filesystem.  A response of 'y' will fix the error; 'n' will leave the error
+unfixed; and 'a' will fix the problem and all subsequent problems; pressing
+Enter will proceed with the default response, which is printed before the
+question mark.  Pressing Control-C terminates e2fsck immediately.
 .SH OPTIONS
 .TP
 .B \-a 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 5cba013..7377e01 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -760,7 +760,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 
 	setvbuf(stdout, NULL, _IONBF, BUFSIZ);
 	setvbuf(stderr, NULL, _IONBF, BUFSIZ);
-	if (isatty(0) && isatty(1)) {
+	if (getenv("E2FSCK_FORCE_INTERACTIVE") || (isatty(0) && isatty(1))) {
 		ctx->interactive = 1;
 	} else {
 		ctx->start_meta[0] = '\001';
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 2de45f8..e2fb982 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -189,6 +189,10 @@ int ask_yn(e2fsck_t ctx, const char * string, int def)
 	const char	*defstr;
 	const char	*short_yes = _("yY");
 	const char	*short_no = _("nN");
+	const char	*short_yesall = _("aA");
+	const char	*yesall_prompt = _(" ('a' enables 'yes' to all) ");
+	const char	*extra_prompt = "";
+	static int	yes_answers;
 
 #ifdef HAVE_TERMIOS_H
 	struct termios	termios, tmp;
@@ -207,7 +211,16 @@ int ask_yn(e2fsck_t ctx, const char * string, int def)
 		defstr = _(_("<n>"));
 	else
 		defstr = _(" (y/n)");
-	log_out(ctx, "%s%s? ", string, defstr);
+	/*
+	 * If the user presses 'y' more than 8 (but less than 12) times in
+	 * succession without pressing anything else, display a hint about
+	 * yes-to-all mode.
+	 */
+	if (yes_answers > 12)
+		yes_answers = -1;
+	else if (yes_answers > 8)
+		extra_prompt = yesall_prompt;
+	log_out(ctx, "%s%s%s? ", string, extra_prompt, defstr);
 	while (1) {
 		fflush (stdout);
 		if ((c = read_a_char()) == EOF)
@@ -221,20 +234,31 @@ int ask_yn(e2fsck_t ctx, const char * string, int def)
 				longjmp(e2fsck_global_ctx->abort_loc, 1);
 			}
 			log_out(ctx, "%s", _("cancelled!\n"));
+			yes_answers = 0;
 			return 0;
 		}
 		if (strchr(short_yes, (char) c)) {
 			def = 1;
+			if (yes_answers >= 0)
+				yes_answers++;
 			break;
-		}
-		else if (strchr(short_no, (char) c)) {
+		} else if (strchr(short_no, (char) c)) {
 			def = 0;
+			yes_answers = -1;
 			break;
-		}
-		else if ((c == 27 || c == ' ' || c == '\n') && (def != -1))
+		} else if (strchr(short_yesall, (char)c)) {
+			def = 2;
+			yes_answers = -1;
+			ctx->options |= E2F_OPT_YES;
 			break;
+		} else if ((c == 27 || c == ' ' || c == '\n') && (def != -1)) {
+			yes_answers = -1;
+			break;
+		}
 	}
-	if (def)
+	if (def == 2)
+		log_out(ctx, "%s", _("yes to all\n"));
+	else if (def)
 		log_out(ctx, "%s", _("yes\n"));
 	else
 		log_out(ctx, "%s", _("no\n"));
diff --git a/tests/f_no/expect b/tests/f_no/expect
new file mode 100644
index 0000000..e7b619d
--- /dev/null
+++ b/tests/f_no/expect
@@ -0,0 +1,48 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 999999999, len 1)
+Clear<y>? no
+Inode 12 has an invalid extent
+	(logical block 1, invalid physical block 9999999999, len 1)
+Clear<y>? no
+Inode 13 is in use, but has dtime set.  Fix<y>? no
+Inode 13 has an invalid extent
+	(logical block 1, invalid physical block 8888888888888, len 1)
+Clear<y>? no
+Inode 13 has an invalid extent
+	(logical block 0, invalid physical block 888888888888, len 1)
+Clear<y>? no
+Inode 14 is in use, but has dtime set.  Fix<y>? no
+Inode 14 has an invalid extent
+	(logical block 300, invalid physical block 777777777777, len 300)
+Clear<y>? no
+Inode 14 has an invalid extent
+	(logical block 0, invalid physical block 7777777777, len 1)
+Clear<y>? no
+Inode 14, i_blocks is 52574694748113, should be 0.  Fix<y>? no
+Pass 2: Checking directory structure
+Extended attribute block for inode 12 (/a) is invalid (999999).
+Clear<y>? no
+Extended attribute block for inode 13 (/b) is invalid (298954296).
+Clear<y>? no
+Extended attribute block for inode 14 (/c) is invalid (388697201).
+Clear<y>? no
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Inode 12 ref count is 34463, should be 1.  Fix<y>? no
+Inode 13 ref count is 9999, should be 1.  Fix<y>? no
+Inode 14 ref count is 12241, should be 1.  Fix<y>? no
+Pass 5: Checking group summary information
+Block bitmap differences:  -202 -381 -457
+Fix<y>? no
+Free blocks count wrong for group #0 (0, counted=491).
+Fix<y>? no
+Free blocks count wrong (494, counted=491).
+Fix<y>? no
+Free inodes count wrong for group #0 (4294967293, counted=114).
+Fix<y>? no
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 4
diff --git a/tests/f_no/script b/tests/f_no/script
new file mode 100644
index 0000000..2a67e77
--- /dev/null
+++ b/tests/f_no/script
@@ -0,0 +1,27 @@
+test_description="e2fsck with repeated no"
+FSCK_OPT=-f
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $test_dir/../f_yesall/image.gz > $TMPFILE
+
+rm -rf $OUT
+echo "nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn" | E2FSCK_FORCE_INTERACTIVE=y $FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+rm -f $OUT.new
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
+	rm -f tmp_expect
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
diff --git a/tests/f_yes/expect b/tests/f_yes/expect
new file mode 100644
index 0000000..c73e620
--- /dev/null
+++ b/tests/f_yes/expect
@@ -0,0 +1,45 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 999999999, len 1)
+Clear<y>? yes
+Inode 12 has an invalid extent
+	(logical block 1, invalid physical block 9999999999, len 1)
+Clear<y>? yes
+Inode 13 is in use, but has dtime set.  Fix<y>? yes
+Inode 13 has an invalid extent
+	(logical block 1, invalid physical block 8888888888888, len 1)
+Clear<y>? yes
+Inode 13 has an invalid extent
+	(logical block 0, invalid physical block 888888888888, len 1)
+Clear<y>? yes
+Inode 14 is in use, but has dtime set.  Fix<y>? yes
+Inode 14 has an invalid extent
+	(logical block 300, invalid physical block 777777777777, len 300)
+Clear<y>? yes
+Inode 14 has an invalid extent
+	(logical block 0, invalid physical block 7777777777, len 1)
+Clear<y>? yes
+Inode 14, i_blocks is 52574694748113, should be 0.  Fix<y>? yes
+Pass 2: Checking directory structure
+Extended attribute block for inode 12 (/a) is invalid (999999).
+Clear ('a' enables 'yes' to all) <y>? yes
+Extended attribute block for inode 13 (/b) is invalid (298954296).
+Clear ('a' enables 'yes' to all) <y>? yes
+Extended attribute block for inode 14 (/c) is invalid (388697201).
+Clear ('a' enables 'yes' to all) <y>? yes
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Inode 12 ref count is 34463, should be 1.  Fix ('a' enables 'yes' to all) <y>? yes
+Inode 13 ref count is 9999, should be 1.  Fix<y>? yes
+Inode 14 ref count is 12241, should be 1.  Fix<y>? yes
+Pass 5: Checking group summary information
+Block bitmap differences:  -202 -381 -457
+Fix<y>? yes
+Free blocks count wrong for group #0 (0, counted=494).
+Fix<y>? yes
+Free inodes count wrong for group #0 (4294967293, counted=114).
+Fix<y>? yes
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_yes/script b/tests/f_yes/script
new file mode 100644
index 0000000..4e114c5
--- /dev/null
+++ b/tests/f_yes/script
@@ -0,0 +1,27 @@
+test_description="e2fsck with repeated yes"
+FSCK_OPT=-f
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $test_dir/../f_yesall/image.gz > $TMPFILE
+
+rm -rf $OUT
+echo "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy" | E2FSCK_FORCE_INTERACTIVE=y $FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+rm -f $OUT.new
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
+	rm -f tmp_expect
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
diff --git a/tests/f_yesall/expect b/tests/f_yesall/expect
new file mode 100644
index 0000000..f6d3c2b
--- /dev/null
+++ b/tests/f_yesall/expect
@@ -0,0 +1,62 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 999999999, len 1)
+Clear<y>? yes to all
+Inode 12 has an invalid extent
+	(logical block 1, invalid physical block 9999999999, len 1)
+Clear? yes
+
+Inode 13 is in use, but has dtime set.  Fix? yes
+
+Inode 13 has an invalid extent
+	(logical block 1, invalid physical block 8888888888888, len 1)
+Clear? yes
+
+Inode 13 has an invalid extent
+	(logical block 0, invalid physical block 888888888888, len 1)
+Clear? yes
+
+Inode 14 is in use, but has dtime set.  Fix? yes
+
+Inode 14 has an invalid extent
+	(logical block 300, invalid physical block 777777777777, len 300)
+Clear? yes
+
+Inode 14 has an invalid extent
+	(logical block 0, invalid physical block 7777777777, len 1)
+Clear? yes
+
+Inode 14, i_blocks is 52574694748113, should be 0.  Fix? yes
+
+Pass 2: Checking directory structure
+Extended attribute block for inode 12 (/a) is invalid (999999).
+Clear? yes
+
+Extended attribute block for inode 13 (/b) is invalid (298954296).
+Clear? yes
+
+Extended attribute block for inode 14 (/c) is invalid (388697201).
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Inode 12 ref count is 34463, should be 1.  Fix? yes
+
+Inode 13 ref count is 9999, should be 1.  Fix? yes
+
+Inode 14 ref count is 12241, should be 1.  Fix? yes
+
+Pass 5: Checking group summary information
+Block bitmap differences:  -202 -381 -457
+Fix? yes
+
+Free blocks count wrong for group #0 (0, counted=494).
+Fix? yes
+
+Free inodes count wrong for group #0 (4294967293, counted=114).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_yesall/image.gz b/tests/f_yesall/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..0f8b205d56977277a5c511d880cfda9209f6c540
GIT binary patch
literal 2597
zcmb2|=3sD**%89T{Pvc0hKQpC!-Jb=MGeJ^J6&8haF~gCU1HPeX?nn%v&TeAWd2l%
znngE`IC*nBvWV(5-MH!Mzkx%nsdrM4PHs+3Ll?)ZUDdmn8_rYQH)+NF@;}zryNj*A
zzt^ocKHbXjXT94dSD8bXwp7Tq7VNkoCmxt@5VXa6t^BG`XOBs1^%qSr;}>V!T&1UV
zswnWKfA{W}j($s@_H|yo_^vwI>`qm6>hl|q_nj@C`1)l3_4~5#Z<SPkIrDQ}_V2vq
zk~}TnEbg0I_TNv9{M9upM}O(Yi%Z!V4#=En+uwaDB5r-H$D>~_Ov)|x#C$J(tx|Z5
zfq~({`^j6T9r`^@&DzU%_V=2&ZfSoOpm4)az1hdMw`;u9UH0XzVqbOj=l>td+PD2U
z@L}R&?eF~Z);r8^hv!Sb^*Y^p^w+yBZ#*9Rsdjy<n8O6r`#Grc)Sv&Qs`LLd19|^v
z_$>!g3}^l`g5>H!Y$Cyr&67-nUjY>#us<#=K%^#Y%Ic1^9*o*5_&@mG`D@F%&!zp`
z-g2#KrvB|X*M%l8YXkQlT_1hzNp*oK)8@n{CA%c#Gm8FqcUj**ukF9m{awAm`kwU1
z^BdD1&$syEWBgB3^yBva`n-APPP^aEy6W~MdfhzU_^0yq#{azE#Yf3rz5aNDji&$a
zo!8f_KBMtp|L^&{f8yJ(ubQmfa;oe7)A`T$?AZE0=K0e-{}jHI+teDz+W$3I+m$w{
z{@(XD&-W*+2+MW(XKi}X{Gzz&+4|5aM<Xn*>?`t|S1-ahcgK%{U3F5qpOx$F|F5Yp
pSH<SlQL)hw7!85Z5Eu=C(GVC70V;&R57YS!Sqyg$GB7AG001R&FuDK$

literal 0
HcmV?d00001

diff --git a/tests/f_yesall/script b/tests/f_yesall/script
new file mode 100644
index 0000000..c3721ff
--- /dev/null
+++ b/tests/f_yesall/script
@@ -0,0 +1,27 @@
+test_description="e2fsck with yes-to-all"
+FSCK_OPT=-f
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $test_dir/image.gz > $TMPFILE
+
+rm -rf $OUT
+echo "annnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn" | E2FSCK_FORCE_INTERACTIVE=y $FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+rm -f $OUT.new
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
+	rm -f tmp_expect
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
diff --git a/tests/f_yesthenall/expect b/tests/f_yesthenall/expect
new file mode 100644
index 0000000..1fc3bde
--- /dev/null
+++ b/tests/f_yesthenall/expect
@@ -0,0 +1,52 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 999999999, len 1)
+Clear<y>? yes
+Inode 12 has an invalid extent
+	(logical block 1, invalid physical block 9999999999, len 1)
+Clear<y>? yes
+Inode 13 is in use, but has dtime set.  Fix<y>? yes
+Inode 13 has an invalid extent
+	(logical block 1, invalid physical block 8888888888888, len 1)
+Clear<y>? yes
+Inode 13 has an invalid extent
+	(logical block 0, invalid physical block 888888888888, len 1)
+Clear<y>? yes
+Inode 14 is in use, but has dtime set.  Fix<y>? yes
+Inode 14 has an invalid extent
+	(logical block 300, invalid physical block 777777777777, len 300)
+Clear<y>? yes
+Inode 14 has an invalid extent
+	(logical block 0, invalid physical block 7777777777, len 1)
+Clear<y>? yes
+Inode 14, i_blocks is 52574694748113, should be 0.  Fix<y>? yes
+Pass 2: Checking directory structure
+Extended attribute block for inode 12 (/a) is invalid (999999).
+Clear ('a' enables 'yes' to all) <y>? yes
+Extended attribute block for inode 13 (/b) is invalid (298954296).
+Clear ('a' enables 'yes' to all) <y>? yes to all
+Extended attribute block for inode 14 (/c) is invalid (388697201).
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Inode 12 ref count is 34463, should be 1.  Fix? yes
+
+Inode 13 ref count is 9999, should be 1.  Fix? yes
+
+Inode 14 ref count is 12241, should be 1.  Fix? yes
+
+Pass 5: Checking group summary information
+Block bitmap differences:  -202 -381 -457
+Fix? yes
+
+Free blocks count wrong for group #0 (0, counted=494).
+Fix? yes
+
+Free inodes count wrong for group #0 (4294967293, counted=114).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_yesthenall/script b/tests/f_yesthenall/script
new file mode 100644
index 0000000..eb11c23
--- /dev/null
+++ b/tests/f_yesthenall/script
@@ -0,0 +1,27 @@
+test_description="e2fsck with yes then yes-to-all"
+FSCK_OPT=-f
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $test_dir/../f_yesall/image.gz > $TMPFILE
+
+rm -rf $OUT
+echo "yyyyyyyyyyannnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn" | E2FSCK_FORCE_INTERACTIVE=y $FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+rm -f $OUT.new
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
+	rm -f tmp_expect
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
diff --git a/tests/f_yesthenno/expect b/tests/f_yesthenno/expect
new file mode 100644
index 0000000..de55f47
--- /dev/null
+++ b/tests/f_yesthenno/expect
@@ -0,0 +1,50 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 has an invalid extent
+	(logical block 0, invalid physical block 999999999, len 1)
+Clear<y>? yes
+Inode 12 has an invalid extent
+	(logical block 1, invalid physical block 9999999999, len 1)
+Clear<y>? yes
+Inode 13 is in use, but has dtime set.  Fix<y>? yes
+Inode 13 has an invalid extent
+	(logical block 1, invalid physical block 8888888888888, len 1)
+Clear<y>? yes
+Inode 13 has an invalid extent
+	(logical block 0, invalid physical block 888888888888, len 1)
+Clear<y>? yes
+Inode 14 is in use, but has dtime set.  Fix<y>? yes
+Inode 14 has an invalid extent
+	(logical block 300, invalid physical block 777777777777, len 300)
+Clear<y>? yes
+Inode 14 has an invalid extent
+	(logical block 0, invalid physical block 7777777777, len 1)
+Clear<y>? yes
+Inode 14, i_blocks is 52574694748113, should be 0.  Fix<y>? yes
+Pass 2: Checking directory structure
+Extended attribute block for inode 12 (/a) is invalid (999999).
+Clear ('a' enables 'yes' to all) <y>? yes
+Extended attribute block for inode 13 (/b) is invalid (298954296).
+Clear ('a' enables 'yes' to all) <y>? no
+Extended attribute block for inode 14 (/c) is invalid (388697201).
+Clear<y>? no
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Inode 12 ref count is 34463, should be 1.  Fix<y>? no
+Inode 13 ref count is 9999, should be 1.  Fix<y>? no
+Inode 14 ref count is 12241, should be 1.  Fix<y>? no
+Pass 5: Checking group summary information
+Block bitmap differences:  -202 -381 -457
+Fix<y>? no
+Free blocks count wrong for group #0 (0, counted=491).
+Fix<y>? no
+Free blocks count wrong (494, counted=491).
+Fix<y>? no
+Free inodes count wrong for group #0 (4294967293, counted=114).
+Fix<y>? no
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+
+test_filesys: ********** WARNING: Filesystem still has errors **********
+
+test_filesys: 14/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 4
diff --git a/tests/f_yesthenno/script b/tests/f_yesthenno/script
new file mode 100644
index 0000000..f41b78b
--- /dev/null
+++ b/tests/f_yesthenno/script
@@ -0,0 +1,27 @@
+test_description="e2fsck with yes then no"
+FSCK_OPT=-f
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $test_dir/../f_yesall/image.gz > $TMPFILE
+
+rm -rf $OUT
+echo "yyyyyyyyyynnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn" | E2FSCK_FORCE_INTERACTIVE=y $FSCK $FSCK_OPT -N test_filesys $TMPFILE > $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new >> $OUT
+rm -f $OUT.new
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
+	rm -f tmp_expect
+fi
+
+unset IMAGE FSCK_OPT OUT EXP

