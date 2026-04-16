Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27F34CDD
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 01:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776304042; cv=none; b=kIlaL+e7zxNF4/lOqPVSm7rLPPSGg5UhnZPdWYvpploDuDyK0z9wFs5+bSjYdYulUUTE1pTzTQIvpHs4tP88LS2qos1Nr9DPqLkRtQ+oDCJojWsqP2RvSsreXxige+D1m1lY/1CXhH3gZq64w+q2olmt39JBkVqGa36FThkGGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776304042; c=relaxed/simple;
	bh=vTHWwUsHvnRBDOyumFAan44av2HSR/hlYH0i1THVPHs=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=Uq9zT9ohbKE6GmUv+KOJguC+hqQNstZE9R9MjQDObthvhX+dAdPhhJX7tYIbS5I3Cu90KZlWpBTYdDt8vR3cldmxfZgZjH/zjeL2mZkr1DvtYWGp8dHF3VT7Xgvu8cLgAegJvrXxmz8k28aMytFiKD9h0c10XmrXCFqgZQUrQxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RXwyiKYz; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RXwyiKYz"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-827270d50d4so6558757b3a.3
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776304040; x=1776908840; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vTHWwUsHvnRBDOyumFAan44av2HSR/hlYH0i1THVPHs=;
        b=RXwyiKYzWn3OTKXhOHcjZBvslDMkVsmWFb5gXwz+sYYlYbQEoqkkO8y2y1wDfKdz5Z
         kB+pAMHwHtgDEFCa0qjo8xjyT0DQNbnXXAxcFEOAdTCDtXMwchzRIBivxeGJH4nVNYRI
         gSiN1WmLhLeGb7F9E3BW4DwwERJBn9n5YjniMI118TXg9PP9oExwDA4Aayu6fkKc6/Mt
         ZGN+CkhY6ZxYMTxTIAGS9gUsoSDXjPIg0r5H9MlQZhQG03gsMnG7r4Qf0cTvz3gA3O09
         jGIP2R/9iVQJz2G41ZRDR3cQJtzD/t1zwuvEsX5bSkJi64HrcrOm2hKYBFtbr8MaAXeL
         W7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776304040; x=1776908840;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vTHWwUsHvnRBDOyumFAan44av2HSR/hlYH0i1THVPHs=;
        b=I8ftS+Z6DXseX1vzYtJi6eNX8XWD+UaDcue5CVEN7HRiseTOGMegCpIl4tWP+KzqMI
         HKUrWTCYdzULpym9HEy9RzVskkQxBozNHF8afK1K7xy5r8oXSGOoJTlE6W6eugLlh/po
         W3Ke7uuJcKX7cG7KC2cfiKL2BTOrQzBuvaRGklUjdnh6rMHY8oicHh075EIFcs10GNea
         iCR8kGSuPaBjGn9FLUGV54MiJd+UJpmkokJ91b+feO0KMYqcFy+RPJs7QHMdUt1C8pyd
         ke4uxBGXxAzAtU7tv5csImk0CM6LNd0jRMOOadetars54VYtJsm8zoK6JbCUe9g0I3gI
         9rgQ==
X-Forwarded-Encrypted: i=1; AFNElJ93jJDFMTvEDVNtjJXT5vh6eggYaVG/fXzGr8lifpKYbd3uGkgVPyN48ltiCrDjD39LnwFFOVqwdmXh@vger.kernel.org
X-Gm-Message-State: AOJu0Yy30k+iRVWV7GYmhacNsd73turpUpNFSA2H753Hn0mLw2yM0grk
	GnZamnYdUOHJOM3FMKudHlBnENSrJcah2ggwvJa1e90CnD707YR6FBbJihaJaA==
X-Gm-Gg: AeBDiet+dtSnMx40sbjr2XdIxgzY+hVBfttQVwAvNad0nz7GTFoOVwCxIiwfRLvJfqw
	6P6pU+yqYEQPMQ/3P+YCZOlEB7hM9oUg8khz54L4YeE8SbFjAi9iGKBK3PLWUQmAF4fbwkYGdvs
	HWja0IVXzaXwhS+k/OyH2babgFCWWHbSMxStNtWRM6Z/B9xY5tXHgkusrWzEI4BTSNv0sbbboHY
	24n3g+J8ISLwrTcbBE8+mUcy8o30vjFkOVm2fU+bO7hH4d4nUKu9c8OKvfUymFMLZY1Nrx8qTDS
	QfjBwJBdMHR2SlgUxU7ko0mCUTG2M7ahzCSkiJ/Bw5MXVCEAarj1wvPm94f8r5EDRBUXSiz8mG2
	S1VVdjNhNROE0aXCT1V8eu3ucmEggNz/SEqvuDGRfw7i35RFrZ/q/M46kD7IQvd4oXh5mypWE8J
	QYW6KHBFj/SiuoSxdhUnvFiiHyum2GbHq2
X-Received: by 2002:a05:6a00:2d23:b0:82c:dfea:9e2a with SMTP id d2e1a72fcca58-82f0c2695eemr25107512b3a.2.1776304040028;
        Wed, 15 Apr 2026 18:47:20 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6702f936sm3328250b3a.6.2026.04.15.18.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 18:47:19 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Baolin Liu <liubaolin12138@163.com>, tytso@mit.edu, adilger.kernel@dilger.ca
Cc: liubaolin12138@163.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, wangguanyu@vivo.com, Baolin Liu <liubaolin@kylinos.cn>
Subject: Re: [PATCH v1] ext4: add mb_stats_clear for mballoc statistics
In-Reply-To: <20260414100212.95209-1-liubaolin12138@163.com>
Date: Thu, 16 Apr 2026 07:14:35 +0530
Message-ID: <mrz3u1a4.ritesh.list@gmail.com>
References: <20260414100212.95209-1-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Baolin Liu <liubaolin12138@163.com> writes:

> From: Baolin Liu <liubaolin@kylinos.cn>
>
> Add a write-only mb_stats_clear sysfs knob to reset ext4 mballoc
> runtime statistics.This makes it easier to inspect allocator
> activity for a specific workload instead of using counters
> accumulated since mount.
>
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>

Make sense to me. The changes looks good and works fine at my end.
So please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
