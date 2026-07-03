Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB82D9EDC
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095632; cv=none; b=GhKbx5i6FmESQh76VgCZePZe9A76ARLdnx3Bj/l8b/Zob8ngZz17pwQ2NMtny//bQt/xe9kJHKcOFeYsOotX3pbNsblqkqTIpb/xir7FPNFbkjtmC4gAAfIgCISve25oWk1cRULSCeBbr4/eef/zFlO+Eo4ZRceE53aoZ/YWJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095632; c=relaxed/simple;
	bh=sIKLbGGOwpaMAgJY+13YJB+xbBvJbDLH3pHeLnHQX3Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To:
	 References:In-Reply-To; b=RZlaEk0+Dcmeb4OB/xqYzpzhwCUylTJTSkOTORs7blmKYH1bDR2Lb25/+9CZpJnxvx1Q7lppI6Lp7v0xLxD53dfZ3zvXNDzAekyohgIMqjQ5FqhmO7J+APmqC3UIsa5rYQjzoW/bVUnm39rnV5BI8ktP1LvbEeiWjlDS97bZ3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=oWidXmLO; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="oWidXmLO"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493b68b4643so4103625e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2026 09:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1783095629; x=1783700429; darn=vger.kernel.org;
        h=in-reply-to:references:to:cc:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sIKLbGGOwpaMAgJY+13YJB+xbBvJbDLH3pHeLnHQX3Q=;
        b=oWidXmLOCCGmafw7NC1MQsDbbYO9eJXJtRjT0PK6uDK3G9/JPM46FZf188F9DKhvnG
         H3vmq5+xV7fm2m8xhPRcMkoAv+mSkMdLZIpaZPjOx0BgDRpFH0I8+1iy6WB6zs7U145p
         ZwQETQCeUmL6IdpDQnTWSTI3vGJ3Q+X42zsyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783095629; x=1783700429;
        h=in-reply-to:references:to:cc:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sIKLbGGOwpaMAgJY+13YJB+xbBvJbDLH3pHeLnHQX3Q=;
        b=Bfsrgn1sK/k/SmXJiScl1SFvizNMBGEY+VnGQKjYfWayGxXrP3rfvHmr6wCNDq0ZI0
         8GNtMZI9da9fWDuGp46Oyo0CgKHMNW4LLJ3xiENOZYitIovxM1NhEjkZ0LUWP+gAuRDK
         6fCGrdUA7+0WeQT2MscHTDuGlOzGdXpJqv4ixFd0WuCxS+Rw92V2Jg16dOfbw08bcS/F
         SgmbPtFGD/dAQxgR9jU5uSx+QvR/i0UqBI2oqH476VfaiGTZ4/6OaiHoImSfYV7hvkXB
         BbtgGMNxa5+bZH2BS4V2wc4yke7a8LC/KDzgZXK/qU5znPgHNRWx3bZKgn2sIFxx+o6m
         lvRQ==
X-Gm-Message-State: AOJu0YxvuS+hLn6yLqTDMqWai4LvvEQh1uGIJML2af4epPHVtZBdnm7G
	VDu8ssc2/JVUNLCOLeAg6EZW0KxZAZnJqBTzbRzGRLfbuZjY0G4iiOh1aKxzZMveMvg=
X-Gm-Gg: AfdE7cksjnbH5uQPJdvxoPzYH1hLugpwqEHp7Ox6Sz7Ot+EXgPSRHK8pOD8cGLBXe6y
	Sb36/owqLurAAiePXzMZ0Rw5MGdQp0kzQodT2D0JdNb5EU0ZDSMP33OqTipSkGO/32bpIkCTwNA
	94AnTI+OGJe+bDQO2z5OuzAKT3XeYbxcsou92yU60KrGxCDsO0kJ48/iTsvPDiUxeu2FAztRskj
	ZDTKUiR+1JAINsjoKgBRhf1d27uhXYgkLXJVOvKEWijchoxOtTR1HjXZXbVA8K5ox8pNzf2Fh5s
	tgJ6u4H+jYTsUCHabBhMRWOJc2drlf57p9L3nx8rNw4RaaJjSUGZVYAIRAj1tmsHE5wqjG7KXJ8
	wkiUgnoW8VcsvNt3t51ZDIKG0LpIF6S0xW5WF0GOCCisaPEAopQsoX5xoL6gMDsI3NgZij2eBA4
	gM3jQIO1ohuuvHgTe4RzNVEco15UHQFL2g+Ddx/NQgju/DWqRhwJNE/UnWWR92bSApBM1go/st4
	UNEkg==
X-Received: by 2002:a7b:c357:0:b0:493:a570:df7d with SMTP id 5b1f17b1804b1-493d0f335b3mr4211505e9.20.1783095628723;
        Fri, 03 Jul 2026 09:20:28 -0700 (PDT)
Received: from localhost (2a01cb001331aa0075403fb2c9c4e210.ipv6.abo.wanadoo.fr. [2a01:cb00:1331:aa00:7540:3fb2:c9c4:e210])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493cce0a7cfsm60003245e9.9.2026.07.03.09.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 09:20:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Jul 2026 18:20:27 +0200
Message-Id: <DJP2NAVND6C3.34I2E0R3EDJPD@smile.fr>
Subject: Re: [PATCH 6.6.y] ext4: get rid of ppath in get_ext_path()
From: "Yoann Congal" <yoann.congal@smile.fr>
Cc: <linux-ext4@vger.kernel.org>, "Andreas Dilger"
 <adilger.kernel@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>, "Baokun Li"
 <libaokun1@huawei.com>, "Jan Kara" <jack@suse.cz>, "Ojaswin Mujoo"
 <ojaswin@linux.ibm.com>
To: "Yoann Congal" <yoann.congal@smile.fr>, <stable@vger.kernel.org>
X-Mailer: aerc 0.20.0
References: <20260702154810.3435236-1-yoann.congal@smile.fr>
In-Reply-To: <20260702154810.3435236-1-yoann.congal@smile.fr>

On Thu Jul 2, 2026 at 5:48 PM CEST, Yoann Congal wrote:
> From: Baokun Li <libaokun1@huawei.com>
>
> [ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]
>
> The use of path and ppath is now very confusing, so to make the code more
> readable, pass path between functions uniformly, and get rid of ppath.
>
> After getting rid of ppath in get_ext_path(), its caller may pass an erro=
r
> pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path(=
)
> and ext4_ext_drop_refs() to skip the error pointer. No functional changes=
.
>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Link: https://patch.msgid.link/20240822023545.1994557-13-libaokun@huaweic=
loud.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> ---

Hello,

I missed it at first but a discussion about the same issue is happening
here:
https://lore.kernel.org/all/tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq=
.com/
But the above is a partial backport whereas mine is the full backport.

Regards,
--=20
Yoann Congal
Smile ECS

