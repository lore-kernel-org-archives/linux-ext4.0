Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD4D2046BA
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784233669; cv=none; b=toXJhFEjaNgznIKkA+j04/XcmEdXrYSMIMnMtCPqf9HeEcucU5QZ/egfeeiz9l3PAqlJ08hKZxP1naR86P6HARLf+NFQn6taDsXGhPklb4vxmO5rmSQoHxUFIdn4TaUNxR0jTt78ijH0QY8Djt7HCY/ETfUzIrh8v4JWhpPtmVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784233669; c=relaxed/simple;
	bh=p+tMBYJIkcf+Y4nh5yJIh7bdfo0w1ggne3Xp89EKcxI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LF0eOOrP9x8u+nkUYAfuHTR8PK5pStWehlrNfDM4voBC9uPwuTLcK6Q2IBslLMgkpWBCPQKQ2tf7rjSYhgCZCyKZ5q1X2PRxSbBd/L2D8yA8Yq6RQdOj5So4bCf/yBArpL8lCOIeCOsjYxlzvS+Moh4itCbDkBYJxbVnxTM8Cp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=ICXmK7dS; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="ICXmK7dS"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso5537627a91.1
        for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 13:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1784233667; x=1784838467; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LexGCswJYo6ueI74fGox985JwhyQ2CL66NDNwc2GrNE=;
        b=ICXmK7dSUZiRLHqspdyLojIaSEJbsmsZnd87qXo9Kvw0FeUFIuk8yp/Pu80cz6xoSk
         /bqn5R6wT8LmOFt7+0kjhfnrrzXSD3SR+tp0ooNUlSMNdIq2997krVjuiQQF6S+lUVye
         Onzmn42onJjOLG5r2g+Tz5odtgRJVDbTqldhrn/XjgVTKRCI9/10o6p0aHjnCkKFh8vn
         mKpw1LkPEHS1VVKU4skFYEyucS5N7O72YETIOwN1AMcoc52dN1yhzg2tmuLbSYRcwKUU
         vhbHQTwg0i2q+85/7nfW4stQWdj8HzAHVYQpLf6ANS4/+Hb40DWss47peM60Wna9fJJT
         TXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784233667; x=1784838467;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LexGCswJYo6ueI74fGox985JwhyQ2CL66NDNwc2GrNE=;
        b=X2kUc2t/eDiDCfpoF/YrazehgFyyf0XNEhMjW8haxX32WOFjcswnUQ6tohiCyd2vB3
         UyORAZmqDQlEtKZ97kFDPswnPYokjXPTMFcrPK0Bi9vrmoMFfAv/Uz8w10H31WruAbee
         gDUQ+N01t+wtwzpQa/i93ahpxbqZgAMUwngK5AAk/NDgsDm2D3YpAXVUCBdcxc2o5zsq
         nTURZzz78X1Zw7EXT2lf3w94JHU+YNe6N85wg5FcqSN5zom1hwSl5cVPCBQyhySnm04m
         aSJ8btx/D8+rE+Uf1c406K63XW4TlMRty1m4KDKWtAdC5lpeld7KDxBdMcof8gXTztAw
         dgHA==
X-Gm-Message-State: AOJu0Yw1BWPZOv+zhei/PbpQgR/hR+wERToi6MnzCo69BRIgyQLUBtNX
	gfJe5Cp3tFP6KMuTbNNhaOCYOlIKjQFFDeIYaobzHOTfXIKQoVRAnW4zb3tSiKDcd9pL4vOVvTF
	yrHdc
X-Gm-Gg: AfdE7cn/tLwB6iL6WpCYinwPvlXxPS1d+2J1BK4SgY+VkIHAWdnZ1Sk4S17G8oLlCJB
	kHjq5gQxgtv5aYXaYYnDZf9dt0gKY9tsokDZ5+PmGBDXpvA2PrYGte32JT3ogtM9fxoAizBWYqn
	YFc0OCIiG/Cak5NXg5wN0vQExEOyOcWSbRNUoKEsYvx5QuTm3nmnLwIblPtWOIDpDcEF0gSAu1r
	JyJgReyMo3+LKn1yWfJcrE13xxqDGKKoMtWuV5qk7wKESvEOFsIKw1qSt/Wmn2y8s6x1LkE7GAE
	FDAcTtQ1MjudAsYsWN1dEbLzW72m9UFQRP7F6dVr0/5XZUl1GVHH129cNxqWFwm8WIlRrPNN0uD
	ol0SXDmRPFGXK/2b3+DTGcMMgLIBJ/PefEEcHtxF0ZbaY51FbqGxRlOieTByQVophNx43S2NPgi
	n4Y4qOAeXe552DWaE6RK6QKAuOxupHLjU=
X-Received: by 2002:a17:90b:1646:b0:381:bc4c:da5b with SMTP id 98e67ed59e1d1-38e1ae5c1cemr11139936a91.18.1784233667332;
        Thu, 16 Jul 2026 13:27:47 -0700 (PDT)
Received: from smtpclient.apple ([2604:3d09:3a84:1700:3854:7eec:417a:89dd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e39e0e53fsm1838063a91.6.2026.07.16.13.27.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 13:27:46 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v5 01/11] ext4: validate count against limit in
 ext4_dx_csum_verify/_set
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260714125111.14699-2-ablagodarenko@thelustrecollective.com>
Date: Thu, 16 Jul 2026 14:27:35 -0600
Cc: linux-ext4@vger.kernel.org,
 Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
 xiaowu.417@qq.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A014BAF0-0EAF-4F61-B1A8-E73065715527@dilger.ca>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
 <20260714125111.14699-2-ablagodarenko@thelustrecollective.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 14, 2026, at 06:50, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> dx_countlimit's count field was read from disk and used directly to
> compute the checksummed range (count_offset + count * =
sizeof(dx_entry))
> without ever being checked against limit -- only limit itself was
> bounds-checked against the block size. A corrupted or maliciously
> crafted filesystem image that sets count to a large value (e.g. 65535)
> makes ext4_chksum() read far past the end of the directory block
> buffer, hitting adjacent slab objects.
>=20
> Reported-by: xiaowu.417@qq.com
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/namei.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index cc49ae04a6f6..a283e285937a 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -477,6 +477,10 @@ static int ext4_dx_csum_verify(struct inode =
*inode,
>  		warn_no_space_for_csum(inode);
>  		return 0;
>  	}
> +	if (count > limit) {
> +		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck =
-D.");
> +		return 0;
> +	}
>  	t =3D (struct dx_tail *)(((struct dx_entry *)c) + limit);
> =20
>  	if (t->dt_checksum !=3D ext4_dx_csum(inode, dirent, =
count_offset,
> @@ -506,6 +510,10 @@ static void ext4_dx_csum_set(struct inode *inode, =
struct ext4_dir_entry
>  		warn_no_space_for_csum(inode);
>  		return;
>  	}
> +	if (count > limit) {
> +		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck =
-D.");
> +		return;
> +	}
>  	t =3D (struct dx_tail *)(((struct dx_entry *)c) + limit);
> =20
>  	t->dt_checksum =3D ext4_dx_csum(inode, dirent, count_offset, =
count, t);
> --=20
> 2.43.7
>=20


Cheers, Andreas





