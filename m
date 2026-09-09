Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1634349B3
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 11:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788954410; cv=none; b=OY0zTKaz3ivQuDCHaTNE59MsrMD+BFbETWno3YDSMHVadWg6bT0LXaDFeg3+wfDsJLae7CEPcoImFp44to4QSWgXLysmd6Q8S+kIzCmbSBUvkazacCEeUF1QBIjcJMHtK0amVuuHKbAPPNV6jEo7D3tlssLL3jSdG6Lxwc3beds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788954410; c=relaxed/simple;
	bh=/ERtdL7Gbn2UEcmCAicOL2oG3iKCG4UiwrEeoTqqEsw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=UJIIA8fPqriV7AcXkfqPCP97FxzqUpqrOVyj6Cy22rEVHnDiesIe7Rc6YeIdGjcs4+9IzORAEppOTU7yy4nyDLrTDHBgobGaPE2XYJ+YCljGoEZrvfeIsYRKffyNVEEAmxUyXd0Eud461E1hEyqFL3tfpfQ8OQdhN8nV6NYg6TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=j+5LNeBF; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="j+5LNeBF"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4b28df1f600so4231479b6e.2
        for <linux-ext4@vger.kernel.org>; Wed, 09 Sep 2026 04:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1788954407; x=1789559207; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EdSBvbVCMly05/MnJatDjpn/i3lZQCfGuxvHm2Q3Abs=;
        b=j+5LNeBFkVFY34F3Z/HuUAhPUAy+MGF/O8DswfhcGTX3zfuBbPSKoQNjPSys4gYKMr
         BciHeQRa9ypBjihd9EQEKYPXIItexDoWvKLQ9fDN3fxBJd7tKV2ZzidsNn0DtcRxL/eV
         Yuf9ZOyA5aEeM8EvjzT0QuX13UWer8mPgu9ryxnuYRItj/eepljoRN1d1PsKgQmSr++t
         5cwVOQJe9+NvDXN7m6nR/L8wnG4N6OFrxkY4k9bI+mBg+7WllFksEqthSziZqQRIjKeu
         aQRSlqgUzULhLqMvSAh1e2X7TxTQkcEGyo9qJu8Qi5AGqYIj43W45Hu3Zve/75ouoGTX
         GCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788954407; x=1789559207;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EdSBvbVCMly05/MnJatDjpn/i3lZQCfGuxvHm2Q3Abs=;
        b=OsrcP2cHY/ZRP4jVO+lkkIVf6WNFcrwnYhikJSe9AjXu6FC1X4UBee4MprzcExjhNE
         P3lVRxHcWOEJxBvhW7ROuWs0KjmQvn787O+6AEU+9j4fLL/VHGf+3MbQxglH0UcRK3d2
         hu6hFpLdD11NPfGyht7AaXSEo28MhhYGTeDTGZf7CFRPAUwjxVEKr/2ejXAivAdb47gK
         Fc0EDooXFWohbUQSdM9Tgm/vcrImBQdkt/MLB0IUChtkgQ8BIMEoAItzjhKBCmWwo4Ga
         LpQSdbMtBxFX/mZKZi/H6UiXRRx+IEVyFR8VApKcUSTPRtfxTmqgkvkbv1AGUv8JNiIe
         p/lw==
X-Forwarded-Encrypted: i=1; AKwUvBzzgdKhZVfBYJj7+NumHsqwS4OF7sCgZywVd3ojFF/4mEhED9atFEcpux8zsads4QHc0aVS5MZQD7+0@vger.kernel.org
X-Gm-Message-State: AFuF++mGWj2N99On465ztofuXJGVk+l9ELfw2rWE7Q9aYgh7HcmYhUMj
	zHrX531XnGsixo/IVqjGoZOx0efjYDebDHazTwHBWqSuLHWoshjcUNkzXwAtojiqKtE=
X-Gm-Gg: AYBFou2BT3Vzjc/vzkjjcU33zRNsSei0g09lkVW/R4IeEtJTLDP0xKTieeqbJazHBhJ
	cdBC4gEAlA3ykib4ybO008mLSEjisU/vIYwQOYTX6FHl1nHRtGt5DVG5N/pgSoPhmA3t1zOyaoI
	d5lt+duiX1NeQERqR51PhsT/g5V72raRPRif84HpdTW21Pm0A4E8YKQrxUh44pviEJwhdVpAK0g
	vc41lTvy0dFgz+JRBmuMJ0bh6Ms/roH4vJAvVlW1DUs4GVl1fEohuKeURjwW09HPr1eoochWQqq
	UQnNeQ1swJSwhJDSp7OwlUZqv/+IMR8GnK95ccg4hQ/PIdmdX93kRklczDurzADsoe02/6bZcbb
	1ScfBMCD0SDipV7RgG9l6FvKxplkv0/IEG/j+4OBIro8nSWbN2eho4RD02oR9wg5k9Vvg0Agzk4
	BOUZ+MTV8NEPBLwCRFOvjpjyU/TJW/8tQBuSy8E1RLQwYEUpoHgUf+NU5F7WCdt6GHViAVxskeM
	ID9w0Zq0iChhwhjODOg7FEK1GLzcXH0ZWDST2l9Y1lBpzdMmjvBs440lA==
X-Received: by 2002:a05:6808:10d5:b0:4b9:e6ab:d083 with SMTP id 5614622812f47-4b9e6abd419mr16647584b6e.35.1788954407195;
        Wed, 09 Sep 2026 04:46:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b96eaa508asm16532607b6e.1.2026.09.09.04.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 04:46:46 -0700 (PDT)
Message-ID: <05177a9e-111c-4595-a7ef-d3de398f0a85@kernel.dk>
Date: Wed, 9 Sep 2026 05:46:44 -0600
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

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest

Let's try on a new base, perhaps it's a mainline issue keeping syzbot from
booting.

-- 
Jens Axboe

