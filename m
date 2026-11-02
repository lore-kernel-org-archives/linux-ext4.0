Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605674;
	b=NWx8j9rItXXwjM7WRDNv4STW3pAQGPhAOtEeNhr549AcDpYiA2wDPYy98hIXj6v8/voA
	 CLPAMMbuyrPcZbbWJGfwcAmc+ejck8o0ZkRLGK+0AMss5TbSNYhbfzWyuKj5cmW0OdhZI
	 CWI3bzhNgn8OIbL5A1eNMBUJyVxUQtHI/Dja7vkQ4QlPaOZiyPvYzriCJFm98LzRmh9nQ
	 tdjX8aOPToguFv85PNKQ8KHpingdDiwqSIpwOmEETsGxP8sCMO0oGQGJs/6l6kRJ/smPC
	 2tZjLmSM26jxx+6LdAnzrOS4pUNOQZSfC16uAr1Yz1oRo0J0bSltpqEzw5iO8Cr0MbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605674;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=JknwNPltG5sxmLJxATvT76Qds3tkZOcqqJ2tuzt8vvw=;
	b=kW49lUhsm9Xj1Pu/9cnoXAqW9cdCwBmVpsHJIxIdVg+z7aJrg8bGo3zt6V3A0xpRkrWp
	 Y2xyD2TE3tRnDm0xyXtdKAc2dLzeQu+Xo2vreJQuOs9Ui5menWksZ0bU03vDpHFG+kEgT
	 3l770hZ0GETxjVruLdX4g33bsT61F7dunBd3pFrNObZN+ZYhMu7zMQRtBmqZ0YZr0hz4f
	 eJu8c6KPL94LWvi+i2rHUQe/bBiKWxM2qlp3p1XR6xRnhOin3nLQ7Ee56DksfSKeboeYz
	 ZDLpNgs7PSRvOrJ9GJJZmZdEhWQ3fQ2GVW/rsLWXo4tZte3WQMChLceFC47pRWnlidQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b="Lb75wL/W";
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA79606A334
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 07:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BA79606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Lb75wL/W
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd6a7e1f4e4so1076386a12.2
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2026 23:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793605673; x=1794210473; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JknwNPltG5sxmLJxATvT76Qds3tkZOcqqJ2tuzt8vvw=;
        b=Lb75wL/WOF6bZydHfVgcO1LI7Z/npId7XZUm4v+RcBg+Wab7qIuidXS51txpGvn+0I
         bEwJnRHbnPVb6CTSpv6l0bSZ20T0rIKCJyEUkLHQF90+7m8GOjOulBy5HL4ELoRDlyqM
         WnpisXwES3P9szyyMp+9Ks3U/z47oXP7Upj9oyWxylKKlQ05HdjBwm1fps9cJ0kFoH+1
         E8Qy2kwSShuNQuoGdQARzLPkvN1+3s4c0NoxdxfwHRpAdAOqOZPURpYbiUxn8Rulj0sJ
         Amf/EXviTE1u7afNmlywXr5sA5EDf24JSavz/o+2+KSdnXF/ONdXSt+Y68x04ZgCMnq0
         VLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605673; x=1794210473;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JknwNPltG5sxmLJxATvT76Qds3tkZOcqqJ2tuzt8vvw=;
        b=IAzYru0WCAeHzbPwlh0Nb5ZKa1Qi7uwxHiM/kshrDV4VY1zJ3u9VQBky6jKigmqc0t
         ohKQIej0jeR5FO9+7vmYOcrQN+nQ7aVleQ9v1UD0o8ho1/XSMI1tGC+UlDdbQSM7stc/
         zz3fssGQM1tA8t+1y+N1JqsK7HcCGN6/U8t+4oT74R3YN4TsatpIA7QRJRO0i3w2l1zd
         BD+x/5BUghbU96lDPw7EYQof8f4KSOsaR8gfNclwbXp9ATZRHeCz2/7IzYmtEjazsQdW
         bEU1R+eJliVnULnMPs8Bfh3HAScxVjbnk3OlycbWx31+EAEflY6ndrUXlMjEzCC/vKZY
         h3Fg==
X-Gm-Message-State: AFq9FYKiCn7qlWmcwquK+H9aJV8UtwSvGdsP4clw6CZ2D6DwoHjNwgaG
	HdPsEPH5KGWeZOIkpJbiKexrkgQn2+jvmIe54f+bdl1VyjcBGIUx7sd5RsZOV2KgpEo=
X-Gm-Gg: AYBFou3WCB5ZIlH1aKVEgCxuVIwTSOTc4ObKp0P8p3A/FUMi2eR04VIf2usNyjVcnvG
	1aCpSWzdkq1X3aAnmYYHAJYpycuTQRmZPR8C27NadeaUffpyxO4VRFefLdf/XpgCzQc4K2Z1vpo
	NlNWjhA6aFIisPasmUBjAJFULkwNKTYbqc3trWwjBWzJQZoD9PB/Mv0Acu0STgb+wju8PdmStWw
	0m2G8s+oYR6T2lvWAI9/JYbw7u0oTIt/fqfp+1A5yKwQES3Z+RplG/1MHSL+BQWM5ARATTscFbX
	PKzAftgPBdUOwyFIhzIvSObPVWD3LaIw1HGSvIM0/pmck5eZtK/N2JxPTQsa+f4lM59XMuDribG
	h3PRXMHKMWDerXbzVXRFLuBOddEpXUHhvEB5/goPD64vHJtLzZRhEP4lmnn/nrPiTr7cNZ/TwPf
	CQzPWS+fWU7bapMysQF2ycjd/nu9R66v7Xlcpbe4QU6v8Xgb80y2q2zE7fqcNzMPjKAvbDSjMk6
	j5HYkDYrXRkEt7GS1cyS/dXPe5Upj/VZH6qymI4gaSxFnmBh4iiHKZn1PQOBnCPjFVWz116wpCr
	O7LhF2gu6hqPRKkIM42CowMuCn/CVb0VLrt3rg7GSmjK2oHdeSYJycwiySFLj1lVYOmgB7P9
X-Received: by 2002:a05:6a20:430a:b0:3e2:6bbd:de4b with SMTP id adf61e73a8af0-3e9290ede4cmr9006047637.71.1793605672821;
        Sun, 01 Nov 2026 23:47:52 -0800 (PST)
Received: from [100.81.10.186] ([61.213.176.59])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aadac9c505sm1657168b3a.53.2026.11.01.23.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 23:47:52 -0800 (PST)
Message-ID: <fe245a58-4cc6-4bf2-a096-efda8a6491bc@bytedance.com>
Date: Mon, 2 Nov 2026 15:47:47 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] ext4: report unwritten extent conversion errors to
 fsync
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, riteshh@linux.ibm.com, yi.zhang@huawei.com
References: <20261023061851.45579-6-sunjunchao@bytedance.com>
 <20261102020508.2677348-1-guolingxing@tju.edu.cn>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <20261102020508.2677348-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/2/26 10:05 AM, guolingxing wrote:
> Hi Julian,
> 
> This patch duplicates an earlier patch I posted on October 15:
> 
> https://lore.kernel.org/linux-ext4/20261015102943.74632-1-guolingxing@tju.edu.cn/
> 
> Jan Kara reviewed the earlier patch and provided his Reviewed-by on
> October 19:
> 
> https://lore.kernel.org/linux-ext4/sclc7h74z7nwfwnx2r62svytfaxquxws5chnopgryh2lpwqqd2@twxuiugbudw2/
> 
> I have sent v2, dropping the incorrect Fixes tag as Jan suggested:
> 
> https://lore.kernel.org/linux-ext4/20261101102145.647496-1-guolingxing@tju.edu.cn/
> 
> Since the earlier patch has already been reviewed, could patch 5/6 be
> dropped from the series?
> 
> Thanks,
> Guolingxing

Hi,

Thanks for the reminder. I'll collect more review feedback,
then resend the series and drop this patch.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>
