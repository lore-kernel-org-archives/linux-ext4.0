From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 11/21] fs: Mark functions as static in jbd2/journal.c
Date: Sun, 9 Feb 2014 18:41:21 +0530
Message-ID: <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	josh@joshtriplett.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mark functions as static in jbd2/journal.c because they are not used
outside this file.

This eliminates the following warning in jbd2/journal.c:
fs/jbd2/journal.c:125:5: warning: no previous prototype for =E2=80=98jb=
d2_verify_csum_type=E2=80=99 [-Wmissing-prototypes]
fs/jbd2/journal.c:146:5: warning: no previous prototype for =E2=80=98jb=
d2_superblock_csum_verify=E2=80=99 [-Wmissing-prototypes]
fs/jbd2/journal.c:154:6: warning: no previous prototype for =E2=80=98jb=
d2_superblock_csum_set=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/jbd2/journal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5fa344a..244b6f6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -122,7 +122,7 @@ EXPORT_SYMBOL(__jbd2_debug);
 #endif
=20
 /* Checksumming functions */
-int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
+static int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *s=
b)
 {
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -143,7 +143,7 @@ static __be32 jbd2_superblock_csum(journal_t *j, jo=
urnal_superblock_t *sb)
 	return cpu_to_be32(csum);
 }
=20
-int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *sb=
)
+static int jbd2_superblock_csum_verify(journal_t *j, journal_superbloc=
k_t *sb)
 {
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return 1;
@@ -151,7 +151,7 @@ int jbd2_superblock_csum_verify(journal_t *j, journ=
al_superblock_t *sb)
 	return sb->s_checksum =3D=3D jbd2_superblock_csum(j, sb);
 }
=20
-void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
+static void jbd2_superblock_csum_set(journal_t *j, journal_superblock_=
t *sb)
 {
 	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
 		return;
--=20
1.7.9.5
