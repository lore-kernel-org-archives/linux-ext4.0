Return-Path: <SRS0=bC55=OP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55658 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbeLFWFZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2018 17:05:25 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Olaf Weber <olaf@sgi.com>,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v4 12/23] nls: utf8: Add unicode character database files
Date: Thu,  6 Dec 2018 17:04:18 -0500
Message-Id: <20181206220429.10722-13-krisman@collabora.com>
In-Reply-To: <20181206220429.10722-1-krisman@collabora.com>
References: <20181206220429.10722-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Olaf Weber <olaf@sgi.com>

Add files from the Unicode Character Database, version 11.0, to the
source.  A helper program that generates a trie used for normalization
from these files is part of a separate commit.

- Notes on the update from 8.0.0 and 11.0:

The structure of ucd files and special cases have not experienced any
changes between versions 8.0.0 and 11.0.0.  8.0.0 saw the addition of
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
VERSION=11.0.0
BASE=http://www.unicode.org/Public/${VERSION}/ucd

for i in ${FILES} ; do
  wget "${BASE}/$i" -O fs/nls/ucd/$(basename ${i} .txt)-${VERSION}.txt
done

Signed-off-by: Olaf Weber <olaf@sgi.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
  [Move ucd directory to fs/nls/]
  [Update to Unicode 11.0.0]
---
 fs/nls/ucd/README | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 fs/nls/ucd/README

diff --git a/fs/nls/ucd/README b/fs/nls/ucd/README
new file mode 100644
index 000000000000..553ce7e4c224
--- /dev/null
+++ b/fs/nls/ucd/README
@@ -0,0 +1,34 @@
+The files in this directory are part of the Unicode Character Database
+for version 11.0.0 of the Unicode standard.
+
+The full set of files can be found here:
+
+  http://www.unicode.org/Public/11.0.0/ucd/
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
+  http://www.unicode.org/Public/11.0.0/ucd/CaseFolding.txt
+  http://www.unicode.org/Public/11.0.0/ucd/DerivedAge.txt
+  http://www.unicode.org/Public/11.0.0/ucd/extracted/DerivedCombiningClass.txt
+  http://www.unicode.org/Public/11.0.0/ucd/DerivedCoreProperties.txt
+  http://www.unicode.org/Public/11.0.0/ucd/NormalizationCorrections.txt
+  http://www.unicode.org/Public/11.0.0/ucd/NormalizationTest.txt
+  http://www.unicode.org/Public/11.0.0/ucd/UnicodeData.txt
+
+md5sums
+
+  414436796cf097df55f798e1585448ee  CaseFolding-11.0.0.txt
+  6032a595fbb782694456491d86eecfac  DerivedAge-11.0.0.txt
+  3240997d671297ac754ab0d27577acf7  DerivedCombiningClass-11.0.0.txt
+  d41d8cd98f00b204e9800998ecf8427e  DerivedCombiningClass.txt
+  2a4fe257d9d8184518e036194d2248ec  DerivedCoreProperties-11.0.0.txt
+  4e7d383fa0dd3cd9d49d64e5b7b7c9e0  NormalizationCorrections-11.0.0.txt
+  c9500c5b8b88e584469f056023ecc3f2  NormalizationTest-11.0.0.txt
+  acc291106c3758d2025f8d7bd5518bee  UnicodeData-11.0.0.txt
-- 
2.20.0.rc2
