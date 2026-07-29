Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5422BDC23
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 03:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785295882; cv=pass; b=fG0Jke9dRYpos3dmd/vVn76NRsKKbGUaCYFOLJ//vEuTfVBJYzjgVqaJTwJ7qkPnRWb3ZiFqPWkccfbVf9mNgBmv2JZyk8s3i9eHmMCadzTU2VmbZ6RuLCreryheEAEioZM4g0c1tGu7GCRCC7SuQ/TSMNCxji9qAE+P8GSzWxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785295882; c=relaxed/simple;
	bh=vgpz1nsCtyukDVrnvJPzH6VKpEbs/rZH5gJoqD1DtJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p2EZOlRqXs6RR4HksxkY2Lg1/V0wGGTCAhtqrMX1zp74vbe2fjUfc/oWrw3T7EWGAfykqauj4wTBbCjWFO94oY/3VUWF1msqJiR2nyRA16rvynF/3ECpthdXQrR1PleuflbfpnOYMfzS4kr1s8iqBZ5XqhDDW8i4z4b37K0LmoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mopaabzg; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mopaabzg"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c01089e8aso3722581cf.2
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 20:31:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785295880; cv=none;
        d=google.com; s=arc-20260327;
        b=JPEMCvneoLMNHrJabSxK6UTU3Wew6E1kxskJVDbI20isIVN1tl2cZjCCBs8oOmjruW
         F6CzbErwWlfNl8VzXN8gzqA7bNDUlCC93PFlePJH1W3QG/uE6ewjK6IQtM5RKec/1vQ2
         CFDbGCkrjoTCX1ha2OYgC+r3VyLdlfd5GOHq5o7eRkok1KMrrkDmAc6KXi6KxxOXQl9A
         4IJwBkJcde0tA9FNNsC17j3ai8T1dMh0paKblPg6zvjhihD/E0KqI41bAcDHfUAVJVSe
         HWyog9DUhSyWUQGhvusfvRSHW9IH3o43vC061aJBIl+ta8urEF5wRAffPsnLjbHzleQs
         UA+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vgpz1nsCtyukDVrnvJPzH6VKpEbs/rZH5gJoqD1DtJ8=;
        fh=eKvdc25xarOUql9/eo/6tt+4GQYeKsLBcbNTbokoTb4=;
        b=UYb6CET01JPWFRzH03wSA9XILNwoINOW+toqzMuxvJmkHVVQNgxSXUO0Mx1ZZt4xrT
         OAO856RecbhMBsUbzX7UXpxI0QFUhLtcsL3csGJj1cmKHB2iOrqyqSAqSinHGHFn4hl0
         c3F2dwxeDI4Kj+s/USCiAXCfykKvUKXvDMjBWq9UD9C3FxWtduMyWsgwJZ+Q1h8NQ1RA
         j0ukUZ0s3/BSuIjCgmdm7aSMknq6IAJTgI4O07tt+BZQ4fIV09743TbAsZeV8onCuH5Y
         P2NkBgoUK5q4o04Js63l5Tx3X84R18chNAV+dVXmVXbTLep1fqQw9jmPaJApgJyxeCyV
         AyRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785295880; x=1785900680; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vgpz1nsCtyukDVrnvJPzH6VKpEbs/rZH5gJoqD1DtJ8=;
        b=mopaabzgpuoHl4TDhbuvjeis9pIxotRD/2ODxp1ziUZM9aaMfk0JHyyPh8RGLo+x6h
         zHxbV8Eie3yJYJgc7xwYcBd+G+rrD5+TPBT7uoGqjssPfdIhaXGdJis3sgkV5Ah4PL5v
         yMMK/4Vgqh/yQjMxaIHrPokOtIWJp1UrP8CyybnoCrx4x8kvjPZytEMkkjNfU2N9jooR
         oOrn7YvqtvdThwy3Vtx0ReTK7/h9gUALLYPa3of8KHfWMg4wG6B0rmByogqsu6YHMjAj
         fdvR+SlzNQyPvfNCLOzDUdUJbFIQEzi0uJ9WUrxhxHmoGl8KierVswGKJAfjQtqsUqvV
         ey/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785295880; x=1785900680;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vgpz1nsCtyukDVrnvJPzH6VKpEbs/rZH5gJoqD1DtJ8=;
        b=eVXS4Es3brtV24yucgxdH3Qd6wUhNAhB3I30Hw9bvDObs4HRWk2XhHg93uQnL0cH4e
         wLqm90GaDj6eS0C4FGR2OW720c2ItpsUQ9iT+WcHpG5Vtivzd3lLIZpA5WyJvTdZXxMz
         Wd7/0bwligTOJZlV/gJlJ2zMABkl/qI3ld3Arr/nedj2tk1uLnURQSvMmLwGlxHhAB3z
         MtOxr5XDerUrxMgC9/oN0Z5s0sXRbd/QLCI42n7BredBfIAe71skDhiXCLk88h4FjeAK
         XLhwVMCf7s2p1ZWxmhSmuLtUQjM7wc+Q3y+zfp8ICD3Gsho7wcNYVDCsiAw7NrN24gxZ
         Ow3w==
X-Forwarded-Encrypted: i=1; AHgh+RphuirNbM+M5lG2rNuJZ4ZxXqmtdQJ3VmudxVaczolAtbaoJD9H8iLScbmw9/4BNXK+K7quLdgLgBWr@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9IPm4glf8GWOrD8+vjk3KtRWUDBFvGRMiSKoEiJnvYFu6k3n6
	qHDDscsh+aJu6gkD942/LCN8qQWA9Ewq+YMyLpT5My3pEM0fI5JwDVXGZIxvyniAQ2gHEGxuyak
	RsdQWxuCb/2NKqK1PwnIp/zvTVk8foJ0=
X-Gm-Gg: AR+sD13n3EEzb/rWPqwJo3KTBoJ3ENFhC6TWaynXAnYHK/2ZEE8bwIO+Gc5/GrpckH7
	6byMFCv5isae55opbdQRv9puKkhsMnKDNre2rucSVBABTxg7mIEuEug9AyxijZuCOXhxsHKESXw
	2IDRO6Y+PIaH4PkxBFUNYBU9xB4fO01WVYXTJ5oo9O8j7gxlqaEXKrIaUHtcIbfNR9/xGFdPuC5
	OuteE7mYI7/f97liaxfVOf7IPcAJxFESV9E1gahdINhhrUfjMAXPLs3NlCPqQ8nVWGy96QTt4l/
	6UA1uyOGrg/mDSVIi1eCMGU25JkRVtFV98VLwkW5pSFQqDGDka3iuA3lRDaMzk4JER70+ABtwFp
	eI3XW37vZRloNuXykXVgEwDOi
X-Received: by 2002:a05:622a:558b:b0:516:e74e:cc51 with SMTP id
 d75a77b69052e-529d71ea13amr47035521cf.51.1785295880018; Tue, 28 Jul 2026
 20:31:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260727104103.28916-1-liujiazi@amazon.com> <cxw7n2vs.ritesh.list@gmail.com>
In-Reply-To: <cxw7n2vs.ritesh.list@gmail.com>
From: Liu Jiazi <jiazi.liu1984@gmail.com>
Date: Wed, 29 Jul 2026 11:31:08 +0800
X-Gm-Features: AUfX_mzqAch4dOTholIbYOxYhhZ4qOB_cjYnwNTLQcvEl2FTMWVofOmkWqsZ6Z0
Message-ID: <CAAcjFgh8Nr5FvLXKAJ+zb-2yKWQxf-BitrZBOEOMkzVEAFaHNg@mail.gmail.com>
Subject: Re: [PATCH 1/1] ext4: fix incorrect function call when initializing s_resgid
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Jiazi Liu <liujiazi@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review.

This was actually caught in our product. We use gid as the reserve
size id, and we hit this issue there.

Brs
Jiazi

Ritesh Harjani <ritesh.list@gmail.com> =E4=BA=8E2026=E5=B9=B47=E6=9C=8828=
=E6=97=A5=E5=91=A8=E4=BA=8C 12:43=E5=86=99=E9=81=93=EF=BC=9A
>
> Jiazi Liu <jiazi.liu1984@gmail.com> writes:
>
> > In __ext4_fill_super(), s_resgid is initialized by calling
> > ext4_get_resuid() instead of ext4_get_resgid(), resulting in the
> > reserved GID being set to the same value as the reserved UID rather
> > than the value stored in the superblock.
> >
> > Fixes: 12c84dd4d308 ("ext4: add support for 32-bit default reserved uid=
 and gid values")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jiazi Liu <liujiazi@amazon.com>
>
> yup, that clearly looks like a simple miss.
>
> Nice catch! Wondering whether this was caught by code review or did you
> hit an issue due to this?
>
> Looks good to me. Feel free to add:
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>
