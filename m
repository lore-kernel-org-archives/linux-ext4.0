Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9AF286D56
	for <linux-ext4@vger.kernel.org>; Tue,  1 Sep 2026 09:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256568; cv=pass; b=RysOcaIlpeWYzyppS0vs1k1uZFf48/m8hYetnL5XhwFeasLYni4c4LnLMBffFyVYKgw6DlA+TvoKeXjByiI3hY+doXVl/4YD72sbEfmjKkTW9YtTrDuW0j+muQfBXtWuaabqIBa80eStPKTNjMNctVVOOk4V/H33YbasGQw3ywM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256568; c=relaxed/simple;
	bh=xA/wfYKsRa1xzjBEfvEgJmKrwA2BaFT91E7WZjD+/I4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ki660C6WwIKNenp6KNzOkI2FIsV7guHIR5n81db2JRSk0FqTWVx1FgCI36e/79SD4un6WDTE7MY1XroIcQc31OMFix+K9dR0831o6gMAqhdyw8KNAmj872NUz8t9c0GK2wIGL8S64+ShgifDnZTcTi0Ylo15S0fdgIDhjiOVoGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BwlBpzzc; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BwlBpzzc"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66e5e33a9d0so1023698d50.1
        for <linux-ext4@vger.kernel.org>; Tue, 01 Sep 2026 02:56:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788256566; cv=none;
        d=google.com; s=arc-20260327;
        b=nxRf9SKH7MrbShT4ykD/T6hI4tD4XpzoJoPKkgJD1fONe/aagqeE6tb1znDL+Mo3j6
         FSj4Q/HOCKB/YcgVgvsj6E0f398IUB5iiXKO4wd9HPjYeXY7Cj6DikXP4FxzavgDRXO+
         YFejy/csdUMoYK75PrSeIahOiFqMFAuGSPzXGA7Qo1NHt0yervzFJH2JKUBPspvIRh4F
         TZ+ECW00uMt9Q0aPh6xeFS2E+sBbI/Iwho5FCz2/+VRcbga+bDj735udfFgaZYL85mi+
         evRxSc+9303rxA6TiqA1MjG86QXxO24uLE4bc52xxAHmvM8LsLQ559I9LgL+2CsynG3F
         TkUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xA/wfYKsRa1xzjBEfvEgJmKrwA2BaFT91E7WZjD+/I4=;
        fh=9QJhiOaPAE2VIJfCbOhXpGZ7Lt+booWF8RJUn1Hp2dU=;
        b=SpPdeF+dlxtGblZFfFgOib2RKimXZRQoCU952VwE5LFLh5Ysisl4gw/delA+vUKtel
         9B5d+rbGyMCNVeSRkxFPlHrvz375eKqT2xV3kSFPh3DaaxlJZIaH4XzxZ/hUs2uP5Gph
         13RQClFOqVdZxnjo9nMUlbyMfhsIbjX4dKm2/rXmbmxEaj0+VmP2MW7+sOzyJCjecLWz
         KzkjY5g2tpR0r1UmBgzsmUiQcZ+ogq3kAiXrSIFtXMTlxPE5PtTSmehE4X7qHNO09zfD
         dudNe7hBooBTCBUrPSolz8bS9LujkeBb5P1JCPBK2Lq/uYjDMOZA9qJItA7Y1khvgKAU
         R8AA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1788256566; x=1788861366; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xA/wfYKsRa1xzjBEfvEgJmKrwA2BaFT91E7WZjD+/I4=;
        b=BwlBpzzcEAZxEfOmU/20jzlIgfRQ66dfzeCLeXNqTjVUu7wWUwDuWYbrtFKF+fSfHU
         QvtS/2EWCHaFE0fVFtY6XvOp+rM1qZIFzAbaaRm2pNs0D64c8E6S2tpRads5ekUeexl6
         6r5MF0VvyEzAIy0+tZMvMaseE5C6Ug+merxkynhLL/IZQB0mMlFh9DZil3OgsUXRqKkS
         TvHak0w52Eo6cuUjnOYwhcFPW+Zqb3gBjdookgyFN/Uyow9fQsLdjyLp8WmifrqLqJiV
         XBQshag7hnRBDdqHzN9GqlIKbuYlodalpe9AUdvcLoWbFnvakwN8j5Jd2KiS1/w0TR53
         +AQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788256566; x=1788861366;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xA/wfYKsRa1xzjBEfvEgJmKrwA2BaFT91E7WZjD+/I4=;
        b=OCE8xFFpEFud6jRPSNMJAioSs6SnGY8kZEt670Gn5KbXNDkA7U5ycXdcBkhuioKcCB
         GmHKoWCr97Zx5lChASBtHbQBV1L/m6ZwJJnjjUl/k86Q6t1NrD6l5Vqfwf15qKGAd+rv
         oo8pwero3GO3opv2NyfD0fMnI4VRHbg7WG9gE3EZbKiocarOmULuKhToOMytqUobS0t/
         sNY+tJdCg+bSYz14imIJS8x8zE6+BwZqssbExh5qjfDkI110ijV4f5iF6Ljwd8DYtYil
         uODxZvNqE/ciMGOkrcnK9mzWf2oY43N/Qa5lRR4Rb1Mc0MXmZ0G9tC7A1RigNpuapXym
         yXxQ==
X-Forwarded-Encrypted: i=1; AKwUvBypxaV/PKl909AL3fsAwpYN/b1IpBaCtMu2u+xoyVHOBxTr+jB3HL18vlOvY7xpanr0RSL574f+29rg@vger.kernel.org
X-Gm-Message-State: AFuF++neudgw/VygckV9ZNZITD3A7jK1uyWiy637Pf+h+MnImX2RRvKd
	yGjWZ+3JVnZg46+aRVBsCpgFtbBnXzW9IPHblBXinPpbVMQg/w8ZyA8Sj/ce8J1N4G5qgTOZ4JI
	DW5f81GMAeH9xWQ9Nzg6mszBZngYLKTyN1fhnRExEFg==
X-Gm-Gg: AYBFou2bb2qK3h51tIqHxG/NuRJwjmyEDtn3C1O+2dOXVwUsl87vzUen/CgsZrqm3ub
	Pf64wpLJCGhSygQRE0lHW2vD/5yHNzzYZGyKU604nJaNd3sl3QGQjgieJRJqzKA9SzRR3Gqt2XD
	eesLuG242QZC7vPFGpkTKgUYN5J//OzuFGv74mzQP/M28QsOc4QkMmwcRMA+Aq3n0dxAqXVcEMi
	+E068GQ/KllT5LDV0jDG0mrc5BftNj44ZWXieHnNB0HbSAQq7rMT4Up1m83om6xBoar5Mw0YbSv
	marhFgqwBe5SbpyqihtAOjrB20vLLQDuged8yAQJt8whwrpDioULDkrUy5TxORcEOrIA
X-Received: by 2002:a05:690e:1206:b0:66d:7f5:37cf with SMTP id
 956f58d0204a3-66e4c755e16mr8690675d50.32.1788256565703; Tue, 01 Sep 2026
 02:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824094512.2436628-1-hemanth.selam@gmail.com>
In-Reply-To: <20260824094512.2436628-1-hemanth.selam@gmail.com>
From: Jun Nie <jun.nie@linaro.org>
Date: Tue, 1 Sep 2026 17:55:51 +0800
X-Gm-Features: AcwNN1W2zp26Au4wUZxrRdhIs2mCY-JPtDHdCakR9MIKevemfj3T-NfrAOEcuZw
Message-ID: <CABymUCONb8y891EFW5p9v44ofRKvVKeGve9SKSfjuwjTpSAYmw@mail.gmail.com>
Subject: Re: [PATCH] ext4: skip extra isize expansion while unmounting
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+4b03894b6ec5753ddf24@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Jun Nie <jun.nie@linaro.org>

- Jun
