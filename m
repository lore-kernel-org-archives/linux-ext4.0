From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/4 v3] XFS TESTS: Fix 252 Failure: Make 252 xfs only with MD5 checksum
Date: Wed, 29 Jun 2011 22:23:58 -0700
Message-ID: <1309411441-2491-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch modifies test 252 to run for only xfs, and also
adds an md5 checksum to each of the punch hole tests

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100755 100755 5efa243... 441bed0... M	252
:100644 100644 ddf63b0... c18f88a... M	common.punch
 252          |    2 +-
 common.punch |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/252 b/252
index 5efa243..441bed0 100755
--- a/252
+++ b/252
@@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 . ./common.punch
 
 # real QA test starts here
-_supported_fs generic
+_supported_fs xfs 
 _supported_os Linux
 
 _require_xfs_io_falloc_punch
diff --git a/common.punch b/common.punch
index ddf63b0..c18f88a 100644
--- a/common.punch
+++ b/common.punch
@@ -218,6 +218,12 @@ _filter_fiemap()
 	_coalesce_extents
 }
 
+# Prints the md5 checksum of a given file
+_md5_checksum()
+{
+	md5sum $1 | cut -d ' ' -f1
+}
+
 _filter_bmap()
 {
 	awk '
@@ -305,6 +311,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	2. into allocated space"
 	if [ "$remove_testfile" ]; then
@@ -315,6 +322,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	3. into unwritten space"
 	if [ "$remove_testfile" ]; then
@@ -325,6 +333,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	4. hole -> data"
 	if [ "$remove_testfile" ]; then
@@ -335,6 +344,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	5. hole -> unwritten"
 	if [ "$remove_testfile" ]; then
@@ -345,6 +355,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	6. data -> hole"
 	if [ "$remove_testfile" ]; then
@@ -355,6 +366,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	7. data -> unwritten"
 	if [ "$remove_testfile" ]; then
@@ -366,6 +378,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	8. unwritten -> hole"
 	if [ "$remove_testfile" ]; then
@@ -376,6 +389,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	9. unwritten -> data"
 	if [ "$remove_testfile" ]; then
@@ -387,6 +401,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	10. hole -> data -> hole"
 	if [ "$remove_testfile" ]; then
@@ -397,6 +412,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	11. data -> hole -> data"
 	if [ "$remove_testfile" ]; then
@@ -410,6 +426,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	12. unwritten -> data -> unwritten"
 	if [ "$remove_testfile" ]; then
@@ -421,6 +438,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	13. data -> unwritten -> data"
 	if [ "$remove_testfile" ]; then
@@ -433,6 +451,7 @@ _test_generic_punch()
 		-c "$zero_cmd 4k 12k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	14. data -> hole @ EOF"
 	rm -f $testfile
@@ -441,6 +460,7 @@ _test_generic_punch()
 		-c "$zero_cmd 12k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	15. data -> hole @ 0"
 	if [ "$remove_testfile" ]; then
@@ -451,6 +471,7 @@ _test_generic_punch()
 		-c "$zero_cmd 0k 8k" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 	echo "	16. data -> cache cold ->hole"
 	if [ "$remove_testfile" ]; then
@@ -470,6 +491,7 @@ _test_generic_punch()
 	diff $testfile $testfile.2
 	[ $? -ne 0 ] && die_now
 	rm -f $testfile.2
+	_md5_checksum $testfile
 
 	echo "	17. data -> hole in single block file"
 	if [ "$remove_testfile" ]; then
@@ -481,5 +503,6 @@ _test_generic_punch()
 		-c "$zero_cmd 128 128" \
 		-c "$map_cmd -v" $testfile | $filter_cmd
 	[ $? -ne 0 ] && die_now
+	_md5_checksum $testfile
 
 }
-- 
1.7.1

