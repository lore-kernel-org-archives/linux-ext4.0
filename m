Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792592814;
	b=4h6hgr4UDg8M4UH7CLNR0SeGvet7ivkCfp8SqWqHYb2opZu5usePAK7NvEJ7GVYQ4u5+
	 CgJ7oxBNmHMuG+bGmdgeJ44tQbE87fcwUGqxz5DQE1nB/+9KgvqGVrNXzCrjZUiZ9+Q5T
	 WFY1l6J77i3nAMwuaAEfPbQjJgrzDO7yT33uUF9CyN0gxQ2/mJXga/GIT7FoNyVFc67yg
	 Sctpd0qnxcZh6zLWXZOB0YQSzyvbusTWQwyfAbjHzAv0h4+Y9UaXQv+NYDGHu8c8qE2Uk
	 Xu38XCidg0WNOU+dMQkyVW/n9jIPhz8krk/qn4uouz7WbQN2e7IFcm3Kc8EogeIFHfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792592814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
	b=2jxBmXu5JrYACfLI3+EksO7sAVxAGZWAyRD/8t7l1A7PysrpgOU+FkasH2IBjFxs9MPc
	 10Yuxj3+9fjZdFw9W97ubnKhtZNfGqn7xnm/SkZQt+wQSv+fYJOjoYrW81Vz745F20K2v
	 9pqEe07cg+dap8yWQZWWXyOYNakN0/K0KAV6DuzFSOezrJwN9XDUxTRW67/t0yF9XBg/I
	 J3Ul3+WUeQWiYaTRjaTGsMj/iOL4GLFvPbg0wQ5vElgfjnyV+66GlQzpHhofuSgAVkENM
	 FrZb3rYMbEwHWjXIqug7/qLHWXJhiA+L8VlnnTCDtyVRpLI4UHdj7vnbf1vfUPh9LVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRqHAhOJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319E4606A326
	for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2026 14:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 319E4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BRqHAhOJ
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b3f7763d88so1014406a12.2
        for <linux-ext4@vger.kernel.org>; Wed, 21 Oct 2026 07:26:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792592812; cv=none;
        d=google.com; s=arc-20260327;
        b=TLYsYHY8Wi1miexIHLz733m82oaY4+4kcJLPHF97yvUII5NFSB1NlVn2FRtw6WceDg
         hnn369cCQQkORJrPNw+E0rWjbf05ictaf0wXWlGW+2ugT0ewqab6rvqgTefezIscL74G
         pBZOqGuO126KvsVDINDHfNNZjl6orUjwwhr0KjLqgoLxEO1nNG4F6zCCVshoGfwa7Fup
         O/N4TEGtGakXTCyxGlyZuddWqBFkATlpKnGX9jqaJr8qal0dvYsgZ6yYvDmeg8YJgClL
         CcAUn19vg84XHBUbMT5sTClvrv2wjR9735A+kaQ740W6FT7oELWb9QrFw6itPwWnpalc
         XzSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        fh=szhug6CrWKvFtP/eYYUvs2k5K6V3ic/SghFLKNM47yE=;
        b=RND5lskmjsTGul2mkhBtcxrnbYiTn4fC8xT/MxOD3ZFzEvfmmPQ1nc9hcE2/ed7UuX
         MhZeTvfWe/MDjn2SD6lClzogaEWCGDFbfT4T02urbO63ovxoGXQWjRr81jXJlULdTvev
         pAG3puJg2hvkJEFSMfeIwxu3JuDXNHLf4/emJZ8atKTc2XZsDQ4dbU63LkDSkwcpo6c+
         EOXG3GsMQyRU8QNoWPhuDPQ4YeWRZk5Uf9UEvqzd3NPI/L/CclEA45NQG0dHMgK5jmHX
         ebgqRIsH2YtSXoDY6ODxAyzgYpe7f4hAbWpwq1NdQyDdYMeKOrMIi+DkLKdfuRH23WiH
         Elhg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792592812; x=1793197612; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        b=BRqHAhOJRFQGCZ0436cerbXsvDGcjOTtcEFCOpJRV+nbVKbSAKMl662tBLFTfb2Sg5
         NFxQNyHoxxgYHQR13h13k71ankQp/N0fxgwfPZdFZZwD0LZwBvhOQiky2tnvBNcGVE92
         vpRJ7hzp6lhKrZveGyDGkQ94JZjS5rrim4/SQCOenhyqo5st97RuKWVFwTkWZQ5bTbIw
         iWX7FjROAHIvHplEaKREmJYGpSp7sUQFKLAPhXVjYlSpM8WQnUK4iSviJf2DCzgxJwf5
         mmlBS+ISZT3vDsrX9Xx3+f3KYgz6TnHUVdIwJP9bY9OfNIdfJdTh5lFsIo+qwhCRzOmH
         nAiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792592812; x=1793197612;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HZWCDTWe8myvVLhLnC3gRwnDw2Z9dfDRU9KvUScIux8=;
        b=wA/zSnf8+GT5fb0ZH9FxmdXEURMx/HK7zZE1Kg/ZQK7wCyqB4qVsaQcLQ0FMJlSptv
         czFKPuotrhETBU7AkW4evlmodyzMz9qd49BWBNJm3j30HgpVn3dGbRAGhah6Ww/IWM9W
         5pOiXC6aK2Vonh4YNbyXsb0Ontb5cXUUk4Jj2rYUHFWxP4q1SrbXyO460hijtT7YP5tM
         2UsOgrzXWGK06CFhjCJktMEZZ28GG0sULL1RHDXY4OBbvhbRKidb/kmL2dxG4tP3YpVB
         zghEg9IvbcAZEbDCGijDDUXT6hTXsAD4JZbCIyZ+j64bESNHBVtOq38aIRfzaV540e7C
         eQWQ==
X-Forwarded-Encrypted: i=1; AKwUvBx/X7DLOW5vIjYikhRDouOn/K8mkCPPlzBtieJfCbTkDSD3NwEH8brOlXNkiJ7HIeyxQH7MrqW65HA+@vger.kernel.org
X-Gm-Message-State: AFq9FYLdkrveYKx4qGw/XQU4BXufYXnM6+pLsaYeymxx9vcvE3jpig6v
	h9jL5GHYuAqyWsjoo/FJ4HFkhIdP2CZyvTrfsavtMksQSRLlwuM+ykr7yzkOIIjzyLp39B2cDJo
	oOL+wxLTEqiRZpNM7dOP5dGh5u4cVvUQ=
X-Gm-Gg: AYBFou0UwgiqBIns4GppVzNW1aoIV/7MvjevL2rYcLjTyMiwTaYCd3i1aWfF92AWgP3
	XPfvxDjRSO0ongDxEJXQYOEZK9VBpUH7QWw3IOTTdmHdqrWuLcmRYxuRIbFmLOWmiojfrmLb3SG
	MEl0w1ZTDAFIH7pmLvI4ftz/N4MmNCNsz/GGuvTVwvCjuUnWR9DqCecCz1vQu6bvBezfIMIKCwZ
	z7/Nalr9mPM712TK6vk800kDlrsjCE1J1ZOQuBaNFRzAg4uH6qnXdL39PMnssaYPwPYHERpTUBE
	T4rLdYo/pKSRpz30vQGfo5++RmoojE1UZer7JwgZSDzZq2Yi4AsMwO2XrRNH5xH1QXnFiG+HGDF
	sEBmcnqqaRl5GkxtJ8gPAijuBVns69qyS4bMs
X-Received: by 2002:a17:906:c105:b0:c33:ca5e:8ddb with SMTP id
 a640c23a62f3a-c46796b58cdmr190770166b.28.1792592812271; Wed, 21 Oct 2026
 07:26:52 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792552161.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1792552161.git.jan.koester@tuxist.de>
From: Lionel Cons <lionelcons1972@gmail.com>
Date: Wed, 21 Oct 2026 16:26:15 +0200
X-Gm-Features: AclHuK9oo5ZYObAiFZur0ih7xDKEBxlKdO-BvoDx6w0mXhpoTx1_PdEXJcogV54
Message-ID: <CAPJSo4UJPnhLFAYRXE-_M2_Nin6=Ff02AjayD10cB7946MvJDQ@mail.gmail.com>
Subject: Adding dreaded Windows SID-style, or. Repeating history, the bad
 chapters. UUID/GUIDRe: [RFC PATCH v2 00/41] UUID and GUID user and group ids
 (*_r system calls)
To: Jan Koester <jan.koester@tuxist.de>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Oct 2026 at 13:24, Jan Koester <jan.koester@tuxist.de> wrote:
>
> Hi,
>
> this RFC series lets a user or group id be a UUID (RFC 9562, version 4)
> or a Microsoft GUID as well as a classic 32-bit number. Processes can run
> as such a user, files can be owned by one, and credentials, ACLs, keys,
> System V IPC, sockets, signals, audit and procfs carry the whole id.

Are you Linnux guys aware that this is just a variation of the
*DREADED* Windows SID that this patch tries to introduce, just with a
new name?
Maybe, before doing this, read about Windows SIDs, and why they are so hated.

Secondly, the whole idea of doing 128bit hashes as UUID is not new,
IBM DFS had it, and had many iterations of security issues via hash
collision exploits. 40 years later all this horror comes back. Does
history really have to repeat itself?

Lionel
