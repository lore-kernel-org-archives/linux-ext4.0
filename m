Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9134B1B0
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010722; cv=none; b=Xe1bgoTn2Gv35G90UfHMf9SXK9V0f5NpYq0mq9UDE14frxQXfuJoqJtMx/PBsAFDDvxqssaoP+lDzcx/ynwtiXqhaFNCyf8FZCG9zKcX5fi+5ZZZpIcU07h3V/Lmcd2eQmlv2wKBoW7++TAuuqUfC0mvqiluIrB9iN6Kr4gN238=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010722; c=relaxed/simple;
	bh=vbQ//l0g/WfhUwKHaLzuzF1bBurov1gfViM6w25EZmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaTeX7Uk0Q64HyZs/Aj6DjYipx1+YZZOvv5r6+CTcQWWd+74O4kiJTFGSQJSXHA8DwF2T5khOCfTEcExCzpzWK57n+OMWqrDGKhFurCkY75pWYPEosIIBNbnaP80Ahb0FwfamkTKGCwphDF0tpbB++6eiQ0ueZeFq5X2D6CtZWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=WOcK2TQJ; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="WOcK2TQJ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784010710; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jRAe0MPvtW/v8AbpVoVMWlf9vvW8L7VRFFfYBW7Khig=;
	b=WOcK2TQJZBEQajeCoKIaTlrJXKSjIvcjqXvZR1Pi9376rUqlTvAvr69A8vtGdDbCh/5N3kqHi2pi4uWNE9cAJU51SIVJ9LWXSB5q8uEtqtnuXtWcfVGDfSfROfgSKrxgdAaFWGjl+OBe3Gwj1KK2gXI8fqLkogYi+aw/BmIWwak=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X73IA1y_1784010708;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X73IA1y_1784010708 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Jul 2026 14:31:49 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH e2fsprogs 5/5] tests: add orphan-cleanup flush regression test
Date: Tue, 14 Jul 2026 14:31:36 +0800
Message-ID: <20260714063136.1284287-6-libaokun@linux.alibaba.com>
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

Add f_orphan_flush_abort, which drives e2fsck directly:

1. Build an ext4 image whose inode 12 is an orphan (links_count 0,
   s_last_orphan = 12).
2. Run e2fsck with a nonexistent bad-blocks file so that orphan
   cleanup runs first and then read_bad_blocks_file aborts the run
   via exit() before the normal superblock write-back.
3. Check that s_last_orphan is 0 on disk afterwards.

Without the flush after orphan cleanup, s_last_orphan stays stale on
disk (still 12) while the orphan inode has already been written back,
which the kernel rejects as a "bad orphan inode" on next mount.

Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 tests/f_orphan_flush_abort/expect.1 |  7 ++++
 tests/f_orphan_flush_abort/name     |  1 +
 tests/f_orphan_flush_abort/script   | 61 +++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)
 create mode 100644 tests/f_orphan_flush_abort/expect.1
 create mode 100644 tests/f_orphan_flush_abort/name
 create mode 100644 tests/f_orphan_flush_abort/script

diff --git a/tests/f_orphan_flush_abort/expect.1 b/tests/f_orphan_flush_abort/expect.1
new file mode 100644
index 000000000000..0a6d09f16e36
--- /dev/null
+++ b/tests/f_orphan_flush_abort/expect.1
@@ -0,0 +1,7 @@
+Clearing orphaned inode 12 (uid=0, gid=0, mode=0100644, size=8192)
+read_bad_blocks_file: No such file or directory while trying to open test.img
+
+test.img: ***** FILE SYSTEM WAS MODIFIED *****
+Exit status is 9
+Orphan before e2fsck: 12
+Orphan after e2fsck: 0 (cleared)
diff --git a/tests/f_orphan_flush_abort/name b/tests/f_orphan_flush_abort/name
new file mode 100644
index 000000000000..c9292546c6dd
--- /dev/null
+++ b/tests/f_orphan_flush_abort/name
@@ -0,0 +1 @@
+orphan cleanup superblock flush survives a later abort
diff --git a/tests/f_orphan_flush_abort/script b/tests/f_orphan_flush_abort/script
new file mode 100644
index 000000000000..9c18011b40db
--- /dev/null
+++ b/tests/f_orphan_flush_abort/script
@@ -0,0 +1,61 @@
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs)"
+	return 0
+fi
+
+TEST_DATA="$test_name.tmp"
+OUT=$test_name.log
+
+dd if=/dev/zero of=$TEST_DATA bs=8k count=1 > /dev/null 2>&1
+
+$MKE2FS -Fq -t ext4 -o Linux $TMPFILE 4M > /dev/null 2>&1
+
+# Create an orphan inode: testfile becomes inode 12 (the first regular inode
+# on a fresh fs), drop its link count to 0 and point s_last_orphan at it so
+# e2fsck will run orphan cleanup.
+$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+write $TEST_DATA testfile
+set_inode_field testfile links_count 0
+set_super_value last_orphan 12
+unlink testfile
+quit
+EOF
+
+ORPHAN_BEFORE=$($DUMPE2FS $TMPFILE 2>&1 | grep -E "First orphan inode" | awk '{print $NF}')
+
+cp /dev/null $OUT
+
+# Run e2fsck with a nonexistent bad blocks file.  Orphan cleanup runs first
+# and clears s_last_orphan, then read_bad_blocks_file fails and e2fsck aborts
+# via exit() before the normal superblock write-back.  The fix flushes the
+# superblock right after orphan cleanup, so s_last_orphan is 0 on disk even
+# though the run aborted; without it the disk keeps a stale s_last_orphan
+# while the orphan inode has already been written back, which the kernel
+# rejects as a "bad orphan inode" on next mount.
+$FSCK -yf -l /nonexistent/bad_blocks_file $TMPFILE > $OUT.new 2>&1
+status=$?
+echo "Exit status is $status" >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s|$TMPFILE|test.img|g" $OUT.new > $OUT
+rm -f $OUT.new
+
+ORPHAN_AFTER=$($DUMPE2FS $TMPFILE 2>&1 | grep -E "First orphan inode" | awk '{print $NF}')
+
+echo "Orphan before e2fsck: $ORPHAN_BEFORE" >> $OUT
+if [ -z "$ORPHAN_AFTER" ]; then
+	echo "Orphan after e2fsck: 0 (cleared)" >> $OUT
+else
+	echo "Orphan after e2fsck: $ORPHAN_AFTER (BUG: should be 0!)" >> $OUT
+fi
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
+rm -f $TEST_DATA
+unset OUT TEST_DATA
-- 
2.43.7

