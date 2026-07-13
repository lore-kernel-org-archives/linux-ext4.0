Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D5F3546C5
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 22:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783983455; cv=pass; b=hRenIdudklKA7OLpRihtS+hWdRj5LWHlfkpQH9JjGbGqaDWY2bjL14Vu3cSQmCP1euiOph+nTTyF/3nJEYZy82mCGouZH2WJAkUebst9Mnzx7A8JuLygjLKNoMLkl553IKRKTxP00JhRftanu73lse09C8gMJs/Ei2mBVu5GYMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783983455; c=relaxed/simple;
	bh=9L/5VLdIHmS3I81dp9ygwQ/Sgi7UyEOF3MlxNCvzo8g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a1XhRVA2OV3qzUbBopzSQiWIzuVKMbnKPxc8GaMWMmtjKqHWtGioRhVL91ZXkHca8vdokzzx6/fpWSF1XZT/OQ3I2p9MfLdmRzAH1snwGxL13FOM0PbRl3dpONEqXZ7RXLmCdEL/3CJXimqmF3NnnaarElbP091MaMOJ7ckrI5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qHN2n0E1; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qHN2n0E1"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8486ac3f347so373464b3a.1
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 15:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783983454; cv=none;
        d=google.com; s=arc-20260327;
        b=s4R++B2gjIlN8qthb7WU9adR5fk8q3l/YBUKydqzev4P7wynR4pkNb5AJL9/6q2So6
         TllCUQiuDMz/X126Q4pUYNqH2M0XqyxyGsQpd00L6ok5fSWkExHfGZi51BRx4z7E1NhO
         OAfXCd2bioxFM0LgSUEPb/aXWzA8kVR4fYwS6+V7BSZ6A//j697PCg5zKkfAYaUuVAY7
         5q7I8lxkSLX7Bag3pAg/x9TUbihHSmdc39t+8K4Um8b46ysvwazimbnwxHPmUB7qdkke
         bpcjiC04FU/dC19VWF/PpMCrJrBpN1gMbPYmslU1fMLKIrvQXFb5aczQ4D0k+Tdjw9Ke
         qVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UR70c6tm5fxtYd6rMoEXnKV8m3WbtaUkpCXr766W6nQ=;
        fh=fGwfW/eKnbbKj9L8mgUiW4U6xOwLkce14QIDVVEFMSA=;
        b=RNxuocSfICXj7nf33WMO2yx9aRV4HwrzUTfF7bmYqyA8sCW5LhtB8iLBg0VMi1293l
         IOtYmVt7eHdcmA8uUOTY4SDMsufl8twRBOEtExU4UTsXXPrKtMPom6QFH9ulvHoGB31i
         WNqkzG+yXImn0ueuVjgzHBWzhKIlDBhRBR9n5wnXtb4CCb9Haxlp72kYO16W+5SGwwfb
         DKFMjAAMcY/dR1OpKSKszJ3kMZrlQl+eyVc9yF4WUBza9iwFx2VRC51MuvAs+/99GVW3
         tfXJWDQCYzsSmkX4Bb+PatjWcAob20YMc+he2roUfYU+lpXXOd3W9/EgiFLe/FnkPLBd
         lYmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783983454; x=1784588254; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UR70c6tm5fxtYd6rMoEXnKV8m3WbtaUkpCXr766W6nQ=;
        b=qHN2n0E16Ut1bhbh1A4s6notUOF2OIEjc+TyKK/SHk/f9pXThY2FM9fc8uVTivgViI
         ckmT0fdV0kTdtxSjMTU7QRUBMemUjTp6hkbN2LI5jhb1YFqJAAnllMwUJCS/PJy1maE8
         yCz5GBXRuuH2iQlXkC09QeBLZwWCh7A18X8J2C3Jr8QfV3x4dUMsURJwvXPB8GT+xKLa
         5h5+XbYZQ0DforiGz2bxyx4bBoE9EloZLpXbpbg4md/HUrVj0NCJIeUl9QMVxaL45+tF
         kFKnShCFMVOVy6GvmnSzgKwga8HdUxs9yX8y0a+AQQo7f1VWiBsIlmBJFKm9KuNVYEvz
         w8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783983454; x=1784588254;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UR70c6tm5fxtYd6rMoEXnKV8m3WbtaUkpCXr766W6nQ=;
        b=EF73y/L9+vdjc+Iyqy7dl+WF7MNEiTl3hPUrXTfpRiRd3LH9frVmIOXOWco8DJ0FJ3
         rRehiOb2tVdLZo9etW3fG79IzQ30vj922Qz74uNubZ2p3Zo3qIkNF74Pxb0jid2My/8Z
         IjLDEm/jp28OgIwfrJfG87S2jC6YceVVOJkGJh7WsDUeXwG2Sg22oJXZrsRbhddUGN4j
         Gg4CILDjy3nVZ4O+K/rc+FuaDJy/yDohqLWi/ou7ix7bzCGSEm1tiOPBMKrsmNdt4CQM
         g5Hz+RRtP/yihjnzN/Dtqli1nQqdYHjC5vsCzSalnOEsL0EWEHYrmJsYBFLLY9vJtiuo
         D/1A==
X-Forwarded-Encrypted: i=1; AHgh+Rr4PKi2nGvuhcS5OQ1Ic5WGX+Uo1gjdZDAm/0m7yhrdB8mmwo7rtuKhGFtfxYoVYU/9HXPIbOxIdLeu@vger.kernel.org
X-Gm-Message-State: AOJu0YyT6rCkjNMoMP1Xz21ssdagIZLw0DBOtHzxQ6zOlIXXi7wYdpnE
	1xkG18O02ph9olnn3h/8r5redL5obfnaPyI8q/AeMf0m4aPorun+iFeWTQ3O6OyRpMJ7cd/5XoJ
	Im9jsF3nM+z25ue8QtSK9d3aY4ZLAr511hZCQ7o4mU7oknzveE4CVkRQR8y4=
X-Gm-Gg: AfdE7clAIn8GYVV120Ho3XnIoEf6HSrmw0dZGVLvPg/9T3q5Qon3IBUN2ykBFgnP1IL
	kwk4CVYzPHjiTVHC3jijlAWuNickAObv7Y8Q6nbVGyq9QJFI0lY+1eTRmBr/n9bzjQwIhpULk+j
	xBLHV1mNQjYo7CyPtA/ZKt5Rn5IJTVuIUajr3l22OZWGbiCqo+dAxzEeesbOHy7wQGrLG/PVaps
	8SxnuMgGgJtjUDbTrnak0WyGw3jNxN6w/Td4jVn6F8fqFQWy3uZ3VrGjK+P+wINajCrQ+T/Dg==
X-Received: by 2002:a05:6a21:d88:b0:3b3:a66e:3911 with SMTP id
 adf61e73a8af0-3c0f0ae84bbmr16882048637.19.1783983453460; Mon, 13 Jul 2026
 15:57:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu>
 <20260713164417.350710-1-timday@thelustrecollective.com> <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com>
In-Reply-To: <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Tue, 14 Jul 2026 00:56:56 +0200
X-Gm-Features: AVVi8Cfgsq6HzcYx2FQQAOWvnd3IKq2ABcFMG8fBLZ6iq_4VJeP2hxKfQnYU0Sk
Message-ID: <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context
 analysis warning
To: Timothy Day <timday@thelustrecollective.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Jul 2026 at 00:27, Marco Elver <elver@google.com> wrote:
>
> On Mon, 13 Jul 2026 at 18:44, Timothy Day
> <timday@thelustrecollective.com> wrote:
> >
> > On Mon, 13 Jul 2026 10:32:56 -0400, Theodore Tso wrote:
> > > On Sun, Jul 12, 2026 at 12:56:02PM -0500, Timothy Day wrote:
> > > > Clang reports the following warning when context analysis is enabled:
> > > >
> > > > fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not \
> > > >   held on every path through here [-Werror,-Wthread-safety-analysis]
> > > >   829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> > > >       |             ^
> > > >
> > > > When WARN_ON_ONCE() wraps down_write_trylock(), it adds an unlikely()
> > > > annotation which hides the conditional acquire annotation from Clang's
> > > > context analysis. This triggers a false positive. Pull the trylock out
> > > > of the macro to silence this warning.
> > >
> > > Does this mean that using Clang's context analysis means that we can't
> > > use unlikely()?  That seems.... unfortunate.  Is there any other way
> > > we can fix the false positive?
> >
> > We can't wrap a function that acquires a context inside unlikely(). We
> > can use unlikely everywhere else. AFAICS, I think the trylock functions
> > are only problem right now. Grepping for ".*WARN.*trylock.*" and
> > ".*unlikely.*trylock.*" shows a few other examples of code like this.
> > Not a huge amount, but not zero. I looked at a few other
> > series [1][2][3][4], but I haven't seen anyone do a similar conversion.
> >
> > [1] (block) https://lore.kernel.org/all/91cb8c790fc8b26b8aa742569fbf8c2c1d099dac.1780682325.git.bvanassche@acm.org/
> > [2] (drdb) https://lore.kernel.org/all/77d0fd75811d7f604fa80b5c93172b5653b52880.1781042470.git.bvanassche@acm.org/
> > [3] (raid) https://lore.kernel.org/all/20260708090614.1431014-2-hch@lst.de/
> > [4] (nvme) https://lore.kernel.org/all/20260713115444.465704-19-nilay@linux.ibm.com/
> >
> > > Even disabling unlikely() if and only
> > > if Clang context analysis is enabled might be a better choice, since
> > > we don't necessarily need to build with context analysis enabled when
> > > building a production kernel.
> >
> > I don't think we'd want to disable unlikely() globally when context
> > analysis is enabled. Only for cases where it'd conflict with the
> > context analysis annotation. Long term, I think we'd want context
> > analysis enabled by default for Clang builds.
> >
> > I think we have a couple options:
> >
> > a) Current fix - it's okay, but a bit ugly
> > b) Teach LLVM/Clang to handle this better - no idea how practical this is
>
> I'm not quite sure what's going on here yet, but
> __builtin_expect-wrapped trylock function calls are supported by
> Context Analysis (Clang's Thread Safety Analysis). Some of the
> additional layers that WARN_ON_ONCE adds is likely throwing it off.
> I'll take a look, but might be a week or so. We are already bumping
> min Clang version for Context Analysis to Clang 23, so I'm hoping this
> can be fixed in Clang 23 (which is not yet released).

Relatively certain statement expressions were once again the problem -
this should fix it: https://github.com/llvm/llvm-project/pull/209330

I haven't had time to test the Clang fix on  fs/ext2/xattr.c with
context analysis enabled  (please do so if you already build Clang
yourself, otherwise I might get to it in ~week).
