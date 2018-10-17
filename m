Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50146 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbeJRExn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 00:53:43 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, Olaf Weber <olaf@sgi.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 12/23] nls: utf8n: Add unicode character database files
Date: Wed, 17 Oct 2018 16:55:13 -0400
Message-Id: <20181017205524.23360-13-krisman@collabora.co.uk>
In-Reply-To: <20181017205524.23360-1-krisman@collabora.co.uk>
References: <20181017205524.23360-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Olaf Weber <olaf@sgi.com>

Add files from the Unicode Character Database, version 10.0.0, to the
source.  A helper program that generates a trie used for normalization
from these files is part of a separate commit.

- Notes on the update from 8.0.0 and 10.0.0:

The structure of ucd files and special cases have not experienced any
changes between versions 8.0.0 and 10.0.0.  8.0.0 saw the addition of
Cherokee LC characters, which is an interesting case for case-folding.
The update is accompanied by new tests on the test_ucd module to catch
specific cases.  No changes to mkutf8data script was required for the
update.

The actual files are not part of the commit submitted to the list
because they are to big and would bounce.  Still, they can be obtained
by the following script:

FILES="CaseFolding.txt DerivedAge.txt extracted/DerivedCombiningClass.txt
       DerivedCoreProperties.txt NormalizationCorrections.txt
       NormalizationTest.txt UnicodeData.txt"
VERSION=10.0.0
BASE=http://www.unicode.org/Public/${VERSION}/ucd

for i in ${FILES} ; do
  wget "${BASE}/$i" -O fs/nls/ucd/$(basename ${i} .txt)-${VERSION}.txt
done

Signed-off-by: Olaf Weber <olaf@sgi.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
  [Move ucd directory to fs/nls/]
  [Update to ucd-10.0.0]
---
 fs/nls/ucd/README | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 fs/nls/ucd/README

diff --git a/fs/nls/ucd/README b/fs/nls/ucd/README
new file mode 100644
index 000000000000..67f2075d1fca
--- /dev/null
+++ b/fs/nls/ucd/README
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
2.19.1
