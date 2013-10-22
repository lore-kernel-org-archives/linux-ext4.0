From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] ext4: check for overlapping extents in
 ext4_valid_extent_entries()
Date: Wed, 23 Oct 2013 02:40:30 +0800
Message-ID: <20131022184030.GC2708@dhcp-13-216.nay.redhat.com>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com>
 <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
 <alpine.LFD.2.00.1310211751370.1983@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43347 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3JVSkf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Oct 2013 14:40:35 -0400
Received: by mail-pa0-f42.google.com with SMTP id kx10so10276306pab.15
        for <linux-ext4@vger.kernel.org>; Tue, 22 Oct 2013 11:40:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310211751370.1983@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 21, 2013 at 06:06:23PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Sun, 20 Oct 2013, Eryu Guan wrote:
=2E..
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index c9ebcb9..855b11d 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -387,11 +387,21 @@ static int ext4_valid_extent_entries(struct i=
node *inode,
> >  	if (depth =3D=3D 0) {
> >  		/* leaf entries */
> >  		struct ext4_extent *ext =3D EXT_FIRST_EXTENT(eh);
> > +		ext4_lblk_t block =3D 0;
> > +		ext4_lblk_t prev =3D 0;
> > +		int len =3D 0;
> >  		while (entries) {
> >  			if (!ext4_valid_extent(inode, ext))
> >  				return 0;
> > +
> > +			/* Check for overlapping extents */
> > +			block =3D le32_to_cpu(ext->ee_block);
> > +			len =3D ext4_ext_get_actual_len(ext);
> > +			if ((block <=3D prev) && prev)
>=20
> Both ext4_valid_extent() and ext4_valid_extent_idx() are setting
> s_last_error_block in the case of error. Maybe we should to the same
> here ? Note that the block saved in that variable is physical, not
> logical.

I think that makes sense, it's better to keep the consistency.

But it seems that the s_last_error_block will eventually be
overwritten by ext4_error_inode() in __ext4_ext_check() ?

>=20
> Also I am curious what happens when one of the extents is corrupted
> in such a way that it crosses the 16TB boundary ? In this case the
> check would not recognise that since prev will underflow, but maybe
> something else catches that ?

Do you mean that a previous (ee_block + len - 1) could cross the 2**32
boundary? I think we can add another check in ext4_valid_extent() for
this situation.

I update the patch to a v3 version, could you please review again?

Thanks a lot!

Eryu Guan

---

=46rom 467025c05bce3ee44e607887bc7cb74ff1bfefcb Mon Sep 17 00:00:00 200=
1
=46rom: Eryu Guan <guaneryu@gmail.com>
Date: Thu, 17 Oct 2013 23:57:22 +0800
Subject: [PATCH v3] ext4: check for overlapping extents in
 ext4_valid_extent_entries()

A corrupted ext4 may have out of order leaf extents, i.e.

extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
             ^^^^ overlap with previous extent

Reading such extent could hit BUG_ON() in ext4_es_cache_extent().

	BUG_ON(end < lblk);

The problem is that __read_extent_tree_block() tries to cache holes as
well but assumes 'lblk' is greater than 'prev' and passes underflowed
length to ext4_es_cache_extent(). Fix it by checking for overlapping
extents in ext4_valid_extent_entries().

I hit this when fuzz testing ext4, and am able to reproduce it by
modifying the on-disk extent by hand.

Also add the check for (ee_block + len - 1) in ext4_valid_extent() to
make sure the value is not overflow.

Ran xfstests on patched ext4 and no regression.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
v3: Address comments from Lukas
 - set s_last_error_block when there's overlapping extents found
 - check for (ee_block + len - 1) in ext4_valid_extent(), value should
   not overflow
v2:
 - check for overlapping extents explicitly not hide the corruption

 fs/ext4/extents.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c9ebcb9..85d977f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -360,8 +360,10 @@ static int ext4_valid_extent(struct inode *inode, =
struct ext4_extent *ext)
 {
 	ext4_fsblk_t block =3D ext4_ext_pblock(ext);
 	int len =3D ext4_ext_get_actual_len(ext);
+	ext4_lblk_t lblock =3D le32_to_cpu(ext->ee_block);
+	ext4_lblk_t last =3D lblock + len - 1;
=20
-	if (len =3D=3D 0)
+	if (lblock > last)
 		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
@@ -387,11 +389,26 @@ static int ext4_valid_extent_entries(struct inode=
 *inode,
 	if (depth =3D=3D 0) {
 		/* leaf entries */
 		struct ext4_extent *ext =3D EXT_FIRST_EXTENT(eh);
+		struct ext4_super_block *es =3D EXT4_SB(inode->i_sb)->s_es;
+		ext4_fsblk_t pblock =3D 0;
+		ext4_lblk_t lblock =3D 0;
+		ext4_lblk_t prev =3D 0;
+		int len =3D 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
+
+			/* Check for overlapping extents */
+			lblock =3D le32_to_cpu(ext->ee_block);
+			len =3D ext4_ext_get_actual_len(ext);
+			if ((lblock <=3D prev) && prev) {
+				pblock =3D ext4_ext_pblock(ext);
+				es->s_last_error_block =3D cpu_to_le64(pblock);
+				return 0;
+			}
 			ext++;
 			entries--;
+			prev =3D lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx =3D EXT_FIRST_INDEX(eh);
--=20
1.8.3.1



--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
