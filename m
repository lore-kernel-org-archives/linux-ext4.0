Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533481A5B8A
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 00:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791160443; cv=pass; b=Jb5B/Yqq3P0zZPFOpR4hf363KnS+8jueQwee/LyCoi74FKevuulz6PWutUx4H86dWVy+FpoqrEQqXPYVxquZPFpLPDOOl5uUsv3GDsDPWD7REXzC+yWZyTBNdJ1MAMtAg2kYx6RXQbDFJk+POhvXB26Va4MJJYGTq4R4PksxW5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791160443; c=relaxed/simple;
	bh=b6Hlryzoh1ESsleEAT9aZ4B8GsUpskyJ2Aa00XZi1sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dx0Twv0KElG+zu1tPFIpYGHNCT+hfrP3JFUKxGJV5VcJgTq1hr5ZweG6wyPvp78IbeisJUdQKOo+tr8ibcWDCMkgR1mPcTBFcEXtutstJIVr+MNblEMV2hzNJKf1ZfSNs4sTfwS3+h+fowfqjppMM9zqY7sLNyw/BtgCRGvg2TI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfHBv6za; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfHBv6za"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-88c72646f03so504248b3a.2
        for <linux-ext4@vger.kernel.org>; Sun, 04 Oct 2026 17:34:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791160441; cv=none;
        d=google.com; s=arc-20260327;
        b=I61qWyP28v7rtxXy0oVYtcj+XMoZ9F416LDQFE5N7A0KcYCp71gZbD8N6WFeaUxfC6
         QKKGUZIvC436A5sUpCnkaJcGCFceHH2Fh8uWBtQp1iqBg2oYOx+OL0iaGZtewr2pUKz1
         3fKqCudmfVV6vXiEhQvH7uR9v7NLdq15dtGA8w3FF8lAkefSAz7OhquW6q8Yf22JZOSS
         TvMTPxSiQR4rj2k6DsnGI7cCckzz78Yj6tu2fkySkjzoTS3j3gmslmEKNXQPekzat6II
         hbBmT5PvZgeGPiQG1SYStkq2cQUVvlt/+khUhmtAuYho7FoQdzm39jnxT+NZnMVSZbLm
         bdgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CTIdHKSAaUYymfZczF379ygjOIZA4TO5XNyuFGQQUU8=;
        fh=Ut12p62RWTatW62qHJ7rITmQVW/eovsOy2VOs2uBgxc=;
        b=V0PqmLUe7FB3nfKDFEFWtSi5FVWY+tjbiIfyLiDxQfXuXTpq5qMPPOQ4QGNPptnR+L
         n39VuIWYlYmRjE1AVcH9KzT3Qv1cUmRCkVHTbpNEiqTrut6MiS8q4BMl+ucDUectBimd
         +VTrCUobFNJIdSqMCDoxJ05+rUbk67hrGf1d0d4mfZ88Q0jTsFBLB7hrq0UaMjcyXtTb
         GQ8FjVRAVUni/nW/h7rc1XP5jhBuITsthB1LnANH6rKW7ktbppgUeXIA51HXcOmlkH61
         s6il+uDH0kqpqk3Ro0S4U9m7N5C4RlOMV0Go8uKjge7vJwyL4IlfjV/9REi1C7zZELdd
         MkUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791160441; x=1791765241; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CTIdHKSAaUYymfZczF379ygjOIZA4TO5XNyuFGQQUU8=;
        b=JfHBv6zaiDFo0kkVH59uumwOMx0bvXhsfLIn+ySwlHuKKYfk7nHvCL/LmoTkWL53n6
         KcpoQ9W3cDKLkit/M6I9YsV4oz9cxsi/Tpxx6lmFf+x1qEYAkj1y8W5CkLFp7+Pw5J9v
         sdR4bng3EfStfq3Bs0tDCt00otIsdjveJgzGapd5RkXtGlPW2TF2CzTcJaGbrQRAZP34
         ptF2McotzJrFkCSXeIKr7XvUE1WgmKjcMHG58fMeWSDP5nnsciL5Yeh33+a30QOXLRX8
         9608QqRuf9P3t/RB68gWcf8pImNNtS63mgpbGUPytXB0y15r2YljFjHw0Dhk+987joLN
         y1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791160441; x=1791765241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CTIdHKSAaUYymfZczF379ygjOIZA4TO5XNyuFGQQUU8=;
        b=A7NvDdzoHhe2de/izY+TIEwDHEUUim/H0kjYKHOwJzsg41o9U6PH+Fwtd9sbksv//s
         C/DeOvBvibnJpbo9jER6MG3T4e0VDvU83Xe9LA1eCz90P0neRfMlwC0U63nYkMuHoL2h
         u6cRkpHOnGpYKKikMBZjqumGSrYSQ4bz6JKoZapezzYHBxhY+cs3kusrFbXM5cb5jypU
         EKTT1pq8GihK6ALRaXVOA2sg5/h17MUlNBRF4xUMmSgebCXzF0xLD3sUnaKsvKSgYNV1
         78sz2vL5S0qtQ13cCR72cUj5Y2xb+UOr6qgWu1V7ijtZd5cNnocGQ0lMUsHW2YesviKq
         jwfQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzjAV51WXnmYZpxY+Syhf1HUgCpJ18qmil1PPxoUZIypJwcVbi9Ln1n+ZD5k/n+qVc8DLdNSeAbV3h@vger.kernel.org
X-Gm-Message-State: AFuF++l/0Cf8xV2m4Vjfs+8mjYdlSBzS52dwSUBOpp6ZIBPmmM9Kj1Ja
	r4Ayj9yeuY+J699S/KFK+W82Qz6C0O42xsic1RfKUfH66k4Q1GKg64Q/fIGEBQjHqoBDCqemidC
	/HOTgcjSg+N3FE+TwO+Xca+A7y1K/Brg=
X-Gm-Gg: AYBFou3qcyhI4WA9CScIWSHvL4FPMg5t/05NQY0ty4oI5TCHCw2l9STvI5lDBDTKzIs
	T4/xqXuOoyYWv+qTlnL7gxV9ZVye+0Gag8GhM0p9Q4rn00TgJlKhro+acpgLaxtTF5aQpweyJPE
	mO+oj1RQSKkiISMIkygBWb6pYF0OWDOV8oKS2Lld3PlduycsYezz+Li2X0shg6P8jzD5wLUiWSe
	Mxf3F8QBL+hnwPwSCMsN55JyRxzhS7XPSK2N46bUINBE2Nv1aH2SujCU3fF2IrydN1J1zUOHZdu
	/nlivhfRsAsvRQFM/Q9MYFgcObLHgRSIO6G+vqqd9/Cm6ifJFGRCRchY25hIwxFkA5M=
X-Received: by 2002:a05:6a00:2e86:b0:886:a52a:316f with SMTP id
 d2e1a72fcca58-88c5fedf61fmr5096519b3a.4.1791160441387; Sun, 04 Oct 2026
 17:34:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261002004127.1332310-1-adrianox@gmail.com> <4zi7wmvjhwe7xph3hxawcuhlocifrnv56545tlxbs4u2r7lto3@kbusw76tettq>
In-Reply-To: <4zi7wmvjhwe7xph3hxawcuhlocifrnv56545tlxbs4u2r7lto3@kbusw76tettq>
From: =?UTF-8?Q?Adriano_C=C3=B3rdova?= <adrianox@gmail.com>
Date: Sun, 4 Oct 2026 21:33:49 -0300
X-Gm-Features: AclHuK8Dy8PQBXpjGnQ2jGTWR6DrhNSKI_B_mO2H_so3srBrNO4hCjaSU6skWW4
Message-ID: <CAMGU2hUBKDMVfxfABzn4bu9mKwH=KXZqsN04dvpZgCYjZG6fMg@mail.gmail.com>
Subject: Re: [PATCH] ext4: wipe moved dirents with their real length
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

El vie, 2 oct 2026 a las 9:45, Jan Kara (<jack@suse.cz>) escribi=C3=B3:
>
> On Thu 01-10-26 21:41:27, Adriano Cordova wrote:
> > After copying a dirent to the new block, dx_move_dirents() wipes the
> > source entry using the on-disk rec_len.  Use the length already
> > computed for the copy instead because the on-disk rec_len is untrusted
> > and a corrupt value makes the memset() run out of bounds.
> >
> > Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D09bec78ee77613a3efdd
> > Tested-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
> > Signed-off-by: Adriano Cordova <adrianox@gmail.com>
>
> Not that this would be wrong per se but the explanation doesn't really
> satisfy me :) If the rec_len on disk is wrong, we have a larger problem
> with corrupted source directory and we shouldn't have reached
> dx_move_dirents() in the first place. So how come directory entry
> validation in dx_make_map() didn't catch the corruption? Did syzkaller
> somehow managed to corrupt the directory entry between dx_make_map() and
> dx_move_dirents()? If yes, that is the bug that needs fixing, not trying =
to
> suck up corrupted directory entries in dx_move_dirents()...
>
>                                                                 Honza
>
> > ---
> >  fs/ext4/namei.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index a6386c1d237f..71e9e7c9a7fd 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -1860,10 +1860,8 @@ dx_move_dirents(struct inode *dir, char *from, c=
har *to,
> >
> >               /* wipe dir_entry excluding the rec_len field */
> >               de->inode =3D 0;
> > -             memset(&de->name_len, 0, ext4_rec_len_from_disk(de->rec_l=
en,
> > -                                                             blocksize=
) -
> > -                                      offsetof(struct ext4_dir_entry_2=
,
> > -                                                             name_len)=
);
> > +             memset(&de->name_len, 0, rec_len -
> > +                    offsetof(struct ext4_dir_entry_2, name_len));
> >
> >               map++;
> >               to +=3D rec_len;
> > --
> > 2.51.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

Hi Jan,

Right. The syzbot C repro works by corrupting the block bitmap of the
in-disk filesystem, so it
has nothing to do with dirents. I will send a v2 with a proposed sanity che=
ck.

Adriano
