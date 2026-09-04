Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742404746C1
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527616; cv=none; b=MrBhmjvbuCE3Qegv9KCqQdBlaFLLUiX6O+6sPtsyAXzxi+1ZytsBKvONXfoICtyUXvmqveQilUDy5pfajRRZ1UlmyFtqR4oJ1JIHGK7UPD39tzCtHnOrKstp3wxmaF/t8hxvnO+XPmvqgPONLJe7Sk9B/+LDsWNW//JzHLMKxv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527616; c=relaxed/simple;
	bh=frKo+EDgyBgPiqzNfVxH9bEhfV6BDttiGdaNdUyhrPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNC2sOzWbBGbnqe1KwbS7+G3CdRSH+QJ9WuBytqTnlEZqz+FamInhK1ed1ypU2SGzPo1UGGDGOpLk7+vSpJlY9nmhuw+3icZF4KjpPmkOlknFtC+girka9mgOzRb84YfNHsgoZIjIHKwsiwzBH9OQ4jGGQZZCm/09xF5o9TbjmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IeWYMJ65; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IeWYMJ65"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-484392e3d33so595570f8f.2
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2026 06:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788527611; x=1789132411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/B3wwZTlur6ZmEw56GSgDTNaWB2UuFCQEkVYM+7GfWk=;
        b=IeWYMJ65Q1LWZv3HS3Frm1F6PdWQA+aQECMPh7AkHYgZ3EymBIvAiCbtmcYd2bhWHo
         VJCQYntFVOFPpXq+Lkol59z5hD3SzHuR1Qa80A4EUzZysgFgbsbGbLQ9K78uXRxtrsi+
         AhgsrgVKlkOdQJzCTEzo1pAHMwGv/nQixuuRSOfmYjfoQkbN7UwuSuxtHJyjkGa5yX7D
         qX1WDrXM1m2dsZwCkJ7on9zP3krU8Jm8BEyhFSVqA7S9Ku03j6WNP1D8r7QOHM8zxW0+
         2kK9Xfex8DPG7b5t7VDcQRVsPdKMzfAJVPyeX46zwQIzK9y4Fw7Um+ZYpJhYm0HFKi+9
         9o5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788527611; x=1789132411;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/B3wwZTlur6ZmEw56GSgDTNaWB2UuFCQEkVYM+7GfWk=;
        b=EljXpDR/yqDV90ROYMPlsUACG6j/AZVvYZetVtZXAa6wlmQsXh69IJlH2wZJHy7l2c
         I8DLwkbm7F2nbf2GVxXH3K/MTMNEYwOmZEoEjh1svQmxwzTH0XLeF1B0peRkRF6fBxbq
         jOeKt+psiF1MUdJqfshhpQVMWAMu9gzFsTelzsC0t3FghUtEZi5+OWQ3b45KHAOB/sKN
         hsHXqbjwMvrBQNQBFx+bxQjv8nQptvdtNSW9FTcXuwuBomC8R9hLw0xj1DM4BZPpDW0+
         WVhJLohn+EqOte9HQD4hbSZbNUhzfFRtWIxfRbnY/r49GXdiO6316n9tnJ6vVUlvZmdL
         +7/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzElnfGEfHSW6iMnuTxAaGYvgeLCLjIXy5Dlt9mXbxboW9C9xAjXCNrSwF2K81NH0BNAwn1a34I8Izk@vger.kernel.org
X-Gm-Message-State: AFuF++mEQX+dbBXNDOgSp+NreinfXXK50m+GWLXihrdaNaTKDl6SICFP
	FQP1WKvyGM77n7IfLrjjGBceepzok+hWQWnZmnb8cDTgsbxAy0VD6LCrspjb/1I/XKg=
X-Gm-Gg: AYBFou1/d9jTUj8ASff6/YVn7nFSW8TVmPe8TYlTsWv8WB0KIh+n1uHx59e7BudLfOR
	nnMFQD9ZEy59vTXt2HEsBn/KNAB+PXzl39AddaF5wOy7KgdlwyX/ZdUmCH8SRZRKRviOGEQLBEi
	aaBId4PYcVzVI2VvMcmIbkD8ZCh/1Qho65QpmKWbHX3VEqSBaq3tj1GsyC2P0h6Vcd9tZrI89wZ
	xe7vQLbq0SgimsuOmM5jZO+gXb5Gs5RqzfacE+NqsFLA7wxd2UBvbflaS6yn8pMPbp2+UQRIJyz
	4H9ajgepCtaRaJyx9ChooXWejzuM5GncnzYaZQTnvdpfTS6oquV8D71ScUZ9rczOW0GQcdj8q0a
	kZFSHrkPEmUEda4YZBKdk6qKr5nuo1P6QdnG7Rdv+CsxqOMgOZeqDerC6wihSGXRYsRVlVYTcEG
	4KUBkhJT/PM5Zj8PaG1zts44IBDrzt42VwUl5n8bLMnXl5pXT6JLbjqtnGAgTB+g==
X-Received: by 2002:a05:600c:3508:b0:49c:fc6c:be02 with SMTP id 5b1f17b1804b1-49cfc6cc032mr33479365e9.25.1788527611383;
        Fri, 04 Sep 2026 06:13:31 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d476esm170317445e9.1.2026.09.04.06.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 06:13:30 -0700 (PDT)
Date: Fri, 4 Sep 2026 15:13:27 +0200
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
Message-ID: <aprD97HPpbVNW4ir@pathway.suse.cz>
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

Just for record.

The conversion looks correct from the barrier guarantees POV.

I am just not 100% sure about that the performance on different
architectures. I asked this question as a reply on the cover
letter, see https://lore.kernel.org/all/apq5iLOF8lAQ_ZVU@pathway.suse.cz/

Anyway, vsprintf() is not a hot path. So, we do not need to take
care of the performance effect here. Feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

I am going wait how the discussion about the performance goes.
If it does not block this patchset then I could queue this
particular patch via printk tree.

Best Regards,
Petr
