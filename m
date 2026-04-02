Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1E91C84BB
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 07:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775115238; cv=none; b=bJauYvwANOTa6knqTtVDdgLPErG/ohwvF2GF5hg5yZo/FqWPEulyF7EEoiHINdPTJPwbjgfcDAGvs/JiuOuB4pMbuc33xVczcXn33rtJEdkuKMspfTI43HSaUzV7/lMHsh7H6bq1L5eOLus+PCQmL6Shhc08OUjsdmCMerfpQz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775115238; c=relaxed/simple;
	bh=kk/SGZETr3VbKn5r9SfE07zMdaV8VAHVgU3f+PHmrTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jyi1I7XadFiIteaIsFK/czDkJv29APMlDdUAdjwmjOWjETpIrAy7Q6TDuGjymHD75PStr6vEFHRBEMbplVf5BcuVUFcYxTsZ/pFa79U/8yUukd337xUqBsrhYjV/FX0Mzmq0b8VDQDf1cId8BaM1gvK2FYdmvIPkZmIzhjeZgEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcYPpT64; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcYPpT64"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so3232055ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 02 Apr 2026 00:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775115236; x=1775720036; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JK30YBReA195moqsRsDMjywxisJV4gXm9twSxeD57TE=;
        b=TcYPpT64yn3+4g8AobUWmV9CCa+ERelf9mfzlF6kWwY1paVbjj8hvwzsn72/JCr3e6
         mR8EUC+FAQ7ewno5YF+US/u2XhH8NMbgAGGnrM0jjV/XhgD9cCs8luO3G5PtHbzY4AMZ
         Mzk5RcI8YUFqLy0dlcr5br8ZPSZgDubZiUfE5+fasuJ9vSWYSM86o6tZWPaJkFzVKncO
         VjFRAu8tUu93e03F4yXtbv0Ax9Cx8QLxQSfHkkeZDc/HCINaJ43baY2UVKluzPa2/H4E
         /jjjEb4hzrmH62uzefiVbfgiFqA7rzamouCOQYF3xJOTQQQekYXhOIjHXU6G2Siw25qA
         fXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775115236; x=1775720036;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JK30YBReA195moqsRsDMjywxisJV4gXm9twSxeD57TE=;
        b=E+iSWG86dPE6OenWMMtHIhk3YVLfa3aSTmx9bBduHaTZQqSD7JCJBZJVOLMRY6Q/9d
         hroTHUmXFeMnfWSsUgLebAbdT+EQm2jZi83gGHdFK1FbD3hNZAJA56yM5JZXdyug5YzB
         dGhRBLf6vTIeLxInEkuJo0XBhcHrzHKjJa4qin8Nm+PPGTOvQJVk3bCUKE5A9YTJp9qu
         c+KfT26RdLbHkYLK2Rvb7u4tuM9D7ZkkktEgKBrmAJPh1WxRFBQAqubddwjJO2yUHcE2
         Q+zZ774JIBtJix1/9J8dPk4GwXUdgg3SlSxXDmQg4M542cNBQBPzsemznQT9+n1iSXN4
         aITA==
X-Forwarded-Encrypted: i=1; AJvYcCXOS0k/K8iAWKx28PaCqJ6YEhofbKwq9Bv1y4XoEWdyCTC6ghAWVmJ//0SF64Dd3qpehpp3kQF0JY76@vger.kernel.org
X-Gm-Message-State: AOJu0Yx52dujs6+iXqUAOPp8+7QFOyiveKfQVcfxWXukMmYHUdlf6wxd
	HZUq6rsoYPiSmABe6yUpkKVZF+pjlWB6NuffLJEW/J/DDlUYDkMTwcTe
X-Gm-Gg: AeBDiesR08ZZ74NDjHTyTR3qFexhezxqdVnRNQDDEonap0maO/lSdV18ruNpsjDt6xG
	BB58Cz1vJwx739fs2rISldyjW6CSyyumJ9thqkKDjMKKmiiXZgwLe1wLTy+T4VnGs9KP8ygdSlQ
	ojpJWEEZ5o8/VUJB/2TCBldddapLrJrA5jIBgGnV2yLOMLF224BL6bMGTK69jNi66/74RrHS82b
	xlFdJIAscJKTXQF9fMBjpFu4yF+Gvjn9UR8REzmmKGJlKHL5rwFVdq169QXz5jIXIJwEtNSEPyy
	rzlZWnIvSNx0734oeKO2A6LQqGjAaeQ1z+PygdRLYzuNO1FX92P5BSsxHWcZHskkrHi+QMC3nVF
	kHIyFWFxIXImfxAGYRLApLwpEQ+fNvHrNsK6TZTVTP9MadESd9Lx6AzmeCvLM3N2w50NyA7Uq/P
	jJSgunNHpuo1GnP+Cick6iCQKCB1o=
X-Received: by 2002:a17:903:248:b0:2b2:5723:12c3 with SMTP id d9443c01a7336-2b269ccfbfemr64748095ad.43.1775115236283;
        Thu, 02 Apr 2026 00:33:56 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27497c0f3sm19793405ad.41.2026.04.02.00.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2026 00:33:55 -0700 (PDT)
Message-ID: <4da9792d-5f4a-4619-91e2-4ffc1691b867@gmail.com>
Date: Thu, 2 Apr 2026 15:33:52 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong"
 <djwong@kernel.org>, Anand Jain <asj@kernel.org>,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, hch@infradead.org
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan> <20260323152943.GH6223@frogsfrogsfrogs>
 <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
 <91d1e10b-b24d-477a-8724-2a75a710dd8d@gmail.com>
 <20260325125952.GB2107@macsyma.local>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20260325125952.GB2107@macsyma.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 25/3/26 20:59, Theodore Tso wrote:
> On Wed, Mar 25, 2026 at 06:59:32PM +0800, Anand Jain wrote:
>>
>> IMO, sb->s_uuid (as used by overlayfs)
>> Represents a filesystem UUID that is persistent.
>> It is derived from on-disk metadata.
>>
>> statfs()->f_fsid is..
>> A kind of runtime filesystem identifier used to distinguish mounted
>> filesystems within a running system.
>> It may be stable across reboots or device removal and reinsertion,
>> but this is not guaranteed. It may change if the device dev_t changes.
> 
> I always worry about "it might be stable, but it might not; ¯\_(ツ)_/¯"
> 
> The problem with that is that people might starting using this
> kinda-of-guarantee-but-maybe-not in scripts or in programs, and then
> when people try to run that script or program on a different system,
> or on a different file system, things goes *boom*.
> 
> So if we want to say that it is stable so long as dev_t and the file
> system the same, that's a well defined semantic.
> 

Yeah, agreed. Avoid misuse. Document that f_fsid is stable as long
as dev_t and the underlying filesystem identity don't change.

> If it's that it has no guarantees whatsoever; cloud change across
> reboots; could change across remounts, then maybe it should just be a
> global mount sequence number that starts with a random number at boot.
> So you can use it to distinguish between different mounted file
> systems, but that's *all* you can do with the thing.  That would also
> be a well defined semantic.
> 

Per-mount random value (or global mount sequence) is also a
well-defined semantic, but it comes with trade-offs: we lose
consistency across mount cycles and need to carry per-mount
state.

IMHO, it's better to stick with a deterministic id:

  f_fsid = f(dev_t, fsid)

predictable and aligned with XFS/btrfs and avoids additional state.
Bottom line, it fixes the cloned filesystem case without regressing
the existing semantics.


