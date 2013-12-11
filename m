From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 68/74] tests: Add block_validity speed test
Date: Tue, 10 Dec 2013 17:25:52 -0800
Message-ID: <20131211012552.30655.46334.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44024 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3LKB0D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:26:03 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Extend the metadata checksum speed test to evaluate the performance
impact of the block_validity mount option.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   72 +++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 7 deletions(-)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 1c73e58..0703501 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -192,6 +192,15 @@ cat > "${MKE2FS_CONFIG}" << ENDL
 	inode_ratio = 16384
 
 [fs_types]
+	ext4icsum_no_bv = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit$MKFS_OPTS
+		default_mntopts = acl,user_xattr
+		inode_size = ${INODE_SZ}
+		blocksize = ${BLK_SZ}
+		options = mmp_update_interval=5 #${RESIZE_PARAM}
+		lazy_itable_init = 1
+		cluster_size = $((BLK_SZ * 2))
+	}
 	ext4icsum = {
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit$MKFS_OPTS
 		inode_size = ${INODE_SZ}
@@ -3171,11 +3180,14 @@ if [ ! -r /tmp/tarfiles ]; then
 fi
 if [ ! -r /tmp/dirs -o ! -r /tmp/files -o ! -r /tmp/topdirs ]; then
 	rm -rf /tmp/dirs /tmp/files /tmp/topdirs
+	set +x
+	echo '+ create_fab_config'
 	for i in a1 a2 a3 a4 a5 a6 a7 a8 a9 aA aB aC aD aE aF; do
 		cat /tmp/tarfiles | grep ^d | awk "{printf(\"$i/%s\n\", \$6);}" >> /tmp/dirs
 		cat /tmp/tarfiles | grep -v ^d | awk "{printf(\"%s $i/%s\n\", \$3, \$6);}" >> /tmp/files
 		echo "$i" >> /tmp/topdirs
 	done
+	set -x
 fi
 if [ ! -x /tmp/fab ]; then
 	cat > /tmp/fab.c << ENDL
@@ -3188,19 +3200,28 @@ if [ ! -x /tmp/fab ]; then
 #include <stdlib.h>
 #include <errno.h>
 
+#define ZERO_BUF_SZ 65536
+char zeroes[ZERO_BUF_SZ];
+
 int main(int argc, char *argv[])
 {
 	FILE *fp;
 	int fd, ret;
-	size_t size;
+	size_t size, off, retoff;
 	char *space;
 	char buf[1024];
+	int write_files = 0;
 
 	if (argc < 2) {
 		printf("Usage: %s file_containing_sz_name_pairs\n", argv[0]);
 		return 4;
 	}
 
+	if (getenv("FAB_WRITE_FILES")) {
+		write_files = 1;
+		memset(zeroes, 0, ZERO_BUF_SZ);
+	}
+
 	fp = fopen(argv[1], "r");
 	if (!fp) {
 		perror(argv[1]);
@@ -3223,12 +3244,23 @@ int main(int argc, char *argv[])
 		}
 		size = strtoul(buf, NULL, 0);
 		if (size) {
-			ret = posix_fallocate(fd, 0, size);
-			if (ret) {
-				errno = ret;
-				perror(space);
-				close(fd);
-				break;
+			if (write_files) {
+				for (off = 0; off < size; off += ZERO_BUF_SZ) {
+					retoff = pwrite(fd, zeroes, (size - off) % ZERO_BUF_SZ, off);
+					if (retoff != (size - off) % ZERO_BUF_SZ) {
+						perror(space);
+						close(fd);
+						break;
+					}
+				}
+			} else {
+				ret = posix_fallocate(fd, 0, size);
+				if (ret) {
+					errno = ret;
+					perror(space);
+					close(fd);
+					break;
+				}
 			}
 		}
 		close(fd);
@@ -3331,6 +3363,32 @@ umount $MNT
 }
 
 #####################
+function block_validity_speed_test {
+test "${SKIP_SPEED_TESTS}" -gt 0 && return
+msg "block_validity_speed_test"
+prep_speed_test
+
+msg "No block_validity"
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum_no_bv $MKFS_OPTS $MKFS_FEATURES -F "${DEV}"
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4
+cd "${MNT}"
+/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
+/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
+cd -
+umount "${MNT}"
+
+msg "Yes block_validity"
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o block_validity
+cd "${MNT}"
+/usr/bin/time bash -c "mkdir -p \$(cat /tmp/dirs); /tmp/fab /tmp/files; sync"
+/usr/bin/time bash -c "rm -rf \$(cat /tmp/topdirs); sync"
+cd -
+umount "${MNT}"
+}
+
+#####################
 
 # Allow restarting of a test run by giving the test name and a plus sign.
 VERBS_LEN="${#VERBS}"

