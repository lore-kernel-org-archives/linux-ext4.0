Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3718F492E54
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788916224; cv=none; b=oPzjxc/XPCmK+8eOG4rduKGenCUoEK3nggODZ9yZJJkxEp6nIseu1pR0Mfml2Ycra6ApquUHzud5koiJRdsyR9bUxBswJclc5Y3zRATEdcxKaSONDHxkdRf3SnDgrPU+j+4pusU00LYmmFMgc3FjPbFEzaGBuK4HnVTXR3CiPYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788916224; c=relaxed/simple;
	bh=/KNkqL8brsMMGc5Cqzr5HLntXTDWrBVEovCUk8D0+MM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XHSZ0WvBtD0yHzwWHnGOV2Iva+D6FsPTFdxUsZuBUtjb/FnNBPiqqffNpBconMNvRbOJTmsLVIrG+C8DVCxWOLhiWjjWvDvFrxxMVmrvhruF6FAZs2T415XSSV/XjTI/u1hU/vFcFWc5j3lJCUwJquyfqtj5BmzN5q0jaG1svf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=NWZv+NG6; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="NWZv+NG6"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7f4df360cc9so5752919a34.1
        for <linux-ext4@vger.kernel.org>; Tue, 08 Sep 2026 18:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1788916221; x=1789521021; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tZczqCxuq41VAhV724eZUITtJnRnt+MmYaUhid2/07k=;
        b=NWZv+NG6ScWiJXBrzINv5nf+h2CGV4UewtnGQ7IVsT1w+viSyhB/HZqxuZbdSyN6NH
         fD1upKpbC5Ugif8JTdXzeAkgeGi7r8nqMLy+XbJjyUS4P4qdVwi/DLmAVmHvIZmeNcN0
         uNzLIQVzE42+2h9B7fCuUQIK4ASVycxHxnFyZN8uaKvqRxjTNeGJFXS/iknYk178z4/w
         Qaqtm/xrcpMtGqi0Johbxc+HvIn0dCXZ/xLQiYRFQjikoQ9iUR7H5l5lesstCH2OqiSM
         P9aigVKQGV+U02AZizU0hX58ZakAPxC7lZHwj4q1rjbdIncAjD71L3X9aRC8es1VDpEA
         abug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788916221; x=1789521021;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tZczqCxuq41VAhV724eZUITtJnRnt+MmYaUhid2/07k=;
        b=gKtaW2dtHny+FE5R6FpFfUls3qT0ikoNLzHdMbwPdZUAXffQP8L7Lk7zdrgcYsFv/a
         bRAjl4uWVpsm1rzvBy1EQXNLeUgR6XkSmTme0pl4NlppZFS3ymFj5ZbraGZIPdbeh+KY
         QgtAYNES51mVmxuyzV6a/pVZ9dPhEigzHMu6gzqSfCeH8BoA3LjKHNgS2jTpnZ+7pZv9
         xn++8XD/3T6ogNZ3O538RaYG8LSmomhi0wqKUSI04A7V1VzIGl660nLFFT8Yz5GVvljw
         e9W+uSQ2iHtjO+I6LHS9uwDvPMEOHWuJ7seJRV8Bv3MDvCVyq77mRv2jiGieMX5B3yDG
         YWYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzBzpDf5+pFvFO0WlYfZPF7hT67toYeGkMrXOd3nkfDh9QIzyovgWNgbc1uVIFCiQIZarUGdLpOtOOw@vger.kernel.org
X-Gm-Message-State: AFuF++nDn069ecrXerZDK2IDciNrNvQHyE2jMElsZhwBYwL9wDfNjIn5
	44T9WRRo2Vs//wuHzevpB53/FwyVH22/LZ8vpUy/nJf0HN/NsSftZkk71WjtnghXKjM=
X-Gm-Gg: AYBFou3C+ucXhUlfbtXPzczsmvR8lATdgSlvHhpfguNnxitnbCmKLGDztc/bl07AhDM
	V68rgwTS3oywCzrlui6u+vIB62cJrVGAwVxv6oyLqchlt7+b8Qcj0U7hpzeWqe+IxB209MH8OYE
	CbkZsp/SUnQ/2TS98aFI3BSwgt8h+AwMSjXgfdhI5vzqZi3XLAyVr8STdRPc0aEWkhj+qm743Uj
	WFww9DThFsyqPZTM/jAW48HrTmkB6utP81SQ0MKw0eF9lqwB/QtpLzt4lqKLaQg1LZZaxwCDvyI
	QeZTMnVfOoM4/mwowXow5SpRZTkVMFXhe67QhEGF7v7USD1H0B3Fz0I9XbQKzIT0AgO1gjTfwu6
	Naqh6dvxykXe+W9mbVCiwnKWKcWW74uIS8V2cqS0YeT56gngNrvL//ZKLMnR7ln05N1+n6oqhQz
	HLV0Z5NczD3pSB3IqvmaT/4krdZsjsmdxp6yjPZ7KBSyr06Bmp8s+XpkaGhiy1ey1P6s0rrUOBu
	7USbLdn/n9Uwo4bPZv8Iy2JBl+p0QAVMIhv3d9ACZ2mSAP8jSVdmUi7dQ==
X-Received: by 2002:a05:6830:8411:b0:7f9:5a3:c24a with SMTP id 46e09a7af769-7f905a3c4abmr10303149a34.33.1788916220674;
        Tue, 08 Sep 2026 18:10:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7fa642bc562sm16613685a34.16.2026.09.08.18.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 18:10:19 -0700 (PDT)
Message-ID: <31ab7ab6-2cf5-4fcb-a6cb-05fab461e742@kernel.dk>
Date: Tue, 8 Sep 2026 19:10:18 -0600
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
To: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6aa0876e.f81106d8.285f0a.0005.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6aa0876e.f81106d8.285f0a.0005.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git io_uring-7.3

-- 
Jens Axboe

