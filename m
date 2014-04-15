From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] check: add support for an external test expunging file
Date: Mon, 14 Apr 2014 22:52:00 -0400
Message-ID: <1397530320-20579-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: xfs@oss.sgi.com
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Currently the -X option is intended to specify a set of expunging
files which are stored in each test/* subdirectory.  As described in
the commit description for 0b1e8abd4, in order to exclude the test
generic/280, the -X option is used as follows:

    $ cat tests/generic/3.0-stable-avoid
    280
    $ sudo ./check -X 3.0-stable-avoid generic/280

However, it is sometimes useful to store the set of expunged tests in
a single file, outside of tests/* subdirectories.  This commit allows
the following:

    $ cat /root/conf/data_journal.exclude
    generic/068
    ext4/301
    $ sudo ./check -X /root/conf/data_journal.exclude -g auto

If the argument to the -X option is a pathname (that is, includes a
'/' character), treat it as the latter case.  If it the argument to
the -X option is just a bare filename (that is, does not include '/'
character), treat it as the former.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 check | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/check b/check
index e7ace63..791a386 100755
--- a/check
+++ b/check
@@ -215,12 +215,22 @@ while [ $# -gt 0 ]; do
 		;;
 
 	-X)	xfile=$2; shift ;
-		for d in $SRC_GROUPS $FSTYP; do
-			[ -f $SRC_DIR/$d/$xfile ] || continue
-			for f in `cat $SRC_DIR/$d/$xfile`; do
-				echo $d/$f >> $tmp.xlist
+		case "$xfile" in
+		*/*)	if [ -f "$xfile" ]; then
+				cat "$xfile" >> $tmp.xlist
+			else
+				echo "Exclusion file $xfile not found"
+				exit 1
+			fi
+			;;
+		*)	for d in $SRC_GROUPS $FSTYP; do
+				[ -f $SRC_DIR/$d/$xfile ] || continue
+				for f in `cat $SRC_DIR/$d/$xfile`; do
+				    echo $d/$f >> $tmp.xlist
+				done
 			done
-		done
+			;;
+		esac
 		;;
 	-s)	RUN_SECTION="$RUN_SECTION $2"; shift ;;
 	-l)	diff="diff" ;;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
