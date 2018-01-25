From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 03/13] charsets: utf8: Add unicode character database files
Date: Thu, 25 Jan 2018 00:53:39 -0200
Message-ID: <20180125025349.31494-4-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Olaf Weber <olaf@sgi.com>

Add files from the Unicode Character Database, version 10.0.0, to the source.
A helper program that generates a trie used for normalization from these
files is part of a separate commit.

- Notes on the update from 8.0.0 and 10.0.0:

The structure of ucd files and special cases have not experienced any
changes between versions 8.0.0 and 10.0.0.  8.0.0 saw the addition of
Cherokee LC characters, which is an interesting case for case-folding.
The update is accompanied by new tests on the test_ucd module to catch
specific cases.  No changes to mkutf8data script was required for the
update.

Signed-off-by: Olaf Weber <olaf@sgi.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
  [Move ucd directory to lib/charsets]
  [Update to ucd-10.0.0]
---
 lib/charsets/ucd/README | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 lib/charsets/ucd/README

diff --git a/lib/charsets/ucd/README b/lib/charsets/ucd/README
new file mode 100644
index 000000000000..67f2075d1fca
--- /dev/null
+++ b/lib/charsets/ucd/README
@@ -0,0 +1,33 @@
+The files in this directory are part of the Unicode Character Database
+for version 10.0.0 of the Unicode standard.
+
+The full set of files can be found here:
+
+  http://www.unicode.org/Public/10.0.0/ucd/
+
+The latest released version of the UCD can be found here:
+
+  http://www.unicode.org/Public/UCD/latest/
+
+The files in this directory are identical, except that they have been
+renamed with a suffix indicating the unicode version.
+
+Individual source links:
+
+  http://www.unicode.org/Public/10.0.0/ucd/CaseFolding.txt
+  http://www.unicode.org/Public/10.0.0/ucd/DerivedAge.txt
+  http://www.unicode.org/Public/10.0.0/ucd/extracted/DerivedCombiningClass.txt
+  http://www.unicode.org/Public/10.0.0/ucd/DerivedCoreProperties.txt
+  http://www.unicode.org/Public/10.0.0/ucd/NormalizationCorrections.txt
+  http://www.unicode.org/Public/10.0.0/ucd/NormalizationTest.txt
+  http://www.unicode.org/Public/10.0.0/ucd/UnicodeData.txt
+
+md5sums
+
+  7893b6e005c5a521319a0d12062ae122  CaseFolding-10.0.0.txt
+  a602e4b44de3350087e40f2eb2184898  DerivedAge-10.0.0.txt
+  5abdeb21af4edcc5d1e4c0b5802fc7a7  DerivedCombiningClass-10.0.0.txt
+  eda11c2c2e3c308d9d3b90e2b3282024  DerivedCoreProperties-10.0.0.txt
+  425ece5ffbecd0140d98c13ce05724aa  NormalizationCorrections-10.0.0.txt
+  7296fe7aa07d7d288e65d559af2ad49b  NormalizationTest-10.0.0.txt
+  2a52f30695dcc821f0f224650552beaf  UnicodeData-10.0.0.txt
-- 
2.15.1
