Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FDF4CB8D2
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 11:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789644496; cv=none; b=c7oz6SevrV40gfAlSDGzEK8S+B48y1N0rJLvzgM672UhWdKNUR8QlVfNjzVN4gREnV7Ca5oGt3pPKS5jn1BuXzoBzY9LP/ylFDdvsTg+klo13lefm2oFRibnUQgzyKJ1Ij3v4rVR/75sqc9sdYwMkJHgAYI/F/v6rvjR/22+Vfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789644496; c=relaxed/simple;
	bh=rkbgMLuM3vm0QjSeOouBx6sDtJtxGAt8tN51h/k1Emg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ka7T++7KliafTPRAd5K38U1K+JlRsdPOK7JOT32qg/GsHzUUHZtoNCV6jaCB17aQcecPBU6MfcLA4lpnqnPtMy2YNL/rC/GjODozqWt/NwySUvkTG082krrMFQ3jYgzw6W6kFpSq2HOX3qAromnKjF4Y/sqNMxYkVViy7Eiy+mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cBiVsMop; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cBiVsMop"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso3514875e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 04:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789644493; x=1790249293; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cPQWIr4fS6DSXVaIcQLRpggCO3UERblx+k2pBWKEiyY=;
        b=cBiVsMopEYxIp2v4ZQ0BZHIhPOhv1WkhfZIuu4HsqqQK2T4j917iiq1KN5c/fsjADH
         Lb/DrZRbp2YE8jKyKg5brHB8Ei8fXa9RRsZYJOu9PUMNXzPqiuM3h4y48c4CxnqggowI
         n9DZLWnAay7DQn4gweYncMCfKk8vjh+xGoxaFlpQF5t1SeWlXGSrVkG/lR8LmI6At+OT
         csDVDcxzQJx+0jpORA4Dm24qTlXpudp0AMa3Giks29Rq7Zdn7cEI92OQDOoXbs34Nl4U
         nIxCQyu9PJWh+fO+c4nhXpeAdIWHLIegu4mkkX+nSSnf5HlFlhml2wWtXm6vKZBOhzmk
         RjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789644493; x=1790249293;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cPQWIr4fS6DSXVaIcQLRpggCO3UERblx+k2pBWKEiyY=;
        b=Z05c3ZIqaV/8cktWteHfDjUBgUJrdyPP7hl9tmp4LRz80m0+DyQcAUOdSm4E22cN2U
         MYaRvsMbgsYt2CVX1KQ7oUdXAeMNQuvr9xORxctpjASCD3rkuCqRVbq0K4DPdpZnxHoz
         G+Ivb2Ng5ou+kUEUwEgmwQRtHbIWL8/DkIeRfT2iTM8yrDV6+e5o3Ak4CJ5lDMVw8OL8
         xlMRCyOFF3sBirOyJvz1ajXtk1/Il5pi9VOKhRvLhl1wzVGWKz6Z1j1/5V3uXftSyfrv
         FSXoyt0vkpPoXJTUb5RnpMfEukCbRyBYGbziLSoQhmWXaJC+z0cA9Y5MIhV5e8EWvYuu
         6CLA==
X-Forwarded-Encrypted: i=1; AKwUvByQgNZT1osnUAmiov2AX0EjVNppaY1y65wG9F7TB4fbu0iE6wVHck1Go55qWSybnnp+3+52CVtQTZ5a@vger.kernel.org
X-Gm-Message-State: AFuF++k6d+SjtR6rEUQfL/1bg94h8lN51MG/KqXOVRY/GfewI/z7A1I6
	r0dmCE5pP4+jabM0CPhpX19zj0VbjjUePeEISkY7Sv6trmU+L0uGiQCEDCUns8tgXnA=
X-Gm-Gg: AYBFou2KtUX3vmn+k4W6OxOAessoUA9Drvyj1/RQOaw4TN7nR/eFFvuaLz4VSetqHgc
	oqo/gxSSskPgHGfNtEXlQriZR7+Mosqqut/jQ800JnZ/S8Xd4Z2q4Q0VxX9qQbMEbXr3IoV8G6t
	LaI5qs4a+T2yEo1vRtCU0pK1O8rlbHnJOxu9mUHwOj9BXj0KNh+HMMN7UtPP2HJni7BPnbU8y/v
	ayCobGlcETkrehnQq2GG048uQcyv+rzxwVvYEIlQjcP5Kx3wQZWCEoewqbcsCzKBO3lsr47LXzQ
	I3Yj2teZa5L95VtSEpvD3bAxxBhiTX03tG8mTINF+V2T9R4RlUH4vplk8Xi7Gu5J19nL5Mlyil9
	ThMw43X3AKdtdQKpgDQygGkKk6o9UmFj5/vTida6DIErQw0oJ4BGx8WmbTLa+YlyEDFoaCh6J2V
	z1FSqbeeeCaK87b4mU0Z5zw+3kHOrwWPaHWiORNjxJSkokrxlyItQM6XWglMXG+8x8MkO0VGysE
	w==
X-Received: by 2002:a05:600c:8a17:20b0:49f:bd0d:59f5 with SMTP id 5b1f17b1804b1-49fbd0d59fbmr28486785e9.18.1789644492945;
        Thu, 17 Sep 2026 04:28:12 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf34440sm14542597f8f.25.2026.09.17.04.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 04:28:12 -0700 (PDT)
Date: Thu, 17 Sep 2026 13:28:09 +0200
From: Petr Mladek <pmladek@suse.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: bcrl@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, tytso@mit.edu, adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, yi.zhang@huawei.com, sforshee@kernel.org,
	akpm@linux-foundation.org, rostedt@goodmis.org,
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
	senozhatsky@chromium.org, kees@kernel.org, tglx@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v3 2/8] lib/vsprintf: Use acquire/release for ptr_key
 publication
Message-ID: <aqvOybiwt5ZTBjAG@pathway.suse.cz>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-3-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902074805.398540-3-ruanjinjie@huawei.com>

On Wed 2026-09-02 15:47:59, Jinjie Ruan wrote:
> Replace the smp_wmb() + WRITE_ONCE() and READ_ONCE() + smp_rmb() barrier
> pair with smp_store_release()/smp_load_acquire() on filled_random_ptr_key.
> 
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
> 
> No functional change intended.
> 
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

JFYI, this patch has been committed into printk/linux.git,
branch for-7.3.

Best Regards,
Petr
