Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794815167;
	b=wZaboTj0H6/FnHN/eZX9hPMlrYQZAmR+GQKOJ0ii0MoWsooSrWmGX0TguKKRiWQuVu1M
	 wCfn/klsRPscPVuWuIVe/oxol8qcJF6diZIyO6YcD1MReduswrSEZ2rUqoIXrgKoFL4Jl
	 8zdKCCb3y6drGdZicGtsgSvnEzdfRBDtGJY3+9+sLboq2D/TkPc8GXcRharNWUB+Gk9OL
	 zUTjm7fEs20u91frkQ5ts/jqp5QK3jPf+Zt7pk/ytmsiiCJeraQJynStDlLqXkegRw0ZI
	 pEaX7x0GUDnO0U8DuZeLAAb9h5ew5o+abMtEyuuoqmI4Ve/q+aFe03VOTa11R+Vg0vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794815167;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FSln3GJdyilcSJoNNwMauSr6iNLe8w//JR+9QfO7bhg=;
	b=qnol5aH78lU/WNdG7ilMIM9x54SoaQMsdfgDte0aEiuBXeJOav7wn9KEQQyQ9sHTv6Ba
	 t9DGQadBGjPaFJfjv1QQp92GvYOdMis6jq2B22GNDE7Un8H3e7s75ym4om0y0Fy+L88Ml
	 aNfXj1rcs0EfhOy900hKCA2V4uNt5n2PIvY6eJnrxHA5UaAKwXbefnxEjePIE44wJgBvN
	 tvzyvWfXHZVYCznUa5tIfd6XaZnNjTI71wUNvYnp3rdfZuIpXkpEhfOALe3MqI1Jm3UKv
	 fSwGC7POKC9wmEv5CoQpN1F9R0xBn6xj/cyD5n91SXjo+n5RIKN0KUgBPYmhTJvNFyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O9ebPlG0;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62846606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 07:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62846606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=O9ebPlG0
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso17970975ad.0
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 23:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794815167; x=1795419967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FSln3GJdyilcSJoNNwMauSr6iNLe8w//JR+9QfO7bhg=;
        b=O9ebPlG0Ls7i+E5Gm6i+9CQPALSK0CP62IX+8iRnrZXehTO3K1ciRUFmv/l56ogw5x
         G8/dr58UAY/4mlTAhUO9Mlrzluf3bWofaL41Y/Kz0LLkkLCbPWoNB3IklpJKNUd+5oUV
         r/fKLW+MQyX8BvynueVDi9b80lfHKHlz27s8otIDRwl4b1Xu8mc86irlndZ5oj/VVXfd
         00QVC4MucxHF/JRgU6wxNH9nb75udF6rhWDtPPVpCjixLkEuqvM4I0xGG4Gi6+GNVcay
         8L/wsIhT8okv/gmnAn5qCBoymH5SUs37mvbLaQDLCO6cI6wtyD6ZlqXPtX+H1ZQxZ7yl
         30eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794815167; x=1795419967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FSln3GJdyilcSJoNNwMauSr6iNLe8w//JR+9QfO7bhg=;
        b=x0yl4Yk/DJgtpQW9K8LKpYIShY8+FBR2bdb2Txsii9FOVJjzx0Pl1TgKWiY6OKc9Jc
         210yB0eRmEvsQkASHQiyYmGfRU4PPsBiGuHPDXWLMdiHDZk4eBt32CsF/mWmWGhjTje9
         YSQHSpofBWQaLB3Pblfr1yxHtj2PsgbLfXf0fc28TYI3HGSQiibrP6AQTHsh2+A/GMWB
         soWfd5sgNEGnXqwH487b3LjSTxaRRTPIT1vbbgWyMQPo7oAZafb3W+ZerC9kL1SJGESZ
         tbEYnQII3hicaoSU887CLP8yqJXVKnH+NSltieFJd5dF78alRER6FVJm96hMMfDzg49P
         fMig==
X-Forwarded-Encrypted: i=1; AL+hErEb31ptWfdtioNoR3yS0VHaxbiL0phRZBGgv/PyqS32OWdnmwQhK3ngDxOKFYZzEwlk+86xZXl8QMv9@vger.kernel.org
X-Gm-Message-State: APuU4Z/gonqlbewSSmajv60bUN/PiWN3cgzNtrJejARI+twkiau0KHgc
	Ti79NIixbAQRfH0BTv9vTja62IBWkq5y2fKi7H+VUhcNMnNceOI1AyYN
X-Gm-Gg: AYBFou2rTd0uftModXq9lTgINJ/W05fZsH/NylPMf+pzQinEX6j/stT+5PjkFoKByLJ
	SE3PF0tXLk2RwUQSGZQVc+wNHkVT6MRY4oC/L1FDdocqEeDuihx+zJyPdXHncD1IRadwF3iGimY
	J4p/7O43aRhuxFN1H3A7UyOA3lqLTZ+Ap06B66SgZqdxxO8A34ox/FZ9xgga03e6ToSW8ZocEtb
	HjM+KCtno307g2iK4GubK9McgzrTD7Tt1/3bJjc0lFlZOf1TQo8epyNfrBOsICl4z121ggiJgZF
	KSCOU0oJYeHYgE1U8Vev0/Do5jhFWmwZNK42hzYEnwk54BkZUG/yLtpX7Y5KQ559swp36vEkblC
	Pue9V9rpjKEIcZcag49ANANjf1EuZi08tm0B2EKK5+QZnx6bvw/r2M7JovXIsok20ls9MmwDJ+F
	W5IKcrE/8J6ePcDYMwtRcPbP4n+JmxbBRPP/rzrfM4pvqZ9ug5QluNhbj5PXi9MvpR1gdV9yEC5
	T0bYxccCwufCOxKWPkKCkzsnFVCa3UB2DjjavkSgmmv13uwgH3ljBkQke2rgGtEpPHl4r4cIl7b
	pNIZ0BMn4mbxJKZJcMDPB9iqLS/5H57jkXpjoQ5wlTc5EtaVjhw+N3cp
X-Received: by 2002:a17:903:22d2:b0:2ed:1df2:8b36 with SMTP id d9443c01a7336-2ee0dbe68ecmr99007235ad.33.1794815166560;
        Sun, 15 Nov 2026 23:46:06 -0800 (PST)
Received: from csl-conti-dell7859.ntu.edu.sg ([155.69.199.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f868231sm32620695ad.50.2026.11.15.23.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 23:46:06 -0800 (PST)
From: Kaixuan Li <kaixuanli0131@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: stop verify_reserved_gdb() one entry short of the block
Date: Mon, 16 Nov 2026 15:45:44 +0800
Message-Id: <20261116074544.2497315-1-kaixuanli0131@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <mlx7il3nok35qeppdkafrqgztvazj3fc44xrp2umziye5ox24m@xwg43blfi3jn>
References: <20260919113940.1823559-1-kaixuanli0131@gmail.com> <mlx7il3nok35qeppdkafrqgztvazj3fc44xrp2umziye5ox24m@xwg43blfi3jn>
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

Gentle ping on this one. Jan reviewed it on Oct 21:

Reviewed-by: Jan Kara <jack@suse.cz>

It still applies cleanly to v7.4-rc3. Would you take it through the
ext4 tree, or should I resend it with the tag folded in?

Thanks,
Kaixuan
