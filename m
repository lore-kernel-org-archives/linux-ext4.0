Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280813D88E5
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2026 07:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778743695; cv=pass; b=UgQirWQLRxKUKCYLGMX73BjSTvylqanTHdaWpf/NxKEhtdVmG4rgtUN7dwdxCIayV5Lhn127fsNdmXu4v6dmnzAuKLn3WI25m4zAB9cPnScQXQoKRPmidLH7HrrzeyP0z9vFz4rsPpcqaDR++VW48GKrNYMU0DKNrsc1VJG2MT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778743695; c=relaxed/simple;
	bh=gTDl3a2HjdTkls2KCClwZup8qGgLP0nHtvXY4JmOPbg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=vEVCLQ4qP5oFI2BXZf0brp1KRQ+UwvgN+yWqAchGRuMAdDBYjClMworG9ibHuYn2Hnrx3EAoTYe524k45LlQUZlriLPhtgB0SmlEeR6BjD8KlOcJmU7+p141xcSqf3qP9jt1M7KMLIGqMASpCwkuwKt/CmYkqmNvc3rWJldmhec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=U/o8+LEp; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="U/o8+LEp"
ARC-Seal: i=1; a=rsa-sha256; t=1778743686; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Q/ylkYm0y5IAbmbGuFVo7Sdcr+Bm1wcL1TLad+vYqqCvd4EbZN2xbUG3rEjeuG79ibw9NZAnLKmkhF5Y3g1rXQEqOqYNlr7JvnBeXh3EZgiZoSq0F/KVx2SqCDf0MqHSpWtqCN97alHBoPTddLzx9FiPI8SpOLEA9f5H6a4GOUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778743686; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WWYjUDfvep/Wp+fKpRwvD98NxIseSp42RISuostGNIY=; 
	b=LbSX5d0z9ppcVuIcn3pJTYEFj2JlADDNrUP8TWQVs4YLRl+H8Ay+QB7dREDLXCnrGciF6dd0+fJHWl1LQdJAzsY9bWbeGeEywt9JOFAHc3i9o0mxy0IBVHx99JNF+7DsIL5QgzVt/H1lXu4II7Z2V+pt6faTE2xrNoCcUtRrZ2U=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778743686;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=WWYjUDfvep/Wp+fKpRwvD98NxIseSp42RISuostGNIY=;
	b=U/o8+LEpnzKVwoNmMz4rOZ+nvxsft5GM1D0P1MKuqX85afBrK2B5UinzivSaf8cZ
	O5YDAeFhJawal8LQI4T/qavNZPdrcj1oYEs8uTKVv0xtYORB2F/+guwD1uIxnpjH93h
	PtQFx/FECKjsmlcrLRb6WoQlJzZ3xPKtNz6Q95v8=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1778743683891166.01678968466956; Thu, 14 May 2026 00:28:03 -0700 (PDT)
Date: Thu, 14 May 2026 15:28:03 +0800
From: Li Chen <me@linux.beauty>
To: "sashiko" <sashiko@lists.linux.dev>
Cc: "tytso" <tytso@mit.edu>, "Linux ext4" <linux-ext4@vger.kernel.org>
Message-ID: <19e2562ab1f.7bfc0be11828124.5033413086245138109@linux.beauty>
In-Reply-To: <20260512034640.71DA1C2BCB0@smtp.kernel.org>
References: <20260511084304.1559557-5-me@linux.beauty> <20260512034640.71DA1C2BCB0@smtp.kernel.org>
Subject: Re: [RFC v7 4/7] ext4: fast commit: avoid self-deadlock in inode
 snapshotting
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi sashiko,

 ---- On Tue, 12 May 2026 11:46:39 +0800   <sashiko-bot@kernel.org> wrote -=
--=20
 > Thank you for your contribution! Sashiko AI review found 1 potential iss=
ue(s) to consider:
 > - [Critical] Removing igrab() exposes a critical use-after-free vulnerab=
ility because ext4_fc_del() can miss the EXT4_STATE_FC_COMMITTING state tra=
nsition and free the inode while it is actively being snapshotted.
 > --
 >=20
 > commit 39c5450f50154240ff764cf3a63e011d8e973fd4
 > Author: Li Chen <me@linux.beauty>
 >=20
 > ext4: fast commit: avoid self-deadlock in inode snapshotting
 >=20
 > This commit removes igrab()/iput() during fast commit snapshotting, rely=
ing
 > instead on the EXT4_STATE_FC_COMMITTING flag to keep inodes pinned while
 > their pointers are stored in the inodes[] array for snapshotting.
 >=20
 > > diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
 > > index 273bf34031aeb..f9bb18c0b5497 100644
 > > --- a/fs/ext4/fast_commit.c
 > > +++ b/fs/ext4/fast_commit.c
 > > @@ -1195,13 +1195,12 @@ static int ext4_fc_snapshot_inodes(journal_t *=
journal)
 > > =20
 > >      alloc_ctx =3D ext4_fc_lock(sb);
 > >      list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 > > -        inodes[i] =3D igrab(&iter->vfs_inode);
 > > -        if (inodes[i])
 > > -            i++;
 > > +        inodes[i++] =3D &iter->vfs_inode;
 > >      }
 >=20
 > Is it possible for this change to cause a use-after-free of the inode?
 >=20
 > If ext4_fc_del() is called during inode eviction, it waits sequentially =
for
 > EXT4_STATE_FC_COMMITTING and then EXT4_STATE_FC_FLUSHING_DATA. However, =
it
 > doesn't appear to loop back to re-check EXT4_STATE_FC_COMMITTING after
 > waiting for the flush bit.
 >=20
 > Could a sequence like this occur?
 >=20
 > 1. ext4_fc_perform_commit() sets EXT4_STATE_FC_FLUSHING_DATA.
 > 2. Eviction calls ext4_fc_del(), which sees EXT4_STATE_FC_COMMITTING is
 >    false, but EXT4_STATE_FC_FLUSHING_DATA is true, so it waits on the
 >    flush bit.
 > 3. ext4_fc_perform_commit() clears EXT4_STATE_FC_FLUSHING_DATA, waking u=
p
 >    ext4_fc_del().
 > 4. Before ext4_fc_del() resumes, ext4_fc_perform_commit() sets
 >    EXT4_STATE_FC_COMMITTING and saves the unpinned inode pointer into th=
e
 >    inodes[] array.
 > 5. ext4_fc_del() resumes, skips re-checking EXT4_STATE_FC_COMMITTING,
 >    removes the inode from the fast commit list, and returns.
 > 6. The VFS completely frees the inode.
 > 7. ext4_fc_snapshot_inodes() iterates over the inodes[] array and passes
 >    the now dangling pointer to ext4_fc_snapshot_inode().
 >=20
 > Does ext4_fc_del() need to re-verify the state flags after waking up, or
 > is there another mechanism preventing the inode from being freed before
 > ext4_fc_snapshot_inode() accesses it?
 >=20
 > [ ... ]
 >=20
 > --=20
 > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260511084304.1=
559557-1-me@linux.beauty?part=3D4
 >=20

Yes, I think you're right. I missed that window.

I'll make ext4_fc_del() loop back after waiting on FC_FLUSHING_DATA, so it =
checks FC_COMMITTING again
under s_fc_lock before removing the inode from the FC lists.

Regards,
Li=E2=80=8B

