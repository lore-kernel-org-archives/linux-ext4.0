Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3F830F7FB
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010719; cv=none; b=aT2NdgDRtQEt8XXTwEeK8JzGqB2EHi2cKWwojimTSc7htJ8es551MQdYoCOzwsJAfHzfHiHVniXRGP30njXm20dI7mNzD2NEbsaA0u3+0+F6f/4c5c5yfWrlDqaUa816pOCWy3ixcpMbDlHQ5udxKE1Qd0m8VFhBkORz0Z0yjxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010719; c=relaxed/simple;
	bh=HHApToZO0uRBOW+ZUM8TVl50d+nuk0VYjwhNoPpw8VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO5GBuRILJ1EmtjpMc4jGjAw3HEbk/HEDOkPZEyrxAVW91jrhRpdbLHeS6iOSjn2oJZD4Mi34fTYVElXu4vOkEq/+q/+Vi9wVzCQBEHTnEUhu6poWgbZ+exh8sr+7Ivuv5OwF2kC9glP8nfjpZPaO8NyCjFY9elYYSLuLHyMBMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VeJf8gbh; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VeJf8gbh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784010709; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eUv49TfaY8/LJlOYMuloCtu/gaM8SydwKwg4jzyuqnM=;
	b=VeJf8gbhh8XV9CihNw8S3Fq/IApt15Zp7FByGOxAsFVpRhviX2CUaqahqU0Prc+s6d+hQaGEmLJrF1jBAowrZwRhE15+thF9u+vrFMf0N2qJKACgifcKXh83lHWqPOoAcObhhOj/1728F/huq2aaRyIf6wy+1PE9hEbWHSZLOmg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X73IA1i_1784010708;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X73IA1i_1784010708 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 14:31:48 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH e2fsprogs 4/5] tests: add fsck option-parsing regression test
Date: Tue, 14 Jul 2026 14:31:35 +0800
Message-ID: <20260714063136.1284287-5-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
References: <20260714063136.1284287-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add f_fsck_opt_parse, which runs the fsck wrapper in dry-run mode
(-N) with -V so it echoes the exact argv it builds for the checker,
and asserts the wrapper:

  - consumes the util-linux "-l" (lockdisk) option instead of leaking
    it to e2fsck, where -l takes a bad-blocks-file argument and would
    swallow the following option; and
  - parses "-C 2" (progress fd as a separate argument) into "-C2"
    instead of dropping it and leaking "2" as a stray device name.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 tests/f_fsck_opt_parse/expect.1 |  2 ++
 tests/f_fsck_opt_parse/name     |  1 +
 tests/f_fsck_opt_parse/script   | 61 +++++++++++++++++++++++++++++++++
 tests/test_config               |  2 ++
 4 files changed, 66 insertions(+)
 create mode 100644 tests/f_fsck_opt_parse/expect.1
 create mode 100644 tests/f_fsck_opt_parse/name
 create mode 100644 tests/f_fsck_opt_parse/script

diff --git a/tests/f_fsck_opt_parse/expect.1 b/tests/f_fsck_opt_parse/expect.1
new file mode 100644
index 000000000000..10b716cd16a2
--- /dev/null
+++ b/tests/f_fsck_opt_parse/expect.1
@@ -0,0 +1,2 @@
+[fsck.ext4 (1) -- test.img] fsck.ext4 -f -C2 test.img 
+Exit status is 0
diff --git a/tests/f_fsck_opt_parse/name b/tests/f_fsck_opt_parse/name
new file mode 100644
index 000000000000..37135f686288
--- /dev/null
+++ b/tests/f_fsck_opt_parse/name
@@ -0,0 +1 @@
+fsck wrapper consumes -l and parses "-C fd" as a separate argument
diff --git a/tests/f_fsck_opt_parse/script b/tests/f_fsck_opt_parse/script
new file mode 100644
index 000000000000..92597ac11754
--- /dev/null
+++ b/tests/f_fsck_opt_parse/script
@@ -0,0 +1,61 @@
+if ! test -x $FSCK_WRAPPER_EXE; then
+	echo "$test_name: $test_description: skipped (no fsck wrapper)"
+	return 0
+fi
+
+OUT=$test_name.log
+
+$MKE2FS -Fq -t ext4 -o Linux $TMPFILE 4M > /dev/null 2>&1
+
+# The fsck wrapper resolves fsck.<type> via a fixed search path
+# (/sbin:...:$PATH).  Provide our own fsck.ext4 on $PATH as a fallback so a
+# checker is always found even in a clean build tree with none installed.  A
+# system /sbin/fsck.ext4, if present, is searched first and used instead, but
+# either way the printed path is normalized by filter.sed below.
+WRAPPER_DIR="$test_name.fsckdir"
+mkdir -p $WRAPPER_DIR
+ln -sf "$(cd ../e2fsck && pwd)/e2fsck" $WRAPPER_DIR/fsck.ext4
+SAVED_PATH="$PATH"
+export PATH="$WRAPPER_DIR:$PATH"
+
+# Suppress "WARNING: couldn't open /etc/fstab" from the fsck wrapper.
+SAVED_FSTAB_FILE="${FSTAB_FILE-unset}"
+export FSTAB_FILE=/dev/null
+
+cp /dev/null $OUT
+
+# Dry run (-N) so no checker is executed; -V echoes the exact argv the
+# wrapper builds for the checker, which is what we are asserting.  -T
+# suppresses the version banner so the output is stable across releases.
+#
+#   -l       lockdisk option from util-linux; the wrapper must consume it
+#            rather than leak it to e2fsck (where -l takes a bad-blocks-file
+#            argument and would swallow the following option).
+#   -C 2     progress fd given as a separate argument; the wrapper must read
+#            the "2" and emit "-C2", not drop it and leak "2" as a device.
+$FSCK_WRAPPER -N -T -V -f -l -C 2 $TMPFILE > $OUT.new 2>&1
+status=$?
+echo "Exit status is $status" >> $OUT.new
+sed -f $cmd_dir/filter.sed \
+	-e "s|$TMPFILE|test.img|g" \
+	-e "s|\[[^]]*fsck\.ext4|[fsck.ext4|g" $OUT.new > $OUT
+rm -f $OUT.new
+
+cmp -s $OUT $test_dir/expect.1
+status=$?
+if [ "$status" -eq 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $test_dir/expect.1 $OUT > $test_name.failed
+fi
+
+export PATH="$SAVED_PATH"
+if [ "$SAVED_FSTAB_FILE" = "unset" ]; then
+	unset FSTAB_FILE
+else
+	export FSTAB_FILE="$SAVED_FSTAB_FILE"
+fi
+rm -rf $WRAPPER_DIR
+unset OUT SAVED_PATH SAVED_FSTAB_FILE
diff --git a/tests/test_config b/tests/test_config
index 9dc762ce5a88..cb2654d59266 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -13,6 +13,8 @@ E2IMAGE="$USE_VALGRIND ../misc/e2image"
 E2IMAGE_EXE="../misc/e2image"
 DEBUGFS="$USE_VALGRIND ../debugfs/debugfs"
 DEBUGFS_EXE="../debugfs/debugfs"
+FSCK_WRAPPER="$USE_VALGRIND ../misc/fsck"
+FSCK_WRAPPER_EXE="../misc/fsck"
 TEST_BITS="test_data.tmp"
 RESIZE2FS_EXE="../resize/resize2fs"
 RESIZE2FS="$USE_VALGRIND $RESIZE2FS_EXE"
-- 
2.43.7

