Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB43DC4B7
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2026 02:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031723; cv=none; b=WBtdwbdpqv4xUnHy0DdpowoMzWPJdXEuowfjsJJJkt0ZYZ0Nt/aGdhrb1c60vZKjgFJfl8dD8SBQ0EBNGZPi4S91ZPkFz1a91om7lIp4Rq3aLn++m5ez91Ih9ulzIjRy6DyasDXEhB+t/hGbBzL+Nq7zwgAhc6+1pKcX8P1ciKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031723; c=relaxed/simple;
	bh=Azk9vLWdcFUm0rin/x9F0DNXMUr/g4qM7o/1SCI2+c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JnSF7MYerRxiMpPkHpfY9P2T2Fq8CA6ewSXnCSCcL+lB2JwYciKmPO7R5isFk77S/b1lPAKUSkS5lt3jl2ejejwaVU9cF9ML6kC1h5YIKBHoeo2WzfqB/HUvcoZA9i5cHg/yb7058wqxC8GWOSOoLH8stDUNWSIGzYkoVK8gu7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AoXKe+74; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AoXKe+74"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8935f42e8f0so612779b3a.2
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2026 19:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792031719; x=1792636519; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Azk9vLWdcFUm0rin/x9F0DNXMUr/g4qM7o/1SCI2+c4=;
        b=AoXKe+7412efTE3EiwkvFQ1eH6HE8+DIv/au2cGQ+bJsCJCsMy7MqhBT+x1d9NR03/
         dUVVhqiuRoMcUh3VkjX/X8DJr839oZuoxYgPUE2RgQjmh4/JUsQmaQMMqnHBf9yhtqdR
         cwUItZ6bJP7KzS0deSFFEj5KaPugm+oAXaPqAk6rDeAGWOQhW1krcDLHJVjBudpenUOO
         kU2wlQX0ORcDR6LukEdPEv+m6DIIcQj6lxj63U3JP8uJlq9O+gHq0qWUSyqxVYzlXHqi
         1w/e9MuSsYOh3tbDHwEdtc2K2HOpwTPl0YsY54rUT55znrRZYaKTlx/qSuN1/23G1xur
         D1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031719; x=1792636519;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Azk9vLWdcFUm0rin/x9F0DNXMUr/g4qM7o/1SCI2+c4=;
        b=iklaxV1el38MfBu/bsA6EdngH3eANWu5j/VlzB9XWsAO+X5TNVQhZv4oYx3r6/j8bj
         2RwdoVRQu8V4JOXcPOnQ1+cFwFG1OvvjrX5k59+pB57vME/al7umU9/G1HHmpuYAyTXH
         8ShlhreUL/QpHHwQgxTgcu3S20d5k3DLhRvhzVgY0TvtrvUO+oTgE/kOjxiE+1gY2Yw3
         lZYC1KmIo1k2v9EsXJfN+c+pEUN/tIHSTsOYRSfIBBd0K1tLlhSHyPH28vAu4tnxvApX
         9fFmC8VLHOmCBZeHG/wu52bCNkO8wX/ZV/B3tZPAGEb/UowWmrIkgHUROiJZO/o0ERaD
         Dm+g==
X-Forwarded-Encrypted: i=1; AKwUvByZIBM9Mx9p7bmTrtsbHgGpzfxzOfswA1lW1DvDi33mRa6WnMp1AZmQpBhncG6pdcjX70Yc8u1357dS@vger.kernel.org
X-Gm-Message-State: AFq9FYI62MXSh+0IUNte/UnKGAkoH430lWYkoZ9sVFCG3nzm7H5+vXPG
	QUPIDj5W794G98d/I/414olBU4BEUdg4koMabVzxnNY3gdCAZYmztCi8jfmF7ufz
X-Gm-Gg: AYBFou3HUoDKm1kM6gRuxsf7Dk7nnZsQTf0SgI3+0zQoKkcMRCo0mneN24UP0lW3Zqh
	XUfacE6cZ6Mbk93vopV4QeFh/VpQng99zc5Zh2pb0GnBTwNoBT2vgP3oKmFdwPfnzxTSBKgJXdz
	6e4AiWgFA4kRQurPqfUWFzuvxcTbJSLVeccJQ7nFbiKZDcsRuXWzq8ypzPFSPe+sn2MB4+YTlhs
	vZ9v28HtJXzkzOcM0acmz+epFjsnaNaBuKyRpaYrqnuScnRwyhP4Ds0wPxOiYvy0LgBlF2ThcgA
	fKA3svibtpgteKe4MxLankUp2YtSbh1+JIDtXBl5M8fA2fu856cq16gPbJmaOuL0V2WvyKIhxkV
	qscM1yK6unyGGzpnNO7pKTFm6su0pWvors7juww+ZlEoyQsXn3tJsal0sqRenozCE9SUgS27cuY
	hr0LYh/1RMQbiltIi8kQA/m2CGih/nvO6iN7vcEbyAJmLDv09LjByXqVUIWVPsGPWPTkAbfRuBO
	w==
X-Received: by 2002:a17:90b:4fd1:b0:3a8:5fd6:cb6 with SMTP id 98e67ed59e1d1-3ab39feaf19mr13291631a91.0.1792031719067;
        Wed, 14 Oct 2026 19:35:19 -0700 (PDT)
Received: from ubuntu.. ([138.199.21.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac944511f1sm2034989a91.12.2026.10.14.19.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:35:18 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>
Cc: Qiliang Yuan <odys.yuan@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 0/2] ext4: fix shrinker scan budget accounting, plus a related cleanup
Date: Thu, 15 Oct 2026 10:35:11 +0800
Message-ID: <20261015023342.ping-ext4-v4@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
References: <20261001-fix-ext4-es-scan-nr-scanned-v4-0-b13703714ce2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Ted, Jan,

Friendly ping on this series -- it's been about two weeks since v4
with no review feedback yet. Patch 1 reverts ext4_es_scan() to the
sc->nr_scanned-based SHRINK_STOP check from v1, which Jan had
already reviewed and preferred over v3's nr_shrunk-based attempt.

Let me know if anything's still needed on my end.

Thanks,
Qiliang
