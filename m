Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87326E6F3
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 07:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779694325; cv=none; b=gCTdZ+F1uKu6V/nLXSDih3lavErz4313isauAt5K73f0K9IRMRYhyGhXxZXGv1o7A3TKMmcfW4EmSF3t16vsmHhn/C5KDzEeqVSIQQcrlvlGueATrmjILMRhgFT6ptlsyvds2lxMEmaqxMNhATOFrW5BfRDI2KOL+HXQT5xux8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779694325; c=relaxed/simple;
	bh=m9nD0Am/sRzjM9JFkd74b7NefUGiEOsYrpW6KiQtGhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=chwKbc1fOhDSUKxfavqR1tgWnM1nVnUtwLNUkxWtUxFI/s0czjHftLtDidF4S3lnKf00jEITVk1IBEPq3Ia7UJU2Ag9eANNm5/cl6UMLh3EodUr9uGOxMbkdApC1hKslUY68s8jSAh/jl+U8TgZnJ0/6Z90QIAszAzTA13o5V3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuFmBqgn; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuFmBqgn"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so97372575ad.3
        for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 00:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779694323; x=1780299123; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mHT8hSrykaY0TXw4B85bKtoqiGDdQ0PRZ/bngSDFZWI=;
        b=SuFmBqgn4icaV+aEmlzYORgADW9/2W4OReWU+KfLs6Us5QD/6eAn2+hX01+lCyU8Ck
         QKteP4Ts/TQDWR4HmfxMThRiNzS2otCR8ns9Wipwc0Uv1bYMK/v7wZWdU2a6tk1Shd34
         0i7lzmGXfEvKmnM5yt6Xb6YNZ/uIC5UoPVpx474g8eD78mHq7NLD/OEXZEDw1uD4Ipsn
         E1Rvr1nSCDVbGsORVsAnlGJapixdmk5jy0J7PHR4XuO1+4E16Iq8tK3jty2yn+B2LkOq
         FmQolJ4UQDU7oN+KFg+y5C4PclxUr2OBxvRBsd+/535QEkedPoooeCuz7J9FiJA/5xIL
         zUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779694323; x=1780299123;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHT8hSrykaY0TXw4B85bKtoqiGDdQ0PRZ/bngSDFZWI=;
        b=EFV0U1h2fijFgJbAYjU7mEJiIcrZXJBcu9LXO84VWavjEUfvGXibEus4Goro7a6q8y
         /Mqg4YOD7rdc0TMSPZ94S5LvyY2LaIfLbzEIay02Ri+DW/oXPg3Oez4XeyrfriFM7qYc
         EaaNzqGSgbKmA9Zx+rX9GQ51I48IVoWAeqm7v9nzhxJfy185KdfJM0EqawuVMKn9gM7u
         zo2hE6mSleizv1JTAav2BMfnyfJ29qIyMbEHeWz8YuyduBDH5ALHTZUUb32pwD+yB0IY
         4fPHWSFlVo8MV2/YUeCXtsvRzB35TVvRPOqCLElkISmE8BqboaxcDGcb5V7s0hjaiqq8
         Hdqg==
X-Forwarded-Encrypted: i=1; AFNElJ+NThPS9dFwrSeYD81tuMhLmOH7oZUuBGyp5gfG+jOqrek83CLwjariqcyltYJ0V2mRjZGI2+hsy4gt@vger.kernel.org
X-Gm-Message-State: AOJu0YybQx5LOxHctW5wnkiJFG8yh4dZ1/C3mQB7fJzVSrG/6Jm55DvH
	y50oDv19/k7ifLZb8QcO8bwu1G1Mn9hyhImsvEG9HsgJajhQ/smaKwNr
X-Gm-Gg: Acq92OFrD98yruQ4UwTsAkueEhYdGf4fOG5NOxJJ6shimlmVFBEHm4UcZ1UpGlOC+z9
	doQYKt4heU0t5O+iBil+o3Eh0R6Rf3aqMDRyjWv1eILWu2cLqnYaThQBTqTW6oy5vAGDB2t/Mjt
	rcadu4C5H7PD7NXcX7IO0039QL2yOuJSgL7Qa3OlipFJ1uS6LhdyKEb2nfG5exKgTf90d9AT1/x
	rylVf5NIKY0HfzTYAVEdb1a5w3eq54hFT71yhefAUkVBTePS0lexXoK13+bUI5PLjFc+4pdMtPL
	mHUz4qZTnFeN4VollnhobMDtoA1NZC+XR1ZmuEYrO6gO4e28S7cWA64+s0d6ARF4e37yt3RnNTc
	mEbrPnoosQwj2yLauP+AEnCA5XU+FLYM8lXvUwiy/PuKfRdc/4fXKmblw0TRG0eJqYBYNH9YiZ7
	4JBUv+riPUOo03qaKmkIsuUDyFl20=
X-Received: by 2002:a17:903:350d:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2beb065aa18mr148715225ad.34.1779694323424;
        Mon, 25 May 2026 00:32:03 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58e4fcfsm89596925ad.71.2026.05.25.00.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 00:32:02 -0700 (PDT)
Message-ID: <7f846f9f-4193-4f6a-8a87-4084988d2044@gmail.com>
Date: Mon, 25 May 2026 15:31:59 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/10] fstests: add pre_clone_tune_uuid() healper
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, zlang@redhat.com, Zorro Lang <zlang@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-f2fs@vger.kernel.org, amir73il@gmail.com,
 Anand Jain <asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
 <0d9f455d20145103faaf4e45262ee44418cbaca1.1779367627.git.asj@kernel.org>
 <fbc03a78-0a6c-4c3a-9608-656d0df83d29@gmail.com>
 <ahP21UfAr3DvEG1B@infradead.org>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <ahP21UfAr3DvEG1B@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 25/5/26 15:14, Christoph Hellwig wrote:
> On Thu, May 21, 2026 at 09:10:36PM +0800, Anand Jain wrote:
>>> +pre_clone_tune_uuid()
>>
>>
>> I missed the "_" prefix for pre_clone_tune_uuid() to match
>> the common/rc style.
> 
> and a comment explaining the helper.  Also I think it should
> be named to describe what it does, not what you use for, i.e.
> something about changing the metadata uuid.
> 

Agreed. I'll update it. Is _change_metadata_uuid() a better name?
