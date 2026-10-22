Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792714031;
	b=V1q3vsaV2HD8Johj5ALMyPsEVnPtLJLEn08ewouN7EoqV+tFC+3faOVUY/Q887s9q1pw
	 yFEoWh02peueuLW/ogbM15nN+QJU7YHcOMSXsBEVQJrCPGQ1B0t5uu9qfWM/ZiVb9ICN8
	 fPt4TEuB6H2zGZakbvL+HYJiP0mrWIykMxABdZBJbWUYfV+3k2A9keavW7tSyZdn7tqCJ
	 64USpFCcPpUpX6jF7bL21+f7K6m2LQipgkD/JYrwcDPWJQ6ZBsttq28USVa8oXWGilfJB
	 F9L8zNM+bx1H1zeMNZUvw2jNc41UVl0g6Qca0yx1yXGCLS0/mbHKKqMsscdx+cdgHUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792714031;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:In-Reply-To:Date:Message-ID:References;
	bh=Z4tHu2iJi/e6dWyG5BERUmTg792NLmlKYp88xKISYEc=;
	b=inohwb04YlLL/AiJW0PETPq7JvD0bF79ihXURORlR9I21nnBloC+4inBMtulk7ShZe6m
	 j0s11RzhpMnZt347iTlfYOHWeTY8NoG7GamyebcpEuaB3ceagxbXyzvaxYqlVmnF7mji3
	 W6Wv/LN3rrD1OpDfhErl0uJnwl82OVqq+krNEeKCNtt8SgQyIbVXLXT8h8n61oJAET883
	 91XJTdOPn1+J9mERGgHqOpbx+KgUA++O5XNnBDveeSfTkxUIblq8jFStfb4gJZ1znQG1B
	 JOpW7kF/sRJAW5MG1G6/5x3M7VSxWtEy18QQDqvpV1DlAfuuOYCovM+vKDfVrU1Zlpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=m+GGjTur;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFA606A31D
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 00:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85DFA606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=m+GGjTur
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-33fb4680717so984903eec.1
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 17:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792714031; x=1793318831; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Z4tHu2iJi/e6dWyG5BERUmTg792NLmlKYp88xKISYEc=;
        b=m+GGjTurIp4URWCyne0AEstlg/S/hifwoIK3vMGc3ULvXuI2/avQDamAyvbwufeGmM
         d4UTiM6MJMonBPDDNPmFRfHQX//HDuDMtMBQOazdDOj1QtK63quy3MiaQuTpH82vLprv
         vx42K36TjgoJl0Nm6EriCVLzGGvhHcMqXtjwW8oaIhWml1qbU2iKsA0CZx9Kv6qM0RT0
         AYFmvn18BC+UfLUm1pzPYGE1a3fqz2ItID5ZRGn0AWKjkP1pcGUfgbfNkzl5tf5xh0pD
         B0X6oCzteP7JrqmNHvJ0dpyaA1YvhgOmNqRL0LfSiKZ43JNbXrFuQsFque5GTTO0G3yC
         t2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792714031; x=1793318831;
        h=references:message-id:date:in-reply-to:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z4tHu2iJi/e6dWyG5BERUmTg792NLmlKYp88xKISYEc=;
        b=dvgabbhnN6GPMPMghGhMxI341vREC5Y6nNFuyKTeUjp54tNhkUJP6Aupji+cx6ZLH9
         fBl7JRGk23r7hf1ONy/wozGTb6eqYnAXxNEX39WiVg1IYKvU5n7oPEzsNUeynhBjPKF3
         7sfWBkcRVsW95a8+hjpuCUyavH15CyS/WogSwPFo3ZaqVogSyfb14o7D+1QiRYWPymda
         2HbQ4BvWu1LdOVI8TAyiyDqV9LBXlgKHVcOf7D0HTST7K2Xtb66rcsTL92dV5KI0JNiG
         bUkyvipepgb67UXvzbM0ApsO2PBLMTp/dVA3IdIsSAZYYQiDSajdBcGsfQesYrT0WJeP
         gCTw==
X-Forwarded-Encrypted: i=1; AKwUvBy9dpyQv57ij3tsuyqbhqX65MBMtRPPAkM5pygGzjp1lx/qzkbNmPQgjnSl+DawtUE2udX9WnZy7h5c@vger.kernel.org
X-Gm-Message-State: AFq9FYLtWI46xmriV/3T8gmKgG4bfLqg4iLIuLP8yYSEANbjQ23uGh3w
	EZlhhxc1KlWeaBxwkAiEA91A3nkSQ9v6H9Ktosp9/lPdo3sk6sXkdu8+
X-Gm-Gg: AYBFou0pGIsABKHq8dsT4gG7KCSDHzfH6ID/wqHOPmbCJr7uN5OM6Oe2RfFRU+B5kSv
	YFpXdy2+ID2GKmENOLZ/D/EGjR08Mx8uZXPjTy5FyUPA5l3xngmx+6uWrBoCOYhYjpu0F7sIFbY
	6skm+c22DZTXzdwcjPYiAyKCRXK4jDBP5VlmwROJ+XwmTWjwJLvwuh6rPk/hlNmQIzNNxDfeXPD
	xgI4Hw6HCwtnbUnYvHjAsX4A1w30/KqdnttKeuq2nc6w42wsdebjkYEdqcqqSvbv9tu8W05ER78
	N/s2KMB2LvCHbNiYT0z6F/5y/i9gD7VGQfIYkP0fBd4ZBSotjpPeL4vt4oeq8S1dd4iZEPZZ/KJ
	SL8iRPj/s1sO/fcEQ57RMKM9S0BLB2qXhBSaTQGglrhh7wJUJl3p/Myz1bPEIwgdwLqlVcTXReQ
	3UlrBRkmpoQCi20zLKEt5JRAs8TNvLLqNsiCx6H2S8QyHAS7f6LsJZiOtyiyprh4udvdpa+dqzU
	w7Md92CI6S19kRZlfMCRVJJFCtlZDAAaIND8djiLb+su1iPrtq5VA==
X-Received: by 2002:a05:7301:fc82:b0:35d:84c2:eb27 with SMTP id 5a478bee46e88-369d986918fmr703493eec.35.1792714030379;
        Thu, 22 Oct 2026 17:07:10 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9db7970sm1525194eec.19.2026.10.22.17.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 17:07:09 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, fuse-devel <fuse-devel@lists.linux.dev>, fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
In-Reply-To: <20261016160037.GA107919@frogsfrogsfrogs>
Date: Fri, 23 Oct 2026 05:09:47 +0530
Message-ID: <fqxx5mpo.ritesh.list@gmail.com>
References: <20261016160037.GA107919@frogsfrogsfrogs>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

"Darrick J. Wong" <djwong@kernel.org> writes:

> Hi everyone,
>
> After 14 years at Oracle and 23 years working on Linux, I've decided to
> take an extended break.  Today, October 16th, 2026, is my last day.

I was a bit sad to see this email :( But then I read it's an extended
break, so I am hopeful that we will see you around after your break.

>
> I don't have any immediate plans to drop the djwong@kernel.org
> forwarding, though ultimately that's up to the sysadmins to decide.
>
> I have very much enjoyed working with you all, and I'm proud of what
> we've accomplished together.  Good luck!
>

Thanks a lot for all your help throughout these years on mailing lists
and over other discussion forums. Really admire your maintainership
style.

I also feel lucky to have met you in person at LSFMM-2024 and to have
had long chats with you on all sorts of topics there :)

> --Darrick

Hope you have a good break! 

-ritesh
