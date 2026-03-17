Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACBD37C0F0;
	Tue, 17 Mar 2026 20:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773779268; cv=none; b=tclhq8PsqcDUO0idYWixEzKaB3J9CwOf8G1K2HMdvNEObvnmxICySuL8ClT5PGzyEGTYM25lstowDd2HPOrTDQ+zaFUZlafRKnPSN2Ev6iicbWbmGKEMGPFgVelksy9hBKvq8V+OVx7iW9RuMMSURCHkVBF7QgeKhmMSElg5wIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773779268; c=relaxed/simple;
	bh=TrryhfY16iEnBl9EI0yi6zqmZvlspCtJwbw52ig1Oms=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=KJS91Jcq7sCyZeLKvUOf+odekJKJ23tnhcFFirx1UtzXllOTUcnyIYsiL/NTzTyBikaVpKlMRJ6Jq3qWAxFJr0y4ERnaFUI+n8pfzDFsmOWCFtWvWlIrR8vPtYtuDPqy8+oRaZAHatlU0xM67peGAXDvtGpDHvwlteLpxnfcoUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=lO6bztM+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iGFrWDFb; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="lO6bztM+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iGFrWDFb"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id B8AF3EC0113;
	Tue, 17 Mar 2026 16:27:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 17 Mar 2026 16:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1773779265; x=1773865665; bh=LrY+TxWHnplXnMPoAHfi1EZkuE/wSRHI4cj
	rfkPKlUw=; b=lO6bztM+zWQdPkcp7ftW5xBuSQ62lGoVvMV0bSWxiYn82xmYOvb
	znusCcUPNINRFUY1Y79h2ObuhJAmwHXJ5RUuDgKFX/2X4LISg61n7jUGK1pHZLm7
	D7ugZthBejoKlzTujllgjOQ5Lw/1LA6DKgpnVwagGuR9CKwz631n5WKMzhShO9jn
	NbUAlSXJpCicrr5TBAREbY3jwwSky3J+Rq8r4RX+trTMCVv5q1i5OpJrSTmDObmA
	mXvmKtj4ZmtB9jWsXwD81x2SFNw6MRJ7oFfr75eTzRd1+XUIgEsqgqriwnSnJuVk
	NmZlOR/uXHTMSsQf4NeOrvMJfiPzecoMInA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773779265; x=
	1773865665; bh=LrY+TxWHnplXnMPoAHfi1EZkuE/wSRHI4cjrfkPKlUw=; b=i
	GFrWDFbzRkl/2byhO59YcZXa3MNR0EKpc7R9M1ZDmVm6YwBSnEtBm5V3u370YQtJ
	U5jinszec6FztN2JQhLdsOXop00XBkUXGXGZK5rN1C1U0QcIY1b631WKhTLvRNcs
	S3iKekiIfY1RJzNft1BoI0HWKFeDpQy/KTG/1nO8IjsW1eeV4hijOyDR86jBnloZ
	xK1ZMX/xzC/6FCw9Zo94PBm0GvbP9Knkuco+HsDmmojAapZhLgDc6dK69Nsce/CG
	P4+j/N/mu6mzPbfS2Nq5opJFGZ9X7JL9mrsbYgtCZDDE/4YxOo5gbYq3wpgzKDqR
	cRwG/3riDFUcCYNUeFU4Q==
X-ME-Sender: <xms:Qbm5ablmEN1lKtxZ5tKwlW8JqucHlUevEJt8a4HFbsn6hPV-pdmEWQ>
    <xme:Qbm5aR70Ri1AWsRzxznlZ9GJSr7UW61nCP4nHXNviOWR8hBu2pIYmr8BCaOHbYp9X
    0oz60hkKSJAg6eU-5pDl0koopplTQ5M-ZzqAqGxDMEB_0mazw>
X-ME-Received: <xmr:Qbm5acS8TnLTNis6_CnuuoLwg4lp6v1RyuKT0ncsXUm9MI81JC8O9pVlDvUmvDCLml2eWk83KwOjDn4Yz0uIIyULaBLeRpniEzy7X6JL__Wy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftddvvdduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleejtdefgeeukeeiteduveehudevfeffvedutefgteduhfegvdfgtdeigeeuudejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtohepvhhirhhoseiivghnihhvrdhlihhnuhigrdhorhhgrdhukhdprh
    gtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepjhgrtghksehsuhhsvgdrtgiipdhrtghpthhtohepthihthhsohesmh
    hithdrvgguuhdprhgtphhtthhopehjlhgrhihtohhnsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrughilh
    hgvghrrdhkvghrnhgvlhesughilhhgvghrrdgtrg
X-ME-Proxy: <xmx:Qbm5afzu0D7xzD_BPC9aeYwK5HIPSmvItw_wV0-XUbHwh9yfUqzzaw>
    <xmx:Qbm5aUqSvOFg3UrMD8oNy7bq1RoPpjtj7PmDZ5OBCKxPNnyVpU65Pw>
    <xmx:Qbm5aS3WYlPObcevLyIoCXinIaObjDEfc6B-0yKWfWIBETGjcZNZxw>
    <xmx:Qbm5aUxheE7p0xjJsI7_EOwAXKJF8MOBjXWe57cMZtJrJXXgu2v9Mg>
    <xmx:Qbm5aYuxAs2ZIwY8qqbyOeh8tgOUrWgd7ppfZnnd74X_hA22FwqBxavc>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 16:27:42 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Jan Kara" <jack@suse.cz>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Jeff Layton" <jlayton@kernel.org>,  "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH 32/53f] ext4: move dcache modifying code out of __ext4_link()
In-reply-to: <imo3cvhqtvginngr2ofsotmrsxixutn2jagbkj6322cfgxm3lj@wosdq3xvlym5>
References: <20260312214330.3885211-1-neilb@ownmail.net>,
 <20260312214330.3885211-33-neilb@ownmail.net>,
 <imo3cvhqtvginngr2ofsotmrsxixutn2jagbkj6322cfgxm3lj@wosdq3xvlym5>
Date: Wed, 18 Mar 2026 07:27:37 +1100
Message-id: <177377925781.5556.10082450121311369542@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>


(cc trimmed...)

On Tue, 17 Mar 2026, Jan Kara wrote:
> On Fri 13-03-26 08:12:19, NeilBrown wrote:
> ...
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index a1219b446b74..c48337d95f9a 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -358,7 +358,7 @@ static inline int dname_external(const struct dentry =
*dentry)
> >  	return dentry->d_name.name !=3D dentry->d_shortname.string;
> >  }
> > =20
> > -void take_dentry_name_snapshot(struct name_snapshot *name, struct dentry=
 *dentry)
> > +void take_dentry_name_snapshot(struct name_snapshot *name, const struct =
dentry *dentry)
> >  {
> >  	unsigned seq;
> >  	const unsigned char *s;
>=20
> The constification of take_dentry_name_snapshot() should probably be a
> separate patch? Also I'd note that this constification (and the
> constification of __ext4_fc_track_link()) isn't really needed here because
> ext4_fc_track_link() will immediately bail through ext4_fc_disabled() when
> fast commit replay is happening so __ext4_fc_track_link() never gets called
> in that case - more about that below.

I thought I might have overdone the constantification, but I didn't want
to under-do it, at least for my compile tests.


>=20
> > @@ -1471,7 +1471,15 @@ static int ext4_fc_replay_link_internal(struct sup=
er_block *sb,
> >  		goto out;
> >  	}
> > =20
> > +	ihold(inode);
> > +	inc_nlink(inode);
> >  	ret =3D __ext4_link(dir, inode, dentry_inode);
> > +	if (ret) {
> > +		drop_nlink(inode);
> > +		iput(inode);
> > +	} else {
> > +		d_instantiate(dentry_inode, inode);
> > +	}
> >  	/*
> >  	 * It's possible that link already existed since data blocks
> >  	 * for the dir in question got persisted before we crashed OR
> ...
> > @@ -3460,8 +3460,6 @@ int __ext4_link(struct inode *dir, struct inode *in=
ode, struct dentry *dentry)
> >  		ext4_handle_sync(handle);
> > =20
> >  	inode_set_ctime_current(inode);
> > -	ext4_inc_count(inode);
> > -	ihold(inode);
> > =20
> >  	err =3D ext4_add_entry(handle, dentry, inode);
> >  	if (!err) {
> > @@ -3471,11 +3469,7 @@ int __ext4_link(struct inode *dir, struct inode *i=
node, struct dentry *dentry)
> >  		 */
> >  		if (inode->i_nlink =3D=3D 1)
> >  			ext4_orphan_del(handle, inode);
> > -		d_instantiate(dentry, inode);
> > -		ext4_fc_track_link(handle, dentry);
> > -	} else {
> > -		drop_nlink(inode);
> > -		iput(inode);
> > +		__ext4_fc_track_link(handle, inode, dentry);
>=20
> This looks wrong. If fastcommit replay is running, we must skip calling
> __ext4_fc_track_link(). Similarly if the filesystem is currently
> inelligible for fastcommit (due to some complex unsupported operations
> running in parallel). Why did you change ext4_fc_track_link() to
> __ext4_fc_track_link()?

I changed to __ext4_fc_track_link() because I needed something that
accepted the inode separately from the dentry.  As you point out, that
means we lose some important code which makes the decision misguided.

I'm wondering about taking a different approach - not using a dentry at
all and not constifying anything.
I could split __ext4_add_entry() out of ext4_add_entry() and instead of
passing the dentry-to-add I could pass the dir inode qstr name, and
d_flags.

Then ext4_link could be passed the same plus a "do fast commit" flag.

The result would be more verbose, but also hopefully more clear.

>=20
> > @@ -3504,7 +3498,16 @@ static int ext4_link(struct dentry *old_dentry,
> >  	err =3D dquot_initialize(dir);
> >  	if (err)
> >  		return err;
> > -	return __ext4_link(dir, inode, dentry);
> > +	ihold(inode);
> > +	ext4_inc_count(inode);
>=20
> I'd put inc_nlink() here instead. We are guaranteed to have a regular file
> anyway and it matches what we do in ext4_fc_replay_link_internal().
> Alternatively we could consistently use ext4_inc_count() &
> ext4_dec_count() in these functions.

Current __ext4_link() has ext4_inc_count().
But it is only usable in namei.c.  So I didn't use it in
ext4_fc_replay_link_internal() as that is in a different file.

I'll revise and resend these patches just to the ext4 team.

Thanks,
NeilBrown


>=20
> > +	err =3D __ext4_link(dir, inode, dentry);
> > +	if (err) {
> > +		drop_nlink(inode);
> > +		iput(inode);
> > +	} else {
> > +		d_instantiate(dentry, inode);
> > +	}
> > +	return err;
> >  }
>=20
> 								Honza
> --=20
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
>=20

