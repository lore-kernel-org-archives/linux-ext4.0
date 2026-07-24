Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5415390613
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 21:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784929820; cv=pass; b=keH2TCLYqLCJw/n6H1O9YVh22LBxkRwdIfO+n+54OU1E4BCHjm998cDZpw4e1W4E2s7QQ4DsPkWKFmxW8ExUmhWL9jWSc4+ZZphIpf5DW8GCu2hkP+8N436Lsy25DBQAQRlj8cVfinPIW1H8+NhRU2G7hL0N8nUEPlBj4DnZvpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784929820; c=relaxed/simple;
	bh=GONOZECKD4VhAKuWjYwwp0qP75BxUV1SGAkrOKq4bp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ek2WkWm2ZrJsP3KltPhl9s3cJXCJm4A6CQSea6jXsl6E0NUvKCcAp69W6tRzy0+Wm+UIFASk9FlXypWFZwZE7BPK+8/GPf9YoUV/xctQNKpiq4byO6BIB6wPTW/SCk48pzpZ5fya7GVSrcKkW3annTLzX8K6K0bzg5N6BNnlOu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ahBrZtSs; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahBrZtSs"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4954c0833b4so7319955e9.1
        for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2026 14:50:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784929817; cv=none;
        d=google.com; s=arc-20260327;
        b=C3BojznL1zLJcUpgYQz5XCZkHe1Sc0OKk1xFeen4PsW/boY7XCIihZADlxNntFNY1q
         yWUyjrQmzU8StSzaA6RvjoCjMY0CSTMAmuqdNCDZTGwx/xVJQv+CX0+sFf4dl1ABJ4Lx
         0DCtZHtol+CMqnNjeeXo/Jhhq3AWuA6YodJDatromA7LKltt79PZT4LLuhtLq3ilKOKQ
         byRMA01WFZuoJvk4E3ujS16UmG4zW2WM6WHdjs/U2tlcmzg/MrC3OzMZ3ReO9eGopC5A
         pFVZ0Mm1vNMoH6keuA/MYDIhbn6QY8BcFZb4/Gks0bmE6RTkR4KxAu3PNPf7rMZrZGmq
         KLmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PcTCJx0iNMKEVpJqVWQmDz8mtFGHipUozPuux86X/uc=;
        fh=mnnJyw8P1yYfnZqmSLiVoUin4+1EGSNZBqmyKBw3DyM=;
        b=oIG1OABMMxkEgXuOM7v8ROjjjETjsHR/xVEy1ScpC9LbVKgBS8Qr2ztnk3Lt9Xss8d
         L2Rr7U0oH32lAfo/AfNNvUkuW1bP0l70P6k1oehQtqHjwHEn0hBbrev5rhAnWXrdgows
         nKmKBagHzc2YWy22Yy89d8Pdi+owTmsCx5twrt8uivTXBqAxmpBCpffSOd8wmord1OH9
         VHHC91+5ic7M/aJ0oH/z8MoAnoOc6ThL0sjhZQBOp8vBKa6yZP2gwBH4W7rtl6wutxJA
         YhhGzXerNwKWrYOtqt3p/Cf4ul5mvYjRnU2tbVdaUtMlMI9AaBLhLhH0K0SZrGK+uvmZ
         5+1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784929817; x=1785534617; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PcTCJx0iNMKEVpJqVWQmDz8mtFGHipUozPuux86X/uc=;
        b=ahBrZtSs67kDaSkppi6tu+bKx31L3rQSeMDpDEDVWSOM482mlwVnGkh1+3MeqMFpCO
         qwyVbJN89xtMCvMRHPTYRIo+HAf7//5hh0/ex81bcERPxRuFJ20BU4hz2fL/DflhZuzj
         TEzQV3rnp3dNrnx9O5rxuHaqrahc/iMWlxqarNiqTj1qTQ8W7LdyyajfPBVITa9iXsVa
         KiQ/FKgEK5AWan6el3kuE3ZDOQnxlIESXECaunNhnkrrlocLWIyHGyE6S/qPY98dHCQ7
         xvivZBhoBDR4qLdHYCSeLYD361CthJLfjAzB/jRFHqgNJ+3ht/Rf4cW/fcl71KdmePTS
         aXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784929817; x=1785534617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcTCJx0iNMKEVpJqVWQmDz8mtFGHipUozPuux86X/uc=;
        b=Z/H4Pp+8yztNmaYLVi3rSCnKCQ0yY2FgXvSZPW+Hm/XW+pyrm+dO2HZ154/lpXGOSZ
         306TlRYHu+NlPqmlCSFnTtbXJ+7KrYimfTSArBvszI6gbHBMw5ySgZCP7ec0yQ4K0w+3
         db3byN1e8g7vdTCLseXCmOp6t7o6MafE6NERdoUWrBuqs9Rf4LA55bfScm+oyyG4cDqb
         LMPU4F7A+VKh5m5MPyq3Xc4vbydhFSUO72PAaJP+TkPgky1S4XzsZKy48cTLuE6DDI2q
         jpZW19LLNf/pkZWwDVNBGE5eQNW3wr5IjBvfBBCRp0jOIYOrEoeIzO9xESn7XOC1W7Ur
         lZjg==
X-Forwarded-Encrypted: i=1; AHgh+RoLLBLblptRauIi0eEe7lG38Mv17n+9WmlFkO4RfeF6bhCm5M0PjwiLQuzd9jIK7bf3TM14bjH4MveY@vger.kernel.org
X-Gm-Message-State: AOJu0YzOoQK9/2OwVQjfwOf+mEbLl8nyXRouhFH+1/iCExStmi6alW2o
	Gggh/rDS47JHkSEqIH7mAScGArWi4Y2VgFFfElPwbwN6k2FCcf4Qj1lm8N32rrUauX4eeReQ8Rs
	GWDzSOqKeDJq7ZuXoiCB5GqC1xB/Fkug=
X-Gm-Gg: AR+sD10ScUR+sNCDdgU+lFlYyVwyb7TrApGncdxg3lRPrQSQ/4fHq7xAKpRQ6KTH2jJ
	BnKehl02aONjBqJ5UBqGt24tZBbdgzpK10yC2YOH1bXeOiJJ7lUBX0hZNz4VqY3TItJfhGEsAwZ
	eSOpLp06YE3Ubab+nwynBt0fE+XXeNuYdbHxXUkge2ua5Pok8Eqa+upr1oJmA9khp4nCed+pLjU
	rrUk/iH8Vy3EvmCkibB8ZQU9DP5rqUqTge6sNW9KbZE6rG7BQsd8dHRg2oEP0xRVumLoVALZwun
	qHygCTZiZeJQUIWqHP/YdqXWN/+YBoEUJ43ec4K/EQ==
X-Received: by 2002:a05:600c:3507:b0:495:5dcc:52ae with SMTP id
 5b1f17b1804b1-496b56e6f5bmr907305e9.3.1784929816876; Fri, 24 Jul 2026
 14:50:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723050201.3381045-1-hch@lst.de>
In-Reply-To: <20260723050201.3381045-1-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 24 Jul 2026 14:50:04 -0700
X-Gm-Features: AUfX_my_nPSev9bT-9Z2cTW7X3xJ7bo6cpxTit3ZoW611uMe8LHBds-augHG3Tg
Message-ID: <CAJnrk1a=83CxXxqaV23dpT_-QTYAoz1pkeGXDU5H0stUW0kVmQ@mail.gmail.com>
Subject: Re: decouple simple direct I/O reads from iomap_dio_rw v2
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, "Darrick J. Wong" <djwong@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 10:02=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Hi all,
>
> this series reworks how the iomap simple dio read fast path is called and
> decouples it from the generic iomap_dio_rw and the iomap iter.  This is
> to make the iomap_iter_next transition easier and cleaner.  It slots in
> after the first patch from Joanne's
>
> [PATCH v3 00/20] iomap: convert to in-iter iomap_next() model
>
> series, and the first patch from that is included as the first patch
> here unmodified as reference.  If the approach looks good to everyone,
> I'd suggest to include it in the next spin of that series.
>

This series looks good to me. I'll wait a few days just in case
there's more replies on this and/or the iomap_iter_next series, and
then I'll send out v4 of that series with these patches (w/ the typo
fixup Darrick mentioned folded in) included.

Thanks,
Joanne
