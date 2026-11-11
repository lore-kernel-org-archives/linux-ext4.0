Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794402605;
	b=4S3awUloSg4nCXByO7bsmpGRvE7dnssVpNqEgS4tDiJW3yB+1fSXRatYvMPCCBlmK94l
	 3sxXmmT/rLy72/Cz2Xh90KiG630Hag02s1TUU7FUcSEJJ8PW7hJqhmjCHKWYQNsg7nH1Z
	 slxR4L5kvczVVIrxLrjLYwVbMoxxmB0qeXuD4Z84bdllEC6unlAF3Ssm8L9JUsFfAkBft
	 PmrflvsSkOg2Ntcs3gDtNGuob/JZ/FGAG7hzUYfVoHM/HDTt7EEpLwPsSCkPinnb0IoFo
	 mqAoISc8XLOm4HpudKEgqoIpah7W/ES+MT53xFRbwzSOAKEhHnIHDhSsnsXX5/zReew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=50VbJogchqDQzU8HRSzVY3/9D6QJQ+rTsM6+rMs8oJo=;
	b=ZYCJ2Y2RaVz9n8QZ+TVK6c4GdgqfO4Qj7Yt4awzBR/OPTl7MbfOV4J4b1FuNfTfqdfj+
	 wece4extKctpbAniilXME0pUpxFDVhOWEgKILWm5e/SBOmvjHpszAMHdWQJzYPl1xE4pH
	 9PPA+CNs7yuT7R/E7wmaRqF72HpNlafI+NgbU4j6lXxUzsbknqkDB/MSJ5Kye/Bk0LUvZ
	 iCrPpWZd1EIaJBJOrGoiOBwgSfTpKTwSlJcc1+RSy6v2gHDkN4QKgZRBx7TP1hwcYs+Im
	 Bm5PBqr5rl9IWBwwjnw7FG4haKbR8K/v86tjWHskI59bAv5jvN2Sbg2R0glTLVuRyBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uFaGAJQD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.75
Received: from mail-oa2-f11.google.com (mail-oa2-f11.google.com [74.125.231.75])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96EF606A326
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:10:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B96EF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uFaGAJQD
Received: by mail-oa2-f11.google.com with SMTP id 586e51a60fabf-49e2cb73ba3so1324173fac.1
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 05:10:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794402603; cv=none;
        d=google.com; s=arc-20260327;
        b=F8/Tfcp1mca6vjU+QAvg+Y297crLHw5a0wTgkKZyeyHg0obZn+kQhxvwYL9UwL/HrN
         71jhPi8WWzP6GOor+qQmbW5da9/PH27RCNw7PYMDR/WYR+Ja7Gef/h54lVhHQcnIeA8o
         wlN6WyThvUrlVnxS8F1alkNg0Jh+pRmTyx6/ckE2NyFy5gNJQxNt/dtQsX7CH5da3vPG
         OGkUuaF8cV61DdDAYNwaqwvNZdvkyb8Nb1439j8wcVVqZSXaO9zYBu7Rfzam2ATGbXUJ
         vYyvTyTvZYc/DGrBKBRNJMei0954q+ACjxdijhsFEN1+SwIuD5qq8Cwhbg1zzFjeD6u7
         a6bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=50VbJogchqDQzU8HRSzVY3/9D6QJQ+rTsM6+rMs8oJo=;
        fh=Si6J7aZSpytN8/EYrRjJiKUNQaMN86j+Ompq0+idjHg=;
        b=dtW14pVpo6FeQ/tSXRDfJwI1O7H3hN6sB3HSStpybe6NSwcR7N/tpAaUAiYdGN1ceb
         dAXvaiiyuDBm7CDcnc0qxfB24YnDMAVPuYhXCDUt1e9hbD+X5WMJNH87Zr818/QX0gdH
         50b4dTIh6+p0sLl/usuT5nyQwii3yAcUljgMstgjKHQjxFkLR9SAK7NjVBdiDhCB3TZv
         3dVbTDCGNtMLaPfw19YreNfmIFFXfYOyVqtFgqqg37YPPZXTspjcDjrBClnkGqtDSjf2
         P4LUQczWprwXbAbtGzCm3VUBgBTtIvCUptLgezLLgPoivpc4dZk7pdlNpdMGzUuvh/x5
         GB2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794402603; x=1795007403; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=50VbJogchqDQzU8HRSzVY3/9D6QJQ+rTsM6+rMs8oJo=;
        b=uFaGAJQDnOokATzCqsyqacwPwGgl9k1FJSDfxv5I4gvUMCTBlha4jhI8rBuVvMMqpl
         TjcKRyH3xn2mH335iwXFtECcXYmFjjHfUftEdQzmEX4Uw8xZU//1PbmhZ6fHgdZ/vVjz
         MVcTaWlFvgNgzn/CGEGc6gIL5vnoPiWLBE5bhZiAc5MvvKjbLiK50YlYHkrv+m4kD6R3
         q5u5eLhkqHvOigookWzlefytCTWYmjZApL8V5+j4t+XxzbqBUFDmHIk+rmgE08gHFZbY
         a2i5M8pWulXlnkzKA/And4ymHTLX+Z5INMotXu4FC4kuTBeey2j+kaLAC0LAusAGqa8L
         8EtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794402603; x=1795007403;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=50VbJogchqDQzU8HRSzVY3/9D6QJQ+rTsM6+rMs8oJo=;
        b=OKLQ3JpDCONkgQLabhFOSwNnYK/iV4EJIvFW00bKUy8D25cuxs/AfRdj1eAkGZhCD3
         gVIK7sT2QAKx/rQyramAoKDdflfvK7dYfFjnJC8+gBVc7a4Ty7OcP0QiuBXilgS1rOkG
         q+49A0op8YN7nb7idb22+MU7gg6XIl1iGhMneeJ8SiJwfw10joZeKUD6rwYpH9IZgDTZ
         DNw9dgH7DLs3bH77ZpwHArnjN4dG7CESUEJtbn3QPnJpAJ4pT2qlit5Ukn0z1whOAGK0
         4NNwqtaLcv6JRs7uthw+eYP8ZzCKQ3AwZRl/we3/bg0uhT+OVlD58uQJyEf2RYrv/61+
         EQJQ==
X-Gm-Message-State: APuU4Z8L9jr9GAIeswz/zqlygl4bt7Bu4a4vRMkPqxNCKF5y3YAPSbGr
	+giHkhISUuqWM6mu6+UUDl7aw4p3oadvQ5pWxzZjX8TKDh15IYZ9ccchoDvzFSMjZa/BYAVuezj
	5U6WccLGtCSvMrVBuBKcYeesNrCLeRHeiVBb7BVl8N44o
X-Gm-Gg: AYBFou0HBSs8koOWZvdqtYVA/giElkTOZT4kzHuSrfPatjigIOUFhTeOK4btyYXP/0q
	cHIXxSBGTxA5TsL1IktY0LpYHFIUFt+KAc+/3PzaWROYYhcW1OwBxG/g8D2SdCpR6a4xQGFPzoO
	uAdI1Nl+TXThTd/+Ql14P+sSzvE+Vp3AeSNzqoRsUllDypVa6Yz7T1UKeZt4+uiV5GIp+898y6I
	2kHUZK2OINAiYE+OMP9FMdBlko9SsRH3s9eJKc0WZ9OMMzoGdjVx0zvQ2faRfjqGiMgJp7e7m/B
	cAmyDGHg9Te8/NhKLlFkO5T39/c7vSxHMuvq37uEhC6IIqWbNDljr/HLPvmyXkxNvdZy1+3xMoI
	Dz34Fu9+M6YTBDYDisxmeKDz/QwJaBYy4hepRUbwmkhPRK0AG95y/KokxDuzoC8hAh4RwCJ8KHu
	eZo/11H+j89lpOwMJ6RLBk4I2xGnjIxBdSoTWVaeSXloSbMULMwugO/Q==
X-Received: by 2002:a05:6808:244e:b0:4eb:b0b9:2dbe with SMTP id
 5614622812f47-56b96ad3458mr2053423b6e.27.1794402603366; Wed, 11 Nov 2026
 05:10:03 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027035857.72265-1-dennylin0707@gmail.com> <sashiko-outbox-186069@kernel.org>
In-Reply-To: <sashiko-outbox-186069@kernel.org>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Wed, 11 Nov 2026 05:09:52 -0800
X-Gm-Features: AclHuK8LUmufgTJ6wUMSDnUFz420gwBNsdzneZ2MWjHdnCLxbW9xM_w8VZUeQqE
Message-ID: <CAGEkeHeXWmu-m03CQJYXY8qiS=zreF0DOmS3TdQNaPPpiruoMA@mail.gmail.com>
Subject: Re: [PATCH] ext4: preserve force-fsck requests across unmount
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hi Ted,

Just following up on this patch.

Thanks,
Hungyu
