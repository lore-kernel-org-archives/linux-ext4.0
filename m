Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5852FFDCB
	for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 19:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776627493; cv=pass; b=d1or6+6JX8WuO2mQB1pKQUix3v36mSuCePhGWiUEmr4pivTPXIfAr2iosJP+Cwb8ls+3lQJgO9BtnZcIFmq4awEqPeqHmvlp3C/o9g4mE77r+hYtoJ9RyU/ad47eb+sGkNpOWeqwB5/7eq5+CK/Vw2Di3A6tErhfhE/IrIOLJQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776627493; c=relaxed/simple;
	bh=FCYG9M4TPg2JFLoztHS5vKeqyv3nd4rXTjH6N4/PBDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lfPqw38owH84p2EszxaQsFsqSsYBTHzGa8ZbjoiCntnTLX5BtxrBn4Dyt3MT4lqHusD0XAu4UOfyP+46v71oV8TGoDjrVUfmDM8nO8kBMqeOClwDeRSb0PXv11/FvwyExzjoqGRPX9N6v7Opcmwo/4kI+0Q5o17MfRYFM2Ua0Tk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WL7HgpI5; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WL7HgpI5"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-652fcd5a6d7so2761622d50.2
        for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 12:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776627483; cv=none;
        d=google.com; s=arc-20240605;
        b=UE8+RaM5hXgTipzd2CItzdYGPA4fgUgsszG7nsNAjtikjzAkYDC9KiiHqgA9VTfg1o
         k6Xiu0no6K+1sRisLN7gjgmVmo2OEKEAG4tC8E+eKjOZqmFxHQV2aw5DCT/YjdAlRzmE
         RkhCvOCjf7k+KhxwRESAhLpo+njSPDd0xUb7N4YZXlIRnyG+qYazJ46laQ0CxEKnqSfb
         FMpNc4yMHJYaPVi48iQbJ/Jv/v+1HPptIfut0AY9woZNh4BzEkcul0oZ018WEOi2b0DP
         ecTJRjTRZRIHjdW4FtdNFFeMMyI6mrKDif407Sw1FcV39SU6OqudpnZu9HDGwUx/OO9Y
         mquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72XWY7KIZXCndujXldtBTJTCi0s+MYNlKHR/houzcKQ=;
        fh=ZXzCTLP96GQ9s1mkoT8A/6ykle3yuM7Qc12HgK20yBc=;
        b=Ubi4r3HbVHIu5Yxy+iniwpCclaSJFdBkpvadvLIZJzB8u74UrCsKrQW69R2FRlmCx1
         WUnChqfgJwYnDB6OZii7x+kX6A5sq5AftujvaR6zZWjs8O0Mrn929Jp/vUNa8uPDzx5n
         fFAA8sYo2uhyMkwA9iFJNpIuBnc7OFklVCIzaVfxAXz5ZCiJx5lH9bOAufUONReUO1iM
         NmKrSGqX03eF98bogkegNGJCycbmC5TvpeRvvaxyObM3FhuCgeCR9P/4+Lfserx4u7LD
         hJqeLBSMKvkziqY9Li7jfnl9Ou1z0SAIvQpwbLAPdsxl3HC/5exrvPiAYl5RPAFaTfY/
         K8MA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776627483; x=1777232283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72XWY7KIZXCndujXldtBTJTCi0s+MYNlKHR/houzcKQ=;
        b=WL7HgpI5hN/Kaz7bTGHXV62V94NLlGHZ17RTszN1Jq08mEqSVBz2ctAEnchWnFhsgw
         1VL5vVWbZvLzkVJrHBVNWObA57cZpEnkzpIR/Oq+1sgD02x7jpj8I218dI39umVv9qVh
         fmfmJE7PnXsFPWybCyKdnRZGWPP/gH7RYeG9SmCLjUHasHHJJcIZ/r2RQDG755TSm+T5
         QTJ0KZmawXiQj6YxB6mxGqpskXWLJwQNIrIOC95qDjeLwcBtFdgH6outnk06nY01C1QM
         hHDkqFUozTTjpTji+TeMzsRYEHhFfgmzdmWlv5SELs2IDEHaCPUiI4xH3LC0+5PB3s1M
         nUVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776627483; x=1777232283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=72XWY7KIZXCndujXldtBTJTCi0s+MYNlKHR/houzcKQ=;
        b=qv3NPWedaSGGjWzZrWQ9FAWrIAflw/j8K83fLn7hJJ7rLRCf7Kl9zASuBUBRgZPvQz
         iLMQI3LbY0kR0vGBaXbSV86XjMUgfwJC7kFq4bzYJxOaVhllS3mITyMZdPU2c8gCrUPf
         rmaiHPMOhkIPqc6mzmBYyesb4l2R0S6yE8T6d5PDYd6WWHJ7/b/rOcsd+4b3GFdHcb08
         9Kz1B0XGgIxt6j49aW4rm+9NPMWmrLN2kr6mV+glQiYqcgE0l7bRAXfHBgBsCFNjFt11
         Onj4+KcKghgRatZftxyKDmdL2bcPQAlORsnSh4UUQnHgATJVw9Ziytecr5Y5YgUknPCa
         wOJQ==
X-Gm-Message-State: AOJu0YwYmoetONEKaZqskw5pufKoHQHWOij1eqIXe9aDsp8vITYXpMiG
	JbSglgqxWDCHN8EnGeaSC9lo8YGEO+j+FDbF1R7C4P5+9V1iEZJbqidkNqE+KVZ9QBH/UfUq3bk
	lG0mG65nyNHA1qe80ZzG7ZghbE/VNXfY=
X-Gm-Gg: AeBDieveLlJv0jQJ7T+df+NJDJ/hy7zIOPiCxqAaEC1nlYeV2dxQwgl890AQGzHekNx
	Bfsim6nSA2/wyUjHSATS7SIil9Y0jhXhGat4d1vj5lP69mF90QrVcME5Ng1E+AZlXz3hcFL97dD
	dJfQysm+G3Am3MDA9zl+Gjmp9HUfXetXneOLmrYWmdaFahBP0DnIzy2o1/xS8qztR53+MwwLmjc
	TgZ7fluwKgLwT0dytrTRYnOTzOcXoCwDGUpQYJpkthmK4lkutU32hEibssSrX12mNDt2W4DVoE5
	WBXC93DRZXUvS3A9D9sYB8qJiykj++ZZ+l73y3keiJADQYoIUk0r
X-Received: by 2002:a05:690e:1282:b0:651:c29e:f0b0 with SMTP id
 956f58d0204a3-653107f0ad9mr10994531d50.4.1776627483125; Sun, 19 Apr 2026
 12:38:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
 <20260418214359.GA58909@macsyma-wired.lan> <CA+rD4x8uk7h7dv_Mg1tMXXiVZZD1YAj5WAw+6GNuMKQAAMueuQ@mail.gmail.com>
 <20260419004716.GB58909@macsyma-wired.lan>
In-Reply-To: <20260419004716.GB58909@macsyma-wired.lan>
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Date: Sun, 19 Apr 2026 20:37:51 +0100
X-Gm-Features: AQROBzA53xSfEz4iR_2ACriw12V6PNicjtO1DL0wb9VRqVHq0T6SG2VMtiM3KYA
Message-ID: <CA+rD4x_5pRycXgqQ=j3FmZC+Q1KpRPYLv84uY0c0VRtq63uT3A@mail.gmail.com>
Subject: Re: [PATCH 0/3] Data in direntry (dirdata) feature
To: Theodore Tso <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Apr 2026 at 01:48, Theodore Tso <tytso@mit.edu> wrote:
> I'm not seeing that in the patches that was sent out to the list last
> week.  Where is that?

I have just sent it to the xfstests mail list and placed you to cc

> I traced all of the places where ext4_insert_dentry_data() and
> ext4_dirdata_set() and I don't see *anything* where dirdata was
> stored, including the fscrypt + casefold hash.   What am I missing?

dirdata feature should be enabled, and  fscrypt + casefold used
The new xfstest ext4/065 should help here

> It *really* would be a good idea if the e2fsprogs patches included a
> way to list and set the dirdata using debugfs.  That way we could
> easily verify that dirdata field was getting set when you expected it
> to be.
I will send a patch for debugfs with such a function soon

> Yes, but that doesn't actually verify that the dirdata field was set
> when you expected it to be.  Just that it works correctly....

Ok. I think debugfs should be improved here to solve this.

> Oh, I see.  So this is for readdir(), right?

Yes

> Well, the one advantage of having a way to set and get LUFID would be
> if you ever wanted to ressurrect the userspace Lustre server[1].  :-)
>
> [1]  https://wiki.lustre.org/images/5/56/LUG08-Lustre-uOSS.pdf

=D0=A3es that would be convenient. I asked the proposal=E2=80=99s author ab=
out this
earlier today. He said the code cannot be moved to userspace due to
its reliance on transactions.

> And I *do* think it would be useful to have a way to set and get the
> LUFID using debugfs.
Ok. Will do.

Best regards,
Artem Blagodarenko
