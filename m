Received: from mail-oo2-f42.google.com (mail-oo2-f42.google.com [74.125.231.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809AD4DF4DC
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951766; cv=none; b=Bkmwo1dUybZpDGbLaEmeJ3MS4h9KEk8wrPLp3gngfqQgjgJLytQEMWGArcU6MRg3mx9It2f7Wg4kLp+tNhX7KVLnIAdvqPFwRSVgF4K0gL16pJNPAETkRAst+8KODKc/ncfTspwfB6Q3IPMTUo0zY+/ZzvAX7FA7gUrK+EXnvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951766; c=relaxed/simple;
	bh=/KNkqL8brsMMGc5Cqzr5HLntXTDWrBVEovCUk8D0+MM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=O4AIM0SawvlFMoF76AIo399nfEPykAvv+/S3ah+9+kQg0E3w8aQwFPhktCfu1OGbm/DbXVeJkPdIbnF5WE2pGdLUZC+5/17GXfn9LGnKeyPnupGI2p9dkBmq9K/edqm/cvf9seLn0NSlN/fFjk6uOT1dGkbgcPF7Qcdq83cNl84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=PzDW+lfQ; arc=none smtp.client-ip=74.125.231.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="PzDW+lfQ"
Received: by mail-oo2-f42.google.com with SMTP id 46e09a7af769-7fcb425fb6bso36597a34.2
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 04:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1788951759; x=1789556559; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tZczqCxuq41VAhV724eZUITtJnRnt+MmYaUhid2/07k=;
        b=PzDW+lfQBEpFLI8b75gyc8ue8zKJWHtomeWlbHdeq4HAMqHCoKFuGr2SlvSm5fbzmZ
         QGesMF1rCd1eZFev4EkwM0Jaa+wHFrgTqy0ArZg6nVwk2i8GmbB7YNzadI+0HU3lvKVs
         wlO6yy5tO6WKyIVHs4/Tl0GQtbmh6eSE8dfgiPjuKeurD4+SKBt+19vgQwNU7amlT8ex
         D4AH5wWZnEO+kS3AmwIr3euIUABBC2RAz2wRNCEcjilcjB5SmpYuqLULDRp2/7VdzgVl
         L8PzfX1VmcKGPmKau4tuYT6rktk0eMA68OJHdb84YwIIvIOF5Ts4TQRWCo3hSxjVmBct
         BDNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788951759; x=1789556559;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tZczqCxuq41VAhV724eZUITtJnRnt+MmYaUhid2/07k=;
        b=FtHjp2Kb3DM0VSjHElZ/LNVGkEN/zfjUT6Ko9tPEAa6YASTOKv56tFrOSZm8Mo/g7f
         Rv/ufSuoGi9PF8lluwzBowu8mP0kkw++xTTbQwQssR1Rz0q3uz1zn+CtBFgjvsFWD0DV
         UXDctW7GM+Y8CBHAA3CA2T3i6Yjmw3Af/17xrdS4iRBl10CZRY6KALt5KTCsGle5Szh5
         RlaIjbF4Nv/SBQeT84XmP1Ah/uzMF/2/3XI7FJYYqVIKGmr9hELMzbWjYKIzYCsG6wew
         XQqAJvor/bk07DMgnu0vOIkUtnhchYy9jX4AZ1zzaqKbduZioX2jWvVFWbGm7gYEv4+C
         ZLuA==
X-Forwarded-Encrypted: i=1; AKwUvBy9t4FI1qWkuEMJBT341946Yc6mZOLNf5xfzh6tvyr0TIIQCFBRzjQEojGIJioRzG9l8MKENVGqyjoU@vger.kernel.org
X-Gm-Message-State: AFuF++lhuL1uuucY1ph170uzuxFV8ZAS2vJvGwWywEjSYfKih4rPBgt5
	W2++bcvhnEWCX+gWFVVjZiCf60jedxu70gZ9CrNaanLBFrH5lCQZwj2T5iy3/w6s/zA=
X-Gm-Gg: AYBFou1oX1yysyFY1LaHCmLUc1Qh3Ut0G7/UONBs8wtNwowL4lUeoaQkGTlTgi97Xu0
	bDLHLy36M79XQnws3voqLSfzNNn8HUxZ7VjthaBZA65wPjzIdv++ngP93BolYt5ejyXIRw/mFKq
	DXFTGgMh+2GVRrx2ajkwpWoEoVatm+3jYk0SM1F8Gv7zq4AsZaCnf8lAR6QzuX0DqJfBvQ6cyvG
	7kHLplsr5N0YplHwSAz2G0sESoDHk4WRRhgpRDvH+RVChQ5ofc+FpQkUwgpe65ZTn/+nFpCBLqQ
	xsDVx2B4HPDDOkT2UnG66jvX6RYzEdQFMdGPI+AlzrgHUaaEVILHAhTO7HmjDrPhs0ukZ6GXI5y
	irVzs/gaBygnriv2YAX0N9DWiFpUWpYSp6hcHzRFio9zeVWetOzpPid6lRZhGCVhXXeJvG0VS0m
	3UyfqKXWNjc3gmVJ+iL6GvQ9K0SMgU2rcinCFg0GplK0fVG3iyorRY+UaIR1uTEHD2bjWC0fyQM
	Z5TYpjUrHqWHcVrvWuymSogjZA06wWLcn4w+nWPSxHwn7msXZdS9AJKWQ==
X-Received: by 2002:a05:6830:6404:b0:7f7:f55a:4bcc with SMTP id 46e09a7af769-8020ee08c65mr696250a34.8.1788951759157;
        Wed, 09 Sep 2026 04:02:39 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7fa888f614dsm15905601a34.15.2026.09.09.04.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 04:02:37 -0700 (PDT)
Message-ID: <fdc957c4-2b98-4b76-9bce-06e4d27c233b@kernel.dk>
Date: Wed, 9 Sep 2026 05:02:35 -0600
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] [ext4?] INFO: task hung in io_write
To: syzbot <syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6aa0876e.f81106d8.285f0a.0005.GAE@google.com>
 <31ab7ab6-2cf5-4fcb-a6cb-05fab461e742@kernel.dk>
Content-Language: en-US
In-Reply-To: <31ab7ab6-2cf5-4fcb-a6cb-05fab461e742@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git io_uring-7.3

-- 
Jens Axboe

