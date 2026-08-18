Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD9F37C93F
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 06:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787036360; cv=none; b=Bm1p/QPQA33xieKJ8KNkz6I9tjtEZbOHq2JN1vR3Oxc5EZSBj8ZGkYbp4WTFJrdfynxgtCiGzkVr26S9eWFL3aCHVC1mkceDDyjgC/t1ifFoffjNbCHkDXpfffyeMwmrjFQ86tyGVOn9lQJd9a+L2Gai7p7gx+9rnkVWFvTLTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787036360; c=relaxed/simple;
	bh=Lo9Dnt2y/TMGSSskmCCw/E68ISLvoXSSWMqfmsWr4W4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uUKBQdSrp8mLF2c/gj/NGq9VStgSyfqbrz0DWH5REX4ZE1XMInO4z87PedccUJIkApEyUly+9rctNrSNHl2VKCZJ+lLzKw2Dku1d7xf9bI5evwmmMZVuSemvTzgJmYe8Mo/n1Jqnuatz4bEqozwIW6RZKe1BWTUQPS1ai3NkNk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K/qJj9Tb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K/qJj9Tb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2caf228a910so32377985ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 23:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787036357; x=1787641157; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EsgqEQAUqrVWXU1GldXAhQw/hCdlChW/NiKf+A/QTHM=;
        b=K/qJj9TbqgJIQQyPUVfyJ91r2dc4GyrA13mhJYIyUJApa1JmjYsdYrZa5pKOHJmFl8
         rXF7ub+jJVk8iCi6ZYonZZwPJKLffwSWwLXr3l2BC+QmKvUTFisz4BVFjHTO2qmxrASD
         folm+hRObzREp7uz5hE1rdjvKA50Lyl+0Mq/O9UCUOd9Xa7/ZDv5iejp/Ibh0M4UPmDR
         LhETIae7nLCGdivTyRT3A91lnA3dlHGbI1w2dBh+dgGzK3EajU8m6f7qnxIt7RzLGfVg
         9xBpxaWI8K47ntdL3pzJnggjPNU7HDAKodWt4vZwjqvee1DMFdOtL94q8C5efFL8rTQX
         ziLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787036357; x=1787641157;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EsgqEQAUqrVWXU1GldXAhQw/hCdlChW/NiKf+A/QTHM=;
        b=iqyqpoqT33ci5vCUyyw2W2eFWjv2fQjDwI21DMCgUlPHVqlwP9JZHh8Cnp3pAJjB1a
         +arN+c3VTbRiP5zwwseF1Se/vT4v2Itg0ywzO6Y0Vkcy2YBlyAOZbbyfNy79S0Rg71fQ
         PB0S185iZ12LG5pyY2WZoEfvtUhV+9IHKRhCmcRXQ0gyNLn+FDbmtB+w+uzYGVboBMAc
         ex+DFQThze8EJ2fvuWmlehguZ1/FB8c6Va2KFvpV+butavysYjtClmF+dWLzQ2O+AAVF
         rk1pczbmTVcCe2tWTJKTVS+kgfWP38lKyjfUdV0cgm7H9HY67K4Nn6nmmuxqvktHjGZY
         AOEA==
X-Gm-Message-State: AOJu0Yx7EPmvNeULq6L5NCSJw7ptDuYpMvU0ZKQAk6gzK+h/MQEDH4PX
	8jN+DvMkw7FlbzPoLqA/Kuy4iPG/acN247BQuGHkEDZeBbc8yeM7FLEr
X-Gm-Gg: AR+sD12WM4HTNDrYqhLkzgkWQXytrKzYsaw0sQxDb+cmjCmP8Of3KN5J1pjPDEUVZV7
	R2bZ/kPXlgbkuqKCy6umezbZXPioQ+FbBNlc6CJ4aGZX7Mjb6DqvaYTVjmKyZogdOxNUaEkR+1M
	KzvvZ+IYIeY8F/g52Q8457ThS3rZsc9AJ+ygA7wB51rxm2r77H7AVZuMJ7NabVW0xKKbqfTJjbi
	Qy+8eUrpzrhRzSu4v+OiV4OtSE8okEW8m4tM9SHoiyumd4M4whcrIn2h8Ff+Kl57xWqFLvbO+Z4
	cVTD3+67BLO7OPn6+etjnkb0EPtrUZ+xTafXJuhNMp9lV3CDv1yhfIOZv2cXI74Oe8iAmc/bn7O
	T2PswzyOPfU0acDQdfNonNiMeGdv/0zZFJf6Vdf2c3uoQjngc+2ovDnUdcpqooXNGm4nZnAh5+8
	QbWQD6qiRBso9GxTdDBpQYhigje5+oLY+WZ71TlXh/zJaqJUmjNnv4VNCmVrct+CwHG4LI9ALJA
	kf6Arusza+y1uk=
X-Received: by 2002:a17:902:f548:b0:2ca:e565:7b15 with SMTP id d9443c01a7336-2d3b0874ce2mr279530695ad.10.1787036356990;
        Mon, 17 Aug 2026 23:59:16 -0700 (PDT)
Received: from [100.82.107.240] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e528b3sm10780415ad.46.2026.08.17.23.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 23:59:16 -0700 (PDT)
Message-ID: <badd3ede-02ca-4fa8-9a51-a2f973dd97a3@gmail.com>
Date: Tue, 18 Aug 2026 14:59:09 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: reject delalloc to nodelalloc before applying
 remount options
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ritesh.list@gmail.com, yi.zhang@huawei.com, bretznic@gmail.com,
 stable@vger.kernel.org
References: <20260814034855.1573759-1-guzebing1612@gmail.com>
 <an7Gj2vWVpbP584g@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
From: guzebing <guzebing1612@gmail.com>
In-Reply-To: <an7Gj2vWVpbP584g@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/14/26 3:41 PM, Ojaswin Mujoo wrote:
> Can you please add an xfstests for this. The test can stress this path and
> then use the _check_dmesg_for helper to detect if there were any
> i_reserved_data_blocks related warnings.
> 
> Regards,
> ojaswin

Hi Ojaswin,

Thanks for the review.

I have posted the corresponding fstests regression test here:

https://lore.kernel.org/linux-ext4/20260818064023.2309786-1-guzebing1612@gmail.com/

The test stresses buffered write/truncate operations in parallel with
the expected-failing remount,nodelalloc operation, and checks dmesg for
leaked delayed allocation reservations during unmount.

Locally, the test fails on an affected kernel with
i_reserved_data_blocks not cleared warnings, and passes with this patch
applied.

Thanks,
Guzebing
