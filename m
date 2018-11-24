Return-Path: <SRS0=yRHK=OD=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48550 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbeKXOfp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 24 Nov 2018 09:35:45 -0500
Date: Fri, 23 Nov 2018 22:48:47 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jean-Christophe Guillain <jcguillain@sequans.com>,
        linux-ext4@vger.kernel.org
Subject: Re: Metadata_csum is still enabled after trying to disable it.
Message-ID: <20181124034847.GA12941@thunk.org>
References: <E1gPWbq-0006F7-IZ@eureka>
 <20181122030119.GA6778@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20181122030119.GA6778@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 21, 2018 at 07:01:19PM -0800, Darrick J. Wong wrote:
> > Is it a bug ?
>=20
> Yes.
>=20
> > How can I actually disable this parameter ?
>

Actually, the metadata_csum feature *was* disabled.  You would have
seen that if you looked at the "Features: " line printed by dumpe2fs
-h or tune2fs -l.  The bug was that we were erroneously warning that
the tune2fs -U operation would take a long time when flex_bg was
enabled, but metadata_csum was not.  So it was misleading wrong, but
it actually turning off the metadata_csum feature.

Cheers,

					- Ted

=46rom 0eeb17d0610fd512c1038dabb39370420ffb47a4 Mon Sep 17 00:00:00 2001
=46rom: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 23 Nov 2018 22:34:31 -0500
Subject: [PATCH] tune2fs: fix false warning that a UUID change will take a
 long time

If the file system only has the flex_bg feature enabled (with out the
metadata_csum feature enabled), it won't take a long time time fix up
the checksums after changing the UUID.  While it does need to
recalculate all of the checksums in the block group descriptors, that
doesn't take a long time.

Also, if the ea_data feature is enabled, changing the UUID will also
take a long time, and we weren't warning the user about that case.

Fix up the warning message so it doesn't mislead people, and is more
accurate.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/tune2fs.c           | 17 +++++++++--------
 tests/t_dangerous/expect | 29 ++++++++++++++++++++++++-----
 tests/t_dangerous/script | 33 +++++++++++++++++++++++++++------
 3 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ec977b8c3..7c5ba0c77 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -3221,6 +3221,15 @@ _("Warning: The journal is dirty. You may wish to re=
play the journal like:\n\n"
 		char buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
 		__u8 old_uuid[UUID_SIZE];
=20
+		if (!ext2fs_has_feature_csum_seed(fs->super) &&
+		    (ext2fs_has_feature_metadata_csum(fs->super) ||
+		     ext2fs_has_feature_ea_inode(fs->super))) {
+			check_fsck_needed(fs,
+				_("Setting the UUID on this "
+				  "filesystem could take some time."));
+			rewrite_checksums =3D 1;
+		}
+
 		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
 			 * Changing the UUID on a metadata_csum FS requires
@@ -3241,10 +3250,6 @@ _("Warning: The journal is dirty. You may wish to re=
play the journal like:\n\n"
 				try_confirm_csum_seed_support();
 				exit(1);
 			}
-			if (!ext2fs_has_feature_csum_seed(fs->super))
-				check_fsck_needed(fs,
-					_("Setting UUID on a checksummed "
-					  "filesystem could take some time."));
=20
 			/*
 			 * Determine if the block group checksums are
@@ -3302,10 +3307,6 @@ _("Warning: The journal is dirty. You may wish to re=
play the journal like:\n\n"
 		}
=20
 		ext2fs_mark_super_dirty(fs);
-		if (!ext2fs_has_feature_csum_seed(fs->super) &&
-		    (ext2fs_has_feature_metadata_csum(fs->super) ||
-		     ext2fs_has_feature_ea_inode(fs->super)))
-			rewrite_checksums =3D 1;
 	}
=20
 	if (I_flag) {
diff --git a/tests/t_dangerous/expect b/tests/t_dangerous/expect
index a9903b750..31aaf4fad 100644
--- a/tests/t_dangerous/expect
+++ b/tests/t_dangerous/expect
@@ -43,10 +43,6 @@ tune2fs -I 512 test.img
 Resizing inodes could take some time.
 Proceed anyway (or wait 5 seconds to proceed) ? (y,N)=20
 Exit status is 1
-tune2fs -U random test.img
-Setting UUID on a checksummed filesystem could take some time.
-Proceed anyway (or wait 5 seconds to proceed) ? (y,N)=20
-Exit status is 1
=20
 Change in FS metadata:
 Pass 1: Checking inodes, blocks, and sizes
@@ -79,7 +75,7 @@ Resizing inodes could take some time.
 Proceed anyway (or wait 5 seconds to proceed) ? (y,N) Setting inode size 5=
12
 Exit status is 0
 tune2fs -U f0f0f0f0-f0f0-f0f0-f0f0-f0f0f0f0f0f0 test.img
-Setting UUID on a checksummed filesystem could take some time.
+Setting the UUID on this filesystem could take some time.
 Proceed anyway (or wait 5 seconds to proceed) ? (y,N) Exit status is 0
 Backing up journal inode block information.
=20
@@ -99,3 +95,26 @@ Pass 4: Checking reference counts
 Pass 5: Checking group summary information
=20
 Exit status is 0
+=20
+Testing with metadata checksum enabled
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks:=20
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      =08=08=08=08=08done                         =
  =20
+Writing inode tables:      =08=08=08=08=08done                           =
=20
+Creating journal (16384 blocks): done
+Creating 445 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      =08=08=08=
=08=08done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -U random test.img
+Setting the UUID on this filesystem could take some time.
+Proceed anyway (or wait 5 seconds to proceed) ? (y,N)=20
+Exit status is 1
diff --git a/tests/t_dangerous/script b/tests/t_dangerous/script
index b71421881..f684d56d3 100644
--- a/tests/t_dangerous/script
+++ b/tests/t_dangerous/script
@@ -17,6 +17,18 @@ cat > $CONF << ENDL
 		hugefiles_size =3D 1M
 		zero_hugefiles =3D false
 	}
+	ext4m =3D {
+		features =3D has_journal,extent,huge_file,^flex_bg,uninit_bg,dir_nlink,e=
xtra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit,meta=
data_csum
+		blocksize =3D 1024
+		inode_size =3D 256
+		make_hugefiles =3D true
+		hugefiles_dir =3D /
+		hugefiles_slack =3D 32M
+		hugefiles_name =3D aaaaa
+		hugefiles_digits =3D 4
+		hugefiles_size =3D 1M
+		zero_hugefiles =3D false
+	}
 ENDL
=20
 echo "tune2fs dangerous prompts test" > $OUT
@@ -62,12 +74,6 @@ echo 'n' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -I 512 $TMP=
FILE >> $OUT 2>&1
 status=3D$?
 echo Exit status is $status >> $OUT
=20
-# change uuid
-echo "tune2fs -U random test.img" >> $OUT
-echo 'n' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -U random $TMPFILE >> $OUT 2>=
&1
-status=3D$?
-echo Exit status is $status >> $OUT
-
 # check
 $FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
=20
@@ -111,6 +117,21 @@ $FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
 status=3D$?
 echo Exit status is $status >> $OUT
=20
+echo " " >> $OUT
+echo "Testing with metadata checksum enabled" >> $OUT
+
+MKE2FS_CONFIG=3D$CONF $MKE2FS -F -T ext4m -U 6fc3daa4-180d-4f2b-a6f2-f7a5e=
fb79bcf $TMPFILE 524288 >> $OUT 2>&1
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd=
_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -f -N test_filesys $TMPFILE >> $OUT 2>&1
+status=3D$?
+echo Exit status is $status >> $OUT
+
+# change uuid
+echo "tune2fs -U random test.img" >> $OUT
+echo 'n' | TUNE2FS_FORCE_PROMPT=3D1 $TUNE2FS -U random $TMPFILE >> $OUT 2>=
&1
+status=3D$?
+echo Exit status is $status >> $OUT
+
 rm $TMPFILE $OUT.before $OUT.after $CONF
=20
 #
--=20
2.19.1
