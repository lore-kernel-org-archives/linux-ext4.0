From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/1] XFS TESTS: Correct extent flag parsing for punch hole tests
Date: Thu, 14 Jul 2011 20:52:13 -0700
Message-ID: <1310701933-18988-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The fiemap filters used in the punch hole tests parse the
extent flags in the fiemap to determine the extent type.
They are currently parsing them as decimal values, but
they should be parsing hex values.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100755 0083963... 0083963... M	255
:100644 100644 a48b7ae... 7337298... M	common.punch
 common.punch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/255 b/255
old mode 100644
new mode 100755
diff --git a/common.punch b/common.punch
index a48b7ae..7337298 100644
--- a/common.punch
+++ b/common.punch
@@ -208,11 +208,11 @@ _filter_fiemap()
 			print $1, $2, $3;
 			next;
 		}
-		$5 ~ /0x[[:digit:]]*8[[:digit:]]{2}/ {
+		$5 ~ /0x[[:xdigit:]]*8[[:xdigit:]]{2}/ {
 			print $1, $2, "unwritten";
 			next;
 		}
-		$5 ~ /0x[[:digit:]]+/ {
+		$5 ~ /0x[[:xdigit:]]+/ {
 			print $1, $2, "data";
 		}' |
 	_coalesce_extents
@@ -228,7 +228,7 @@ _filter_hole_fiemap()
 			print $1, $2, $3; 
 			next;
 		}   
-		$5 ~ /0x[[:digit:]]+/ {
+		$5 ~ /0x[[:xdigit:]]+/ {
 			print $1, $2, "extent";
 		}' |
 	_coalesce_extents
-- 
1.7.1

