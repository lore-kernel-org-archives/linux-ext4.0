Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E96E3195FC
	for <linux-ext4@vger.kernel.org>; Thu,  9 Apr 2026 18:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775761190; cv=none; b=H9MV1zB8SpLdQLU9W7R5UWIiQFWJzzl9xNAhvtgoaJ1OfF9svEN59GuMrat4R3zUY7ndfC/6Dqfbh6086mUZBOmsRU1txpkwlzj4KkbznxFDNJkXM5SqS+4HQYnLil1DvY69FY+K0tKlfowjkisbDEnuYchm1LiGCXMxw+jVBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775761190; c=relaxed/simple;
	bh=YDfCbSOCT/VePpsM1GCJR3KRmd3LAmnBBqwVegZalRw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/Ybx5YuQ7BvJCo3T3ZEWLjA2pfZxZMdbg8v+YoVsPwcjqoL109hvadTc6hHHILMDwWkCYCJ8iU3STZ7uOR2uOscaM8/MD3xzwT/3DxqAQS+0xqnmmXbbzKYIZYTPLpw6TmCaeaVyzcD0LpB8khQZnVSFdeJ/W5URBB0PY1yavM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzboGKm9; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzboGKm9"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488b8efed61so10601655e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 09 Apr 2026 11:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775761187; x=1776365987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMFVvLT6MGeXYI6XAT5Rr4C/KWhcYugpA/JpBgEF65Q=;
        b=MzboGKm9l2tVpCn1DgjpyQUHR+u+xvD0a8eQ0CxRpwvnYcafA1k4B5iHVQ4QV5cZxT
         qlCaEWCXFoDwDwXCTeCv7EluJ+gn8JJKagRNOrNDmc3WPkvZ0D+Fnq4s4UYeO9fYdJ06
         ZEb1eTnM+/p0k3CaRsTyhvsvyF7yrtdFYo/dAY9ICvASHJprjO7yzgGl/Gt+D3ffdJor
         2Nsry9r04ob/uLSYOKF4ENjg+P568ddAwmCGcDNTRHjzGsa423Jg2JX+oogIkGzVIiGa
         USWv89kf4AXC2MdVg612oYmSFLY/lvUch1SbYRGoDOnaLTRjBlP52HB2R9HB1g5vbnWq
         KGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775761187; x=1776365987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tMFVvLT6MGeXYI6XAT5Rr4C/KWhcYugpA/JpBgEF65Q=;
        b=s0if+s28md8PJNA7RtkZPIat7WKT1NMxjuLFQUXrAHSO4XXUFX3NvBiw5y5UzHCu1W
         hO0q3okLG2vOeGWtNAEmUBeQ9l4/T3xqHkdCNwJ5iMj7LQ+OnAsFZUS2TB8cjSMe98gX
         gKC0no49Izf2IXLiqfNQEZz8q41R0ZEcnxJ1Zy3GtYMvO2oS6N75IpfPoRjIokDwpYhV
         VerQCjW0kyidVh10DqBw7Bvxh4sUY1OmNvO3Jq/OhTVeiqQFBFxIYbCcUK9Jf9AmUfZy
         dxt+tHGAT2v5FVveYuVjEj0ojlotKYc0Fqy1L5GGQpaIHJ9H5b3j0Vzug0IT/eaB8evB
         TaNQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3bTRduXYZgQ19lJ/R/UHD1gx1lPjSTdktZCmGhNpPjaMqxFftUfelEaW9WMuY6LR/SKuPrUJBkF8z@vger.kernel.org
X-Gm-Message-State: AOJu0YwHrJC2GCGJMmEaKjhV6IhZfyF9bXujWYvzfXsKUK+BO6xBnd1u
	Pu+kIWz+kPLAvlzDuEMNpdwyCKe1Ev1TBEoBOx5VHu4rphEtCbkmc9Fs
X-Gm-Gg: AeBDieuIQQITQWclOH/JrDl9RaGMGgL8rSEawraSX+UIwTIa6MqELulYigHZHCQNTb0
	gKAePDEnk9GFZ9Ns0GftbSrGp2LJYpM1sm/K7hKNvR9xInekQE11sUewpWqsyNxmWkL3TLbvN2p
	jfab1vFAdLREWZfouKeqpmeesaKX2009RwWrpPP6wN+wR13tacjos4sqxHJWNO2j/cFM+sCusnZ
	tUyF5pTwtUvtoFgHQglQOaUbVlPFmmNut0/B8Weimbtv8s/S5JFiR9jo5ZuNnWq81jeeHPuxBa5
	Ts87p6HOWMcDFTuiJU+3m50HQCIeD7iopj75h6WtUWrqI4Lw1JSP5KafweD1691pTaQtYjT7h26
	je0hSHw5+FWaVJQ5Qu4AGgxsqGu22/Dr+MP+YIQi3SyMaQuT9JB2DzcrVslEMnRRx6/wTsQAw0N
	y/RLVoA9tZZ0AwSFrq+hqFGrvvIHlypCnOAHdQp8nJbYZlQspTuUMHCXnTvYMsNjHi
X-Received: by 2002:a05:600c:19cd:b0:488:c239:d498 with SMTP id 5b1f17b1804b1-488d68712d5mr286365e9.8.1775761187196;
        Thu, 09 Apr 2026 11:59:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d53807d7sm26718395e9.10.2026.04.09.11.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 11:59:46 -0700 (PDT)
Date: Thu, 9 Apr 2026 19:59:45 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext4: align preallocation size to stripe width
Message-ID: <20260409195945.76393a20@pumpkin>
In-Reply-To: <20260409142911.GB59468@macsyma-wired.lan>
References: <20251208083246.320965-1-yukuai@fnnas.com>
	<20251208083246.320965-3-yukuai@fnnas.com>
	<20260409142911.GB59468@macsyma-wired.lan>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 Apr 2026 10:29:11 -0400
"Theodore Tso" <tytso@mit.edu> wrote:

> On Mon, Dec 08, 2025 at 04:32:46PM +0800, Yu Kuai wrote:
> > When stripe width (io_opt) is configured, align the predicted
> > preallocation size to stripe boundaries. This ensures optimal I/O
> > performance on RAID and other striped storage devices by avoiding
> > partial stripe operations.
> > 
> > The current implementation uses hardcoded size predictions (16KB, 32KB,
> > 64KB, etc.) that are not stripe-aware. This causes physical block
> > offsets on disk to be misaligned to stripe boundaries, leading to
> > read-modify-write penalties on RAID arrays and reduced performance.
> > 
> > This patch makes size prediction stripe-aware by using multiples of
> > stripe size (1x, 2x, 4x, 8x, 16x, 32x) when s_stripe is set.
> > Additionally, the start offset is aligned to stripe boundaries using
> > rounddown(), which works correctly for both power-of-2 and non-power-of-2
> > stripe sizes. For devices without stripe configuration, the original
> > behavior is preserved.
> > ...  
> 
> Hi Yu,
> 
> Did you see the build failures reported by the kernel build bot on the
> i386[1] and arm[2] platforms?  The problem appears to be using
> roundup() and rounddown() on an unsigned long types.

Looks like that whole condition chain should be replaced with something
based on ilog2() (or some other bit-scan function).

	David

> 
> [1] https://lore.kernel.org/r/202512102331.yweFnVTU-lkp@intel.com
> [2] https://lore.kernel.org/r/202512120613.mM5COVWV-lkp@intel.com
> 
> We can't apply your patch until this issue is addressed.
> 
> Thanks,
> 
> 					- Ted
> 

