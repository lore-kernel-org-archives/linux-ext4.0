Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980737;
	b=OQzdJHt+bxf6uQNIBLF0fNUAs9e/YzvFlAzZxJpfTuujSECFmxS1LK4/XbwWwXxFj5xV
	 5ZNSw8whAO+urbt59NNSWfiYB6oLsroMZ0Ntgzk8l8PMluPyiRXMF1R0lrZoit9Su8L3/
	 +xUi+rqcoKon0AIfQgJPqBH1n3JIjV82mPtkg+HUzwFllV3LyXqIo7VljKnqx76mXnl1K
	 8fAgfeawG9JFE8QS0XGDecMi3Wv4rdLddDRUZACBl8dhGH6jR9Y37lRhzlNvRNspJ4CSD
	 7kfSpY0Fre+igujohJhW9u9ml0EInb6kNj7ZZiTf6cYWygblufPdZX6+pt4pxSxo8pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980737;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=GPu9YN25dDm57paUC3yXoaI+yd25NXWYw23eCkA96p8=;
	b=aRaAa/hXPwfpV80R8oJhHQb2g9N3/rNFfFe/Ly0pGTxJanYY1lJxOt0MEcgX51l1ZOcS
	 ljoXzexuCYnFl5FuxZpl7SKD3tgXgm2IaG5OcXoOvgGiXG2Xnqn4ntVqRnmQ6rYgxnQdN
	 MRprkLtDRT2jnxrr8qpN3tLA7eKpC9YN2clZMPfB725Gsh0eDtVJnPQLDv5TkCqigeO2Z
	 mqaBHHmB3ruAkcm+RN2dNb8z66ZFcv40FVdI7MiJNUvMmPau10ZupT9moQme7L8sSwZ5A
	 hURhlbhRnXYgGl1rvaWxBXcU3tsStV4BBaATg31siJNZSEtbhJvwmYaNx9MO2Sv09Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=H6t4AtAr;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB45606A321
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 02:12:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EB45606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=H6t4AtAr
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6afafc89b48so4159250a12.2
        for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 19:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1792980734; x=1793585534; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GPu9YN25dDm57paUC3yXoaI+yd25NXWYw23eCkA96p8=;
        b=H6t4AtArQAj3QgYaCfrM3lyItzggtnfyus2Lijv+bbrQrM5UR/A99W/WKYkK76N16q
         J112kHpq/pkZhYcYyHM2ypu2OxNZ9qTRP8mRQVEYwYk0n3KFOKv9RFDWogak2ICoSgy1
         HYUvM3ch8wN8V8L9x5DvOM0myzqwMXz+RkCCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792980734; x=1793585534;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GPu9YN25dDm57paUC3yXoaI+yd25NXWYw23eCkA96p8=;
        b=sBS7DMptDT3FMsuHqVBWG/cdK0ltHZVcZYFFVqdYL3kzx1E4vFd45z8EAMcQTXqVHH
         QCuzY3ocEGt5qZZkTMRGJ/XkzV8bzpg2AKWjAIQypxeftqAX9N/8PGVSLx2AIf8kMf7q
         Goeey6u3AHguZDS74vK0YIjU9fdNxcbcPtIdCyhGeqFTpX9zBlmPqb2Q341sEQrr5MkG
         rpg6AQ2Dssje+FQ291bo1Qlk0JfilRNEePwDIdRVd4uFA4yO+OPyfOOg30Wqkz6fwxut
         f7T5jB6SGfeTC+NQDDEcYGbSqRS053TatXpViRXCNaxTZyV2387X6uwGU9ixJlqyp2l9
         jntg==
X-Gm-Message-State: AFq9FYJLomr/kOKMs0W6+uHIbpmkUQ9DcskbpTmfe0wZAs1Z1Xb0dyZu
	L72zesIONorkrNXty5CFJcoAsNj+MFoB3tGUJ8l+6tm1tmcKpGNOR1YqCQ4I7+Ya2M2vt4HudqE
	DteE4NuQ=
X-Gm-Gg: AYBFou2ci2L6f97+Joue8YXTPYAVc9fMKSsNn3n566RJlm+BkAOFz6vQ64vNiUWU1Ud
	hlDC6w5OwEwYDBgf+b9+CrLM2hkYCyTz0+uOTFn6vTTo5umce3qUQAIx2QHqSay9OY51nHFw38+
	RiugmcofkVm7L76m5r6zXjOwGYBjYJWbI6yrCT0Oqm5gvuZ6qSxCh50VqX/EOlKnCY+OfC2phI5
	U873ZjK85sZ2rYBCUhNy21p+HQ+GXv7by7hd52rWAN36GozBG3wHIqsjRNgNXaCi5j9P3KIeaGE
	xZTrdvrxUCs4O7YtEADOc9sVVjuMbuS8wAe+WtAxeemrSDjss9nNZSRfPUFph0Vc3aULCJLrHY/
	PaQetzIO0UEqG2QdrAPfsamQs5LwVJ81ULBWB6avaogFTi8MDDYJ3xS9DyWnIYYMo12xEDC1j6B
	svutGs846oEUeaBGFZoGgCUZcjkzrs7yU70rnsbJdxmH74afp96Dh0fGs0yuJvGMobQhfOgKC/G
	JzchOh8peJP6OdPtMjk1mt/RGQPJS412UdUtsoTBBLeIE3KJ7HFJeMBnFH3OhrVfEK2pHsf5rRo
	X90Zdvh/FTFpHlKhryK+D/O/wGy8dQ==
X-Received: by 2002:a05:6402:1f07:b0:6b4:1d53:5185 with SMTP id 4fb4d7f45d1cf-6b44313823bmr7037199a12.16.1792980734387;
        Sun, 25 Oct 2026 19:12:14 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b44584ad9fsm3143987a12.0.2026.10.25.19.12.13
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 19:12:13 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c450ab1483cso334204666b.3
        for <linux-ext4@vger.kernel.org>; Sun, 25 Oct 2026 19:12:13 -0700 (PDT)
X-Received: by 2002:a17:907:3ccc:b0:c29:f5d8:9c75 with SMTP id
 a640c23a62f3a-c46bde7eabemr658242866b.36.1792980733776; Sun, 25 Oct 2026
 19:12:13 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <atoWDJDx6sFovvjp@mit.edu> <at1viAwYP3bFOkj_@mit.edu>
In-Reply-To: <at1viAwYP3bFOkj_@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Oct 2026 16:11:57 -1000
X-Gmail-Original-Message-ID: <CAHk-=wgsdLwcKr1jguH4QfPtS3sm5Ss6HKfk5RAMULHz+O6Jrw@mail.gmail.com>
X-Gm-Features: AclHuK9VwiBTuLWnqHPC6xVDVLPjjIrsXpo0uxJp1zsuHKmEBofnjvervhtz3pc
Message-ID: <CAHk-=wgsdLwcKr1jguH4QfPtS3sm5Ss6HKfk5RAMULHz+O6Jrw@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 updates for 7.4-rc1
To: Theodore Tso <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, 
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Oct 2026 at 16:56, Theodore Tso <tytso@mit.edu> wrote:
>
> Ping?

Pulled.

Note that I was pulling filesystem code early in the merge window, but
this hadn't come in then. And then it was architectures and drivers
and other things for several days.

Now I'm back to filesystems.

It's been only slightly slower than usual due to a couple of days of diving...

                Linus
