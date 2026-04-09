Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC18820E030
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 00:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775693761; cv=none; b=nn+rPi8Vww0mzElEoOueNZowYJ4nVc7ejAevxNe2UMtVBpYqk5cIUe8qVo674f3TWD0pbfxl17MfxgEQQEDXlmgAP7CBPG64P/rlZPkwvSpJbypR0vINbqFoUMnNS1kNgTendW/qv6jKv3iWiyWS+yw0ixB7V8Bnha6oTKd/O+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775693761; c=relaxed/simple;
	bh=onvyvMxJh7UKD/t36rqIrGcDEfy6BFwtyVraUGbLzC4=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=eOtbynE+qrpEWNK7JR5mWPc2GVhxdu5uamZ8CUPQ6FxMPAUHlVUh1MtiLIof0/PMtPWWcIYlbWJuApJZLe7z7I5ovrdN9k1Lfh72/aCxzX467MHD/YYTo94cStgNqFnfFmTHs9AiEdxGfK5bFAXqJytdhIdMhTR6gwIblXKA1Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fbtDwk/I; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fbtDwk/I"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d7f09aa39fso398996a34.0
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2026 17:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775693759; x=1776298559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wnAEjEllCMkNmnU6SxzJLp3EKy3h7hXrnH8kOTYBGnw=;
        b=fbtDwk/IxNOpKEqIOrddrztrNq++y5ljLjWhFSGECECW1CPXYS9js5haAyXeLwSRAL
         lNddVB3ARVVbfK+qRcznAJ/3Wb9rB4KfQr+oRzcgNyNSgn3tbZzUtCmJvdBvSGqD/VNh
         wlVUGzo7FZ/VCALW4CrtIZeQCnT/WO0eFLJ3evGAkZn+1Np+K0wC4As79kZMYw0Pumxu
         Pf64mE/omFc2oZkQer7faPtCHsfxHNL762pdEcVtBh+Qc4DnBfgc02BKHeGZoQ0ClCPj
         09FDTp38YJpTbop7qol/jthD8XI+5PJ2+tRcwTLSAyX5wJj34rcYmB0MoWzqpHjyAgMT
         L+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775693759; x=1776298559;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wnAEjEllCMkNmnU6SxzJLp3EKy3h7hXrnH8kOTYBGnw=;
        b=DG8hns+TPszn0pDNJ2h3XK5JsPD8ux+4zUQzN5PmZf6jECgOWIVwzAJGsbozJ+BS7e
         2YqaUmClazynK0gDunpg99qoo+VqAlU3LTsxgGBc53cU7SD4aZ1USIhWtBOLIGMwFPiq
         fgIB0HemgKLKk6BPtAbPRHxUIa+WYTKMRxH9TrLMU0G9JtE4T2gXEzuTlQ/vR1ceFSJ5
         dlDPpHpwvTKO7IB0OMJAUkwQ7DOLLdTL8eZGBj7k91/frVjSy67l+k1iPf1FD1YVTsV0
         cRrughU8Ja1ZxYmLJ1npKbYdtu70FWvkiU8J+EN9pBd7PCznUPCozbbXlMt9d9CEDU8n
         DU4g==
X-Forwarded-Encrypted: i=1; AJvYcCVvBHfOh9ditA5XyHgfq7iLxijfXp+hLhkc6V7X0aDFSl6ZA7QrGc5DtU1DY+mLnzb9ItgVnNM148tr@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtk1UPpB3ADprdvsYw19DgMw/fKMBVQYGypbL1e3Gj7NGLMplZ
	ujLToVsWNfWq3JLsHQvhnNjXwx9PH4TNvD4V2ah2KXtbl35qibviGT35
X-Gm-Gg: AeBDiesk85jgb/YHw4Qj6WT13sf50QWDsiFKBtGK0zhK0VYUjcIcj7a3JaAVtYnYfFP
	xGkDJzICaGhENz2oF46G/94HfIUZOtKTvib63ZFeJFBzhE9TlIzGBFuEg/7RtNIHSuyxl1YYorY
	cFqVl5mx7XILnzgz09GNwr6pc/Fm7EJBmgCib9pRKZuB7RkHLup/VzaaSbY5SXFRmO8HwIh4xlP
	pIouN+2iKsxbYMS7uyNQacgE0MTwXrcbGbLrJYjUpUUzSjVWTEXP3pOqpn+gQ2ZByrd3Ux7B7KZ
	UMLJ92f8hKyAKXRuPNeZfjfpgbNKAmNilMwLPyUyVA+qI6dMLIbETorSFvW07n85JR9KiQ/LoBr
	YtRBveOa6LyZVecBgxqmwby9xJwHOvf/zb81uTk3Xmop+nxByjmiJIRH8h9pCGNj2Bw+46vlmSi
	qGdQCTeWRB8AZWTvT5dYZzd1DC/zlakPrTq90FKO6Ca41FdivOqhjW3WeMoue+ajW8a9azuwksf
	jCiY+lK
X-Received: by 2002:a05:6830:43a5:b0:7d7:b6f0:c609 with SMTP id 46e09a7af769-7dbb7289cfemr14631507a34.24.1775693758519;
        Wed, 08 Apr 2026 17:15:58 -0700 (PDT)
Received: from [192.168.50.127] (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba72fd409sm14997234a34.16.2026.04.08.17.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 17:15:57 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
Message-ID: <a0ee95fd-9366-4ddf-a5e8-bd8431c1738d@gmail.com>
Date: Wed, 8 Apr 2026 19:15:56 -0500
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/6] provenance_time (ptime): a new settable
 timestamp for cross-filesystem provenance
To: Theodore Tso <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, dsterba@suse.com, david@fromorbit.com,
 brauner@kernel.org, osandov@osandov.com, hirofumi@mail.parknet.co.jp,
 linkinjeon@kernel.org
References: <20260405225442.GA1763@macsyma-wired.lan>
 <20260407000558.417-1-DefendTheDisabled@gmail.com>
 <20260407233618.GB12536@macsyma-wired.lan>
 <92e61267-eb24-4f94-b9a1-e009b5e00d65@gmail.com>
 <20260408133324.GA18443@macsyma-wired.lan>
Content-Language: en-US
In-Reply-To: <20260408133324.GA18443@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 4/8/2026 08:33, Theodore Tso wrote:
> AI models which don't consider secord order effects (or used by people 
> who have different priorities than others) can result in...
> suboptimal results.>
> And this is why it's important why it's important to have humans in
> the loop instead of blindly trusting AI models.
> 
> I'd also suggest that you consider the value of patience.  Linux is 35
> years old as of this writing.  One of the reasons why Linux has stuck
> around this long is because we take the long view.  Sure, it might
> take longer to shift the ecosystem to use some new interface or new
> feature; but everyone will have to live with muddled interface
> semantics *forever*.


> MacOS doesn't have this Windows-style timestamp support, 
> and it hasn't stopped many users from switching from Windows 
> to MacOS.


I think this thread demonstrates the value of humans in the
loop. Despite my efforts to be careful, my earlier claim that
"Windows, macOS, and SMB have supported a settable creation
timestamp for decades — Linux is the outlier" was wrong. macOS
doesn't preserve date created on copy either. Windows is now
the outlier. Working with AI, it feels like drowning in
information which no single individual has the time or ability
to fully verify. Your years of experience caught what I and
agents did not.

From the sound of it, the issues with rename() will block an
upstream merge of a kernel-based ptime. I can maintain my
kernel patch on GitHub for those that want it. The file_attr
design work that came out of Darrick Wong's engagement was
productive and worth doing despite this outcome.

I see long-term value in our discussion. As agents become more
involved in projects, this LKML thread will establish ptime
as a solution to this specific problem. Someone migrating from
Windows to Linux who asks their agents how to preserve
date created are going to find this thread.

The tools I used to build my kernel patch didn't exist six
months ago. My AI harness is just as much a dependency, and
it didn't exist three months ago. My harness undergoes rapid
development and increases in capabilities, even without newer,
smarter models releasing every few months.

I think there's a real risk of a negative feedback loop. As
implementation costs drop, people who could contribute to
upstream will find it easier to build and maintain a custom
stack rather than try to get changes through a multi-year
review process. I think experienced developers need to lead
a shift in how contributions are reviewed and organized. I
think the key challenge for maintainers is figuring out how
to work with a new class of contributor, and direct them so
they work in a coordinated manner.

Thanks for taking the time to engage with me.

- Sean

