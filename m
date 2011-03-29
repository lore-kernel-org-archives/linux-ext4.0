From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck.ext4 taking months
Date: Tue, 29 Mar 2011 08:03:00 +0200
Message-ID: <20110329060300.GA27142@bitwizard.nl>
References: <4D8F1F75.8010201@psi5.com> <4D909E92.4080209@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Cc: Christian Brandt <brandtc@psi5.com>, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:42010 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752739Ab1C2GDD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 02:03:03 -0400
Content-Disposition: inline
In-Reply-To: <4D909E92.4080209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 28, 2011 at 10:43:30AM -0400, Ric Wheeler wrote:
> On 03/27/2011 07:28 AM, Christian Brandt wrote:
> >Situation: External 500GB drive holds lots of snapshots using lots of
> >hard links made by rsync --link-dest. The controller went bad and
> >destroyed superblock and directory structures. The drive contains
> >roughly a million files and four complete directory-tree-snapshots with
> >each roughly a million hardlinks.
> >
> >Tried
> >
> >e2fsck 1.41.12 (17-May-2010)
> >         Benutze EXT2FS Library version 1.41.12, 17-May-2010
> >
> >e2fsck 1.41.11 (14-Mar-2010)
> >         Benutze EXT2FS Library version 1.41.11, 14-Mar-2010
> >
> >Symptoms: fsck.ext4 -y -f takes nearly a month to fix the structures on
> >a P4@2,8Ghz, with very little access to the drive and 100% cpu use.
> >
> >output of fsck looks much like this:
> >
> >File ??? (Inode #123456, modify time Wed Jul 22 16:20:23 2009)
> >   block Nr. 6144 double block(s), used with four file(s):
> >     <filesystem metadata>
> >     ??? (Inode #123457, mod time Wed Jul 22 16:20:23 2009)
> >     ??? (Inode #123458, mod time Wed Jul 22 16:20:23 2009)
> >     ...
> >multiply claimed block map? Yes
> >
> >Is there an adhoc method of getting my data back faster?
> >
> >Is the slow performance with lots of hard links a known issue?

Yes, it is a known issue. 

You get to test my patch. :-)

I strongly suspect that (just like me) sometime in the past you've
seen e2fsck run out of memory and were advised to enable the
on-disk-databases.

	Roger. 



-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ

--EVF5PPMfhYS0aIcm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="tdb_init_fix.diff"

diff --git a/e2fsck/dirinfo.c b/e2fsck/dirinfo.c
index 901235c..9b29f23 100644
--- a/e2fsck/dirinfo.c
+++ b/e2fsck/dirinfo.c
@@ -62,7 +62,7 @@ static void setup_tdb(e2fsck_t ctx, ext2_ino_t num_dirs)
 	uuid_unparse(ctx->fs->super->s_uuid, uuid);
 	sprintf(db->tdb_fn, "%s/%s-dirinfo-XXXXXX", tdb_dir, uuid);
 	fd = mkstemp(db->tdb_fn);
-	db->tdb = tdb_open(db->tdb_fn, 0, TDB_CLEAR_IF_FIRST,
+	db->tdb = tdb_open(db->tdb_fn, 999931, TDB_NOLOCK | TDB_NOSYNC,
 			   O_RDWR | O_CREAT | O_TRUNC, 0600);
 	close(fd);
 }
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index bec0f5f..bdd5b26 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -173,6 +173,19 @@ static void uuid_unparse(void *uu, char *out)
 		uuid.node[3], uuid.node[4], uuid.node[5]);
 }
 
+static unsigned int my_tdb_hash(TDB_DATA *key)
+{
+        unsigned int value;      /* Used to compute the hash value.  */
+        int   i;        /* Used to cycle through random values. */
+
+        /* initial value 0 is as good as any one. */
+        for (value = 0, i=0; i < key->dsize; i++)
+                value = value * 256 + key->dptr[i] + (value >> 24) * 241;
+
+        return value;
+}
+
+
 errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 				   int flags, ext2_icount_t *ret)
 {
@@ -180,6 +193,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	errcode_t	retval;
 	char 		*fn, uuid[40];
 	int		fd;
+	int		hash_size;
 
 	retval = alloc_icount(fs, flags,  &icount);
 	if (retval)
@@ -192,9 +206,20 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	sprintf(fn, "%s/%s-icount-XXXXXX", tdb_dir, uuid);
 	fd = mkstemp(fn);
 
+	/* 
+	hash_size should be on the same order of the number of entries actually
+	used. The tdb default used to be 131 which gives us a big performance 
+	penalty with normal inode numbers. We now trust the superblock. If it's 
+	wrong, don't worry, tdb will manage, it will just cost a little bit more 
+	CPUtime. 
+	If the hash function is good and distributes the values uniformly across 
+	the 32bit output space, it doesn't really matter that we didn't chose a
+	prime.  The default tdb hash function is pretty worthless. Someone didn't 
+	read Knuth. */
+	hash_size = fs->super->s_inodes_count - fs->super->s_free_inodes_count;
 	icount->tdb_fn = fn;
-	icount->tdb = tdb_open(fn, 0, TDB_CLEAR_IF_FIRST,
-			       O_RDWR | O_CREAT | O_TRUNC, 0600);
+	icount->tdb = tdb_open_ex(fn, hash_size, TDB_NOLOCK | TDB_NOSYNC,
+			       O_RDWR | O_CREAT | O_TRUNC, 0600, NULL, my_tdb_hash);
 	if (icount->tdb) {
 		close(fd);
 		*ret = icount;

--EVF5PPMfhYS0aIcm--
