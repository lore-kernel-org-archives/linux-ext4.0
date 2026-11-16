Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794815214;
	b=N4whJ/k0vc177NnBGALywPKY+g3v/19TLUpx23pHsm9L3ZQn0O5RXi1g58uB4i/uFXsH
	 RSmRFXhTAZ4jGT4EGJTnpktcv5TXBqDS+AAliPq83C2WzWsfYGp+MSoVacAUwQIBXTGRv
	 e9a78WvCmRtzQ7Yriht7JO+ANdwn1mLI7eBodOKXESAbf1D7/CXAykUPgCCizSJ/3yJQH
	 y7BrNLRvWELanSKj1Avd49FxNIzsw3SGNBNUvd+OLrLnMBl6wjRELO8/4broqyBBOulY8
	 XIWVEqzeTOBMWdcbVlXwSWfz+VpyT/WTOM+Q+7OZ/QN4gWhpnSqW6XIZXKHJxz6t8ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794815214;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vlmmf3Yw+/83b82AdIUcfUJeqmaW+6kFUL2ngX8JzfM=;
	b=UnOnnTe/vKo6BXvQERVW2ZZ13Z57IIh69+1XmAwMHwZyJTQo3qddww8rB2RQvtj4Kkeh
	 QHIMCVxA4Km3nCXpMttH66KSuZU69xg+9JiZL9LbwBSw4NckQyXPJBuCdvzfKM90KRHLj
	 OkmVvR0N2ZN83feuU7D2HNCB/KH8hEhbSo7uyJRexY/+ctbeVl+zGQ7zFk2vt3LPdTCwL
	 eE8P3V/sVMgDmMu0Docc/SM7Df3wq73A3ruQEExdf14DwzExAYwS1DXuSgJ/HxQ1HZyTP
	 4E5R57QMcC11NzGAk7DM+7vNfcQNSAj+IEW499IwBUHYerfFSux8GCWFocIWbW7pSXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bHYZUuPN;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346BE606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 07:46:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 346BE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bHYZUuPN
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ed408b0d9dso10730995ad.2
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 23:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794815213; x=1795420013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vlmmf3Yw+/83b82AdIUcfUJeqmaW+6kFUL2ngX8JzfM=;
        b=bHYZUuPN9xML3Yrn+cCasQ29AbiNF4JPUbEf+WiN9vI9QhAUir1nYMBF44t8yngNJX
         FCyfosmDGvuolOH7vpwB02QbVRIDtV8eXdj4sQb9zBxzLFrglwpbsjpUBFOUfujIInYC
         2xiEwEWtjRwHyNkqzu2bsC0rVKyrQjGGvRBElOFJP4AGuXrvASxD3+4UB2q8zKw/aFWi
         xlNqwCCKZOmQ7ZuOeljW8RZt0eObB0UnJIgk39heff/DzgMm4D5iLjuZ5wrdO/krjykN
         ru/ADmOFKKC0oshz9HsbPDQj33Pub0FnNVdtQJ3S8hcBj1u9lGzEoX6L4YpPG9xTOIkF
         yP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794815213; x=1795420013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vlmmf3Yw+/83b82AdIUcfUJeqmaW+6kFUL2ngX8JzfM=;
        b=j7SmArtn3y6A6mmhRd+IFlxc4ycTQhvptk2boSk4ehoWvGZ2MXl3zMIYIr6ETjcNIm
         TZhY2owvYLn+RyaZnPzwPl3tMNJ0hIL1ixn9XLK9b28Cs4BZ/P7F3ZXNJ5rLJytSJjf/
         6pR+gU90UU5Hunbg46hzDd7y94mxLcX2Y1rjneLuYNbzJR9eqpn2QsoP50kSgu9Yzf80
         uMndtNGeLv+P2Ucni4PknAjaZoWrF7JB6SsGM56qcho+MbB2nBmE9jJ2F02u3OT//3k4
         GzBvGhgk29KYdsUWsc5vPiYhJX2g6jQO6tziMDh2lMXvM2GqRXt6dJlYx/rzWjYKzodF
         LQuA==
X-Forwarded-Encrypted: i=1; AL+hErHICXhqWcCedvG6nRpckN4EyAvtwvE9QcZ85f0ank2/1fOivCcqChD6iRGgwljOKmJQemgL44sqHdDV@vger.kernel.org
X-Gm-Message-State: APuU4Z8lX/aru4ENF8RxrliOBQvgBGpIpAgltGgteZJhWhk6UA6Nuc53
	UnxPYVO2C+a4/r8ibmfe5hNfmXMv+C0NaR0D/xEV+GspGHhXBDt5d7z8Rqy2fUaA
X-Gm-Gg: AZFdTZfjuNiQhFrEgknUp1tipMUfpeBfrBbX3pbG2K78if/hPK7ZteQt+eDbKaXpQZn
	zYfpbg3sF5vwMcWmNm2eRbbMJmVSX6BlcZrA5fmJDMBTDNYDI9VR6BdaJrZVm5BZ5Ip22Ou2++j
	OoVtDkVwPHsBAh6LLIYZEM726DEtXdsBTdZ1Lh3/WDGgqqofDyudsk5Vw/poY3gOUAhnfA1MNJs
	jAONNproGpz8E0JugegycHNUzDYnQiphks6bE5bZcJXNtPoOwq+hmOQl8dLtVO8AvR/3WGRSEZ/
	IHN9L/nPCsq5ceWz5/uV7MiEGLHtS+f//kUYtNQhhmXkA1b/nIKlnl5pawnmYcExHWkhbxXAA9n
	Kzi4kZlhuY+CG+iEEh797BcaDbp3cESpZc0+xhqVh/Efc0LRGQ/JaZZDKeujfQwX+qZuic7Lxkf
	lBaUdyUMD6VCqok5BEKJExhHCGgxnfQyQ5o9C9f6+RXpeEOK9TN124YUrEPQHCN5VUG7z9e18uM
	5Z1I3cyupEWTRiJS8xtkmtdIIzO3vpIbquChTMwyURBLwUG6oZiLkkHQRv70hsyzWJjweHoWbqD
	L+m7evhAiC8cRno7pHpXagiLc8kfTr58bL8Zrvi5wusE1qn3wGWbLpVycONH8Nygaf8RKsMplZn
	6
X-Received: by 2002:a17:903:11c3:b0:2e5:54b9:6b37 with SMTP id d9443c01a7336-2ee0de56f82mr93360645ad.28.1794815213447;
        Sun, 15 Nov 2026 23:46:53 -0800 (PST)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f75c98dsm34379565ad.17.2026.11.15.23.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 23:46:53 -0800 (PST)
From: Kaixuan Li <kaixuanli0131@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: don't read past the UAPI struct in GROUP_ADD
Date: Mon, 16 Nov 2026 15:46:41 +0800
Message-Id: <20261116074641.2498433-1-kaixuanli0131@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ys252ecwpg5kqvwjpfehelyatwapddajbtnjsjllttwm32dhgz@frw2pzzlvvoy>
References: <20261019131655.2583227-1-kaixuanli0131@gmail.com> <ys252ecwpg5kqvwjpfehelyatwapddajbtnjsjllttwm32dhgz@frw2pzzlvvoy>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ted,

Gentle ping on v3. Jan reviewed it on Oct 19:

Reviewed-by: Jan Kara <jack@suse.cz>

It still applies cleanly to v7.4-rc3. Would you take it through the
ext4 tree, or should I resend it with the tag folded in?

Thanks,
Kaixuan
