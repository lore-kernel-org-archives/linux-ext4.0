Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AE3A937
	for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 09:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776590360; cv=none; b=sLwFucVYM/an354RIkEk8IKNn5B1WPdN5nwMSwNWQk+ERQk78eVUWnEcMQEv6p60SHLlQEYRDmGpDodDea8pSbDX7qtEz0Gp41c0a53cfRk6Fu/ljXauQHbfbxl4GemWYU/hSngtKJcDj1Jh2PhgJiKc5IW1CXpJYPll7sQ1nl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776590360; c=relaxed/simple;
	bh=jFTNz/IS55IKxKdfCgeQyRLTWc7CLwahTGTBGCGR/8c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QfzFuBhFD6jKz/4Sz3+lhG8cF+4bcZYPZiapKszWbbiZA90Cq/D7hDd/mATVOoh3EjBWEno3LsebyBpsLS+8Af3oVDHvg+w/1MX0CiVNjYFtAEoJcXDTqcg5CESy4PnlWg0Z/sCSWNfNSMOjd5pEABLig2p6X07S51RR1478pDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=E18VU4X3; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="E18VU4X3"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35e576110adso1387176a91.0
        for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 02:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1776590357; x=1777195157; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pWG/734fv6hzCaz+ymI0qh9ne5UrcgfAIiyWYMrCbuI=;
        b=E18VU4X3HX9dXFKS4ck76hWSEvDFzGyQJsIbYCg8O6pJNzSJvQIFW1w3Wx62cWEVsP
         in+V0Hnm1R/KxXOEUJ2SXKUrLIVq41SE5cYqoOTKetgh5gkbqegGuLyHQ2dqGSVIxfVT
         dRVkclcDK6a6bXcnZroCKS54bbx/dOkYyV0oTKO3/cv+VtVa7GYMaSb38aYjJUvFIn3p
         P+0sReX0EsjJfBw9lGeyM6g7UObDymTvcLaODKq5s0hTSj5ynyHHk5ztkHyXCjigpGMK
         SjXiq26ZvHjtn3n3WFMw9nk0qj59psCD8OORhH/6o/FvbYy9CNFx4ukbkD+2+cWvUkjK
         uOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776590357; x=1777195157;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pWG/734fv6hzCaz+ymI0qh9ne5UrcgfAIiyWYMrCbuI=;
        b=QGazrUT6nPU9h/mIgRjGXRHpUJ93Kq4q1pqtP9eRdOsD8V2PMUWKwjJwJ0KhtzGRBL
         i8miK29QKNBsF7Wwr8VCLZRvZzBLOv/vw+y0wpi+aJ8AWl54tnFf3PpZtc9QPiVtYD2O
         QFQXo9CGvjsPazWAilzxqocmSML/WFogLcYcrq//K45FKArxCdeXZCD0OSN+SraytXYE
         Eey+BRDRs0UJx7Wcak/pKD7aY0mq9w1Kn9caZqq8V2ZubDACmvtbHjrtnarnwPuccNi6
         N5QFbK2Nx3iDhfRLK4MxVNMlOwxhca5aH79a6kxSJYhsg1ivsjn/S1XNDLMs5rqsmvTO
         aR4w==
X-Forwarded-Encrypted: i=1; AFNElJ/AiaXOTtXcvPdtMmPwc6ZfbaObEqKbU6ytwtGR19PeisL6z+hWL41kM8eP91hD5KbhDkQOMDRLf8er@vger.kernel.org
X-Gm-Message-State: AOJu0YwUfdGUqfnivZT9Y6RC9Ymcl4vTz5BtKFC4Bqi9+dvDV0ut3QDb
	ukTWW+mdExIgnqnj9l5knh7JSb2qFBcWI2D65TNdIOP0vHXk3Wx2EuaC9YD1nXzqjK8INih877N
	jrWBmcbg=
X-Gm-Gg: AeBDieuJZnqjVvGm+mfgL8RlPyI+kYMa6P0cyrQNBZRerkpeBLUiymQamXIvq7iFx0p
	Zl3HzuoDCa8tuSOLVS/6Sy3AOtVTA6azZb0ETgXbA74LiLjuFP6QzcWRhXlG/I2qShzEN/kK32v
	+VONognjv01IbMvdLee9PB5A7AwaQZ69FFoS2TWC4UVz8tE+N3dB+XhWS2/mDruvFuALmELmede
	sXJCGfWR2spB/8aPb+AmOIDu2Id6o8G2YvtLcQfzRhqOJQaXh3FJmdHMFPNgNSFEpcs7bkfcv68
	0QWfkDtuisQaS/5zoXNOz6zG5Pc95bDRkdie8+BFao9bHFAM75HoYpf3xxytGmQEmxOAj/otOeX
	/H11gcGE023JJH9SmmSLC5b5Ar3ZpwxjQNZJ9S8gcgNXVwclX7DH4zfkX8O43/sU3/gF4ujJmyY
	KD1nlK5aNPxrjFDZGE1pJltM+X/7Zjv3K5tKSXGqEY3c7NQCwF5cT5E9OvEQI4PPjcnPQgpjx0D
	jW7bECHoEiUYDfTMQobYx8Ya78=
X-Received: by 2002:a17:90a:d604:b0:35b:952c:43ab with SMTP id 98e67ed59e1d1-361401eb6e8mr6723270a91.4.1776590356685;
        Sun, 19 Apr 2026 02:19:16 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36140edb04dsm7284669a91.0.2026.04.19.02.19.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2026 02:19:16 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 v2 1/2] ext4: add blocks_allocated to mb_stats output
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260419063436.17999-2-liubaolin12138@163.com>
Date: Sun, 19 Apr 2026 03:19:04 -0600
Cc: tytso@mit.edu,
 wangguanyu@vivo.com,
 yi.zhang@huaweicloud.com,
 ritesh.list@gmail.com,
 ojaswin@linux.ibm.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <9B80A448-B299-4D23-AA2E-AC8643AA474E@dilger.ca>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-2-liubaolin12138@163.com>
To: Baolin Liu <liubaolin12138@163.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 19, 2026, at 00:34, Baolin Liu <liubaolin12138@163.com> wrote:
> 
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> Add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats so that the
> reported statistics match the mballoc summary printed at unmount time.
> 
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>

Reviewed-by: Andreas Dilger <adilger@dilger.ca <mailto:adilger@dilger.ca>>

> ---
> fs/ext4/mballoc.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..1e13ef62cb9d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3211,6 +3211,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq,
>  			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
>  		return 0;
>  	}
> +	seq_printf(seq, "\tblocks_allocated: %u\n",
> +		   atomic_read(&sbi->s_bal_allocated));
>  	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
>  	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
> 
> -- 
> 2.51.0
> 


Cheers, Andreas





