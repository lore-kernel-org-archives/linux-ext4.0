From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: don't consume reserved space when allocating
 partial cluster
Date: Mon, 23 Mar 2015 19:15:39 -0400
Message-ID: <20150323231539.GA4135@wallace>
References: <20150317012009.GA5870@wallace>
 <alpine.LFD.2.00.1503231117470.1578@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:36531 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbbCWXPn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2015 19:15:43 -0400
Received: by qgez102 with SMTP id z102so81307763qge.3
        for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2015 16:15:42 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503231117470.1578@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>:
> On Mon, 16 Mar 2015, Eric Whitney wrote:
>=20
> > Date: Mon, 16 Mar 2015 21:20:09 -0400
> > From: Eric Whitney <enwlinux@gmail.com>
> > To: linux-ext4@vger.kernel.org
> > Cc: tytso@mit.edu
> > Subject: [PATCH] ext4: don't consume reserved space when allocating=
 partial
> >     cluster
> >=20
> > When xfstests' auto group is run on a bigalloc filesystem with a
> > 4.0-rc3 kernel, e2fsck failures and kernel warnings occur for some
> > tests. e2fsck reports incorrect iblocks values, and the warnings
> > indicate that the space reserved by delayed allocation is being
> > overdrawn at allocation time.
> >=20
> > Some of these errors occur because the reserved space is incorrectl=
y
> > decreased by one cluster when ext4_ext_map_blocks satisfies an
> > allocation request by using an unused portion of a previously alloc=
ated
> > cluster.  Because a cluster's worth of reserved space was already
> > removed when it was first allocated, it should not be removed again=
=2E
>=20
> Hi Eric,
>=20
> I am not sure I understand. What do you mean by saying that the
> space was already removed when it was first allocated ?

Hi Lukas:

I'm sorry that was confusing - I didn't get the terminology quite right=
,
given the usage in the code.  What I'm discussing in that sentence is
the space reserved for delayed allocation.  Instead of "removed", I sho=
uld
have said "released".  If we're mapping from an existing cluster, at so=
me
point in the past that cluster was allocated, and at that time the spac=
e
reservation for that cluster would have been released.  So, we ought no=
t
to be releasing its space again.

>=20
> From my point of view the ext4_da_update_reserve_space() call is ok,
> because we're going to use blocks from already allocated cluster, so
> we do not want to account for quota in this case, because that has
> already been done when the cluster was allocated. The rest is just
> updating reservations and the dirty clusters counter which needs to
> be done in any case. But I might be actually missing something, am I
> ?

I agree that we don't want to account for quota, as that should have be=
en
done in the past when the cluster was first allocated.  I think we don'=
t
want to update the reservations or the dirty clusters counter because t=
hat
should also have been taken into account at the same time in the past. =
 If
we update them again, decreasing them once more for the cluster we're c=
urrently
processing, we'll be double accounting for the space.

The code in ext4_da_map_blocks() that runs at write begin time and incr=
eases
the amount of reserved space only does so when a cluster has not been
previously allocated or already accounted for as part of a delalloc ext=
ent
recorded in the status tree.  I think it should be accurately reflectin=
g the
number of clusters we'll eventually need to allocate for data, so there=
's no
room for double counting when mapping from an existing cluster in
ext4_ext_map_blocks().

If I'm not reading the delalloc accounting code incorrectly, a few more=
 patches
will likely be required to remove some of the code immediately followin=
g
if (!map_from_cluster) and a chunk in ext4_ext_handle_unwritten_extents=
().

Thanks,
Eric


>=20
> Thanks!
> -Lukas
>=20
> >=20
> > This patch appears to correct the e2fsck failure reported for
> > generic/232 and the kernel warnings produced by ext4/001, generic/0=
09,
> > and generic/033.  Failures and warnings for some other tests remain=
 to
> > be addressed.
> >=20
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  fs/ext4/extents.c | 14 +-------------
> >  1 file changed, 1 insertion(+), 13 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index bed4308..554190e 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4535,19 +4535,7 @@ got_allocated_blocks:
> >  		 */
> >  		reserved_clusters =3D get_reserved_cluster_alloc(inode,
> >  						map->m_lblk, allocated);
> > -		if (map_from_cluster) {
> > -			if (reserved_clusters) {
> > -				/*
> > -				 * We have clusters reserved for this range.
> > -				 * But since we are not doing actual allocation
> > -				 * and are simply using blocks from previously
> > -				 * allocated cluster, we should release the
> > -				 * reservation and not claim quota.
> > -				 */
> > -				ext4_da_update_reserve_space(inode,
> > -						reserved_clusters, 0);
> > -			}
> > -		} else {
> > +		if (!map_from_cluster) {
> >  			BUG_ON(allocated_clusters < reserved_clusters);
> >  			if (reserved_clusters < allocated_clusters) {
> >  				struct ext4_inode_info *ei =3D EXT4_I(inode);
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
