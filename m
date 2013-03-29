From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Date: Fri, 29 Mar 2013 14:08:38 +0400
Message-ID: <87mwtmcyc9.fsf@openvz.org>
References: <20431405.8258404.1364547223843.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: CAI Qian <caiqian@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:38669 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3C2KIo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2013 06:08:44 -0400
In-Reply-To: <20431405.8258404.1364547223843.JavaMail.root@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Mar 2013 04:53:43 -0400 (EDT), CAI Qian <caiqian@redhat.com> wro=
te:
>=20
>=20
> ----- Original Message -----
> > From: "Dmitry Monakhov" <dmonakhov@openvz.org>
> > To: "Theodore Ts'o" <tytso@mit.edu>, "CAI Qian" <caiqian@redhat.com>
> > Cc: "LKML" <linux-kernel@vger.kernel.org>, "linux-s390" <linux-s390@vge=
r.kernel.org>, "Steve Best"
> > <sbest@redhat.com>, linux-ext4@vger.kernel.org
> > Sent: Thursday, March 28, 2013 10:56:37 PM
> > Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
> >=20
> > On Thu, 28 Mar 2013 08:05:17 -0400, Theodore Ts'o <tytso@mit.edu>
> > wrote:
> > > On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> > > > System hung when running xfstests-dev 013 test case on an s390x
> > > > guest. Never saw
> > > > this on 3.9-rc3 before but need to double-check. Any idea?
> > > >=20
> > > > =C3=9D 1113.795759=C2=A8 ------------=C3=9D cut here =C2=A8--------=
----
> > > > =C3=9D 1113.795771=C2=A8 kernel BUG at fs/ext4/inode.c:1591!
> > >=20
> > > thanks for the report.  What kernel version did this come from?
> > >  Was
> > > it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).
> > >=20
> > > If it is indeed 3.9-rc4, it would be helpful, since you can
> > > reproduce
> > > the problem, to insert a debugging printk which fires when
> > > bh->b_blocknr !=3D pblock before the BUG_ON, and have it print the
> > > b_blocknr and pblock values.
> > I've triggered this bug on before at the time i've worked on
> > e4defrag functionality, but AFAIK all related issues was aready fixed
> > and 013 has nothing with e4defrag.
> > But still bh->b_blocknr under us. So other obvious place I suspect is
> > puch_hole but this also not true because 013 use fsstress
> > test in vegetarian mode: "-f rmdir=3D10 -f link=3D10 -f creat=3D10 -f
> > mkdir=3D10
> > -f rename=3D30 -f stat=3D30 -f unlink=3D30 -f truncate=3D20"
> > So the only place I suspect is some unknown bug in extent status tree
> > Can you please enable ES_AGGRESSIVE_TEST and rerun xfstest.
> What is ES_AGGRESSIVE_TEST and how can it enable it?
Please apply patch. It should helps to spot an issue

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=ext4-map_corruption_debug.patch

diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index d8e2d4d..70233a6 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -24,7 +24,7 @@
  * With ES_AGGRESSIVE_TEST defined, the result of es caching will be
  * checked with old map_block's result.
  */
-#define ES_AGGRESSIVE_TEST__
+#define ES_AGGRESSIVE_TEST
 
 /*
  * These flags live in the high bits of extent_status.es_pblk
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3a5213..676c3e1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1588,7 +1588,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 					}
 					if (buffer_unwritten(bh) ||
 					    buffer_mapped(bh))
-						BUG_ON(bh->b_blocknr != pblock);
+						if (bh->b_blocknr != pblock)
+							goto map_corruption;
 					if (map->m_flags & EXT4_MAP_UNINIT)
 						set_buffer_uninit(bh);
 					clear_buffer_unwritten(bh);
@@ -1627,6 +1628,17 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 	}
 	ext4_io_submit(&io_submit);
 	return ret;
+
+map_corruption:
+	printk(KERN_ERR "mpage_da_submit_io failed block=%llu != b_blocknr=%llu\n",
+	       (unsigned long long)pblock, (unsigned long long)bh->b_blocknr);
+	printk(KERN_ERR "ino:%ld lbkl:%lu, b_state=0x%08lx, b_size=%zu\n",
+	       inode->i_ino, cur_logical,  bh->b_state, bh->b_size);
+	/* We have triggered emergency situation. Do not waste our time on
+	 * useless cleanup in order to pretend what situation is under controll.
+	 * Just panic. */
+	BUG();
+	return -EIO;
 }
 
 static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd)

--=-=-=


> > > 
> > > Thanks,
> > > 
> > > 						- Ted
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 

--=-=-=--
