From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH V2] common/rc: improve _require_metadata_journaling() for ext4
Date: Fri, 19 Aug 2016 12:47:38 -0400
Message-ID: <20160819164738.GA1903@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The code in _require_metadata_journaling() currently rejects ext4 file
systems that have been created without a journal.  However, an ext4
file system with a journal should also be rejected if the journal is
not loaded and made available for use at mount time.

V2:  Replaced code with call to _exclude_scratch_mount_option() per
review comment.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 3fb0600..9d1fc07 100644
--- a/common/rc
+++ b/common/rc
@@ -3057,6 +3057,8 @@ _require_metadata_journaling()
 		_require_dumpe2fs
 		$DUMPE2FS_PROG -h $DEV 2>&1 | grep -q has_journal || \
 			_notrun "$FSTYP on $DEV not configured with metadata journaling"
+		# ext4 might not load a journal
+		_exclude_scratch_mount_option "noload"
 		;;
 	*)
 		# by default we pass; if you need to, add your fs above!
-- 
2.1.4
