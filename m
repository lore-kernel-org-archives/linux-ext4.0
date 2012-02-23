From: Philipp Hahn <hahn@univention.de>
Subject: Re: backport "ext4: serialize unaligned asynchronous
	DIO" to 2.6.32
Date: Thu, 23 Feb 2012 14:23:15 +0100
Message-ID: <201202231424.23645.hahn@univention.de>
References: <4D2F7B52.1040209@redhat.com> <20110207023336.GI10402@thunk.org>
	<20110207155936.GA3457@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8096001725940985653=="
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xen-devel@lists.xensource.com
To: "Ted Ts'o" <tytso@mit.edu>,
 Eric Sandeen <sandeen@redhat.com>
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20110207155936.GA3457@thunk.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
List-Id: linux-ext4.vger.kernel.org

--===============8096001725940985653==
Content-Type: multipart/signed;
  boundary="nextPart1849790.JziXrtG3Yg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1849790.JziXrtG3Yg
Content-Type: multipart/mixed;
  boundary="Boundary-01=_D3jRPNguxyYS6GX"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_D3jRPNguxyYS6GX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Ted, hello Eric,

On Monday February 7th 2011 16:59:36 Ted Ts'o wrote:
> commit 7520bb0f2980ef79d17dcbec2783760b37490ffc
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Mon Feb 7 10:57:28 2011 -0500
>
>     ext4: serialize unaligned asynchronous DIO
>
>     ext4 has a data corruption case when doing non-block-aligned
>     asynchronous direct IO into a sparse file, as demonstrated
>     by xfstest 240.

I hope you remember that bug, because I encountered this data corruption bu=
g=20
on Debians 2.6.32(.51) kernel as well.

On the other hand RedHat seems to have back-ported that fix to RHEL5 (2.6.1=
8) =20
and probably RHEL6 (2.6.32) as well, but I don't have a subscription, so I=
=20
can't verify that:
<http://rpmfind.net/linux/RPM/centos/updates/5.7/x86_64/RPMS/kernel-devel-2=
=2E6.18-274.12.1.el5.x86_64.html>
<https://bugzilla.redhat.com/show_bug.cgi?id=3D689830>

The Xen-people also encountered it and asked for someone to backport it:
<http://osdir.com/ml/xen-development/2011-07/msg00474.html>

I tried to backport it from 2.6.38~rc5 to 2.6.32.51 and thus far it seems t=
o=20
fix the bug. But several other things were re-named and re-organized betwee=
n=20
those versions, so it was not slreight forward.

Since I'm no ext4 expert, I'd like to ask you to have a look at this backpo=
rt.=20
Is it sound or are there some tests I can throw at it to get it tested more=
=20
thoroughly?
Does is classify for <mailto:stable@vger.kernel.org>?

Thanks in advance
Philipp Hahn
=2D-=20
Philipp Hahn           Open Source Software Engineer      hahn@univention.de
Univention GmbH        Linux for Your Business        fon: +49 421 22 232- 0
Mary-Somerville-Str.1  D-28359 Bremen                 fax: +49 421 22 232-99
                                                   http://www.univention.de/

--Boundary-01=_D3jRPNguxyYS6GX
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="26192_ext4-serialize-unaligned-asynchronous-DIO.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="26192_ext4-serialize-unaligned-asynchronous-DIO.patch"

commit e9e3bcecf44c04b9e6b505fd8e2eb9cea58fb94d
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Feb 12 08:17:34 2011 -0500

    ext4: serialize unaligned asynchronous DIO
   =20
    ext4 has a data corruption case when doing non-block-aligned
    asynchronous direct IO into a sparse file, as demonstrated
    by xfstest 240.
   =20
    The root cause is that while ext4 preallocates space in the
    hole, mappings of that space still look "new" and
    dio_zero_block() will zero out the unwritten portions.  When
    more than one AIO thread is going, they both find this "new"
    block and race to zero out their portion; this is uncoordinated
    and causes data corruption.
   =20
    Dave Chinner fixed this for xfs by simply serializing all
    unaligned asynchronous direct IO.  I've done the same here.
    The difference is that we only wait on conversions, not all IO.
    This is a very big hammer, and I'm not very pleased with
    stuffing this into ext4_file_write().  But since ext4 is
    DIO_LOCKING, we need to serialize it at this high level.
   =20
    I tried to move this into ext4_ext_direct_IO, but by then
    we have the i_mutex already, and we will wait on the
    work queue to do conversions - which must also take the
    i_mutex.  So that won't work.
   =20
    This was originally exposed by qemu-kvm installing to
    a raw disk image with a normal sector-63 alignment.  I've
    tested a backport of this patch with qemu, and it does
    avoid the corruption.  It is also quite a lot slower
    (14 min for package installs, vs. 8 min for well-aligned)
    but I'll take slow correctness over fast corruption any day.
   =20
    Mingming suggested that we can track outstanding
    conversions, and wait on those so that non-sparse
    files won't be affected, and I've implemented that here;
    unaligned AIO to nonsparse files won't take a perf hit.
   =20
    [tytso@mit.edu: Keep the mutex as a hashed array instead
     of bloating the ext4 inode]
   =20
    [tytso@mit.edu: Fix up namespace issues so that global
     variables are protected with an "ext4_" prefix.]
   =20
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 67c46ed..10edb67 100644
=2D-- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -781,6 +781,8 @@ struct ext4_inode_info {
 	/* on-disk additional length */
 	__u16 i_extra_isize;
=20
+	atomic_t i_aiodio_unwritten; /* Nr. of inflight conversions pending */
+
 	spinlock_t i_block_reservation_lock;
 #ifdef CONFIG_QUOTA
 	/* quota space reservation, managed internally by quota code */
@@ -1889,6 +1891,15 @@ static inline void set_bitmap_uptodate(struct buffer=
_head *bh)
=20
 #define in_range(b, first, len)	((b) >=3D (first) && (b) <=3D (first) + (l=
en) - 1)
=20
+/* For ioend & aio unwritten conversion wait queues */
+#define EXT4_WQ_HASH_SZ		37
+#define ext4_ioend_wq(v)   (&ext4__ioend_wq[((unsigned long)(v)) %\
+					    EXT4_WQ_HASH_SZ])
+#define ext4_aio_mutex(v)  (&ext4__aio_mutex[((unsigned long)(v)) %\
+					     EXT4_WQ_HASH_SZ])
+extern wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
+extern struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
+
 #endif	/* __KERNEL__ */
=20
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ecbe20d..f4830e6 100644
=2D-- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3118,9 +3118,10 @@ ext4_ext_handle_uninitialized_extents(handle_t *hand=
le, struct inode *inode,
 		 * that this IO needs to convertion to written when IO is
 		 * completed
 		 */
=2D		if (io)
+		if (io && !(io->flag & DIO_AIO_UNWRITTEN)) {
 			io->flag =3D DIO_AIO_UNWRITTEN;
=2D		else
+			atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+		} else
 			ext4_set_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		goto out;
 	}
@@ -3404,9 +3405,10 @@ int ext4_ext_get_blocks(handle_t *handle, struct ino=
de *inode,
 		 * that we need to perform convertion when IO is done.
 		 */
 		if (flags =3D=3D EXT4_GET_BLOCKS_DIO_CREATE_EXT) {
=2D			if (io)
+			if (io && !(io->flag & DIO_AIO_UNWRITTEN)) {
 				io->flag =3D DIO_AIO_UNWRITTEN;
=2D			else
+				atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+			} else
 				ext4_set_inode_state(inode,
 						     EXT4_STATE_DIO_UNWRITTEN);
 		}
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a60541..a18b45c 100644
=2D-- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -54,11 +54,47 @@ static int ext4_release_file(struct inode *inode, struc=
t file *filp)
 	return 0;
 }
=20
+static void ext4_aiodio_wait(struct inode *inode)
+{
+	wait_queue_head_t *wq =3D ext4_ioend_wq(inode);
+
+	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_aiodio_unwritten) =3D=3D 0=
));
+}
+
+/*
+ * This tests whether the IO in question is block-aligned or not.
+ * Ext4 utilizes unwritten extents when hole-filling during direct IO, and=
 they
+ * are converted to written only after the IO is complete.  Until they are
+ * mapped, these blocks appear as holes, so dio_zero_block() will assume t=
hat
+ * it needs to zero out portions of the start and/or end block.  If 2 AIO
+ * threads are at work on the same unwritten block, they must be synchroni=
zed
+ * or one thread will zero the other's data, causing corruption.
+ */
+static int
+ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
+		   unsigned long nr_segs, loff_t pos)
+{
+	struct super_block *sb =3D inode->i_sb;
+	int blockmask =3D sb->s_blocksize - 1;
+	size_t count =3D iov_length(iov, nr_segs);
+	loff_t final_size =3D pos + count;
+
+	if (pos >=3D inode->i_size)
+		return 0;
+
+	if ((pos & blockmask) || (final_size & blockmask))
+		return 1;
+
+	return 0;
+}
+
 static ssize_t
 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
 	struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_inode;
+	int unaligned_aio =3D 0;
+	int ret;
=20
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
@@ -76,9 +112,31 @@ ext4_file_write(struct kiocb *iocb, const struct iovec =
*iov,
 			nr_segs =3D iov_shorten((struct iovec *)iov, nr_segs,
 					      sbi->s_bitmap_maxbytes - pos);
 		}
+	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
+		   !is_sync_kiocb(iocb))) {
+		unaligned_aio =3D ext4_unaligned_aio(inode, iov, nr_segs, pos);
 	}
=20
=2D	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	/* Unaligned direct AIO must be serialized; see comment above */
+	if (unaligned_aio) {
+		static unsigned long unaligned_warn_time;
+
+		/* Warn about this once per day */
+		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
+			ext4_msg(inode->i_sb, KERN_WARNING,
+				 "Unaligned AIO/DIO on inode %ld by %s; "
+				 "performance will be poor.",
+				 inode->i_ino, current->comm);
+		mutex_lock(ext4_aio_mutex(inode));
+		ext4_aiodio_wait(inode);
+	}
+
+	ret =3D generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	if (unaligned_aio)
+		mutex_unlock(ext4_aio_mutex(inode));
+
+	return ret;
 }
=20
 static const struct vm_operations_struct ext4_file_vm_ops =3D {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f27e045..2cb8748 100644
=2D-- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -713,6 +713,7 @@ static struct inode *ext4_alloc_inode(struct super_bloc=
k *sb)
 	ei->cur_aio_dio =3D NULL;
 	ei->i_sync_tid =3D 0;
 	ei->i_datasync_tid =3D 0;
+	atomic_set(&ei->i_aiodio_unwritten, 0);
=20
 	return &ei->vfs_inode;
 }
@@ -4002,11 +4003,21 @@ static struct file_system_type ext4_fs_type =3D {
 	.fs_flags	=3D FS_REQUIRES_DEV,
 };
=20
+/* Shared across all ext4 file systems */
+wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
+struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
+
 static int __init init_ext4_fs(void)
 {
=2D	int err;
+	int i, err;
=20
 	ext4_check_flag_values();
+
+	for (i =3D 0; i < EXT4_WQ_HASH_SZ; i++) {
+		mutex_init(&ext4__aio_mutex[i]);
+		init_waitqueue_head(&ext4__ioend_wq[i]);
+	}
+
 	err =3D init_ext4_system_zone();
 	if (err)
 		return err;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
=2D-- a/fs/ext4/inode.c	2012-02-22 18:21:15.000000000 +0100
+++ b/fs/ext4/inode.c	2012-02-23 10:53:48.893489058 +0100
@@ -3609,6 +3609,7 @@
 	struct inode *inode =3D io->inode;
 	loff_t offset =3D io->offset;
 	ssize_t size =3D io->size;
+	wait_queue_head_t *wq;
 	int ret =3D 0;
=20
 	ext4_debug("end_aio_dio_onlock: io 0x%p from inode %lu,list->next 0x%p,"
@@ -3619,7 +3620,7 @@
 	if (list_empty(&io->list))
 		return ret;
=20
=2D	if (io->flag !=3D DIO_AIO_UNWRITTEN)
+	if (!(io->flag & DIO_AIO_UNWRITTEN))
 		return ret;
=20
 	if (offset + size <=3D i_size_read(inode))
@@ -3633,7 +3634,16 @@
 	}
=20
 	/* clear the DIO AIO unwritten flag */
=2D	io->flag =3D 0;
+	if (io->flag & DIO_AIO_UNWRITTEN) {
+		io->flag &=3D ~DIO_AIO_UNWRITTEN;
+		/* Wake up anyone waiting on unwritten extent conversion */
+		wq =3D ext4_ioend_wq(io->inode);
+		if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten) &&
+		    waitqueue_active(wq)) {
+			wake_up_all(wq);
+		}
+	}
+
 	return ret;
 }
 /*
@@ -3747,7 +3757,7 @@
 		  size);
=20
 	/* if not aio dio with unwritten extents, just free io and return */
=2D	if (io_end->flag !=3D DIO_AIO_UNWRITTEN){
+	if (!(io_end->flag & DIO_AIO_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
 		iocb->private =3D NULL;
 		return;

--Boundary-01=_D3jRPNguxyYS6GX--

--nextPart1849790.JziXrtG3Yg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAk9GPcMACgkQYPlgoZpUDjnX+wCdF3yNEwze7p9QDyxtLm4y3H7O
Oq0AoJysjortE/rngdExTlD4KdI1JYlK
=+s9j
-----END PGP SIGNATURE-----

--nextPart1849790.JziXrtG3Yg--


--===============8096001725940985653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xen.org
http://lists.xen.org/xen-devel

--===============8096001725940985653==--
