From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 73/74] tests: add large symlink test
Date: Tue, 10 Dec 2013 17:26:31 -0800
Message-ID: <20131211012631.30655.22099.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44223 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3LKB0h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:26:37 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test the creation and reading of a large symlink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/metadata-checksum-test.sh |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index 4e353e1..d34985b 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -3277,6 +3277,30 @@ ${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile' "${DEV}" | grep -c "Size: ${FILE
 ${E2FSPROGS}/debugfs/debugfs -R 'stat /bigfile2' "${DEV}" | grep -c "Size: ${FILE_SIZE}"
 }
 
+##########################
+function big_symlink_test {
+msg "big_symlink_test"
+
+$VALGRIND ${E2FSPROGS}/misc/mke2fs -T ext4icsum $MKFS_OPTS $MKFS_FEATURES -F "${DEV}"
+test -z "$NO_CSUM" && $VALGRIND ${E2FSPROGS}/misc/tune2fs -O metadata_csum $DEV
+${E2FSPROGS}/misc/dumpe2fs -h $DEV 2> /dev/null | egrep -q "^Filesystem state:[ ]*clean$" || ${fsck_cmd} -fDy $DEV || true
+
+set +x
+LINK_TARGET="/$(printf "x%.0s" {1..1000})"
+set -x
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+ln -s "${LINK_TARGET}" "${MNT}/biglink"
+umount "${MNT}"
+${E2FSPROGS}/debugfs/debugfs -R 'stat /biglink' "${DEV}" | cat -
+${fsck_cmd} -C0 -f -n "${DEV}"
+
+${mount_cmd} ${MOUNT_OPTS} "${DEV}" "${MNT}" -t ext4 -o journal_checksum
+LINK_NOW="$(readlink "${MNT}/biglink")"
+umount "${MNT}"
+
+test "${LINK_NOW}" = "${LINK_TARGET}"
+}
+
 # This test should be the last one (before speed tests, anyway)
 
 #### ALL SPEED TESTS GO AT THE END

