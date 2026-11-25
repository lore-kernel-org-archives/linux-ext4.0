Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576056;
	b=LTx8rFuaF7pCTanF271CrJAhuF7Fy2z3ASOWvcl3VXCN5dNmCbicaCusJqiWZFQSDIaS
	 VDkznizkGIjIPknRITGtqP6CHuxuui7sjJY7SbF60RVcsRRzebilgocGgFaxtYPI1zh5k
	 cH5R2EP4ZFu2rNc1WsF9Hp5xnH3gQmTml+eUgPY7zmGCK1a4lyUhDdPnFUS/tcThpg8nS
	 JlbvAeVf+9/vFceoaY2BHWcIN8t2dtOkLJi65CS+j980u36gozEn9ACFmCcbR9Gs+/tfm
	 SDDcZCldjan4XUgMaNTRoUCpVZQfgtAKg06wqJxZ2T+YnriGcw3MhckEhplkprF0zbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576056;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=CUafj1yXhndAFrMHVKhryVJo/igZsYdELEkxAr8CdXU=;
	b=JcQ828Txb8nEjY6oH5/sJu33d2HJ9EjDXhNvWZFkBeiR4+4bBPTEyyusB2LgUtsiUpiI
	 iXLiJ2UC72pkKqe76CagAWgjjgUonC94e+7OuQSCEc4Yl3337FqH3KnpT+h1XoMg+8a0H
	 gRQnuAdvIUjFkiq9sAqELNST9YgQiGKuaERYBFc8ZdZCogJACz4VJfiZMGvnfftXhVvW7
	 n4o0hgZMeEmbIE8N0+qFaXrlHnfH1BixsPmTz2+nts64XEy/5BGuwidP8j3Odd2ExbLKj
	 CmwsY8EEvtDa1dC7/zqw3ja6CXReEhuh7MnmKJNqDfwQC2wdmX6qsFj9v5aP13EzaZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=DoKos0t5;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB32F606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 03:07:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB32F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=DoKos0t5
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso864043566b.2
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 19:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1795576054; x=1796180854; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CUafj1yXhndAFrMHVKhryVJo/igZsYdELEkxAr8CdXU=;
        b=DoKos0t5g7Ky/m0BUA8mj3mrpacfhJ7ur5p3xnhfCxjYgq6lUs+9IE/Dxyno5laH1W
         /xVxsZdWpdcKfX1r648QQHl1556rp97VemD4bRlWqDwHU32daV6rNLxL0TcrjJdoa6cb
         4KhLCS/mxi8ka1YGA0uOuuO+qIPY+3lPeZa0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795576054; x=1796180854;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CUafj1yXhndAFrMHVKhryVJo/igZsYdELEkxAr8CdXU=;
        b=Jkb4/sa50AB2HxBeDDuR52bh9iSeloMiTlRR2LJlAlo+KCfpUsByS4dtOv0uk7DGKM
         xo41sGA0u/gGiwfexc6DTcrS0wKpmzebXWUloO9+Kcxq3mxBiI0G7003/NJtIv8yaFMb
         ahRfjP+04QkNMuRiO+iQmvTxP3gX7GrU63yON8gfDpqv0bkTWbQtZ9GA1104EWbf49BI
         CnBgtb+IeLiVATGHmxMGmZCKvzYxlBB/JjMgPAuyWNpKmSXc6OVBlNYW0aqETDNG1XtN
         2TQBkVwsxoxRRh7Pq75kraWY6XUYACxj1GVY+ESCf04WfY35GbgFgWwX+KJWP1wWT/s3
         /OXA==
X-Forwarded-Encrypted: i=1; AL+hErGACheH2pzOCp/cmMLpIeXuhlR+ev5K5+flduG+riCn2Iu8fiSTbImY+jdVXWjRtp6yukkLGmsxMn+h@vger.kernel.org
X-Gm-Message-State: APuU4Z9jieY9/mwB7vAR+liCr1Xk5m8IK2YLqU3yFFDUEkLxjkwxdLm+
	Ua4TbW9JsdPVK0ha+UzW+36+DBMVeoB+ym/IH/B4Wvzg46IvBiWCk8KQt96RbQZWZFbcTC2QnGS
	/USX+DRM9Aw==
X-Gm-Gg: AZFdTZewz4YnVeEmfj1JNQd4Mf0k9wwTplEiZae1qt4EJvVvEFaJZYlg2+yrRfw9Ecl
	TCjetLwsl6WMHi6ZAmrdvf3W5i8fBJuNcL4gHLwqCMig7UVyRKoYZ7e7TM1t2Nxkn//rKoCFgI3
	5NQRqEoZztnt5X1MW8x4Uq7H5MzhdNY1AJ2CALPYVh/f9kx6lo9yZv8tK7VVppFvaNiLnsT9ROB
	5t3rgiDlDbyYHQfeB8B+CyHODIRmCKoeosbLc2xgcL5j5+85SU3TZmht9Blg0olgciqf/X8kByM
	cUKR9X+PrP6WVaKfiDaN4D4a0tpyccJIUjCBi0cv+QhYmuPgDItlFYZ2i4PeEnkfFOfIszWJKPx
	EII9uH405dXDC6MmhQ0C+0TPIdwKb2O+3TdeYHAd2cnC8PokvlkYhu83kbmz9r/pqi8a5zNm8zB
	RESmGLxbwlvtLDfAuK46j+DNwFWSYaRnebxFzUca5d4FQI/90MJzGl+PzLmQTAGHz0A44E5ym2i
	c9QlRUYo6UpKjzaAfx7tkEUCQ7fPCAoTDMfXrzq4SyTtMCIcmCRSVyD3bf0Bxc94/6fk1DWv0tE
	ZVvPrMA2cpZoYp+OSMruP2/qk4veK+Wca+s0/QXB5mZYuq9VMa24kkDij8AooC1Ylv/5oPqjhiO
	Ceyo=
X-Received: by 2002:a17:906:9c84:b0:c44:16ad:c31d with SMTP id a640c23a62f3a-c513a3a720fmr1448699666b.4.1795576054059;
        Tue, 24 Nov 2026 19:07:34 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513acff65bsm609963266b.4.2026.11.24.19.07.33
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 19:07:33 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b87408c797so7148320a12.1
        for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 19:07:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHR97PJNcX76lbgwZ5fwpkTF8zmzde8hm+0bKyuUwtFgVWfptXA40KRb/x7n0RjqzBe0G31OJNlHXY4@vger.kernel.org
X-Received: by 2002:a05:6402:274d:b0:6ba:95c2:7512 with SMTP id
 4fb4d7f45d1cf-6ba95c27b99mr7047608a12.12.1795576053551; Tue, 24 Nov 2026
 19:07:33 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <awW86EI5fYafQx-o@mit.edu> <CAHk-=whyUfwzMDMTpih8Xs1MxmhwTCDAc_YwUSZG79vXFMLU=Q@mail.gmail.com>
 <awYonzw5rsvf0cnZ@mit.edu>
In-Reply-To: <awYonzw5rsvf0cnZ@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Nov 2026 19:07:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=whFaGFFcyyWXvm9NEUchjhRHSa7LbB7ki3SzWKcRx3xJQ@mail.gmail.com>
X-Gm-Features: Aa3M54qFs9GPvdo-tQgVAcJ0Pp0N8DDqDCwWF-YWiFCYZYqnp6OC8FnRyFwqSiM
Message-ID: <CAHk-=whFaGFFcyyWXvm9NEUchjhRHSa7LbB7ki3SzWKcRx3xJQ@mail.gmail.com>
Subject: Re: [GIT PULL] updates for 7.4-rc5
To: Theodore Tso <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, 
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Nov 2026 at 16:21, Theodore Tso <tytso@mit.edu> wrote:
>
> Yeah, sorry.  The tests were on a separate branch, and I deliberately
> put it at the end so if you had objected

Well, I do kind of object, but I did do the merge and while the test
infrastructure changes did cause conflicts, I don't think it's worth
undoing.

So I've pushed my merge out. Do check that I did it correctly. The
test resolutions look "ObviouslyCorrect(tm)" to me,. but I didn't
*run* any of them, so they may be complete garbage.

                Linus
