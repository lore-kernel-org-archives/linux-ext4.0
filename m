Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794404677;
	b=kXy62lsbz6DCqk6/IJB+uANfMhVrf6xUkubE4yAkLB6gmWIIzQa/apa12gr7opRUex0X
	 9+JxD/1xUrAOYs5VrPw/f3huRfI48yTBBOp6c3FFK1xIImQL9dsuMD3+eP3bdjp/VubWh
	 ZexdfQLXCKdbty036rB7iTziXQbpjJXWaAe1XyNKeeWEiUE021avAJ6aX4/IjatUYvDsD
	 0K/eVmQia5Jlj025Hzp2TvmosyFUXBr81pkeY/MB/9DfQH5mnZFic4+Xpsy7fw26o9nGu
	 abJoJyFFPcmOh4cd9jPrYOZuqDugBpF2RfUa8mGgCr+DbKaiGwi1ihQoo0lThHmwT3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404677;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=nykMBg/2MeMQEccf9258OGWyJYnGf8mjfzIf8QpZ/L4=;
	b=Hir1VlKYhk4PpC6SYgm3bVbXjPArkOGaZJG1NxF9buVEJPaNw4u8mK9Yfm9AEVhuQngw
	 FAsCdZJXTERIF4mJRszplL6N18Bbvj2UVyTf7oEFTR3WwzGHwifJ4mWx66uLkm1pMWa9g
	 fGaER+o0fwpACzBYjbj+R9GWKQRKD4J/3mjb+2jJ/UJOvv0670m9uSbn1K2FUmcVsaD8G
	 0hWuzkzmn/cVCHw0oNvGYPo/MHTLdqfgEdHrvRPrO2N+Cdxaaj7qxBXJmHnMsE282rlNx
	 C8sTKvvME0ZUQn4+otCgdsN7M+ez+kOo3214/zvrrYA8t4g1iACMPQzdqoNq3CwX3KA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=KtsxRMFH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE55606A885
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:44:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EE55606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=KtsxRMFH
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4d28f75d62so431533066b.0
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 05:44:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794404675; cv=none;
        d=google.com; s=arc-20260327;
        b=KPChm8NeF6wdzzkG8u/622+ysE/G9hs/32M3PeRnh0iuAI7ZXBBmyoZqJfKJsllDa+
         +VskLftJQb1poWKdtRQWB4rpzChqWJLwYu1+CanBWpDiwmCjDa2bTN7OKIie5ahjp4q4
         U8v09Mq6qizqDXfGr8xx7MpfTtEnOI26MmGLifxehdW5pU8rQmNnDZWCxsaGzmE7+ViH
         IXnNAo/gCDRlEQKgfppdGPDGwUwjxWSYF2cMN8cemPAZuq8T9IygAMUa2mDY2bRS32qi
         L+/UVlbv/Z5V2goGCTBr4JTrI2z8IFJEIqImctkd0MuDwwWAcY65OeAbjrp+td8Y87k9
         JWiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nykMBg/2MeMQEccf9258OGWyJYnGf8mjfzIf8QpZ/L4=;
        fh=Y2ayDC8zFnKiZiN21sHU3ECHxZSzQvRySU2z8/dY9nc=;
        b=e4JiapbNim6hkD+mWTUubxn6GAXAz1AXqvIZqE/rt17c7FmyJZ3CA1cyMX27fFJFyy
         QMzByS2CtaZjgre+IwlF9ltJuzs9H2B6qAHBWvph57RtGbJ/CvAzN6gwMqNEeS7ztrms
         zNNP6rNH7rXCQTUrF3YLs+yf6eFDnMNHPKLTKbWvT9sf7/RVWduvx7iGho7vby5bUT0q
         uqNp08t4mq4DzA9f8NxGNtrxCzIjwkR/vfv3oQDBDlxXUW7QaIrMpTrlAPuKMWZY8ud2
         CHcBBdIdnPK8lPnZbndgQm/Mzv4uKCXhSIShCiR6WkGxkg8rapHJqni3i7qwZXBxfnIu
         +YQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794404675; x=1795009475; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nykMBg/2MeMQEccf9258OGWyJYnGf8mjfzIf8QpZ/L4=;
        b=KtsxRMFHvnX0U+GBDoK/mDVqPP0gAJaxMwk2kyLGH1SPyI0EllM/7x+ucvXe1E566Y
         92aMIVLaNjxgGJZdBqbCzVViQbHxfxF+vztiwIg8dwM+v3VHUaVwOlMJRKbSs+8c7EA+
         yk2poNGvfT7Ez/rPbuHXOPhbPoUkGvlFRDrN86+ru1e6aZdwNWoYCt5fMeq5UDIiBEr/
         zU8XDaOSVPP4A+i8K9DO6e3O7wSgC1zdl0CtUv/AMwXpUg+8HrtiE5iuYRQ3NwlMzHyL
         4X8NQk3cRb523EwrsQ52c9zXR8ga+OdFaKBbO66JV5rr2eRUDCmNQufOoGfCp1UZZz2A
         E2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794404675; x=1795009475;
        h=content-transfer-encoding:content-type:cc:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nykMBg/2MeMQEccf9258OGWyJYnGf8mjfzIf8QpZ/L4=;
        b=N1Q/SYWoaPEY02cgY1v7rgAJPgs+q1Jj1jJo4nO59TTLfXYXZxJ91YNsuXZmhwqG8P
         Ki2o35r/v4iSxrOf9dku1A4gfESD8oMMPd/XbLZuTc6huZJK7MuielHIT3SbcPAPZs7p
         2ZhkB61951j8gCsHgK61PvV5diHLV0iw+mItEfNnwhLpUZ7RfFLpP7wr1KOU3TdBlbjD
         xFGsnrwGzndpsb7HLWQMPMfIgaHW99lbrNtkA3U18lgzqCsSLb3ln5e6KWQvbWhbs40F
         /C77WSoEXapT5V+gbqecUJE8BIrvq1ANLMfIDjqSZuY8N8o/Am78/bhXiqVGVVwQW4Ab
         /CSQ==
X-Gm-Message-State: APuU4Z9s1F7rvtXOJ8tEJjFY785JqJOIYQXbbNG0tsdodgss6H/7Et+3
	2vckaQNdh0guIx2bTZibfBREMrBerGPYbwQ0S7dOQwhcn5s7LeD2GBr37pOd1ejjhcBSBpV11Ab
	Td2t6SAGeT3gHGuaFQ4bT5MYbLwv5uvv00nGP3n3vJOaOi6LHfKwqaKk=
X-Gm-Gg: AYBFou2/YUEoz+FuzbSsLZDJwhtj3rs2gGVXQl+NB8k3cY6bbdw30jMU/UVm/B+GaFl
	G0lDJ2pHQBMDrqpK9eWjO0wHcND4cPLh+Gxs3Qg4LHujEtKZab6VJ53U24ZPMKYUAv6/ToGJHDs
	IH4eUMTbv16I1Vtv7XYR8sXoRfHLbNoptN3w88aqO5LCkCiBGC7vI6hq/T5/xidfe/6K00QaHMY
	yN1ghy/NGuyd5LfJ4l5Gbix0TfAJeENO1hEAN5TbrF5MN2VbPCLLYco6AkAbFQ9lKxoebw2YaZy
	gkUGY6YaCWzpFs97h05sWogxcb4OKpLIw/xWPsAbOExYqe4Dw8hKNbJ2ZwVNGuDgU45g9qH1zZa
	9TLBuTmSWTT5tC/4AuX1Tr41XvGjjg+3qFAVIzEutM5/CTYRInA4LAlw2aGNU5KXc3w==
X-Received: by 2002:a17:907:9454:b0:c3f:55e6:83e6 with SMTP id
 a640c23a62f3a-c5066a89b17mt156570066b.15.1794404674627; Wed, 11 Nov 2026
 05:44:34 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111125242.1078620-1-max.kellermann@ionos.com>
 <20261111125242.1078620-2-max.kellermann@ionos.com> <sashiko-outbox-209051@kernel.org>
In-Reply-To: <sashiko-outbox-209051@kernel.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 11 Nov 2026 14:44:22 +0100
X-Gm-Features: AclHuK84idtyNkOZcnEsiCWIJqloE9e_NtxMzrpcZAtWp-kkueGVk9y1xQJEQ9k
Message-ID: <CAKPOu+8L6wPNPhADS4wROLBg=jXoHYBEoj7c1UoeLX8g1zZU7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] ext4: make fast commit support optional
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 2:15=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> - [Medium] ext4: build failure exporting static inline
>   ext4_fc_init_inode()

Indeed I was not careful enough when I ported my patch from our 6.18
branch to linus/master.  I'll fix that in v2 (if these patches are
generally welcome).

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group
