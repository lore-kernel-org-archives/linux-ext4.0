From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: don't consume reserved space when allocating
 partial cluster
Date: Tue, 24 Mar 2015 15:31:47 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503241516410.2541@localhost.localdomain>
References: <20150317012009.GA5870@wallace> <alpine.LFD.2.00.1503231117470.1578@localhost.localdomain> <20150323231539.GA4135@wallace>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1407652996-1427206789=:2541"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbbCXObv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Mar 2015 10:31:51 -0400
In-Reply-To: <20150323231539.GA4135@wallace>
Content-ID: <alpine.LFD.2.00.1503241520120.2541@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1407652996-1427206789=:2541
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1503241520121.2541@localhost.localdomain>

On Mon, 23 Mar 2015, Eric Whitney wrote:

> Date: Mon, 23 Mar 2015 19:15:39 -0400
> From: Eric Whitney <enwlinux@gmail.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
>     tytso@mit.edu
> Subject: Re: [PATCH] ext4: don't consume reserved space when allocating
>     partial cluster
> 
> * Luká¨ Czerner <lczerner@redhat.com>:
> > On Mon, 16 Mar 2015, Eric Whitney wrote:
> > 
> > > Date: Mon, 16 Mar 2015 21:20:09 -0400
> > > From: Eric Whitney <enwlinux@gmail.com>
> > > To: linux-ext4@vger.kernel.org
> > > Cc: tytso@mit.edu
> > > Subject: [PATCH] ext4: don't consume reserved space when allocating partial
> > >     cluster
> > > 
> > > When xfstests' auto group is run on a bigalloc filesystem with a
> > > 4.0-rc3 kernel, e2fsck failures and kernel warnings occur for some
> > > tests. e2fsck reports incorrect iblocks values, and the warnings
> > > indicate that the space reserved by delayed allocation is being
> > > overdrawn at allocation time.
> > > 
> > > Some of these errors occur because the reserved space is incorrectly
> > > decreased by one cluster when ext4_ext_map_blocks satisfies an
> > > allocation request by using an unused portion of a previously allocated
> > > cluster.  Because a cluster's worth of reserved space was already
> > > removed when it was first allocated, it should not be removed again.
> > 
> > Hi Eric,
> > 
> > I am not sure I understand. What do you mean by saying that the
> > space was already removed when it was first allocated ?
> 
> Hi Lukas:
> 
> I'm sorry that was confusing - I didn't get the terminology quite right,
> given the usage in the code.  What I'm discussing in that sentence is
> the space reserved for delayed allocation.  Instead of "removed", I should
> have said "released".  If we're mapping from an existing cluster, at some
> point in the past that cluster was allocated, and at that time the space
> reservation for that cluster would have been released.  So, we ought not
> to be releasing its space again.
> 
> > 
> > From my point of view the ext4_da_update_reserve_space() call is ok,
> > because we're going to use blocks from already allocated cluster, so
> > we do not want to account for quota in this case, because that has
> > already been done when the cluster was allocated. The rest is just
> > updating reservations and the dirty clusters counter which needs to
> > be done in any case. But I might be actually missing something, am I
> > ?
> 
> I agree that we don't want to account for quota, as that should have been
> done in the past when the cluster was first allocated.  I think we don't
> want to update the reservations or the dirty clusters counter because that
> should also have been taken into account at the same time in the past.  If
> we update them again, decreasing them once more for the cluster we're currently
> processing, we'll be double accounting for the space.
> 
> The code in ext4_da_map_blocks() that runs at write begin time and increases
> the amount of reserved space only does so when a cluster has not been
> previously allocated or already accounted for as part of a delalloc extent
> recorded in the status tree.  I think it should be accurately reflecting the
> number of clusters we'll eventually need to allocate for data, so there's no
> room for double counting when mapping from an existing cluster in
> ext4_ext_map_blocks().

Ah, you're right so that's there probably from the times where we
had to do metadata blocks reservation as well. Thanks for
clarification.

> 
> If I'm not reading the delalloc accounting code incorrectly, a few more patches
> will likely be required to remove some of the code immediately following
> if (!map_from_cluster) and a chunk in ext4_ext_handle_unwritten_extents().

Maybe it would be worth deal with that mess in the
ext4_ext_map_blocks() within a single patch ?

-Lukas

> 
> Thanks,
> Eric
> 
> 
> > 
> > Thanks!
> > -Lukas
> > 
> > > 
> > > This patch appears to correct the e2fsck failure reported for
> > > generic/232 and the kernel warnings produced by ext4/001, generic/009,
> > > and generic/033.  Failures and warnings for some other tests remain to
> > > be addressed.
> > > 
> > > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > > ---
> > >  fs/ext4/extents.c | 14 +-------------
> > >  1 file changed, 1 insertion(+), 13 deletions(-)
> > > 
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index bed4308..554190e 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -4535,19 +4535,7 @@ got_allocated_blocks:
> > >  		 */
> > >  		reserved_clusters = get_reserved_cluster_alloc(inode,
> > >  						map->m_lblk, allocated);
> > > -		if (map_from_cluster) {
> > > -			if (reserved_clusters) {
> > > -				/*
> > > -				 * We have clusters reserved for this range.
> > > -				 * But since we are not doing actual allocation
> > > -				 * and are simply using blocks from previously
> > > -				 * allocated cluster, we should release the
> > > -				 * reservation and not claim quota.
> > > -				 */
> > > -				ext4_da_update_reserve_space(inode,
> > > -						reserved_clusters, 0);
> > > -			}
> > > -		} else {
> > > +		if (!map_from_cluster) {
> > >  			BUG_ON(allocated_clusters < reserved_clusters);
> > >  			if (reserved_clusters < allocated_clusters) {
> > >  				struct ext4_inode_info *ei = EXT4_I(inode);
> > > 
> 
--8323328-1407652996-1427206789=:2541--
