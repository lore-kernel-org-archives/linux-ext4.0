From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: handle NULL p_ext in ext4_ext_next_allocated_block()
Date: Tue, 11 Oct 2011 11:01:57 +0400
Message-ID: <87ipnwnh96.fsf@dmbot.sw.ru>
References: <1318122074-16056-1-git-send-email-curtw@google.com> <alpine.LFD.2.00.1110100841380.4851@dhcp-27-109.brq.redhat.com> <CAO81RMbLGDUihKORjQ5rGeRHPHg5ivvQtOGJL_oBe4QUiiO0hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>,
	Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45956 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1JKHCC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Oct 2011 03:02:02 -0400
Received: by bkbzt4 with SMTP id zt4so9410983bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 11 Oct 2011 00:02:01 -0700 (PDT)
In-Reply-To: <CAO81RMbLGDUihKORjQ5rGeRHPHg5ivvQtOGJL_oBe4QUiiO0hg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Oct 2011 08:28:23 -0700, Curt Wohlgemuth <curtw@google.com> wrot=
e:
> Hi Lukas:
>=20
> On Mon, Oct 10, 2011 at 12:19 AM, Lukas Czerner <lczerner@redhat.com> wro=
te:
> > On Sat, 8 Oct 2011, Curt Wohlgemuth wrote:
> >
> >> In ext4_ext_next_allocated_block(), the path[depth] might
> >> have a p_ext that is NULL -- see ext4_ext_binsearch(). =C2=A0In
> >> such a case, dereferencing it will crash the machine.
> >>
> >> This patch checks for p_ext =3D=3D NULL in
> >> ext4_ext_next_allocated_block() before dereferencinging it.
> >>
> >> Tested using a hand-crafted an inode with eh_entries =3D=3D 0 in
> >> an extent block, verified that running FIEMAP on it crashes
> >> without this patch, works fine with it.
> >
> > Hi Curt,
> >
> > It seems to me that even that the patch fixes the NULL dereference, it
> > is not a complete solution. Is it possible that in "normal" case p_ext
> > would be NULL ? I think that this is only possible in extent split/add
> > case (as noted in ext4_ext_binsearch()) which should be atomic to the
> > other operations (locked i_mutex?).
>=20
> Yes, unfortunately, it is possible in "normal" cases for p_ext to be NULL.
>=20
> We've seen this problem during what appears to be a race between an
> inode growth (or truncate?) and another task doing a FIEMAP ioctl.
> The real problem is that FIEMAP handing in ext4 is just, well, buggy?
Wow, IMHO it not just buggy, it is obviously incorrect, IMHO it is more
fair just return -ENOTSUPP, at least it is much safer.
Yes calling FIEMAP and truncate/write in parallel is stupid, but not
prohibited.=20
>=20
> ext4_ext_walk_space() will get the i_data_sem, construct the path
> array, then release the semaphore.  But then it does a bazillion
> accesses on the extent/header/index pointers in the path array, with
> no protection against truncate, growth, or any other changes.  As far
> as I can tell, this is the only use of a path array retrieved from
> ext4_ext_find_extent() that isn't completely covered by i_data_sem.
In that case i_data sem protects us from nothing. Path collected can
simply disappear under us. And in fact i don't understand the
reason why we drop i_data_sem too soon. Are any reason to do that?
Seems like following patch should fix the issue.

--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-do-not-drop-i_data_sem-too-soon.patch

>From 12cd56ccd86c4d132f186034a9c11b0a2441a19f Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 11 Oct 2011 10:44:31 +0400
Subject: [PATCH] ext4: do not drop i_data_sem too soon

Path returned from ext4_find_extent is valid only while we hold
i_data_sem, so we can drop it only after we nolonger need it.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index da4583f..c716a1f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1847,23 +1847,32 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 		num = last - block;
 		/* find extent for this block */
 		down_read(&EXT4_I(inode)->i_data_sem);
+		if (ext_depth(inode) != depth) {
+			/* depth was changed. we have to realloc path */
+			kfree(path);
+			path = NULL;
+		}
+
 		path = ext4_ext_find_extent(inode, block, path);
-		up_read(&EXT4_I(inode)->i_data_sem);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
+			up_read(&EXT4_I(inode)->i_data_sem);
 			path = NULL;
 			break;
 		}
 
 		depth = ext_depth(inode);
 		if (unlikely(path[depth].p_hdr == NULL)) {
+			up_read(&EXT4_I(inode)->i_data_sem);
 			EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
 			err = -EIO;
 			break;
 		}
+
 		ex = path[depth].p_ext;
 		next = ext4_ext_next_allocated_block(path);
-
+		up_read(&EXT4_I(inode)->i_data_sem);
+		ext4_ext_drop_refs(path);
 		exists = 0;
 		if (!ex) {
 			/* there is no extent yet, so try to allocate
@@ -1915,7 +1924,6 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			break;
 		}
 		err = func(inode, next, &cbex, ex, cbdata);
-		ext4_ext_drop_refs(path);
 
 		if (err < 0)
 			break;
@@ -1927,12 +1935,6 @@ static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
 			break;
 		}
 
-		if (ext_depth(inode) != depth) {
-			/* depth was changed. we have to realloc path */
-			kfree(path);
-			path = NULL;
-		}
-
 		block = cbex.ec_block + cbex.ec_len;
 	}
 
-- 
1.7.1


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



>=20
> > However this seems like an inode corruption so we should probably be
> > more verbose about it and print an appropriate EXT4_ERROR_INODE() or
> > even better check for the corrupted tree in the ext4_ext_find_extent()
> > (instead in ext4_ext_map_blocks()), however this will need to distingui=
sh
> > between the normal and the tree modification case.
>=20
> What we've observed many times is a crash during a FIEMAP call to
> ext4_ext_next_allocated_block(), which appears to me to be during a
> race with another thread that's splitting the extent tree.  This
> causes the machine to go down with the inode in a bad state.  But of
> course, fsck won't detect and fix this, so when the machine comes back
> up, and a FIEMAP call is done on this same inode -- without any other
> threads -- it'll crash again.  Hence a nasty crash loop.
>=20
> So you're right, in that this isn't the "real solution."  But devising
> a safe, non-racy design for FIEMAP is not so simple, unless of course
> you want to just hold the i_data_sem during the entire loop body of
> ext4_ext_walk_space(), which would be pretty ugly.  Hence the
> "band-aid" approach in my patch, which at least seems correct, if not
> thorough.
>=20
> Thanks,
> Curt
>=20
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> >> ---
> >> =C2=A0fs/ext4/extents.c | =C2=A0 =C2=A04 +++-
> >> =C2=A01 files changed, 3 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >> index 57cf568..063a5b8 100644
> >> --- a/fs/ext4/extents.c
> >> +++ b/fs/ext4/extents.c
> >> @@ -1395,7 +1395,9 @@ ext4_ext_next_allocated_block(struct ext4_ext_pa=
th *path)
> >> =C2=A0 =C2=A0 =C2=A0 while (depth >=3D 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (depth =3D=3D path=
->p_depth) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* leaf */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (path[depth].p_ext !=3D
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* p_ext can be NULL */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (path[depth].p_ext &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path[depth].p_ext !=3D
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 EXT_LAST_EXT=
ENT(path[depth].p_hdr))
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 return le32_to_cpu(path[depth].p_ext[1].ee_block);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >>
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
