Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227AE41CB4D
	for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2026 19:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792352854; cv=pass; b=L63QFky9twGhKc8rZj853WTDC/VQHnx6R6LF3RZziPcMl8uuN/RJpHMG9Ac95KAeGGojBgyc+6URKa5A2q8nuBZP9bUe12wiQxjqlPCz5QaT4oESf5Rmo9cIgM+NjYrjHX8mYQq2uLmC+IpMVW+U7LyQ0qV8Wokl5R/7vk59UAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792352854; c=relaxed/simple;
	bh=uSwsGj7z13o5NrJE21iC68UKNr7h5yOq6P5JpP5TNDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/bcSyPxt62NLdYBfJgzcN7Hs7joe6LqFodeTjNaqnt3EZInXyI1THVLOYPUr7biJJxJfcnjKV0Nj1MblfAU1JzvswmXCPVAon0TX29Bk3+iEV1XvNNPdjTi5L3Pry8zuEtjQimIhB6Qp1WXWQLMO0ejdy64I0y0/NaBhxTiDaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=U61hr0Px; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="U61hr0Px"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3a9787a156eso10101721fa.3
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2026 12:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792352851; cv=none;
        d=google.com; s=arc-20260327;
        b=c7nW4vk4DqM7SE/asyr1sXYIiULS8rl6EoaTb27C9qyD2IUdjWOQBMeloYNDKfFpXH
         sLJm2AOhfimbDn6EY+21u6e6V344vZ1MPqCnm4pYV9gxt60RXaZoChm4jgY+IJjmlIrB
         9bWL7fCdBZE97q0KMZQUG51WJU9lgSG1d/diphL+RlmBQ+vKPfZaPi9fZ6rQ1W+Mkdiu
         3aal/sMt5wY0CoJWhAVg1JxH9qbI223IWoRuh2iuIxFLV6NV4+r7bsP6vAbo3OKuoObb
         0MHKqREJtla+eaSg6el8SSQiJJBrldI7POZ/MeTfBylHgt4UOuY6OiqVWqAYYb+YjiCJ
         DT9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        fh=b3gg6cXo4QeVk42oe28yZe8hcVeyi3A2nmipW7OLjFM=;
        b=cQW9sgE9Wb846OWHCoEZ4muNwIE9UbSh5kEZsIgTY/mpleeM00CUNvJPwiAIdxTK/C
         Yrj5DtlOrC+fCEI1cOGjhqMzUoFgL9OklsTBrGZDvd726tnY7W4z/3dOkYVF3RoqD1Uk
         a9O/RX3GAVzpAKy0XKssP2dek617qu7RWlWHp3mzNqBsoNzTyyaWC7+p8vXuxCq4uQof
         o7sAnTwGQHB2N/z38xfD6NxqDVPAzhrbUeGIyMGOBAoMgetZOSMZMPkvocbcWWP62OzM
         /zpGWGft9ruOdXGSpc5+OAMy31R3ruPYS40d5nXStk1//m0kYL/W5qqvuURZ9HR8DiuQ
         oc9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1792352851; x=1792957651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        b=U61hr0PxGjsekFN/Peus8SSvsCkWL+X4cEShlWPsXJwFZsPSOlvUCsybYg9BgwgJRd
         4XnxIJgNM2UxnPRJ7LJ9ePNZaMA3S+v2khZQd28a3QJuiBcuUaNEpSAyegrHLGxeAQOF
         XWhhz9z4gvoj1jD71wUdmMg7TKUgBLlQEbfCfdSDreL0vc42Gwa+0w9MuT0mJeW9FjHk
         InbXbqmJqWqFBCaE7bhMzpyoImihsnstJokhn5vCptf2p7cb0uxL1CtKsrsoOoa51lXm
         tyklrtgAN7N7S853vG7iCSHElYqHLPGyLpCn9vrAZ76I1HHBL84qCv0LlLe1GVF1/qq2
         6Adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792352851; x=1792957651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        b=pxoM8imSd5tqYS/MxjKeHksukj/FPB+jl7/+Zzv1CsXWwCLCJoo4LKVKZBTIlNwHlI
         oNiU7CxsmmWpfTwn2HpH6aDJaYrB1A/Ty8whSw2qwrv0PKpSW6+sMPB6yX7EHUfIv37a
         6umUi0opWtR1STcewkXgxPSqsJEzMGUU0BjcAHqaHnukG/FwFjmvRNUJeXyunIE9C6p8
         rCP01UU+bkGS+YJX/rCFep66r/12iBcvbQe+Wzun6WvFQoKdpbpTvQb0+3NXRuoZCCS0
         9Cejymz+SJdhCx974s/HveqfZiNb9NLl3YlKASCAe1q5/hiCcJdgiO4RGezMZwEviEJG
         w6PA==
X-Forwarded-Encrypted: i=1; AKwUvBwenL7gVRNZfWSTaPkvSN45EhRbB0BisqSPC+YzGOMOlStdweJmiGdOK/EiE47LIxDvKzp+g1/0DzND@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3WDBRDicySPFi0qL32mlM+Zn+WWvP4nDfv8ycM9SVbd95/pyj
	ZemsDFBzUzDhjM+xq60uVMjH9xxMrt+EkXEuXY3q8zyqw8tBbtRaqL3q9UHMukrQx1e8FpfY1Lk
	yp/L3iBIrnyW+9GN7hvsr6Yx0V6Q248r7of4R94LY
X-Gm-Gg: AYBFou1BzEXbDOqvTqpWQJXM6eR5i6nMslGU0QUn1NMnmaVs7LXOreTkN5dToA+km7V
	XAd8qt389GFEgNYrzbV8ULSVCrRCy53UdnMO61FFTDAQPkKKATPr43bDKJ8c9CFfDUV5xuyF1/m
	i/HhRiDwMkORAOkmw1d8ooNqOAkPazLAOdWq8SqkoAOt6OBgmeGSHbuhnNy8RHPIpjCEqu+8yKX
	unnsV4VxykcrJo9ES9G2PLCyZt7VjZF2zXlUcKBht/l6JKy98ivySexQmJ9zroSeqGyC2DBUANy
	ts7PHRR4bGHaJ580sGN3nunjfDoRdUp7HjQKjCQywrkHOS+y5H3I
X-Received: by 2002:a05:651c:3614:b0:3ab:1639:9a79 with SMTP id
 38308e7fff4ca-3ab292b7375mr9897881fa.15.1792352851051; Sun, 18 Oct 2026
 12:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792346472.git.jan.koester@gmx.net> <9c17a1f7f82b953e6f4d9e17f4ca19d5220d7f2b.1792346472.git.jan.koester@gmx.net>
In-Reply-To: <9c17a1f7f82b953e6f4d9e17f4ca19d5220d7f2b.1792346472.git.jan.koester@gmx.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 18 Oct 2026 12:47:19 -0700
X-Gm-Features: AclHuK_TjVvADO7YV_Of3nNvklGJn7yisT4mnRNh7189wUPwvl6Zlkl0ZNpg8pA
Message-ID: <CALCETrUjRpHSTBzO65uU-YaEj4espqnwDSaSLcXu653xJyooHg@mail.gmail.com>
Subject: Re: [RFC PATCH 09/41] uidgid: let kuid_t and kgid_t hold a UUID or a GUID
To: Jan Koester <jan.koester@gmx.net>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, netdev@vger.kernel.org, 
	audit@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 11:10=E2=80=AFAM Jan Koester <jan.koester@gmx.net> =
wrote:
>
> Make kuid_t and kgid_t (and vfsuid_t and vfsgid_t, which share their
> layout) tagged unions: a classic 32 bit id, an RFC 9562 UUID, or a
> Microsoft GUID. KID_LEGACY is 0, so zeroed memory still holds the root
> ids, and KUIDT_INIT()/KGIDT_INIT() keep building classic ids, so the
> bulk of the kernel needs no change. The member is renamed from val to
> legacy so the compiler finds code that peeks at it directly.
>
> Semantics of the new ids:
>
> - They are not in any uid_map or gid_map: they exist in the initial
>   user namespace only. kuid_has_mapping() is false for them in every
>   other namespace, so no capability in a child namespace gives
>   privilege over them, and from_kuid() and friends give -1 (the
>   overflow id when munged), exactly as for any other id without a
>   mapping. Anything that can only store or report a 32 bit id thereby
>   already treats them safely.

Why?

>
> - Idmapped mounts map classic ids; UUIDs and GUIDs pass through them
>   unchanged, as long as the filesystem itself is in the initial user
>   namespace.

Okay, so they pass through but don't work.  Sounds unfortunate.

> +/* Like kuid_t and kgid_t: a classic id, a UUID or a GUID */
>  typedef struct {
> -       uid_t val;
> +       u32 type;
> +       union {
> +               uid_t legacy;

Linux is Linux.  small numerical uids are not "legacy".

> +               uuid_t uuid;
> +               guid_t guid;

I'm at a complete loss.  Is guid is only unique on Earth but uuid
unique in the entire universe?  Even Microsoft admits that GUID and
UUID are two names for the same thing.

I realize that Microsoft colossally screwed up years ago with their
little endian uuid idea, and I sincerely hope that this is not some
endian thing.
