From: Pavel Machek <pavel@ucw.cz>
Subject: Re: bcache with existing ext4 filesystem
Date: Tue, 25 Jul 2017 15:46:04 +0200
Message-ID: <20170725134604.GA26445@amd>
References: <20170724185703.GA31422@amd>
 <64c810cf-a95c-f862-f25a-ebd7419b2632@thelounge.net>
 <20170724191548.GA32425@amd>
 <20170724192718.t7n5zgualz5lillg@thunk.org>
 <20170724200451.GA4318@amd>
 <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
To: Theodore Ts'o <tytso@mit.edu>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725045156.kbyaxj4mmi75yyt5@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Question for you was... Is the first 1KiB of each ext4 filesystem still
> > free and "reserved for a bootloader"?
>=20
> Yes.
>=20
> > If I needed more for bcache superblock (8KiB, IIRC), would that be
> > easy to accomplish on existing filesystem?
>=20
> Huh?  Why would the bcache superblock matter when you're talking about
> the ext4 layout?  The bcache superblock will be on the bcache
> device/partition, and the ext4 superblock will be on the ext4
> device/partition.

So this is what I came up with so far. With SSD in USB2 envelope (and
previous version of the patch), git diff goes from 9seconds to
3seconds; not too bad. git diff on (different) ssd is 1.5seconds.

Warning: this is rather dangerous, as it is easy to make cache go
out-of-sync with data partition. To solve that...

Is there some field in ext2 superblock that changes every time
filesystem is changed? Is mtime changed by fsck/badblocks/...?

Best regards,
							Pavel



diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e57353e..f8c0aef 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -6,6 +6,7 @@
  * Copyright 2012 Google, Inc.
  */
=20
+#define DEBUG
 #include "bcache.h"
 #include "btree.h"
 #include "debug.h"
@@ -67,7 +68,7 @@ static const char *read_super(struct cache_sb *sb, struct=
 block_device *bdev,
 {
 	const char *err;
 	struct cache_sb *s;
-	struct buffer_head *bh =3D __bread(bdev, 1, SB_SIZE);
+	struct buffer_head *bh =3D __bread(bdev, SB_SECTOR/8, SB_SIZE);
 	unsigned i;
=20
 	if (!bh)
@@ -95,10 +96,11 @@ static const char *read_super(struct cache_sb *sb, stru=
ct block_device *bdev,
 	pr_debug("read sb version %llu, flags %llu, seq %llu, journal size %u",
 		 sb->version, sb->flags, sb->seq, sb->keys);
=20
-	err =3D "Not a bcache superblock";
+	err =3D "Not a bcache superblock: offset";
 	if (sb->offset !=3D SB_SECTOR)
 		goto err;
=20
+	err =3D "Not a bcache superblock: magic";=09
 	if (memcmp(sb->magic, bcache_magic, 16))
 		goto err;
=20
@@ -124,7 +126,7 @@ static const char *read_super(struct cache_sb *sb, stru=
ct block_device *bdev,
 	case BCACHE_SB_VERSION_BDEV:
 		sb->data_offset	=3D BDEV_DATA_START_DEFAULT;
 		break;
-	case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+//	case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
 		sb->data_offset	=3D le64_to_cpu(s->data_offset);
=20
 		err =3D "Bad data offset";
@@ -132,6 +134,15 @@ static const char *read_super(struct cache_sb *sb, str=
uct block_device *bdev,
 			goto err;
=20
 		break;
+	case BCACHE_SB_VERSION_BDEV_WITH_OFFSET:
+	case BCACHE_SB_VERSION_BDEV_EXT4_LITE:
+		sb->data_offset	=3D le64_to_cpu(s->data_offset);
+		printk("Size of sb is %d\n", sizeof(*sb));
+		WARN_ON(sizeof(*sb) > 1024);
+		if (sizeof(*sb) > 1024)
+			goto err;
+		break;
+
 	case BCACHE_SB_VERSION_CDEV:
 	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
 		sb->nbuckets	=3D le64_to_cpu(s->nbuckets);
diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index e3bb063..b1ef80c 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -142,12 +142,13 @@ static inline struct bkey *bkey_idx(const struct bkey=
 *k, unsigned nr_keys)
 #define BCACHE_SB_VERSION_BDEV		1
 #define BCACHE_SB_VERSION_CDEV_WITH_UUID 3
 #define BCACHE_SB_VERSION_BDEV_WITH_OFFSET 4
-#define BCACHE_SB_MAX_VERSION		4
+#define BCACHE_SB_VERSION_BDEV_EXT4_LITE	5
+#define BCACHE_SB_MAX_VERSION		5
=20
-#define SB_SECTOR			8
+#define SB_SECTOR			0
 #define SB_SIZE				4096
 #define SB_LABEL_SIZE			32
-#define SB_JOURNAL_BUCKETS		256U
+#define SB_JOURNAL_BUCKETS		64U
 /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
 #define MAX_CACHES_PER_SET		8
=20


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAll3S5wACgkQMOfwapXb+vJyawCfSXHk+gsMjnKHm84F6esL6338
F7gAnjVytXE/lqs4bXJfir/tVkdf/0yw
=AMyk
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
