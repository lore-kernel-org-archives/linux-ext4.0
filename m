Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD993DC4A4
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 22:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784066960; cv=pass; b=WktVhjIFGvHrqZMoJSJp5UI4YSNnJJjwbsW8ZJMNbPLWKxpjFKuoICGJE60x+RStWymS2BZI8HMPWK5bFEIyvTqZv3v5xaIbSmby7EKbe2JhiMoPDRlyo3T+CH9NaE5JuPYWfRMJyg/lflNfy/IxOTe9P+c3JtevbztJh2DdiSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784066960; c=relaxed/simple;
	bh=r2iYkOkZqaZiczZDu8484dwuTk2brepREdMPjm33dmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqZERFrQB9UFvcMn4LiIicywnHgdgToObnTPAEWcpROlkHJq+hlunwLTfxuBE0oLtbqdaec8wA7xypBLu24PeIILXoB0yBS8BfA+ofXbB40xJx8webFALqKc9mBjBSAXxxpP/0nSYS9IdhkHvPt+jpHhG3D3Xt7WVoSzpRNVZdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sz0LpnsS; arc=pass smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sz0LpnsS"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9ef3e1337fso3249884a12.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 15:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784066958; cv=none;
        d=google.com; s=arc-20260327;
        b=CWCJ+3gaxPUsPcKTJiRaU6GSZZQ7pfqmJxa7Wsw9RorDmSqe6E2AjlDEWvJl3FkOJO
         VAdFD2SwmCLpFyOrgTCC7H6woaaf23RQGUup5rxFWeMZTib/Wo6ppR358ozA2N1/mtSt
         4gIULYlQnRVkXR20244KB6d3pR1CTei8wcCwVVL6KpdvMwoCXgJ+tFyaDmVbdnGYp+1n
         c7DV/EH++kLLcpySpHOtXr+DT9ji7ZQAh/Rn2tcD6IqS087B0tFsN+brEH1I86ORoEwB
         WjmSrccIeE1k1SjSSqhezE/Few4Ivrz5QMmTewNjs/unoKMxlNalFWT98Ltuf3tvlXjT
         9SBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xMAuuyWZB7XoHJOmWQuRMJ1M8biAFJoe1pbNkAJBxPk=;
        fh=zDDI/XYT1f0fUllLuo8hIT+GPDoqesRI7bcI5P99KLo=;
        b=LN4Ig7oowSZjmb/tTLNn8tN/SGQ/CQqQMKT7/jbARRrBZ0ECquHi1U3b72xOjnKmFp
         fKzSVEF/dFllu61QsTms+nG/fVurjBTumwpY4Lg1aDWCpNA5jNq81g7mpV+VATVRiYYA
         RgJvzAZtghrPA7GoJke8hM/K6RqAEsrz3LQlsJzQSLI5lSaiciZsfbUPHGQkAsM7c9gz
         SnKKGlX0V6wYh7J7LzWtBseDR3J0YjnJCIIvkrtwIqlfXcICMkwTKrpEL8HOFcDmEQRU
         ZgHQCNp8W6k8mrQf/oWvWalaxvJjFkefrYTdVviPxc4a+tb6wG72wEUbluExu42VcTVI
         fvyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784066958; x=1784671758; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xMAuuyWZB7XoHJOmWQuRMJ1M8biAFJoe1pbNkAJBxPk=;
        b=sz0LpnsSgN3nfi6bViH7gRKH7GhRay6LfFmo5wJ+IeL80EJjvI3dmmvbCyLz7J6JLf
         3Tawx9BQF9/WJxH7P2zNL0y/30+tPXsH+tceEg1j7W7n0U0AvF18aEt7QNi5G5WiU5CK
         ynLrN+wJXi1o0GOZAgjO2BJeAzM4d+EMOze+uLMPLDPtLN9zDe4FOporF7OoeZQMwEOy
         kkSbtR/2rdPNNHmUICHjCJKMSpj+OBtyae10gSlMwPQnOh1hAd4URp7cX8L+ZRzdofSM
         fIkVHXDms6ScmGGsdoqdky9ENMhBePaRwtcnEsrN6ulL0XFg8gOGE4SJbQM/cvsgWUOm
         6Oow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784066958; x=1784671758;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xMAuuyWZB7XoHJOmWQuRMJ1M8biAFJoe1pbNkAJBxPk=;
        b=BybcmylSwuN3nTBIwMfps1cnHC8W116mVrxDZvVX4bEhH75dBFOuJWPjttoJdhjI+q
         vw26y42KQ1aSMXxImpnS//qaReaxVi3V6MW/vXSVuYpyRlSSCPG/ysnskENqS84e2G9V
         mY4PLDvGBMWUImwdByGmsEXJEcB2IZw152Sk+B+JV2gaRFdzi6fpXLyDu82EPmrPWaIE
         1IXN6VrwLbhFq7cXBrzfkkmUZrdH5WShmN3pKLDL/H6QSm4WGrjnuW+HBowX/tHPADB6
         RksSMzwx5eOYgiXn0XrKKpDFLGQBWZPq/DUyPg+Kf+wUBIW6yKLJFwPBYiALKnYUqug9
         hhhQ==
X-Forwarded-Encrypted: i=1; AHgh+RrJlT6KnMj/Bt7762JKkQft89BJNTK2ONcLC7NfOf8lnHOmQUfkTroFxOepEfQeGlpVCnKgkqCDphUE@vger.kernel.org
X-Gm-Message-State: AOJu0YxUqkEhZJR7Hcr+zxzlHRitE2KknZAHQesFf1pIm4yt8xCPTDPo
	W36XFB4JMwdJoK1LsF3R1Ugihfp+h5yJ7X61e59dOpR4S5gvJgPk4yzs2QCvj1crtibHZnSEKCo
	vCtpCAWBwU24+Rfm9dU+cu8KRvglYPkGMzYJhXVgK
X-Gm-Gg: AfdE7cnaHyIbGLFQ94YPv00ZOVDBfZZHjpspprwdasEX1R11sAuDluseBuHb/tT0o23
	tqp/7KWaUNkbipl92grAxTwbPRUV9+KWVjHl3GjcQFgCav9574QExyPB+tiliqg3WfRTB53H5Wy
	BJbDUj3C1E1pNmBsgqlEBRjbeWjT4ZQIwKUqDG/UArLWGS2HiZvaoG7dCJtm0FqzsooOLRjXnYQ
	vWeVJ0ZNo6NGHGCNVaN7QyUDYRaXc/UBSw2MUr/hc4+sl2Zjn5OecDbyYXKXz8SGVcnUNeuX0nW
	i/6VzLY=
X-Received: by 2002:a05:6a20:a10e:b0:3a2:dbaa:82ee with SMTP id
 adf61e73a8af0-3c34d5297f9mr6314687637.9.1784066957186; Tue, 14 Jul 2026
 15:09:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712165610.366474-1-timday@thelustrecollective.com>
 <20260712165610.366474-2-timday@thelustrecollective.com> <alT2yHlfzhTZ9n4T@mit.edu>
 <20260713164417.350710-1-timday@thelustrecollective.com> <CANpmjNMfQT6Z9ke4x49sp6z8+pt_5ZLUoSh0da-99bwos5-8Lw@mail.gmail.com>
 <CANpmjNM5CmQc_YG_5=zhdLCr7gGL3QYPcd4R4=m2NzwNY03d3Q@mail.gmail.com> <20260714211246.1046948-1-timday@thelustrecollective.com>
In-Reply-To: <20260714211246.1046948-1-timday@thelustrecollective.com>
From: Marco Elver <elver@google.com>
Date: Wed, 15 Jul 2026 00:08:39 +0200
X-Gm-Features: AUfX_mx1t1iYPhOzdPqbpB7WFQla88w25d073M0qcSXD45eo5bd5Svr3aBYrm4o
Message-ID: <CANpmjNNU_GiRW6y24hvbUsXze+jf+9ptx8_Acq1Y=mvPSr=wFg@mail.gmail.com>
Subject: Re: [PATCH v1 1/9] ext2: fix ext2_xattr_delete_inode() context
 analysis warning
To: Timothy Day <timday@thelustrecollective.com>
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 14 Jul 2026 at 23:14, Timothy Day
<timday@thelustrecollective.com> wrote:
>
> On Tue, 14 Jul 2026 00:56:56 +0200, Marco Elver wrote:
> > Relatively certain statement expressions were once again the problem -
> > this should fix it: https://github.com/llvm/llvm-project/pull/209330
> >
> > I haven't had time to test the Clang fix on  fs/ext2/xattr.c with
> > context analysis enabled  (please do so if you already build Clang
> > yourself, otherwise I might get to it in ~week).
>
> The fix wasn't enough. The commit message on patch 1/9 omitted another
> warning. On vanilla Clang 23, I see:
>
> linux/fs/ext2/xattr.c:829:6: error: rw_semaphore 'EXT2_I().xattr_sem' is \
>   not held on every path through here [-Werror,-Wthread-safety-analysis]
>   829 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
>       |             ^
>
> and:
>
> linux/fs/ext2/xattr.c:860:2: error: releasing rw_semaphore \
>   'EXT2_I().xattr_sem' that was not held [-Werror,-Wthread-safety-analysis]
>   860 |         up_write(&EXT2_I(inode)->xattr_sem);
>       |         ^
>
> If I apply your patch, it resolves the second warning but not the first.
> I tried to generate a fix [1]. That branch has both your patch and my
> fix applied. Those two changes combined fix both warnings. My fix
> tries to add some special casing for tracking contexts acquired by
> trylocks. It works, but I'm not very confident on the correctness.

Nice, thanks. I'll have a look, but it appears right. Need to get my
PR merged first (need approval), then please feel free to send yours
with me as reviewer/approver.

> About next steps, it seems like everyone is happy with the rest of the
> series. But the first patch should be dropped in favor of a fix to Clang.
>
> Should I submit a v2 with 1/9 omitted?

I'd wait for the Clang fixes to land. They look relatively
straightforward, but just to be sure...

> When would we be safe to merge
> the series? Once the fix is merged to Clang? Is there some kind of
> periodic LLVM release we ought to wait for?

https://llvm.org has release schedule. While a release for 23 is not
yet cut, and we do require the unreleased Clang 23, we can respin the
series after ~1 week of the Clang fixes being merged. Only some CI
systems build Clang at head, but it's generally assumed that given
it's the pre-release, they will catch up with head with some days of
delay.

Thanks,
-- Marco
