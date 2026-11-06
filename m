Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793951389;
	b=KkhosZwZJ5BBBuMy6N4rYItef5UGLlBrBRbzh/J+TwrBBCzCjKLV9AJRxIB5QYJ5fO/R
	 +JXIfvMqH6ECpNqq48bvHLpXvRtI2ciib+y1NbNxW2Ja1542iKm5ebMsbIG/SQJnQvyL1
	 ckgUWtWosz0Jr2677JBlJtKV6aQUgVfkNsO6Nvej4Vlk39XtXef19dzVJjWvHWeXpYteH
	 Ej/mzKxhxJF1hVDYsQbHPWDa0jptpYzMfJYPyOOwB+1yjYyCXZ9N1WoGFz62NeeZob5Z9
	 D3smf8SbvmZtMuRec8tBfZuaFyL64lPzy5jqw7Gc5El+NUUWIYUHT1+hxQYO/nFF+Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951389;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=SepoqOBIH35nB/FkCEe9apXI5pwKb8GPvQVFdYUNpjM=;
	b=3JUwLWD6X8NELyVh6di3oejcIIizUKGD8JyD5jtlaRQJ7oFMVqiKcQR+AOVx6x7sNpKT
	 w4q+UVsVzEgRHAruaTZwc8xQUJBL9m/uVbEUPDl6N32KZq6oUrJY1yaa3CSMBgo6AywTU
	 9pR9MH4UWBNcA9jZ3zeYzbPXkWWzFnkdWdQpkMdardDevJ51JqsU3R55m+upZBLlExh2T
	 +0BL38SpJsNI117yGRiaqgfaqCqFiq3G+rYemHeV0e9xcBr8bgxZM1RVY+puwybsQYngY
	 l7FkOB1dufDI0hq6wPl+HH64K7aT/RxxTnaH+I42GVXxX8OyTGTeqqdOcJLJ61MgJ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=126.com;
	spf=pass smtp.mailfrom=126.com;
	dkim=pass header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=f6uzlnxI;
	arc=none smtp.remote-ip=220.197.31.9
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF2D606A326
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 07:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABF2D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=f6uzlnxI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Se
	poqOBIH35nB/FkCEe9apXI5pwKb8GPvQVFdYUNpjM=; b=f6uzlnxId0bC5yAhRK
	nHB8p3Rj+qjicIrBWlo5jDDLR/q8RupR3aRnRMMSO0+paJUzkeT2OTTMt2BXiUuz
	C5xI4gR9fSJbq8v0e82XvmIzRboqajjGAbxKX6tgPwq6mYp6WtHB85vsW7fEt5Ta
	1w+3shJsoiTAnNWKCl/iSJOLA=
Received: from yean-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3xwd8hu1q4tKoCg--.1810S2;
	Fri, 06 Nov 2026 15:49:32 +0800 (CST)
From: wangyining <yeanwang666@126.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
Subject: [PATCH] libext2fs: reject existing mkdir names before writing inodes
Date: Fri,  6 Nov 2026 15:49:13 +0800
Message-ID: <20261106074913.112512-1-yeanwang666@126.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3xwd8hu1q4tKoCg--.1810S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKrWxuF4kXFyUtF45Ar1UZFb_yoWxXrWUpa
	95GFWrKr1xJFW7uFs3GF4xZrySqa18try5CryxW3W8AF9xK3sIyr4akry5Za47Cr45Z3yj
	vF45XFW8Gw4UGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jIbyAUUUUU=
X-CM-SenderInfo: x1hd04hdqjllaw6rjloofrz/xtbBpQzaZGrthowLkgAA3D

From: wangyining <wangyining@kylinos.cn>

ext2fs_mkdir2() checks whether the destination name already exists only
after writing a new inode and directory data. On EEXIST, cleanup undoes
the allocation accounting but leaves the newly written inode on disk
with a nonzero link count and references to blocks marked free.

For example, on a freshly formatted ext4 image:

  img=$(mktemp)
  truncate -s 32M "$img"
  mke2fs -q -F -t ext4 "$img"
  debugfs -w -R 'mkdir /lost+found' "$img"
  e2fsck -fn "$img"

The final check reports an unconnected directory, link-count errors and
inode/block bitmap differences. This is also reproducible with ext2 and
inline-data directories.

Check the destination name before allocating or writing anything when
the parent already exists. Retain the post-initialization lookup for a
self-parented directory, since that form is also used to bootstrap the
parent inode itself.

Add a regression test covering an existing directory and an existing
regular file on ext2, ext4 and inline-data filesystems. Check both that
the complete image is unchanged and that a read-only e2fsck succeeds.

Signed-off-by: wangyining <wangyining@kylinos.cn>
---
 lib/ext2fs/mkdir.c            | 28 +++++++++++++------
 tests/d_mkdir_existing/expect | 30 +++++++++++++++++++++
 tests/d_mkdir_existing/name   |  1 +
 tests/d_mkdir_existing/script | 51 +++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 8 deletions(-)
 create mode 100644 tests/d_mkdir_existing/expect
 create mode 100644 tests/d_mkdir_existing/name
 create mode 100644 tests/d_mkdir_existing/script

diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 45f6e9e..4bf64d7 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -47,6 +47,16 @@ errcode_t ext2fs_mkdir2(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	/* Reject existing names before writing an unlinked inode to disk. */
+	if (name && parent != ino) {
+		retval = ext2fs_lookup(fs, parent, name, strlen(name), 0,
+				       &scratch_ino);
+		if (!retval)
+			return EXT2_ET_DIR_EXISTS;
+		if (retval != EXT2_ET_FILE_NOT_FOUND)
+			return retval;
+	}
+
 	/*
 	 * Create a new dir with inline data iff this feature is enabled
 	 * and ino >= EXT2_FIRST_INO.
@@ -159,15 +169,17 @@ errcode_t ext2fs_mkdir2(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 * Link the directory into the filesystem hierarchy
 	 */
 	if (name) {
-		retval = ext2fs_lookup(fs, parent, name, strlen(name), 0,
-				       &scratch_ino);
-		if (!retval) {
-			retval = EXT2_ET_DIR_EXISTS;
-			name = 0;
-			goto cleanup;
+		/* A self-parented directory could not be looked up until now. */
+		if (parent == ino) {
+			retval = ext2fs_lookup(fs, parent, name, strlen(name), 0,
+					       &scratch_ino);
+			if (!retval) {
+				retval = EXT2_ET_DIR_EXISTS;
+				goto cleanup;
+			}
+			if (retval != EXT2_ET_FILE_NOT_FOUND)
+				goto cleanup;
 		}
-		if (retval != EXT2_ET_FILE_NOT_FOUND)
-			goto cleanup;
 		retval = ext2fs_link(fs, parent, name, ino,
 				     EXT2_FT_DIR | link_flags);
 		if (retval)
diff --git a/tests/d_mkdir_existing/expect b/tests/d_mkdir_existing/expect
new file mode 100644
index 0000000..6927ee0
--- /dev/null
+++ b/tests/d_mkdir_existing/expect
@@ -0,0 +1,30 @@
+ext2: mkdir /existing
+ext2fs_mkdir2: Ext2 directory already exists while creating directory "existing"
+mkdir: Ext2 directory already exists
+Image comparison exit status: 0
+Fsck exit status: 0
+ext2: mkdir /file
+ext2fs_mkdir2: Ext2 directory already exists while creating directory "file"
+mkdir: Ext2 directory already exists
+Image comparison exit status: 0
+Fsck exit status: 0
+ext4: mkdir /existing
+ext2fs_mkdir2: Ext2 directory already exists while creating directory "existing"
+mkdir: Ext2 directory already exists
+Image comparison exit status: 0
+Fsck exit status: 0
+ext4: mkdir /file
+ext2fs_mkdir2: Ext2 directory already exists while creating directory "file"
+mkdir: Ext2 directory already exists
+Image comparison exit status: 0
+Fsck exit status: 0
+inline: mkdir /existing
+ext2fs_mkdir2: Ext2 directory already exists while creating directory "existing"
+mkdir: Ext2 directory already exists
+Image comparison exit status: 0
+Fsck exit status: 0
+inline: mkdir /file
+ext2fs_mkdir2: Ext2 directory already exists while creating directory "file"
+mkdir: Ext2 directory already exists
+Image comparison exit status: 0
+Fsck exit status: 0
diff --git a/tests/d_mkdir_existing/name b/tests/d_mkdir_existing/name
new file mode 100644
index 0000000..c21b153
--- /dev/null
+++ b/tests/d_mkdir_existing/name
@@ -0,0 +1 @@
+mkdir on an existing name leaves the filesystem unchanged
diff --git a/tests/d_mkdir_existing/script b/tests/d_mkdir_existing/script
new file mode 100644
index 0000000..6b1fc75
--- /dev/null
+++ b/tests/d_mkdir_existing/script
@@ -0,0 +1,51 @@
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs)"
+	return 0
+fi
+
+OUT=$test_name.log
+EXP=$test_dir/expect
+> $OUT
+
+for fs_type in ext2 ext4 inline; do
+	rm -f $TMPFILE
+	if [ "$fs_type" = inline ]; then
+		$MKE2FS -q -F -t ext4 -O inline_data -b 1024 $TMPFILE 8192 \
+			> /dev/null 2>&1
+	else
+		$MKE2FS -q -F -t $fs_type -b 1024 $TMPFILE 8192 \
+			> /dev/null 2>&1
+	fi
+	$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+mkdir /existing
+write /dev/null /file
+EOF
+	cp $TMPFILE $TMPFILE.before
+	for entry in existing file; do
+		cp $TMPFILE.before $TMPFILE
+		echo "$fs_type: mkdir /$entry" >> $OUT
+		$DEBUGFS -w -R "mkdir /$entry" $TMPFILE 2>&1 | \
+			$CLEAN_OUTPUT | sed 's/ *$//' >> $OUT
+		cmp -s $TMPFILE.before $TMPFILE
+		echo "Image comparison exit status: $?" >> $OUT
+		$FSCK -fn $TMPFILE > $TMPFILE.fsck 2>&1
+		status=$?
+		echo "Fsck exit status: $status" >> $OUT
+		if [ "$status" != 0 ]; then
+			cat $TMPFILE.fsck >> $OUT
+		fi
+	done
+done
+
+cmp -s $OUT $EXP
+status=$?
+if [ "$status" = 0 ]; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+rm -f $TMPFILE $TMPFILE.before $TMPFILE.fsck
+unset OUT EXP fs_type entry

base-commit: 75e95512b22c57db042a53e2fe1af7fcc0a3b2e3

