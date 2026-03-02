Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0F1A6818
	for <linux-ext4@vger.kernel.org>; Mon,  2 Mar 2026 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485447; cv=none; b=DvUwbTfkH3WUrlV8r4WZw9oE6CI9DAuQi8GfNt7Jy8x+gySAFonwYmOwhfRAVxsUG2Y9pk58YubjyrvgBrgHlkzt+UMqgDxDC7DnFrLloT+ALmSf4RpsHuMgwZCiVR2my4ryMBx02/10uuscwWKuwGbhGITRAduhbCq9PKWpVz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485447; c=relaxed/simple;
	bh=UwKN828bpYjsATwe/PFNfBBgDEwwJJjZ3GciXwnOP1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4CI/dRwgsGF7x056EeFixNJwbk9oty0C5VE5I1OnlM3vIT0y9FSy96Vbbx12Hci7ggHkUpQf9MdTjgR+smyeQrXcDDY6rV4/20Atvwym0BGYh4p0I5Nm0AW8q/RKADtkVL4dXT4ON8wG0nYeibyZtjPZ3XLkVCRVhdNTPtGCo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z4Bzo0Wf; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z4Bzo0Wf"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-464bba2db1aso1817457b6e.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 Mar 2026 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485445; x=1773090245; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=Z4Bzo0Wf3G+d2z5kyswDxW3jW+NPZDiVyYZwCcqN83Y49dvLqgm1fj0D+2nh2e/7HK
         y8XgjjOFWG50GRCh2srXXbYtnH1gxt5oudR0awiokKqFJBqFV+75vqF0fXZcb9O37PzB
         ssP/XV05YlZsYh2QLF+rBPyBu9kralV3P1u67TnrC4Gq176kdbtB+q+Yzk7rNrtA2DyL
         JNxO+m04ssNNgDdJS5SdTjn5rlUQGzbyEPyhUWsMrh4R0eemKB2xMgXYGgCtad/ThjyD
         pZvO5pkjXBF07tjJWmuzdzaOoLCD/n7CQeuwzhnCm1zeTQbegrjQte7JAmiotc4r7I1y
         akRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485445; x=1773090245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=uhMhMXUVROSCcQZOsJygJIU/TSGmM778XrjV7HZmeKrLBHNe1ESUD+4gon7rxo3/58
         HqifkjBOeyd1G46uw4dLuOdKToQM+lecmiZBsLPCMCDXxFWPYvAjr4rPfQxdcVO2XrQo
         AB2/BxS2IYHd7TVDFlvtdbr30ympfbQ4kIeDQhU8QMrGKDrxjNfBbyMQea2yKf/wxPNY
         2lc3Fn6MCRzy5KEDUkSN4REDmNQMlGMNRP+XiJORt0jXt3PjCe2w7sWIAbYwxb46QG9w
         PiHc0Bj3pp1Fw+va7FlwJrW74iBrGyDKOgE3wMQ374VgNSp9aWLsFsceenhEXJzO5Nyv
         aAAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbBdEsP7g3efkGU0TClOMaYuJViE3eTMxuEK4+Ra4TcNR45m7U+rr3tvsab+aoD2S1AYUQeQz3EkuK@vger.kernel.org
X-Gm-Message-State: AOJu0YwY6+QNoBK1FuoFYcpAkdpWTpezP0RS/0tQbbPQU8ezFzHvVDYK
	H/fO2r+7/UfbdABy4/MnVyEOuAHvETJZZ8UrkSSDSrduK2YUcwv2SOxns5Rahl8tCOI=
X-Gm-Gg: ATEYQzwNqX0vpQExkUTMX8GsxiDHPT06+BRPR2Al1uioSH/AR8m9sjyRDaCm0qkvRjm
	DNnmNLokpAT2EqyDmc/JPFnv/IXj1wxQWx2M50nZPtFK1QqYSpjdJjbwPZw5tJpn59VRchaoauF
	nL9+Bag+jC0dijMbO5aMUUQV3U9Km5OghLUkYBVDrBArindcc05d9N855wf2RQNQMGrvILDQihU
	DiLcheXs9JMhh03hy7OmKZkQwupEns8dQO5aO6l8CpbqZwUZCWbSqxqxTl2UEGuk1FuQKVaOEC2
	PiBKCZZ8Cj/DVz7nKspVdaMXuGG5tWYqeF0IdrYUlHQDCc7LsxtTDbyyrrDyObJlNAZXi0FE7lX
	vqkOm9TyyFY2fyCRZ0D+ujf1HQu6u6hX+0oTyg4esuQvNBG2MDdBAUq72jWVSBFHXc1Vev3GfD2
	+LuUigQf7eW7YSu7IvxaeUsFI43gNA3ObpC1rVaKjWyV8uTaTgLpS/JworNwS2l0oQDvm5BjooS
	zR1vxl3btTJddRTBPa8
X-Received: by 2002:a05:6808:8281:b0:463:b4bd:5287 with SMTP id 5614622812f47-464be921973mr6434178b6e.11.1772485444663;
        Mon, 02 Mar 2026 13:04:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab302sm8292175b6e.7.2026.03.02.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 13:04:03 -0800 (PST)
Message-ID: <40e13629-aa4c-45ba-a2da-b7614961def0@kernel.dk>
Date: Mon, 2 Mar 2026 14:04:01 -0700
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
 <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
 <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 5:27 AM, Damien Le Moal wrote:
>   > Is it worth the change, as it looks quite subjective if you prefer the
>> one or the other way?
> 
> I think it is a nice cleanup, but I will let Jens and other
> maintainers decide on the worth of this patch.

It's a bit of pointless churn, but I kind of suspected this was coming
when we added the bdev_rot() helper and now had both of them. So I guess
we may as well finish it, as we're half-way there anyway.

-- 
Jens Axboe
