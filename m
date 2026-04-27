Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857472D47E6
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 10:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777284985; cv=none; b=eiKYH6HV4Tia74cpAnfTmHbv05YgM5RJVdw2QKhz+vJ0MtNHlXr+UyDJNRGyXoogzjMhIF5tD0XxPF6U6V4EqQe6ybXaGRi5hOTvA4Yf25cArFfFzVnGe4pjYmk0wmEv4oE/aHaXtgKbSO79Qt+f5bT9tZc8u/IUbQDwWotHA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777284985; c=relaxed/simple;
	bh=MVzRp4OGUxMMdWcsFlN4qWeIX4Qazp+n6VnfWzrAamk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QN6bP5zw9wFosFhyZkc/YJJYkpmEgzr4wYifGPEkq4xwHmpg7TN9FuWrj6iCSfI9dzGNV7evRqi3FMryt/XdaYQzBPrjIRci68vW1iLwhrpBUOgdL8SZqkYBnu8B4snGQDRnNZbgD8cdjmdmN4iOu+1xvSYeshbE39Buehv5PM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ipf/P+mJ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipf/P+mJ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35d99031e4eso6856075a91.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 03:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777284984; x=1777889784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pdggqY40OkypkTlyFCDPbQJ5t8fWVIZTWFDYfO2J5OM=;
        b=ipf/P+mJXMFbjUJOYSs6xDia98wvHxaAjL40BuOuATATeYYLy8jD4ZwaXBY/oAKIdh
         zjaj0NamCDeLhyrr5M+LMwmeI1uVFnx7/08SowVtFlhKSBTVTWKKTUEZ8KNcgBmPROTy
         ldoe5bO5NygjFrhfyuf2aOV3hoTanFTK7pfmuMrUReOGmcZqGSEvIWFtMZ7VqCcRlYfB
         buyXAsmV20TiqYI8RdE1yjWNDGSbd43ejYakfLlhhqPXZC++Uo8JY1+ZvmYBGf+W9W40
         2w0mh6cOUOWUVi9x/Ds2eWSE+fyZdBjt2mFX+6raVVEnv6+VfUyLQ163UOJ3LRyDC0qz
         dleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777284984; x=1777889784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pdggqY40OkypkTlyFCDPbQJ5t8fWVIZTWFDYfO2J5OM=;
        b=YxKPnPHqJRy2d4MdyXPlIiA4FGnK7erLoWZ3pFrQ1/r+WglpKdhUFomkZsXaNggtGQ
         9UUmF/cs95mB9gJhKey8FVZ++/S1y7wnYmQf5trEPQzfHtqNlNWeBEjvylkOQWqT1o7q
         e2jFybKbLKHD049Lr4i4biuGwzgu3Q5uRr4eU5qZGDp6msNzJgkNsZ2W3xHPZvOVA568
         yBYr4yNYiAQFR7oGrmBa5CQIkx9cmTPG27TPP6hVkhraR//ZrL6v1x+HipkPxKmaJGE8
         83Onr4U7GfTnU8JF++DNzg20tBQ4DiFEuzDNYvWZ1hAEpGJi+CO79jH1HUgOBqJwBPff
         ysTw==
X-Forwarded-Encrypted: i=1; AFNElJ8YLt9ltIA62P+u+s/fsWjMFNg6hcUA/YLmqqY+ZdmdaUlX6nezxw7fqTyz3u4QnIezkP3NZjNqHG1H@vger.kernel.org
X-Gm-Message-State: AOJu0YwdA7bZEKddprR3CCdxzNY5Ho7gB42UW23HgZ2DPl+0h57gW3O/
	0n1y8OzQE5RR2/bmkfP9OKrldQu2Wa/ecz1ej3G+rHOyNMnv3LRJL9rK
X-Gm-Gg: AeBDiesOqnEo+VnSMKDk8MSHHlk7kH2hw8LGKGRUzq8Y2C4OZW/s0mkOEtelyRFKSEX
	R4Q22hk/B6EBKfUSTM/NFNlpADQEqR+8rpSlYeiC4U/TN51ZaKr+toKcnMUWvy82+7zuGkTFkDc
	9Rm1lSKqk/twk0dnC/iNsk6w8fvVqyutVWfSfvg9WQs6orXFi2orQvkkWyf2EHJQzp8GGn6VvLF
	ZHnKNV49zUPcgHYwKzLiWH04CNNr6eVRpwQLd0hO0ULgDni1MQM4XvgTxZ3r7KbNnRFbmj9kMV6
	Hzyn8e+11y2SJH2FM6LA6qLeF8DeFdtgLpA0LHXtqVtZu2D7DmS6PGyHctBLA7wbulnUDEwkDzO
	Kw7G7jCWOPJrKlYpuET7tNpdgkA5kGP3vKaYfsK8OZuUsJeG9H/Mz/TShsw5naCbU/oLXJuQAQC
	34RKtfqePzUe1zKBDqhOaxYU3/1VXQ6tVBrEIDiQ==
X-Received: by 2002:a17:90b:5544:b0:35b:90e7:c44f with SMTP id 98e67ed59e1d1-361403e1016mr40055142a91.7.1777284983849;
        Mon, 27 Apr 2026 03:16:23 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613f56ecbesm11872541a91.0.2026.04.27.03.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 03:16:23 -0700 (PDT)
Message-ID: <a7df722a-834a-44f0-87ad-d0da5a813e6b@gmail.com>
Date: Mon, 27 Apr 2026 18:16:19 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
 <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
 <aeHikJwRmFdDg5FW@infradead.org>
 <cd9c0147-18cf-464d-86e2-12342a992ebc@gmail.com>
 <aempTb5TyKG0vPL0@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aempTb5TyKG0vPL0@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 23/4/26 13:08, Christoph Hellwig wrote:
> On Wed, Apr 22, 2026 at 07:39:57PM +0800, Anand Jain wrote:
>>> No, T10 does not actually mandate unique identifiers, NVMe does, but the
>>> implementations are often totally broken.
>>
>> Right. Newer SPC-3 (and above) compliant devices must support
>> the Inquiry CDB EVPD flag and provide page 0x83 for identification,
>> which is what we typically use for multipathing.
> 
> But there is no requirement for it to contain something useful.
> 
>> These are globally unique. And, we can overlook legacy
>> drives, as they've probably been past their EOSL for a while now.
> 
> We have absolutely no useful identifiers for most USB devices.
> NVMe devices have broken identifiers all the time as well.
> 
> So no, you can't.
 Agreed. I have dropped the plan to rely on hardware identifiers;
 the lack of consistency in USB/NVMe firmware makes them a
 non-starter for a stable identifier.

 The updated patch set, excluding the ext4 changes, has been
 submitted to the mailing list. Fstests test case updated as well.

Thanks, Anand
