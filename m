Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792478024;
	b=U+ygiW7uavWlWrkT30CZDZkqAOKlTlnV5y8Mn2bQwkX4bms6AxqOt/+Z/rkzSMUHhnpq
	 bXKknbPXCsyzM/iEZxjJv9g5tXENgqP9p2dpz8kr5etnGy1bSbCER+AM3m2jKzl8fHz6P
	 XqkIDTxqdAzzpqdr9uoSPy874t5sTbqxE0kKk3U9TX8nyxO0PUHZAfz3GpWSbN9iy+yF6
	 i7ynQnryKxOAb8OAaBGJ0TfWFgo8bTLeEo3hHuBf7GuXhI9/mOsGTbGrh1wGpRGw/4Xkd
	 XQsjcY23qFi+JpNRM8BgSZOBR1+jk2/4cuj92UA4CRMOoYh9vEcUJUKZdp+qt2SvcGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792478024;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
	b=pSY93Spnaoi4mJ1zVSJ8Oxhe5jXxyMCFjvHL9Hq9T7xEMBTY23KMJ1ZbupFUdfYs1FP6
	 7YLxmNwKu4oakyElVlw3dRrSMMnneL1rSLotpOYdyz6DFVdPey4gQInmiCPUiozKjZ4ED
	 c5oXmfQ3dPKevfHq51/lBRj6vuFtWBPqxryZVG0jp+PwF6pRK7f8pAnZ6NnGxS7Flzoqo
	 8BDOEakvB7gwkjyH2kx41YF+s2Z/RsKd+z4XVEwwXqhNTj07iR6fq8Ev4HwboqOYUz9ca
	 QDNxxVOhueD51kX2U83sTd2iPCOF9Xbae5u2dkpgFlG8SdOT0ZEOD6+zOK4v7jIFOtg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=owltronix.com;
	spf=none smtp.mailfrom=owltronix.com;
	dkim=pass header.d=owltronix-com.20251104.gappssmtp.com header.i=@owltronix-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aXnphUCd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5BC606A323
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 06:33:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F5BC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=owltronix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=owltronix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=owltronix-com.20251104.gappssmtp.com header.i=@owltronix-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=aXnphUCd
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1e266fca2so13387765e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 23:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792478023; cv=none;
        d=google.com; s=arc-20260327;
        b=Akil4uMGnjpxGt/TvkOFzPwfsYaK0S2SlqR8y0R6tF8Rbqw3xzIMVGprzKySI9IVGH
         MkzvbQ+hu2KCuqr74r46YcVbGWuwHi2dFElS9sjgtqYyx1p2QJLwafL1Bw7Knp0JQ46L
         GSduyiBw7g8wuw+k8KYwICRGWP5+D8qXKJwHxWZFTRuYAQQ3PZ3HY+Zqn8Eu8GRrQBy0
         WHkTHyVREyQuHHV5ruqR0/+cfdwYbe1z/W5BkoroiApKN5x+hw5TV4KFhavIsS3fx+Iw
         yE3G1gaPsJjx8Qj9eo5vgMthiTGf6xCMqke2pvleRsXwUxMr8O8u2SCi98gDkG0mZ/xJ
         mD/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
        fh=D4P67bUUnPaZScIa4TDPfyxQztxIhxb6ZLqPdAmkkaE=;
        b=SBO4HFyFVuR1ydST17kBMtJySoaAtU2ROH6gd902Eu95p4Jc1LNmTSIZFyD6sZfkJg
         SMSDYSLFGD9MX7x0/vtsLU4FPwe9ANhvdKQZfSaPlzQLYmzzFKVqrHVAioSbqBYm6+1t
         mFsicvhipW+PHZIJl975scQbgTdRKX0JA+uPr1xS123yjc4Js0ApF7CJC5OhzdfmIKzw
         eqzmOBlM31eWA32wLy+W3fmbEfMv5yPXZsWPrFPwwtqH34XS9uOxXO70VwU8T7A8Jtwr
         iDQqTmTnXLAU8LNLFDk2nGrus6XvVcOIEPCKOjSL1X84p+j6YarLENJr7YYvIsHTGUAv
         yT7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=owltronix-com.20251104.gappssmtp.com; s=20251104; t=1792478023; x=1793082823; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
        b=aXnphUCd1OxmReadwWegZwBmMEXcQoL5UXzvHpS6C5j3EWlIRvjPWPNunlqO+IWQel
         TLjejB3aKqyeGJcs2XDFWRVHO0NShXeY4QCocXkRzsjqySq9g68Hcn5EFspP6iqw2DxJ
         pun+vmmO6V3eUuwc18zX56uanSkO/w++vt6zjQJScnjIj1LPa6sYimGT5H0t5kOz3str
         ByLPtoXIji412AHh53PuTjgh6Lf+BweNFvTBBdK/wZgci189jV6FJigATHzDga3AJlxM
         hW8D7sRhOEhR7g+d2s+j7Xh7APye/CBgRphiwifOaZypID1F/l077nZMfaosuEAy4f1u
         m+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792478023; x=1793082823;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=exeTp1cAoNgGNBzHpnK0Fe4gV+c26CWlkIC+95vHT8w=;
        b=rmBaoSuUPWPimDsD9t6Gpz2CQM8UGm3jh46rPoE+Ek/3rBEvVG48O4B095/xXpjWku
         mcrTWXq3oxQWnJipnykp2IaVOUGpYL//LqclXfHUQqNXCjiecXPndHm7fs3EcGvX3ale
         5bJkhHCxh3WY/C7acnaxpBLyd8va1vzIZ2wpIYcKfZZUthV6XnS765wHMr1DLsrWq9x6
         cVdgAmEgtecVINHmb7yLz+/lgKXo4lcbYFEx8DH1h2rOoyrAv451FhYvWYnh7dlDI72X
         TWkCgdtEsJVrHX5lVqbUm1GoBOsIpnTp76/YHckpsCf478XxAVFl4+I7d5a83v3u2eOL
         cEfg==
X-Forwarded-Encrypted: i=1; AKwUvBybw3yit8lPNiH9+dnjoK0DXz/QtT85AKr8rvM8lOKEENuTuC86yIfL2yClINPr3X68FFyCmccZV1NV@vger.kernel.org
X-Gm-Message-State: AFq9FYL0RJvROuooXtVs9CKAYjHCCtm+FmOWnYoSuKNf6MV2dqV2Hs/a
	3o40BoIUx5KdeL6RpYzaX8gtkSE5b/rkM2aitLHzn91u7BIz0uVPpP01FZZNvbR29RwFaCzPrlu
	qQFZACmILjGQnZ7mshaKo03VyKUAASUgBqlNOkFLgTw==
X-Gm-Gg: AYBFou31HrqT1RzbNIX6nmX6JLxQXkrQ7rp5vn6AJHj1Xw0NjI1OJ/cyuCaOvkAzasG
	YSRDlPms+pyKU5p9YxXAAswBh4Vhxcp9E6f6QX62n8NiMS2lQaG1su7o+RGD7pHZNZUlGcHhiaA
	MQiiAO0bwdrYFEyZZXuPbvgxQzz9E5DGP6yb7V2o3YfURVkBKhaUXAXEilBpJRMs7MAbBImpeQQ
	0opYTUc9xtn8o/v3d2WPiErOIjJh6COkUGpzmgSgnngeYRRtMWMvZik2j0itlMu867Q20gapd2V
	KOdFcY6UTqt0uJI0aX+78UIDeW9R0B806pOeY0wK3ft2hOjCTNX5gX7Y
X-Received: by 2002:a05:600c:b99:b0:4a1:d36f:1ba0 with SMTP id
 5b1f17b1804b1-4a1d76227b4mr199950255e9.35.1792478022502; Mon, 19 Oct 2026
 23:33:42 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016160037.GA107919@frogsfrogsfrogs>
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
From: Hans Holmberg <hans@owltronix.com>
Date: Tue, 20 Oct 2026 08:33:30 +0200
X-Gm-Features: AclHuK_ADi3z0cS39x96qE3d4XzZpXIuupVRKpApcCWwiB08hyMIjCfxAVkNnMI
Message-ID: <CANr-nt1btFt4FqSgrsjMW5tRihyKcUKG-irW9su5AM943+1vzA@mail.gmail.com>
Subject: Re: Farewell!
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for everything, Darrick!

It's been a pleasure. Hope to have you back one day!

Cheers,
Hans

On Fri, Oct 16, 2026 at 6:07=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> Hi everyone,
>
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.
>
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
>
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!
>
> --Darrick
>
