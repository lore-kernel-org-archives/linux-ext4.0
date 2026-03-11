Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596C3148CF
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773238410; cv=none; b=XKyiTQG+fvLpsUhvmyfmeGdk8T0RLncOJ8TUgxADJLPlMVoUKBMAW+nDS4ZGyIulejgp3HgBec1IW7g1fklE6uYP1tBZl5i0f6knmySo54V1GF8KNaOwOqv6ohUXlGeFONh/acHDepTaY/lhBF3/R79fgdiSqiA4fbU22i03lu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773238410; c=relaxed/simple;
	bh=POUJjzeRhBIXfPGojdZfC417KH92loTKx1KmDpRcfoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKeEPiC8DnPZxVBzfVtF/Vpo5nQ7CIcm+SngWH/VPeVuuV4rq9L6Wf0Xoe1qP7DmNY2BA6n71jBHgMrIIM638qXwMa4ekc0qYN97EBq4pD+oHb6dihe9aFQl4YqH6P5xdhPabRx8Vj8sqkAE0Gp1YKEcsforKJq3dKicVpxBKDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b942b36de08so190712266b.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 07:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238406; x=1773843206;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=QmgC1xU3JdvW568nPnauE/aJgLdwHX3J+5oD26AOpfpILepLGzvhveHlCa0KYp3gU8
         O95z0eurYf0oJk5+h4z8heQo2F44QMWz/kyqXEEOynaBlNKeRlFi5oxCswPS/9rO0k/J
         qCIBdw/8jJE8zAJ7+gQKFqgnwrpidOzSeNZtmKiAFIIiCQEVoNSWApZSN2fMgtconfY1
         JvcOSLrr69nVz7AmDhsLZvo8sr604EK2L19Mpb/TKtEJI68NgV0NjjyF1z2HjmjqKgZA
         EevnzEM+OUyAA7Yk3pPVQJTrNVZgAKiChan8fq2a32j463W9GCYSzRbd261aTkfxTuyZ
         SwjQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6ZlTajajERPekwIde/8em6Bpb4yq6seZL24APxauMpQPZ5rdg3sC/xsoSZqw7TOVUhazsVm6FOPFr@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ4ynhcHzRDiZG5u5QW1XQFWZ4E67vq3IFnileE8+zuraHZU+C
	bGpSIlCNqL4bLQaXEppTFpzMBvHwBrOxDY5Pu4xofM1u1eSr1YNNEtUZi3leo/f8QtGsJw==
X-Gm-Gg: ATEYQzynuZ3wu4A12xVjci3giiiEtItoLnu3v96/BIPLy9Iz2VmN3/ophscqkhzi+3H
	OzJtYI7GR7c17VmKKaYn7sMzCCGMJF5DKhVWGaUAMYqgLR3oNiLgpizd5tb5/5woG2hOAGqWT/1
	i6Xy5NNvQmb44yP5xY3KQ3zjOeJPpuz8Zt1U95pBEE0qmdaRVkTW4g9CnD/X+THcSDuNDQV3GFL
	HrerggjPQAg24MgQCjSCVLUDoUpDVQMv4+wFtvk1XOjsEozmY45NGg2Bk1UHAw3Js+IaKu1n+uR
	vslW1A+1x5aAKF71/lp6M2JMNfnW3x+AvRFYbrfd224OA3Wx/A8+F3EkyAc47BNiVZsp3+0JzYb
	unE3k6WuFXu9oniryYlQFDLtQF6++EiMtxJ3F6e/OgNBd4Jx/Srm+5KI/WNpzrMPLv7zbdwqpv5
	Hw1B/i+GYGLMGxwxrw/lK4qTAJYxmEbYz9gzugjduVqfQDJ56gBdDGVi+3datv2ZoAYGtbOS8=
X-Received: by 2002:a17:907:980b:b0:b94:82e:55e7 with SMTP id a640c23a62f3a-b972d86d8edmr135099366b.25.1773238406035;
        Wed, 11 Mar 2026 07:13:26 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b972de47966sm56443766b.17.2026.03.11.07.13.24
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:13:25 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-66325f30570so984889a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 07:13:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXEovXyeEIDQsalCUVA1lyDXFBenVaDsMDOYCXPuUp7F1Vvpjf8/EVpTcxQIlG94LttN+jn7bOLdDN3@vger.kernel.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
