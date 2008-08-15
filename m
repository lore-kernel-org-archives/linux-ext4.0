From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [EXT2] Discard unused sectors
Date: Fri, 15 Aug 2008 23:48:47 +0530
Message-ID: <20080815181847.GF6511@skywalker>
References: <1218704379.4620.46.camel@pmac.infradead.org> <1218704748.4620.50.camel@pmac.infradead.org> <20080815120235.GJ13048@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Woodhouse <dwmw2@infradead.org>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39376 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbYHOSTG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 14:19:06 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7FIHoCm028447
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 04:17:50 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FIIs4Y4538572
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 04:18:54 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FIIrYC007115
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 04:18:53 +1000
Content-Disposition: inline
In-Reply-To: <20080815120235.GJ13048@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 08:02:35AM -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 10:05:48AM +0100, David Woodhouse wrote:
> > I'm not sure how to do this for ext[34]. The sb_issue_discard() fun=
ction
> > issues its requests as a soft barrier, because for na=EFve callers =
it
> > needs to ensure that the discard happens _before_ any subsequent wr=
ites
> > to the same sectors (if they get reallocated immediately).
> >=20
> > But ext[34] can probably do better than that, and submit the discar=
d
> > requests _without_ barriers of their own. If someone with a bit mor=
e
> > clue does it, that is.
>=20
> It's worse than this.  We can't call sb_issue_discard() until the
> transaction commits, since if we crash before the commit, the undelet=
e
> will not have happened.  (The block/inode bitmaps, inode table,
> et. al., aren't allowed to go out to disk until the transaction
> commit, and similarly, those sectors aren't allowed to get reused
> until the commit happens, as well.) =20
>=20
> This is going to be true of any filesystem which is doing journaling.
> What makes life a bit more difficult for ext4 is that we are doing
> physical block journaling, so we're not keeping track which blocks ar=
e
> getting discarded.  (In contrast, systems that do logical journaling
> are keeping track of specific lists of blocks that are getting freed,
> since that's what they write to the journal.)  This means we'll have
> to keep our own in-memory list of extents for which we should call
> sb_issue_discard() when the transaction finally commits.  So this is
> something that we would have to track in the jbd/jbd2 layer, hanging
> off of the transaction structure.  If we do this right, it will also
> be what OCFS2 can use too (since it uses the jbd layer as well.)

Doesn't both ext3 and ext4 do this via=20
ext4_journal_get_undo_access and ext4_mb_free_metadata ?. We actually
wait for the transaction to commit to free the meta-data blocks used by=
 the
transaction

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
