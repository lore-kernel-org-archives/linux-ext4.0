Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C4321ABD7
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 01:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776303333; cv=none; b=lFkokVrjIMak6Kyt9Sj+hLeV5fHM8Pk7ClHya1qYPM2b6fowSfJVHJl+cnbcvAD8SEtoxFRTOt7a+aR0wEmHAlsKGtJyeS1AuFneEBL1OBBZUPNKmLsMvRxBHMjlA2io+4n+Z12ggZmHS13oreyRi2nda+58Pyles9yC9jGA+bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776303333; c=relaxed/simple;
	bh=OUfLQlvSRYmq8b/tYOiTz9DRgTJoD51BTsiRRKFElKY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=h0w8Vnn4JGHC5/tIyjGiJdpZdvIPfYpmotlF4I1qM5GvthgATkANKrLiKmIIi6ZgbG2dVvRJP2W2tAM+XeRc8o0G5S1v67Pm9+s8lao/7pvQgJGYOMGUyrGy4tKg0awNVaRCd8JV9QbC9K4Q0EAOVZo1YQyWepOq3cEmF32rDFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=SGqGr9Fh; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="SGqGr9Fh"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so6416606a91.2
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1776303331; x=1776908131; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYsib8kE3GPFho4+TI/7PNSbcA8dhEW8o3VOnnyFQc4=;
        b=SGqGr9FhvhWjnL+LQq7XAbfJYIVjt7zVN2zKgzIhAnuvMlKhaCf/K8EOJMznQA7qLG
         PT2qOGGYGRkSAvZVTnBMYu4Cg5IQiwJbHNZNrSGBJtCTvVWjiudjemgdBYeImoAOjfyC
         o/1kr7c19CZhLm9LQBxsIcAsK816RniXSX0d5y7VRFzZLENot22KfNL8J4ATyK2fKLit
         7Tgiy1IsfxKv2HcFxpb2uvgYqKh9XOLokn51RvFvS+RAVKLYJHYjdcr+PvphuCoXUwVk
         mQLuUX7nhrVkQa1IYjAkg9os6zgDPc83OJganu9vZx1aUjuVQFGO8MhORKYCKNxLg4YP
         r1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776303331; x=1776908131;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AYsib8kE3GPFho4+TI/7PNSbcA8dhEW8o3VOnnyFQc4=;
        b=BZc5DssoUNnsDa6Pp3vu/ya1s9yWTodR0mMUqh/hNQW0V7cGvtAsJKMr2KulMMoPDc
         cU8iEXI0y+CSA4pCQ5mQRzl0psJyogUOGMruAlQ8ZCGv1Na/5Vze7iB1XL/qiyjOt3f6
         hH/BlmNhhQw2SjZRmxfFBlmC+e5Xi97HN4VWDeFHxgE6O4zi/u0NhGsvnxynzaCcO0dg
         X1XDjBb7i9q9ZMgRpAI8KY6/+hMZHNdhPJg04I6jkf9xuUHqeVaYmM8q0YbgpDGllB3D
         KC5L+FYQYvi7fz32dIgIhsuTyQIoYp70KvcJfsD0tnQGW6EIWGNpwUh13kasAZ1SlfJo
         GV6A==
X-Forwarded-Encrypted: i=1; AFNElJ88lutkePFbROn8OiodLVmDoZgQ6iErq2QhhMDJC6U7i8jxlgFCLREH7YCQnff2SVDBLF3sxpsrV/te@vger.kernel.org
X-Gm-Message-State: AOJu0YxC+UHR/0O2VMtBWnHXHPfvgQ1yS1ShcbU5/4M1J7qnSeE+7vPE
	NxQwyKNimawUytdYSScgANkJqSthbBuaA4X1apPN/hWyLj+MQi4vM7j4n7cr9PAFkpCTOtyIWSi
	Vy2+d4YQ=
X-Gm-Gg: AeBDiesj/jl7l5Ddvre9q43FKoDaed8WLcgUwqpnSB2Rk7YTCQa4z5gsQNJMdq1B0tW
	Rte4d4zvM/1Cb5i+Mi+BLcPIBrS3WnXhO96vkPS8fzbAn7Ez6qEqI1sxcXIaS0eyNN+nM9IThEO
	nKJx9b8LkPxqPH6RsQby8VfvVxV5fFarftSlNYVKFabQPkY6rBzLHg8xIo5uLbwQIBABvMpIWmz
	BKlkaKD+gv9WND6EafJhTcclReqp5KHOXG8sJ5kOEA446gzZ8ne4wAM6DIhfDvQOeujmMz6e+yV
	o2W+pb9VQzCsylkfzuwMViKOG3t+UKFZPZUwlODzZ3bUzJCDjiz8b9EulA/SiQ1tpNXBObQDEhE
	JLX4HQHeuZ3e9tcwul0x4IB5qUMjePqPSIBPJQVGdAH7EjGkPoGzvGsh4tDnIIwAYYMnCFGS45b
	GgToc/kjeXqXCrY2shmk7llCvsoOptVQCwFcPqR6V2S8qhvu4E/ddbiPuopoTCTeOJyic+6t72v
	XMSVoWP4gqnsw0mPw==
X-Received: by 2002:a17:90b:1804:b0:356:2c7b:c026 with SMTP id 98e67ed59e1d1-35e42853374mr26498956a91.23.1776303331141;
        Wed, 15 Apr 2026 18:35:31 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fd07a972esm1799062a91.4.2026.04.15.18.35.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2026 18:35:30 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] jbd2: enforce power-of-two default revoke hash size at
 compile time
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <cjtirtqozud4keiu2fqi6sj3o4moimloti7celc4y44eejsn2y@i2tz72chmm34>
Date: Wed, 15 Apr 2026 19:35:21 -0600
Cc: Milos Nikic <nikic.milos@gmail.com>,
 tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C27553C0-0A8E-4BCF-8C6F-1D62A69841C1@dilger.ca>
References: <20260413212724.127035-1-nikic.milos@gmail.com>
 <cjtirtqozud4keiu2fqi6sj3o4moimloti7celc4y44eejsn2y@i2tz72chmm34>
To: Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 14, 2026, at 06:59, Jan Kara <jack@suse.cz> wrote:
> 
> On Mon 13-04-26 14:27:24, Milos Nikic wrote:
>> The jbd2 revoke table relies on bitwise AND operations for fast hash
>> indexing, which requires the hash table size to be a strict power of two.
>> 
>> Currently, this requirement is only enforced at runtime via a J_ASSERT
>> in jbd2_journal_init_revoke(). While this successfully catches invalid
>> dynamic allocations, it means a developer accidentally modifying the
>> hardcoded JOURNAL_REVOKE_DEFAULT_HASH macro will experience a system
>> panic upon mounting the filesystem during testing.
>> 
>> Add a BUILD_BUG_ON() in journal_init_common() to validate the default
>> macro at compile time. This acts as an immediate, zero-overhead
>> safeguard, preventing compilation entirely if the default hash size is
>> mathematically invalid.
>> 
>> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
> 
> Eh, if you modify JOURNAL_REVOKE_DEFAULT_HASH you should better know what
> you are doing and if you mess up, then the kernel failing with assertion
> isn't that difficult to diagnose. So sorry I don't think this "cleanup" is
> useful either.

Jan,
this is a BUILD_BUG_ON() so it won't cause any runtime assertion.

Cheers, Andreas 

> Honza
> 
>> ---
>> fs/jbd2/journal.c | 1 +
>> 1 file changed, 1 insertion(+)
>> 
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 4f397fcdb13c..62b36a2fc4e2 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -1565,6 +1565,7 @@ static journal_t *journal_init_common(struct 
>>  	/* The journal is marked for error until we succeed with recovery! */
>>  	journal->j_flags = JBD2_ABORT;
>> 
>> +	BUILD_BUG_ON(!is_power_of_2(JOURNAL_REVOKE_DEFAULT_HASH));
>>  	/* Set up a default-sized revoke table for the new mount. */
>>  	err = jbd2_journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
>>  	if (err)
>> -- 
>> 2.53.0
>> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 


Cheers, Andreas





