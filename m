Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC9034B1A7
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 19:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784231983; cv=none; b=h7y7hQaZe0Ix0UaeR3bX+gRktvtakRt2ERZXcs5HpWmC6n88kScQzoOyO/ojDYpKLbHdk3EVWtV8ITR0g3ay69Pa9yU+YAv7qQHXMMRTLMH1Am4j8CMnfP6999cu8nLsOnr3h/Fk7HhAShN8Q8xFsiCcfeOxSn3kVhiQPt1WgDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784231983; c=relaxed/simple;
	bh=e+m1SwYMH/CdvTCpbrEWXnH91RGXc1Ver7a0Glf3zXU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Lx40H/0w3BqCxy+6IA6trt8DryRGXMrjtkpC6Hkzf4Bl3LwsAai8DDeEsJKnU3ggnXEmO6pqrcH/ZTo8djlP9Ex6yBh4/T804xxSbc6DQZwVl44owhblETcn0exogRy0byO7SKCtg8P27U+E5evF2pSHU0ojfj7jN2tOu90Zh4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=AzfgWFiz; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="AzfgWFiz"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso763026a91.1
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 12:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784231980; x=1784836780; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oPU/ClEXdqKFs7z+OnL26xahawNai6l8KBwMmW0aWyc=;
        b=AzfgWFizXAS52hoIHf7i5QQb5+LZp0UiDBQjm/MYFs2wJymzxwFG0Z6MAed9hf3g/5
         dU8QAwphVt2VTJZ00RDE3rn4AED/2lliZD/PsPanVMeyEVHswyrsCyOncWZmlDcG5QFa
         yGNmVlENw1jkgVf7SiajF9NYRDAJlfc+pdKaFCWkoLq//ivt/E/0/Px0Q9qdA90lY7NQ
         m3Thxb8uMFqFs7VBPQnUrVXWjtZdyyO/hhyuL3QqHDNft99CYeSGiRBAxix+XRU5U/1C
         tLPBffVbkIogPqKz85ej/yQnGr+T9QNW+A34LNipECLpfOKlA8SRWsg8whdfU10WIAeY
         GVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784231980; x=1784836780;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oPU/ClEXdqKFs7z+OnL26xahawNai6l8KBwMmW0aWyc=;
        b=b8qwbbycWHL48MtltCt7AV69vr7zsEqevqO28Ol+LPtD9u58B3F3Y9OYXsZWJLnyhI
         d6dDhE/2dUmEWlaABYjqmPhdAxCJs3MrqEmzeAHuFABs3W9Bs3LSX9yFXgEjwsCdYJXR
         Keziaw6FBWSGTs4I9P8LbnE6q4w6F8ZVviPsYEqTLnakLeO/GNawVXkmC8tU5NeUd2ux
         Duqx+v6Uew85QfG5I4OLY6MmKMgRMDg2mO9kMjlHWofZM2SnVZ1/HE9mWAx+dJ6o8TYr
         jJMGOnue23DpsFFY5ZAc2xqTByJJ2lTolO6FbuAdRjs1gSKUDgob1tufmNn3bP4lJ/Mh
         Sbcw==
X-Forwarded-Encrypted: i=1; AHgh+Rq1rXa/2uAdmxitUx2Kw555tPD+8H1luKFSNBBFaX7Sh0jxoJHormTV3ESP4JM2FZhQ4xdEq66ySvK5@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgc9RVNI2ay6YXfqU84Rv+PTU6H3bAJoASREpK9OEwtvpTV8Yq
	t23TYD952pIeKfRNoNyZfiorNtP5dVduNBn3COaBzWJbaqqXEM/Ok/hEBNwPs6atV4naRYEP0Mw
	9xFa3
X-Gm-Gg: AfdE7cmpGZre8RGlCTU0mMO20UEBg31XQMEun3KNyYjD7lU9CjkMMs3HlxKBLuTw038
	wMou7/NFRo+N6DkHVQLJGteEK8TQ59xlnAnYMeHvycT5Gz/4b+UUd9ij47K5vhvLv5br17C8UlF
	gyZ+jASb37AQ2uEGaPEjHtPbFsBu3vHeMLFObFBgDNf76eErVDViTUS/QZKTT0/kIqGZsXQJZPz
	REau6e8dNvVUM8E/B0y+HP/2v2gxMdLO36I7HctA/Ac71Wcr+xfMVg2Dj8aF4t2tb6qnI3a7VLK
	i0F+2HDboljqBUwnAXnsB1c03Q16C9bb5PlPz6SQxUlzP41S9+JvBMx7W7dySp5extERa0eTXyW
	v5TfQBTGc+CPw5neHXm2/+GbiiY/9itUboPUHrA3f2Hq8D56krBA8r5ZhnGO//jUBwTDYdaie8f
	rTmeus0wyo/rTlygGr00OkcgVOEa3MogQ=
X-Received: by 2002:a17:90b:39af:b0:37f:9e21:91d6 with SMTP id 98e67ed59e1d1-38e3d1d1815mr3010571a91.13.1784231980511;
        Thu, 16 Jul 2026 12:59:40 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:3854:7eec:417a:89dd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e3cf246c0sm1579706a91.3.2026.07.16.12.59.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 12:59:40 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] ext4: skip i_extra_isize expansion during inode eviction
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260715175253.2171303-1-koike@igalia.com>
Date: Thu, 16 Jul 2026 13:59:28 -0600
Cc: tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <BDA9BA20-2727-4FCF-99E3-AAB52431CDBE@dilger.ca>
References: <20260715175253.2171303-1-koike@igalia.com>
To: Helen Koike <koike@igalia.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 15, 2026, at 11:52, Helen Koike <koike@igalia.com> wrote:
>=20
> __ext4_mark_inode_dirty may be called from the eviction/free path (via
> ext4_truncate =E2=86=92 ext4_ext_truncate =E2=86=92 mark_inode_dirty), =
which may call
> ext4_try_to_expand_extra_isize() that could create a new EA inode,
> wasting work that will be immediately discarded.
>=20
> Skip the expansion when the inode is transitioning to freed.
>=20
> Signed-off-by: Helen Koike <koike@igalia.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
>=20
> Hello,
>=20
> I saw this while investigating the syzbot issue (see the stack trace =
of
> unlink "-> #0"):
>   https://syzkaller.appspot.com/bug?extid=3Dd91a6e2efb07bd3354e9
>=20
> While the reported issue is fixed by:
>  7f473f971382 ("ext4: lockdep: handle i_data_sem subclassing for =
special inodes")
> I believe the call to ext4_try_to_expand_extra_isize() in the eviction
> path doesn't make sense in the first place.
>=20
> I understand this is not a major optimization, so not a high priority,
> but sending it anyway in case anyone finds it useful.
> ---
> fs/ext4/inode.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..cea3405cd841 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6603,7 +6603,8 @@ int __ext4_mark_inode_dirty(handle_t *handle, =
struct inode *inode,
> if (err)
> goto out;
>=20
> -	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize)
> +	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize &&
> +	     !(inode_state_read_once(inode) & (I_FREEING | =
I_WILL_FREE)))
>  		ext4_try_to_expand_extra_isize(inode, =
sbi->s_want_extra_isize,
>  					       iloc, handle);
>=20
> --=20
> 2.54.0
>=20


Cheers, Andreas





