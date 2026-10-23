Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792719101;
	b=Gz1Nw04iu+CSYxIl2JduaMiuLr6bavxXLotGlLjOf+BHLPOtd8FBLodivMtffui+8mze
	 cZAMn4p2IK6RSTgxJnei//Th9NLElOf/bZIyjvRmgO35A+pxXeybWe3S+GZcDstJVNr8p
	 C9H4alC1hy8i3l4K9npyQOn2VeW7UmNK5v25ogQVtG9IdOozyjVSYDcA5NEEqO/c9HKnx
	 JMVIDdx2MsrRyLG50HHSSnpSW4h1jmMtsDYOalw8JvfUNNNwfczsvAdy6EiAhBnf5t0yZ
	 KsvKb1e1NbqWqrfOBFO1v8rSmOrS2H9ZDl2eTEIE29tnt7h2qq9Ucg2/xX/BfAYts3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792719101;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=wYXbJB9VAY1S4oQALteeZU5UK7u0MtCoYdQ5l8f5/tE=;
	b=MJINg5gwepFSKV9anRGwaYwlsvsHcAfVMu2u08CCft8MLvWfds/YCHv+FLnmR0TLMRCo
	 JIcOMVXFfLte6wMkDEmnPjpMZMBJ+yLiVf4tLga5UX33saxTF/dNSOkINa9kHHA4Dri9F
	 xEbfrwMxqfSylo9nJRgjq9kkm1kgLE93qtQKP1b2Hv7Y+llpthbo7u5QJxSXjtv1Ko0Wr
	 0Y5YHFOv0RyI7OH8VQka65ELEFFjt5xtZ7Lfu6X2cuBmvpsC3n/MQ3Bm1J3UbdREyZhKM
	 v+SqEv/C80q6lGhFQ1GZ/5HRzz0jHc7Q2luE+V6Wl0NyCrW/yFsrqvNxZ93oY/kt8hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jXw349qt;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F9C606A319
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 01:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4F9C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=jXw349qt
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1846bc43c28so434218c88.0
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 18:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792719100; x=1793323900; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wYXbJB9VAY1S4oQALteeZU5UK7u0MtCoYdQ5l8f5/tE=;
        b=jXw349qtyTNEwOf3gxD7hZOj/TjaoRKt7ihN6mVn8PdnkNxzeHVtmHhwlreRLyMyg3
         ChgTXxwej43jCqKriLq/82hEltXDi9bUm7lqWeBlbmfv5X4XPHOakXAEueVMiPto3KI+
         4i71bGeOedr0dQB+jOzwCmFHScBEBFcDlii58aytqrYoMorpOotdBH5nWHf80SCsIK9S
         uAptkehvFSErauRpybvWvkqPRfhYLP6u06r5mnJVOrzu1A/R2zjydqFPj7Z7RGN0NYic
         Z9C1if8Ujn0ygmRYOiCrCAsk5jYWG9xSvwMSwYCVIuFBcX6YcH8NjDahZLQ4bLUj50+n
         icUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792719100; x=1793323900;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wYXbJB9VAY1S4oQALteeZU5UK7u0MtCoYdQ5l8f5/tE=;
        b=mqtX+Nb3DwEPwSpE+fzzyH48HX6ORwOMmPoPPrNrmFquhsmSY5zY6fcIKt8gG0Z1xj
         LM8Rn1RgkVx8eJ/O7ewEreEPMBU377kZVNA3PVzWkQcNaVokTaUbIJnTkNN0BgRiD/lj
         YZK7IjhlMGfGApl+L8hdX2F7Ijd91zXWEUsYoSgPIYStkFUT/d5XT5PhG8bMJaSuE5BM
         CCjzkIx7z6JrNljIoC3zKowko1kYn0C0oFKwTLKh3HToZAjO+sb2UoIi5aY6xfLsDnuN
         k/6lTjQmKx0r6PAXBRx2P4Eus0Dr4XX9/2sx0uksO/JT3KTmcO4wOVRQoQ4BCAd3Ke4z
         nheg==
X-Forwarded-Encrypted: i=1; AKwUvBxqM4VKD+WkmQW9ynNICg8+sP3IoPUqx/1IGS510e81Wpx8xgmSeFVZdoGRKtX0m2oawflNNdLL4sKT@vger.kernel.org
X-Gm-Message-State: AFq9FYJ2S0gHQGO10uaU6+ANHZjgRtEgoaDB1ch60Mjx7G/dbrlZHZso
	aBvyWlRNngc+qQ8RhnMEVjiMBU0ONNDMs/wb/ZOAB+W7NCH1qZ62IYpZ
X-Gm-Gg: AYBFou3oXFf6WpeyQK5onIHE992NXO4II7rMqP5oRE8/hNBOJYUDdaqPYw9QwMSjLQF
	2d5T3GVS4h4O9H08mw1Od9Bpfr3nzUHxooFZN8STp2v6Dual6dt0SLVPexiYIrnXw73ylZ4r55U
	BW8FE3yt0CG5VOsUsA2UQiDq7dkoXLP5S9pxwngsbOj2F+GktGTscbpYPOmE9y9siZwCGann7tk
	SKl7hRF2mGKQohbwmSWkai9RqT3d5NbvJd4SK7/GjMKgWSgwwTFcQ8uC0RlOTqS+DvNks0672ON
	lo0c4/el6+a+9wx8kO/qAQAnzAbEJKrb8USp+ArXzO/6dd/FRl8fZxcIg2SZFpzy9TOwNLrY/oX
	eyCWKUpVxj6DhRKKVX/Ji2aEg3y8oBoRhbFA+CvWzFh8/w3cc7sTx+rNx/w5hO5DAN4vv6jkqaG
	iQicvzalQu6ST1osMZ8wUHin12pOJN6EUR7ZKwBNHq4DuVeekinV7cVe6M0kABp6oUN8gLn0FZd
	goT/94V0Br+BJUjO1CALOw6v4xmaufZ8wZoxZPeIP5nMdz1iuT7J8eiuxgjYi265uENfECmtiWO
X-Received: by 2002:a05:7022:418c:b0:144:fd7c:84fe with SMTP id a92af1059eb24-195c6ff6892mr1714767c88.35.1792719098953;
        Thu, 22 Oct 2026 18:31:38 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-195e9ea28cesm1774901c88.8.2026.10.22.18.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 18:31:38 -0700 (PDT)
Message-ID: <3e774e32-fa5c-43ad-bc2a-c6d29f7ec7df@gmail.com>
Date: Fri, 23 Oct 2026 09:31:32 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ext4 data=journal deprecation: long-standing industrial use case
To: Andreas Dilger <adilger@dilger.ca>,
 "Korber, Markus" <markus.korber@anton-paar.com>
Cc: Theodore Tso <tytso@mit.edu>, Gabriele Moabiti <gabmoa@gmail.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <4FAF6F56-F054-474C-8538-92D8309FAC08@dilger.ca>
 <AM0PR03MB57141FD8462BD0C6D075863DDE672@AM0PR03MB5714.eurprd03.prod.outlook.com>
 <8B27CFE7-E4AD-4679-B772-6473C3849964@dilger.ca>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <8B27CFE7-E4AD-4679-B772-6473C3849964@dilger.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/2026 7:22 AM, Andreas Dilger wrote:
> On Oct 19, 2026, at 22:18, Korber, Markus <markus.korber@anton-paar.com> wrote:
>>
>> On Oct 19, 2026, Andreas Dilger wrote:
>>
>>> are you running with delalloc disabled when testing ordered mode?
>>> That might be the source of NULs in recently written files.
>>
>> No, we did not explicitly disable delayed allocation.
>>
>> The data=ordered tests were run with:
>>
>>    data=ordered,commit=2,noatime,errors=continue
>>
>> so delayed allocation should have been enabled with the normal ext4
>> default.
> 
> What I mean is that if you *do* disable delalloc then this might stop
> the appearance of NULs at the end of a file after a crash.  The normal
> "ordered" mode writes should sync data to the filesystem before the
> size is updated in the inode, but delalloc does not do that.
> 
> Cheers, Andreas

I think this is caused by the default dioread_nolock behavior. Once
dioread_nolock is enabled, the extents allocated during writeback
are unwritten, so ordered mode doesn't take effect, and the
transaction that updates i_disksize may hit the disk before the
data I/O is persisted.

Cheers,
Yi.
