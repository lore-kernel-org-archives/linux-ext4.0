From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: don't consume reserved space when allocating
 partial cluster
Date: Tue, 24 Mar 2015 17:06:25 -0400
Message-ID: <20150324210625.GA29607@wallace>
References: <20150317012009.GA5870@wallace>
 <alpine.LFD.2.00.1503231117470.1578@localhost.localdomain>
 <20150323231539.GA4135@wallace>
 <alpine.LFD.2.00.1503241516410.2541@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:32961 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbCXVGa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Mar 2015 17:06:30 -0400
Received: by qgfa8 with SMTP id a8so9886178qgf.0
        for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2015 14:06:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503241516410.2541@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>:
> On Mon, 23 Mar 2015, Eric Whitney wrote:
>=20
> > Date: Mon, 23 Mar 2015 19:15:39 -0400
> > From: Eric Whitney <enwlinux@gmail.com>
> > To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> > Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
> >     tytso@mit.edu
> > Subject: Re: [PATCH] ext4: don't consume reserved space when alloca=
ting
> >     partial cluster
> >=20
> > * Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>:
> > > On Mon, 16 Mar 2015, Eric Whitney wrote:
> > >=20
> > > > Date: Mon, 16 Mar 2015 21:20:09 -0400
> > > > From: Eric Whitney <enwlinux@gmail.com>
> > > > To: linux-ext4@vger.kernel.org
> > > > Cc: tytso@mit.edu
> > > > Subject: [PATCH] ext4: don't consume reserved space when alloca=
ting partial
> > > >     cluster
> > > >=20
> > > > When xfstests' auto group is run on a bigalloc filesystem with =
a
> > > > 4.0-rc3 kernel, e2fsck failures and kernel warnings occur for s=
ome
> > > > tests. e2fsck reports incorrect iblocks values, and the warning=
s
> > > > indicate that the space reserved by delayed allocation is being
> > > > overdrawn at allocation time.
> > > >=20
> > > > Some of these errors occur because the reserved space is incorr=
ectly
> > > > decreased by one cluster when ext4_ext_map_blocks satisfies an
> > > > allocation request by using an unused portion of a previously a=
llocated
> > > > cluster.  Because a cluster's worth of reserved space was alrea=
dy
> > > > removed when it was first allocated, it should not be removed a=
gain.
> > >=20
> > > Hi Eric,
> > >=20
> > > I am not sure I understand. What do you mean by saying that the
> > > space was already removed when it was first allocated ?
> >=20
> > Hi Lukas:
> >=20
> > I'm sorry that was confusing - I didn't get the terminology quite r=
ight,
> > given the usage in the code.  What I'm discussing in that sentence =
is
> > the space reserved for delayed allocation.  Instead of "removed", I=
 should
> > have said "released".  If we're mapping from an existing cluster, a=
t some
> > point in the past that cluster was allocated, and at that time the =
space
> > reservation for that cluster would have been released.  So, we ough=
t not
> > to be releasing its space again.
> >=20
> > >=20
> > > From my point of view the ext4_da_update_reserve_space() call is =
ok,
> > > because we're going to use blocks from already allocated cluster,=
 so
> > > we do not want to account for quota in this case, because that ha=
s
> > > already been done when the cluster was allocated. The rest is jus=
t
> > > updating reservations and the dirty clusters counter which needs =
to
> > > be done in any case. But I might be actually missing something, a=
m I
> > > ?
> >=20
> > I agree that we don't want to account for quota, as that should hav=
e been
> > done in the past when the cluster was first allocated.  I think we =
don't
> > want to update the reservations or the dirty clusters counter becau=
se that
> > should also have been taken into account at the same time in the pa=
st.  If
> > we update them again, decreasing them once more for the cluster we'=
re currently
> > processing, we'll be double accounting for the space.
> >=20
> > The code in ext4_da_map_blocks() that runs at write begin time and =
increases
> > the amount of reserved space only does so when a cluster has not be=
en
> > previously allocated or already accounted for as part of a delalloc=
 extent
> > recorded in the status tree.  I think it should be accurately refle=
cting the
> > number of clusters we'll eventually need to allocate for data, so t=
here's no
> > room for double counting when mapping from an existing cluster in
> > ext4_ext_map_blocks().
>=20
> Ah, you're right so that's there probably from the times where we
> had to do metadata blocks reservation as well. Thanks for
> clarification.
>=20
> >=20
> > If I'm not reading the delalloc accounting code incorrectly, a few =
more patches
> > will likely be required to remove some of the code immediately foll=
owing
> > if (!map_from_cluster) and a chunk in ext4_ext_handle_unwritten_ext=
ents().
>=20
> Maybe it would be worth deal with that mess in the
> ext4_ext_map_blocks() within a single patch ?
>=20

Ideally, yes, but we'd like to get out the safest fix (this one) quickl=
y
so the developers working on SMR support get cleaner bigalloc test runs=
=2E
The others will follow.  A patch fixing delalloc accounting in
ext4_ext_handle_unwritten_extents() just needs more testing, but
potentially affects non-bigalloc file systems, so is slightly higher ri=
sk.
A second patch would remove the code in ext4_ext_map_blocks following t=
he
"if (!map_from_cluster)" statement inserted by this patch.  However, it=
's
actually protecting us from a bug caused by the use of
filemap_write_and_wait_range calls at the top of ext4_punch_hole, etc. =
-
it causes the same reserved space to be released twice.  There's a two =
year
old patch, never landed, that might be useful to fix this by removing t=
he
filemap call, but it's going to take more time to get that sorted out.

I'll post a v2 that cleans up my terminology problems with a slightly
different title shortly.

Thanks for looking this over!

Eric


> -Lukas
>=20
> >=20
> > Thanks,
> > Eric
> >=20
> >=20
> > >=20
> > > Thanks!
> > > -Lukas
> > >=20
> > > >=20
> > > > This patch appears to correct the e2fsck failure reported for
> > > > generic/232 and the kernel warnings produced by ext4/001, gener=
ic/009,
> > > > and generic/033.  Failures and warnings for some other tests re=
main to
> > > > be addressed.
> > > >=20
> > > > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > > > ---
> > > >  fs/ext4/extents.c | 14 +-------------
> > > >  1 file changed, 1 insertion(+), 13 deletions(-)
> > > >=20
> > > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > > index bed4308..554190e 100644
> > > > --- a/fs/ext4/extents.c
> > > > +++ b/fs/ext4/extents.c
> > > > @@ -4535,19 +4535,7 @@ got_allocated_blocks:
> > > >  		 */
> > > >  		reserved_clusters =3D get_reserved_cluster_alloc(inode,
> > > >  						map->m_lblk, allocated);
> > > > -		if (map_from_cluster) {
> > > > -			if (reserved_clusters) {
> > > > -				/*
> > > > -				 * We have clusters reserved for this range.
> > > > -				 * But since we are not doing actual allocation
> > > > -				 * and are simply using blocks from previously
> > > > -				 * allocated cluster, we should release the
> > > > -				 * reservation and not claim quota.
> > > > -				 */
> > > > -				ext4_da_update_reserve_space(inode,
> > > > -						reserved_clusters, 0);
> > > > -			}
> > > > -		} else {
> > > > +		if (!map_from_cluster) {
> > > >  			BUG_ON(allocated_clusters < reserved_clusters);
> > > >  			if (reserved_clusters < allocated_clusters) {
> > > >  				struct ext4_inode_info *ei =3D EXT4_I(inode);
> > > >=20
> >=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
