Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795552604;
	b=u2SuWfFTtHvPaZI7TBa0dbtqaLr7dKpuO7gzZu7aDFn7WukXDEUy67sjrni2mjy7qrns
	 f8ikNM3J3I8zbZi7oj7UH+cTlr7cixlMm7RyVPZByqv3CVLrB1/mTuKkNi9If1NQ8Cv/t
	 KSxAkyUPVCi3a376cjIT/qAQLXptvSC3Mw+YKRBPi+0LxvoTTNWp/Uzto7EpVe+lQCmh7
	 ER4IEaMhOINlUD2FX7113zt4SMeulLgiwBmFYiRncUZ7IGbqFC6VZXLoxzNbJ7VL6IWn7
	 2bcjaMzy0PxwzWzqCVNv9RYnL8HdKRzPwDkOh6OF008IwJArvelQ5HczvffeK6ANNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795552604;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=eJLr5+zjtN2zIXLilCqA/IW3JjEHhNR2k5tn4GAGSN0=;
	b=IT5XCI8AFutLpwjq55vjn6C+A6fufBD+M82Ur2bmcg0p9TpJ1tBF7NTcOin5FqNrPpDS
	 1ytNcT0AB4eJfmGyJR/uCcoKWpMWgvH5sZEQzIO+pYwV5qRT4o0yQTh8cy46Gm1lh6s+e
	 QbjxpkoIITtrt98JsfxcOsQA452WAA1wTJmqpkNkDIhvVkrbdSAB2m101aQgewjiCCDJD
	 KONTUT+tE2aT/GdYrJ42JTc6xGZdfLNy+GiA1YJlmbKeLGDX0PuzeaCymK3dNzQZJIdOF
	 hEbfqou5hF1hlkKw11bJAsgHspMbo+eYFiQsD2nYOaqcnvjW/2+pQxah5yGYBWAdQow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=DVprFqwV;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE0D606A321
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 20:36:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FE0D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=DVprFqwV
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c50cc7540b7so698609366b.0
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 12:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1795552596; x=1796157396; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eJLr5+zjtN2zIXLilCqA/IW3JjEHhNR2k5tn4GAGSN0=;
        b=DVprFqwVG+CqZxFOhrPwTOOUFwE6Xg3/Col6fPRGNb8237f1+rU1JJiCfZgGMFpFCc
         +n/2jM6INDpG1bHAR64IBgDQCf6IpT/7CKMtvm/EUK3TXux2LOZ21PzVmDQKRbJAKIyz
         +PAar+PskwlTC9R1fi/DFw92nqkA18pZLu4DU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795552596; x=1796157396;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eJLr5+zjtN2zIXLilCqA/IW3JjEHhNR2k5tn4GAGSN0=;
        b=J6lA4dXaDggsUcPFx4I/xFQX0gYksRHtLkFQnu+V5xhczOJYAMj1qUptMskaD6w+bQ
         zlCoeWZJ+rRVeLzA031xiyrpSHAikL+G20Im1qwU3JXfO5GqWN77fX6wvHi7r6mO/d+/
         RWVayAHNvfFkQXfzA37p/maZ0qcQ5HlAPTnbIo4AnIXQjwPX9G62xDwZQ/EdUsGT/ANJ
         7l0351mGbyfcFGNEABPDdjTVkU1s2wxQ7Nt9XJyPRJfOGKxDIkVwlkdxwExe2XwTHuRR
         Ek7EX+MMn61oyYEBdfD+TrgulCtSSEACGQz7kHA9EE4rN6kZj4HywVGjUjb5mglYhJaE
         mcHw==
X-Forwarded-Encrypted: i=1; AL+hErHFLrkgOG1oSQkGRWLxElEVWbojkreamVOdgQwk5VKHKsumHLwH2cT201LB8nRgekKiqfWHv/njz3DF@vger.kernel.org
X-Gm-Message-State: APuU4Z8WqV8UwmRm/GkBXgeMA1Wt0Tx2o48zHyK/nWcswiao/cDb7hjg
	OULuqKFwr9djXU3Y8Y7ThluSwm5txc9yfmxfOuxS1Fdjvdlh2jTRXxbINLYkTN4bGFqrGIS9fGN
	kz3Vl/fvTpA==
X-Gm-Gg: AZFdTZcq+KjjCnIaCkONW/7caZjZtlgiuZ6R+66zZyJrkWtrEq67PlbK3EfFdlgANNX
	Pj0FECqC5eFvaXktXuYj3J5RCz0XOhUf4ZCOHkJT+a2CU41yB0UFwoZ8DNKTc2ESOX5ZnkUljiP
	Iv5n/uOVHlzqE+WT5MXLvjD9pVmgktmpHKY3ALGktxaYh2wyYOzfpQ8mSHyKqfr4DGXas4za1yt
	NKvx1cS3YTzjjOSEVCXbUDzssBWgam14h7MmCd7Yy1fehJ3np+tm4ehygthS7ZMec3GJtnXSjUo
	sx8p8q0R4rgAahLwNSPkarJ1v7CGdk21tvbgkr0r69LJvjHtpmfXnZS2liral/uAHfUlm+vF6Rn
	viWYQM8P+BPkTMXK+H/VEsaU91nqcxkPhcV4i6Wzkav16OCzKP9Bb+gigqbKlptm+ACLoDUunto
	xsiv6dqM4eFpFv4owiomgOYi5Fh6EBb4acPr92w2SPzxZ7REm3urhRoocqpSxTsDxVbSR5XOXrR
	9bojlh3zhyF3XetYXFC54UI8/xT1rD1qf9TRPcB/rIC/U6koK5/OpRR/YLLPa5rSk76rHb/Ibu8
	2IdWXM5z9jjPZUmKIkhgZbI+qMQH13QHtDDVDtu8eXqWXfNC/ho4c12YX+ZBAakRIeeaOUy3F21
	qOqI=
X-Received: by 2002:a17:906:9e2b:b0:c26:2a2:b91d with SMTP id a640c23a62f3a-c513a39f13fmr1065818066b.6.1795552596508;
        Tue, 24 Nov 2026 12:36:36 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afc2579sm534123866b.52.2026.11.24.12.36.36
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 12:36:36 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b8a52db5f9so6187202a12.3
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 12:36:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHsh9FIl4id3TKKozTyKnhJRrmB4ndVgux/S5O1aoJ0FHBU+1Iy0Wm9RAnA2JxBAHgNMV2lZL096O5D@vger.kernel.org
X-Received: by 2002:a05:6402:2484:b0:6b7:221c:beb with SMTP id
 4fb4d7f45d1cf-6ba37ac6648mr12169260a12.0.1795552595842; Tue, 24 Nov 2026
 12:36:35 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <awW86EI5fYafQx-o@mit.edu>
In-Reply-To: <awW86EI5fYafQx-o@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Nov 2026 12:36:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whyUfwzMDMTpih8Xs1MxmhwTCDAc_YwUSZG79vXFMLU=Q@mail.gmail.com>
X-Gm-Features: Aa3M54piJ-XMLaeN1Oeemqn9S4xWtQbFhct3GZIUhtcFVjPISsbDehuY56nJB5M
Message-ID: <CAHk-=whyUfwzMDMTpih8Xs1MxmhwTCDAc_YwUSZG79vXFMLU=Q@mail.gmail.com>
Subject: Re: [GIT PULL] updates for 7.4-rc5
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, 
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Nov 2026 at 08:36, Theodore Ts'o <tytso@mit.edu> wrote:
>
> The bulk of the new lines was caused by adding KUnit tests, which
> makes it safer to validate AI generated patches.

Honestly, I don't think this was appropriate for this stage. You
should have kept your tests in a separate branch for your testing, and
done this *huge* update for the next merge window.

This whole notion of "anything that is a fix goes in -rc" is bogus.

I've taken this, despite serious reservations and some bad conflicts
due to this braindamage.

But next time this kind of sh*t happens I'll just ignore it.

STOP THINKING THAT YOU - OR AI - NEVER ADD BUGS WHEN YOU FIX SOMETHING.

There's a why we have release candidates and several weeks of calming
things down.

Yes, I'm pissed off. Why the hell people have such a hard time
understanding such a simple concept is hard to understand.

If you think that "41197 insertions" is ok and cannot introduce new
problems just because most of it won't be compiled or becasue they
were fixes for other things, you are full of crap.

If the bugs were subtle things that have been around for a while
without being detected by AI, the fixes by definition are fixing
something subtle and rare that nobody has noticed until now.

And that makes the *fixes* possibly buggy.

I was going to just unpull it, but I dealt with this and am giving you
a fair warning instead. Get your shit together and stop this kind of
idiocy.

And tell your AI companion to get its act together, and do any new
development and test-cases ON A SEPARATE DAMN BRANCH, so that it can
be merged during the MERGE WINDOW.

What's so hard to understand about this?

And yes, it will mean that *you* have to deal with the resulting
conflicts while running those tests, but dammit, it will also mean
that we don't introduce tens of thousands od lines of random crap in
the middle of a release!

               Linus
