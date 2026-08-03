Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E171B40963F
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761891; cv=pass; b=rYH29xJefXi+IhWGUWuwo49fapJcbX+8x++zxhKDExOUhYbpcPnEm66PQAEpTqokY+nccd7Wl+/m6GXPAf2eKwwl/93Y/30c8vFYz+Vao5P/nQ/rzlvUEMKGpT6/YMiP1+rxHFPOkvGj7AwbZo+4IG1EsUHcwUM6rOMTEV1Z4gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761891; c=relaxed/simple;
	bh=FNY7Ce3oJGc1geg0IrHDEAX/u5vtJaHKFgdO1MGS8RU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K1khRnfuDr1g4brBkuGWgMvMeH+8RI0kPyB6ScNe+x88VRwZeUVRhcQ0a5RAFGCb3rjvwtEAgrXo9vtprG3cPCH41TFrY5dYRrox/02BJTwpDPl3JEhIe8VMCUq6unTevuXQ8ysRxuOIDG8Da5RdgqBlKbCQH5BKPybkHefOk6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXOOTXz5; arc=pass smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXOOTXz5"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81ecf499af9so44837827b3.1
        for <linux-ext4@vger.kernel.org>; Mon, 03 Aug 2026 05:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785761886; cv=none;
        d=google.com; s=arc-20260327;
        b=N672C1yQ3Ao7vBrynwk54ETBKq8D1TAQDX9cCh0zGFPRAIZ8fsDg6C7p3h19HMMoDR
         A9BI8uh51+j0P36zaMSnTcCilH8WMA8PZoNQp5wStuqUzH8ciDnaTm6pngX7FeI/3d4Y
         1DleI0bWtHkOt04kFx7/2AaIy5kDLDqH0feYoby37FGAmDX2QQNHwYaCCK+JAhkPEcgr
         GGyuRBM//8YPxgZ+HkiJaqK29LK21fYqgSDpn/xOi+36pe4NaYGzKGqPT1WFPutboLAf
         GokCPXLMPMAlapcAaHZfMHBfnmEesVdR9XwtuIjj+8IFNqS9pKIID08yRkPzWUETlnxu
         NbYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FNY7Ce3oJGc1geg0IrHDEAX/u5vtJaHKFgdO1MGS8RU=;
        fh=YpZ2nAlUl2dZtQ+KNt870LyZGABbwWnKNHkDNi6a9IY=;
        b=dvzGFbjFoEAxN53xF3S8kVBWOSoMggh5dCW/MlcSK+FveF0mjFOsHbQ0koT3XBYNPW
         Yy+K7XwZeK6OWh14k92Ias+OFdQREkxE0qDIJBXmTRoN/YzQLft4aCkmClt6a3CYoJIC
         /DBUbD325ICEoAuWPvdOZvHMSigvYY9cDzcxeyqFgpcFEtwdbxd+a1A7lBAimoZZKhnm
         +Brv4oHlwz2nq/jJZjpLzMVseSoUF0YivrBFKKPyJx/8sGOWKwktcgnDSiG0TCk/xgH4
         T0ewKH1I+6ngfWiEAt06JD1wPfc7vRCCs3xVHRaa2nsADS41KUeJIpf1if0iFH0Bxqn8
         ZG7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785761886; x=1786366686; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNY7Ce3oJGc1geg0IrHDEAX/u5vtJaHKFgdO1MGS8RU=;
        b=EXOOTXz5aBXGcIubIyc/we2MjqtgiWPoP/zgRtLlF44IHAFebAZXNsJ3R3yyPHxP2l
         /KeO4jcCkBj69Xor2c8f6XtGCcH+TWif5jgNhYh5tSpl9rAQv7stiZVt3J7qOeg50I7H
         zyZ2gbeuULWzocdsOodKmUvqAFbqvqEd3mXeKMWAwHR8AppN0Fyli01vLYIoG7qNbPtQ
         7FOuq3owL+e6NvCsGt6yymiSifRBslrXctyRRVeOB+33+2RC88KACgco9jOWpFmK4JYz
         ty4bSQwRymxK71QbZBXzzw0xoykgYkaBFKgvlMAaIFKqtbbrBAILYoUD2k6QfMeKj3oq
         nRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785761886; x=1786366686;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FNY7Ce3oJGc1geg0IrHDEAX/u5vtJaHKFgdO1MGS8RU=;
        b=sOs5v3hEF0bf6+QEbxTZJtEPSw9I5QTh1PINY7RiQgbukOYy2rojz7H1X4r1h731pC
         7MNDDA6QBCKGKpJVGYVhgk6UVPnOSO6juZuD684u3YF4RFJ0kMDwgrgLeblM8lhD3d3p
         8BgJ14lICqqZQY//uWtIWgWmvwV/3G+vmqrNAlLA56DEzWU63opSADXJM+EeiOu4fvXr
         Pij/LgG3YRwflHieb5+YXO3NATywdmgpf4MwbysL74Xw3YT6uShg9Nmr3jo6pSiaTiQi
         ZGcgrED3RZJV9Kvf9YaZJsQcUlJxZEJHD7ircD1TELzHtD3F+ucNsHUXOfeo8nCQw75I
         IPFw==
X-Forwarded-Encrypted: i=1; AHgh+RrO/RnyDhb8URXoKdUZJ2nbE0ZOiaUhhRSIgedSQAPfZw0T1fa0kQFc2dFiXR9KiLRhpyXKHrzo19gC@vger.kernel.org
X-Gm-Message-State: AOJu0YxH/Dqtuuc3NYyLnQNb4C9R7cxdRIBMqK4NVnUgFDyrv/Bhmbmk
	5C2EDZVNz7LhY2xrG3LEEBwmB9DjwiryXzefqYptvpHNO93g0GLvEZo0NtrlIU6NHb7WrzDKoG8
	SeFwovgVb1DIleSuPpwbZAAAbOKKFgO5YYA+e8Mg=
X-Gm-Gg: AR+sD10jQBN8tfv+s+D17P6boSH2ghB0SyN0RHzxJ1wuJz9iDfWNr0opR+YBB0YoC+E
	nAIC+tf7w2SiLvJkiHuYPsrYUVsRwPPqkNMxZbYFJILSp5XN1i1JpRtAwnWzfvU+0k6CQDRJFBO
	Mje4PRJnEwJ33mqh6aoAjrfw0ukKRag+qo+SA9Smqx7Y9hiLEXCFOh+qmn8tSyqM/gzXfUCz4ZM
	wT6lUzLXKoEdC4l6GJ53+ssXIx1C9HmBqyIiUuSKNvg2XCuSWyIdH6rJVc/aLKOO1BETZBLHdA/
	LYlakGm/BWRt0rxzPHkTO/5lKBvEj68WksO4+zCP/q8WU9EpPBkxT/swlHjxVbGavhRvOymOGwC
	f
X-Received: by 2002:a05:690c:368f:b0:81e:7dfa:b799 with SMTP id
 00721157ae682-81fd4bab2b6mr127193657b3.24.1785761886420; Mon, 03 Aug 2026
 05:58:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAK+_RLmWU-GjYu9Z+AWnoKd__AiaWZUt=zOkx3jr2-a4Hv3KHg@mail.gmail.com>
 <am_gplyBEyvbuHM_@archie.me> <fmdp3k4efrv44yqjmukk47ifa3rxrjvj2ndfin5lu6c3x5b5lh@5vv2yblzxy7b>
In-Reply-To: <fmdp3k4efrv44yqjmukk47ifa3rxrjvj2ndfin5lu6c3x5b5lh@5vv2yblzxy7b>
From: Tigran Aivazian <aivazian.tigran@gmail.com>
Date: Mon, 3 Aug 2026 13:57:55 +0100
X-Gm-Features: AUfX_mzj7188YY1Ej-krLaz5Tumhl2nXjtPLXZK8jysM9R3mbh5fOF21zeZkgPY
Message-ID: <CAK+_RLkvc3b0vC7SHygRv+4xdk_mC-362T60NbtQT4Zmpp6fxg@mail.gmail.com>
Subject: Re: ext4: spurious "orphan cleanup on readonly fs" due to remount,ro
 failing to reset orphan_file structures
To: Jan Kara <jack@suse.cz>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>, Linux ext4 <linux-ext4@vger.kernel.org>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Mon, 3 Aug 2026 at 13:36, Jan Kara <jack@suse.cz> wrote:
> No need to, the behavior didn't change for a long time. In fact, any
> read-only mount with orphan_file feature enabled will result in the
> spurious "orphan cleanup on readonly fs" message. I've just checked that.
> It is only a cosmetic problem but nobody noticed so far.

You say it is a cosmetic problem, but here I somewhat disagree.
Logically, seeing "orphan cleanup on readonly fs" implies an unclean
shutdown that caused those orphans. Consequently, I spent time
debugging it by instrumenting scripts in
/usr/lib/systemd/system-shutdown/ and even suspecting the NVMe
controller caches, etc. Any sysadmin who doesn't like leaving
"mysteries" on their Linux host would have done the same.

Kind regards,
Tigran
