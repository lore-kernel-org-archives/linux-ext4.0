From: "jon ernst" <jonernst07@gmx.com>
Subject: [PATCH]ext4: Log inline_data feature in Documentation
Date: Fri, 09 Aug 2013 17:28:51 -0400
Message-ID: <20130809212851.284520@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-doc@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When I tested inline_data feature, I found it hasn't been documented in=
 ext4.txt.

Signed-off-by:jon ernst <jonernst07@gmail.com>
---

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesys=
tems/ext4.txt
index f7cbf57..f2de1a1 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -99,6 +99,7 @@ Note: More extensive information for getting started =
with ext4 can be
=C2=A0* large block (up to pagesize) support
=C2=A0* efficient new ordered mode in JBD2 and ext4(avoid using buffer =
head to force
=C2=A0 =C2=A0the ordering)
+* allows small files or directories to be stored within the in-inode e=
xtended attribute area via inline_data
=C2=A0
=C2=A0[1] Filesystems with a block size of 1k may see a limit imposed b=
y the
=C2=A0directory hash tree having a maximum depth of two.
