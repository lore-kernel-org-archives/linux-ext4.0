Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81949262FC1
	for <linux-ext4@vger.kernel.org>; Mon,  7 Sep 2026 22:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788819493; cv=pass; b=b6i79C62lGBuG7zdeNSCdE/BM8nMJcfIqyuNTjO+bi7x0zhWJmaLs0CQ4r+gvc0gDkDodfhL/ZO8M1gGq3xO+cbBNXtWuq9caXmpbyjWh4Z/UEQu5d6USyrwGyUKI6nj2owvaq5+ub8B0seBzzF7PEDpfe72J/F+lse/9DzY84Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788819493; c=relaxed/simple;
	bh=ZdQ3JbGEBj66Iri9bXPFZvgMyN/PybvpINhIicFF/EE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PpCMPyNrIFiN+D+sdu5FlKAKb/slZpdyXyMn2GTTz3vS7y4Wg0Bu2rQa8KYcPu6LsHEt4SrCEFRg1/scRumga7gArIDLFuTOTWpN3hgcqBT3W3a4KqL87g7kblvJ7MYCDTn27GmY9v95ILfeww/BjClLFkLoxrnRcqpNDHWqZWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gpyxuA40; arc=pass smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gpyxuA40"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e041ea211so3081694a91.0
        for <linux-ext4@vger.kernel.org>; Mon, 07 Sep 2026 15:18:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788819492; cv=none;
        d=google.com; s=arc-20260327;
        b=mHKqYIbXiU3DYXUjIu8AhlKxVM3NSRWIlomq0eXfQcdxyYlt6zaxxAzoHTVkLL5UMn
         yZJFrNgI76dGGcdRPWPmlA4OK3YQ66qIqIr1p+jNLV0wSanxEYwW0RxP8QB6DpAhYaTu
         cpxfEPMlgG7oJcwFZ1Rw+S+Hd8sryS21tc5oSDa4tBtgb2DL9k9zvv4SZaxrPPIuNVj6
         qM0gyu+/PABjTlemHQswDocjtaCgxqTQ3AknGu/pbcDqAFBvuPAjj9cwA0opZ0mGs1Bx
         +BF2pvDRXAM5iutIr/cp/ibn3qP0/BLslkO58KXWiPZjNZrUEaQBZvch+xlgsfVN7IEF
         7/9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jNlTXyDPKBggEGyMwYYgjcO9kU30dwD9XLhdPez1l84=;
        fh=RldA9hPrENv4k4Q5JWCbq84xk2AxKiIFJqopApWMrgA=;
        b=iZcRe+WiPnoSfwpM+iUVBXvR4p9CSonpE0xwbxVFji4c/r2teIm7e2V2PoLe71rrxG
         Fb6vtkCjf2zcEITRRFP77mH4lFI007OVwmvHvwfn554BfEbDIfzdIgORGvPxfyVgtWWU
         rjoDiUSDbqC72Jess59lpUTh3GF7QPMA6vK7s4lSXs3NmgghaTzFvPOMOn/ogibn6zjA
         dIy8oOT28wPjzvtzZXN0HUPpFM/eJeR3v7Fzk7OCURivnO/eakgR3K04OUYD7I/mrtxs
         eq8HEmGGUVsJsRCIcKnBsxwUr995wkUyb5PAJRsgEy3qhjdJudctTLY65FYS8mmTXncN
         v7UQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788819492; x=1789424292; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jNlTXyDPKBggEGyMwYYgjcO9kU30dwD9XLhdPez1l84=;
        b=gpyxuA405pfhfXiGIMx1EziqMPmw5k+AfeoYjX6GWiJH5nXMvUufy17ErKzQJdrJsP
         YFLCQSh/he5lOnjY28WA1eM0VzjJG2HizQf7b53oZ8R9y7JB74tr6RZyRrza90vyuOjp
         niYC8FCUDSsjr5cuJcDL2or9TLjVncQLrnGD3kkqs476rd/txfpJMCDsdgqp8ygpTC6I
         /IaP/YXo/3wecobtyAW/kcfNJA8HOqbWTSeZGfnpZ3SnceW1wX7/M4+levpUiiX666ci
         caCQTir3leVBQ4+QCPkG6zo4zVM1T5kFuwNs0BjykEPUaTFp2333tnIDJWjlLwHrU+QD
         6aeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788819492; x=1789424292;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jNlTXyDPKBggEGyMwYYgjcO9kU30dwD9XLhdPez1l84=;
        b=RmoPYgDZ7e8xPMiFk+awd+H8quXSecwmUaB6YdwZQY5GbTc6AOpfc7Iam05Ii3ZyMP
         BZH52B65kdA/zzjoFJRnxYNiH0mMtRfb1RWrRb1OXC4aH4i4X1cyR41JmocZPa8jdLR4
         skiX3LrhO8v6c+CrbbA1nGPY/zCh7OQtYZHaNWqzYDt29Qugespc7E11hZ4azF7fPnT1
         XzgRLfEUxAjmK761Mf9bgskuysvsWIz8r4dk6qMtZuHuw0iRuIP6HtPUe8Vl5PHQqlw5
         UbeOcRtqTpPUQdKYYhLPHa6evenuvlMxacbL8InnXY0+lALN6bimN/ykfaENRXyMJ6WG
         5Zeg==
X-Forwarded-Encrypted: i=1; AKwUvBzQF6xwJIO4Lp5u9IAA8744UeiUzAYkaH0sn7HIEkkQX3APhiL9lUqF2z0yOSyJKz9obGB8Q2dfTWtP@vger.kernel.org
X-Gm-Message-State: AFuF++lUctKpxqOxRZhSywtMkz6IwvFi3sroxLCYAuQpj7KPXibHaa55
	owACDElsVLSmcze6MS3Q3NpeK3Qzpt9jLFxd8yvL9Kgx5YPdc/6bDHXsJwfqPM+0aagD5I6qnyG
	d3UR6jcaRj2KCQrSOP9dbzR+NjCG4fB0xAxTR6DG0
X-Gm-Gg: AYBFou0P5B76peFPEogwpcFqn/yqfo6DRlLZrXljBCSVJIrv2D4Fc7e5AtXqiwbaPSY
	DDU7KNqhqGwf7mV6Co8YRiA9z+7Lc6mIoqtP7ILb54tOYsQaIuj79VuwGG+fkhZN+3QjazlU04q
	ZQV382tR7DdIibq99HSrsLokxnC4IpMEdwRWleVXtueu1fjBPfOCAHua2+i0QsQj3IhKfRE8hc+
	wZeChedsgIOtIVrCQxGTQUGWBAQKK00cVjwMfU5BUahe5ww48DK3VkTTusvhEBjCdh9lnlc2QeF
	fw81b/1KHQWDrJ3JafNHqa4ZQe9j6M1gFEy+Pzwh6PlEG+2EfCi2wO9ZfzRj7W5fz+3fLTES4WD
	5K/bMfaq1bA==
X-Received: by 2002:a17:90a:149:b0:39b:2b10:d05c with SMTP id
 98e67ed59e1d1-39b2b115ba1mr26085066a91.5.1788819491324; Mon, 07 Sep 2026
 15:18:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903101843.3462767-1-elver@google.com> <20260907221334.GA1619741@ax162>
In-Reply-To: <20260907221334.GA1619741@ax162>
From: Marco Elver <elver@google.com>
Date: Tue, 8 Sep 2026 00:17:34 +0200
X-Gm-Features: AcwNN1Ud8SWGdY6soyCDfiwuMYKmM_SUBGIs8OdKM5eZuw6s2ybWmhPNVxak0AA
Message-ID: <CANpmjNNuiX-rQFvn0GK1SxAbcxEUH7rKh69GPq+7u2tg63qbmQ@mail.gmail.com>
Subject: Re: [PATCH] once_lite: Simplify condition handling and fix context analysis
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Jan Kara <jack@suse.cz>, Timothy Day <timday@thelustrecollective.com>, 
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 00:13, Nathan Chancellor <nathan@kernel.org> wrote:
>
> On Thu, Sep 03, 2026 at 10:16:38AM +0000, Marco Elver wrote:
> > When WARN_ON_ONCE() wraps a conditional lock acquisition (such as
> > down_write_trylock()) on architectures relying on DO_ONCE_LITE_IF()
> > (e.g. arm), Clang's context analysis (Thread Safety Analysis) failed
> > with a false positive:
> >
> >   fs/ext2/xattr.c:825:6: error: rw_semaphore 'EXT2_I().xattr_sem' is not held on every path through here [-Werror,-Wthread-safety-analysis]
> >     825 |         if (WARN_ON_ONCE(!down_write_trylock(&EXT2_I(inode)->xattr_sem)))
> >         |             ^
> >
> > This happens because DO_ONCE_LITE_IF() branches on __ONCE_LITE_IF()'s
> > return value (__ret_once), creating an intermediate branch merge point
> > where the lock may or may not be held depending on whether the once-flag
> > (__already_done) was already set. Because the merge branch condition is
> > __ret_once rather than the trylock predicate (__ret_do_once), Clang
> > cannot reconcile the lockset at the branch merge points.
> >
> > Fix it by refactoring __ONCE_LITE_IF() into an unconditional
> > __ONCE_LITE() primitive and redefining __ONCE_LITE_IF(condition) as:
> >
> >   (unlikely(condition) && __ONCE_LITE())
> >
> > This simplifies the implementation, short-circuits evaluation so that
> > __ONCE_LITE() is not called when the condition is false, and ensures
> > that DO_ONCE_LITE_IF() only enters __ONCE_LITE() when __ret_do_once is
> > true.
> >
> > Reported-by: Nathan Chancellor <nathan@kernel.org>
> > Link: https://lore.kernel.org/all/20260903072759.GA1750084@ax162/
> > Signed-off-by: Marco Elver <elver@google.com>
>
> Thanks, this fixes that warning for me across all my builds.
>
> Tested-by: Nathan Chancellor <nathan@kernel.org> # build

Thanks! I think this is one of those orphaned files - which tree can
this go through? Can it go through your tree, unless Jan already
picked it up with the other fix?
