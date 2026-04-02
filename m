Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AED1D516C
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 00:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775089445; cv=none; b=rrxy3buEZ0LaD9SzEAUu/1bfi/mZ5mJAcizomAtAL9rb0f5SxcrmLyGedLlLbTFkOJ34WjIdDExdhFA+BD5lhjVj3tUXCt/bc8D+jCm8dlJpL6Zv6SqQxF+8RK/BIgYngdEe+m+WizpRHUyUmzQ0gHVr6VmqJvhYciZUqnN4fHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775089445; c=relaxed/simple;
	bh=Olu5tsASkZ1VQLA+MfMnYz52JkAp74HQENbsucNki00=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=uWKt6EWceRzgvUXp5NXRzduP1Ehe9EcyMzQ2O5WE0gWOS/qeMrXP5ZUnP/yXVvP4x7GWzx0aZBGFFxj+I8TtwlUehpclu6EmWgGzXyZHuHbUJf2bZkuuAlA4xrhlIV6+37UmnotxTYhJ1a9+/VDFS9aHTbylqyFzElOBeyniLjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9HjXOF5; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9HjXOF5"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so157587a91.2
        for <linux-ext4@vger.kernel.org>; Wed, 01 Apr 2026 17:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775089444; x=1775694244; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i9XhsCJfPlh4GHkbFm3hgDAzLOlaHJE8sb4/uRoIfO4=;
        b=a9HjXOF53UekSldf7w5oyQ5XWDH5vM6VGCz+6i7WchN6cChz+xwWv6RRba5VVzeiKZ
         7kNjaYAepyi95wbz+wv9WaQM7rauagtaOVRcW6KMiLwygWgZY9E7VPF/GHyb7nvP9rcF
         +l3spxzXSpB8Cgr50YYeRfl33aiNo9/gw5mbVDQlPTiDmFMARaWePpEb/E+hztuvS3fk
         K4yZEpA6Ti0DYa7Jk3lJWa8Hh8H+YwLC3duWb2wkzk1u+etTRmLeq1RV+C9th5bcs9vw
         25+9ZhyRddEd8fboARrOjAY3eDIsA8KXK1mgpGVlK6yK5MUUmmipb/ZbUnx52hqPPNV/
         /Phg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775089444; x=1775694244;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i9XhsCJfPlh4GHkbFm3hgDAzLOlaHJE8sb4/uRoIfO4=;
        b=EhjN8jabmIui56OCR6i7gtv4LhD0NowSAg0N/92vrwshHt1F9DrS8iriWrPC6mi2Wg
         zbqEGkd3Nu41yUTjY6XXq3ImkXPWiKAiP7j32poAipOrl9q1UTkOgI2GRRyvAkQ7YEwB
         1E874MDKDYJjbuLYBiBH/9mKb8qHvKrjXMJKoIb3hQxj/x4qAC4FzTknaq6zbwuE2D4U
         zd6DqfG3CI9SWxdx7VxuzwmrsdwcbGr6b5pcd5KuDwGan8jC/UdiAqQ6O+bfhkOtGAGv
         8CRbl3Z717HyvQgVjMBZcZl5UTxd6obJWGSuq7dReYsMZajX33Hl7asUocpZzLxTuJEN
         y7Pg==
X-Forwarded-Encrypted: i=1; AJvYcCUgt0tfb1IiK7H5qNRVmUxJ7859+5s2L1pyuaPrbYxn6MP7y7Qh1S885b1cf92qWyR8peYbk7YNIyuk@vger.kernel.org
X-Gm-Message-State: AOJu0YzWIQ0wtnu+hi+eDgLL81FQOlECFKPfuopQybjYq3xX0Dz9thBh
	63kd/PkrJ3UIcXxr2KvQckDTb/r87inyfnhXADPmuUm3b+QiFToEZ/7Dmwrfvyp/
X-Gm-Gg: ATEYQzwJkjkfMA4tpoCjae2QF1tcsZ8iBOf70rsSfNXxXrxw8K/t4hqa4kHHlLayLMW
	9gCOJg5AF4ameq3LwYQu3BioE7VA4rNPQSf4+gL6LZz40Rcl7ivLYcO+AnLU0jY10kdNyX8rTPm
	aRBpSE4GSmxMb5olIcQ/7rCcNCk48HDM16XnXTqff/HYjbo/OI18OTeL1U/p9z/fj9wGROVFF3I
	oIibBmo7+lmy9zspsIgrz2Mn6WMpjjSLGusU9C5bw6tMjdFNqrnitqpRbUlIAvDZOFv3ZoOeErK
	nqhJ32uOJb/44iAxotQZ9vG+TVppBi//6Eph/JF+MPBPdQXs1sifke1+6UJkv8I/wQdXh1LAirn
	QNnpWDOhClQKYTDNACHcP3dxS+ROq5p4I+L76usBBVuI9cVTmwA0qRbEtfiwJNz/f4S+/OGN29J
	RbrOUbdRbfJ5gxvmgHH5NAfkQVOwYx4j49
X-Received: by 2002:a17:90b:48:b0:35b:e4d8:e21d with SMTP id 98e67ed59e1d1-35dc6e7aac9mr5276300a91.2.1775089443841;
        Wed, 01 Apr 2026 17:24:03 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe5e4ba7sm5936280a91.4.2026.04.01.17.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 17:24:03 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH v5 3/5] ext4: fix the error handling process in extents_kunit_init).
In-Reply-To: <20260330133035.287842-4-yebin@huaweicloud.com>
Date: Thu, 02 Apr 2026 05:51:58 +0530
Message-ID: <ldf6mct5.ritesh.list@gmail.com>
References: <20260330133035.287842-1-yebin@huaweicloud.com> <20260330133035.287842-4-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> The error processing in extents_kunit_init() is improper, causing
> resource leakage.
> Reconstruct the error handling process to prevent potential resource
> leaks
>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 50 +++++++++++++++++++++++++++++-------------
>  1 file changed, 35 insertions(+), 15 deletions(-)

Looks better now. Thanks for taking care of it.

Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
