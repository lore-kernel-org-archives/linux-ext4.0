Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54840FDA1;
	Thu, 19 Mar 2026 23:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773963072; cv=none; b=q4efkzd6JSJM5nNn/IhUNrL2kWqpIZKG8h6CxX1vknKwPT2HsKN42fpl22+YMfdsYjbhsrb+V8946kJ7OFEoE5ILpGG36iYH8mnypAu4Y+Kd1eGBbmGyUrQZqcdXzSEOjaBsepdx/0fYKVQUPgvEktFtbxxzdBVuisPaqKi2eOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773963072; c=relaxed/simple;
	bh=VDV1t9X0pCHz/FqLpP7oaxOs14JmZqMPXyxxrK41nb8=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=cvvkuVLFfmcK3Uv5Rw+q1IrwO54CvhBzA7Cz47wjpM8U8v0IbLRCQ2AowNM34PiFIQi0d6q9Vx18AcmdZnYW/UfKao6Hq+sBClZDp6ExCQxq1TU3VNNmuyZ0JuIjhVRUHDpPVaWqfISnpk2/dtF4bD9AEH3VpIia6/pH5a6rfWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=VamPNMTM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=2VnWrWVV; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="VamPNMTM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="2VnWrWVV"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6265D1400263;
	Thu, 19 Mar 2026 19:31:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 19 Mar 2026 19:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1773963068; x=1774049468; bh=LHdPdoDlVBet7DwKoIGjDsuMYpD72lArg1Y
	8Hs9OJSU=; b=VamPNMTMQUQhrSbKT0PiUi10pxzRgg3ubPJXGHo9oHbeX+N+BYj
	gD8y/65phPFI5zbP5IOSgSCsyPW0nInXrCop8jLeQFRtWBo6vu8gLoYAq36T7A0/
	V5hFiHoTH6InJ/P4yETnuk7WJMGlzZsAIzV2N5S+0VWQnzO+YntQrbyELVqYPv/1
	s6osG8CiFTz2Lzp2WSBHzsGulOgT3k1GGG44hAqHMghqZFP7d0BctDLXRIZcogAW
	rE7Q5qx+qV1uXn/TD2BxEVeD56TWKIZD/WyrG5T3+sMxggvvrCYcJ6Witeyjjcax
	hMRSQO9oWGTZZLNUUvOV8PM4MQA4ZBQhvsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773963068; x=
	1774049468; bh=LHdPdoDlVBet7DwKoIGjDsuMYpD72lArg1Y8Hs9OJSU=; b=2
	VnWrWVVetcp0xKY+PheuuIH8Lu8mj02PQuMN6meSrQet0pNGqMQw7Gz0AmoDma7D
	Wu3SMmN0EoVZ0Q6M2l67g6UZUP2LiPJHfGOIIh8PPZ/v0TLVOBeIQLc//nVVbJBz
	xAMjpMuUGC5aWhv7xlSD1XTV44FjON7tOiYZxt98DMUwE7u3rkDrHHf3/oOflKal
	srjB1ampfdiwB8Snlq02oTGbUMLtMtbAd/UsJ6gtQ1dUY6qHAnAd1bjXSfPSjiOy
	OGVNK+RfH9TXionsLM7XbNZ+Msw+CqdYqQ2RcNxby0kJHLjgPExYRwuozBC12jpM
	Dsaf023a7xD/P7At0wXlA==
X-ME-Sender: <xms:O4e8aTipvpABKR-OJz1w_z1gMwu65swvcgZx9HPetLrCYvpobdB9Ww>
    <xme:O4e8aRiHdwLJ1TDy67ZA9E9A4quO43FLDq6PFyd7IRd8-EZBychHO4QLdgYM3TDXK
    P7N8LLgTSUNMaF9gvAYNC_lM7-t97SQLtW0QhoyK64pGTaqkA>
X-ME-Received: <xmr:O4e8aTLSef_Fufm8rWIHaVGeCEj1hhUYXXZTrdPNjGUVjaMwfqprhoULQ597KD0O9dWw7qw94kanYfwWk3AxcsUi-IUs-iO2kswPu4Q0XMxl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekfeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpegtgfgghffvvefujghffffkrhesthhqre
    dttddtjeenucfhrhhomheppfgvihhluehrohifnhcuoehnvghilhgssehofihnmhgrihhl
    rdhnvghtqeenucggtffrrghtthgvrhhnpeeljedtfeegueekieetudevheduveefffevud
    etgfetudfhgedvgfdtieeguedujeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggprhgtph
    htthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdhfshgu
    vghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvg
    igthegsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhs
    vgdrtgiipdhrtghpthhtohepthihthhsohesmhhithdrvgguuhdprhgtphhtthhopegrug
    hilhhgvghrrdhkvghrnhgvlhesughilhhgvghrrdgtrg
X-ME-Proxy: <xmx:PIe8aQHFy1-AZm1jRnziaP9ZCLlpNzgJVFRfGEIg0Dxu0-gfYpSgpQ>
    <xmx:PIe8aXQP563yyGiYbxgaNGHBlZxVy3XM4Ul-mlamtuRGgGDwSCQkNg>
    <xmx:PIe8accNpXEacDQ7QHwwhb0OEG44KwyKHMbfinRSVCZnDQdVXgnXiw>
    <xmx:PIe8aWoC3ztaZEt3Z3g9Ov1MVY5cfwL1uE4SxFdL9TE1eqK1vRsFVw>
    <xmx:PIe8adrfr3podYklJL6NOYII0bnx5ZPiJB03KU8MQoTN5Q4T65_SnRP_>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 19:31:05 -0400 (EDT)
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
Cc: "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>, "Jan Kara" <jack@suse.cz>,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] ext4: add ext4_fc_eligible()
In-reply-to: <gh7e7uykczpyhfxrh6y54c2jlcs4pzcud65aqsjoj4am6cajzp@wq26crdxv2yd>
References: <20260317224638.3809014-1-neilb@ownmail.net>,
 <20260317224638.3809014-3-neilb@ownmail.net>,
 <gh7e7uykczpyhfxrh6y54c2jlcs4pzcud65aqsjoj4am6cajzp@wq26crdxv2yd>
Date: Fri, 20 Mar 2026 10:31:01 +1100
Message-id: <177396306176.3934327.9167241352093307006@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Thu, 19 Mar 2026, Jan Kara wrote:
> On Wed 18-03-26 09:39:50, NeilBrown wrote:
> > From: NeilBrown <neil@brown.name>
> >=20
> > Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
> > ext4_fc_disabled().  The code can be simplified by combining these two
> > in a new ext4_fc_eligible().
> >=20
> > In ext4_fc_track_inode() this moves the ext4_fc_disabled() test after
> > ext4_fc_mark_ineligible(), but as that is a non-op when
> > ext4_fc_disabled() is true, this is no no consequence.
> >=20
> > Signed-off-by: NeilBrown <neil@brown.name>
>=20
> One nit below, otherwise feel free to add:
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
>=20
> > @@ -557,16 +548,13 @@ void ext4_fc_track_inode(handle_t *handle, struct i=
node *inode)
> >  	if (S_ISDIR(inode->i_mode))
> >  		return;
> > =20
> > -	if (ext4_fc_disabled(inode->i_sb))
> > -		return;
> > -
> >  	if (ext4_should_journal_data(inode)) {
> >  		ext4_fc_mark_ineligible(inode->i_sb,
> >  					EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
> >  		return;
> >  	}
> > =20
> > -	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
> > +	if (!ext4_fc_eligible(inode->i_sb))
> >  		return;
>=20
> Here I think the !ext4_fc_eligible() check could be actually above the
> ext4_should_journal_data() check - if the fs is not eligible for
> fastcommit, there's no point in marking it ineligible again...

Both you and Andreas have questioned that choice - so I should explain
my reasoning.

ext4_fc_mark_ineligible() is NOT a no-op when the sb is already marked
ineligible.  The code updates sb->s_fc_ineligible_tid to the largest tid
which was ineligible for fc.  Then it only clears the "ineligible" flag
after that highest numbered transaction has committed.  If we skip
ext4_fc_mark_ineligible() because EXT4_MF_FC_INELIGIBLE is already set,
then that flag could be cleared too early.

Thanks,
NeilBrown
