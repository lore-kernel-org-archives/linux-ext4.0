Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D119D08F
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775092547; cv=none; b=M7UlzBEUD9P1/QkzOOpaLtiilyo9anqIZhHnwuYRus+Q7Rui90+a72Vz5WC5vPrP35DUejukb1reBzfrayG9k7nPEk9Gse/3zh/MWjvfvciCifhYxMqLD6POxIMdF0bIjrXg0m+GwgZG6+nZcThCiSrWRyFkfJe+pJKFeYSlb+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775092547; c=relaxed/simple;
	bh=1mNywe52Px8TWgPsbQl9i0MoEn1zPrcJBjOf8FgHIGQ=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=ReHdAUdBRN/QFGkvtdA7ckELHTOPSfAwFo8usKUZcBRBFaN70BcJJUBwVsrvt/rwasDKc21D8Ljq9dTzyMTtxL+rf3bLfSm3uQARAmE8qpjK2EjzxRTe6Ah3GC2RomL55rIwU865+fSkAJepGoLo5JpWaZjc2rjkiu8EcaKZjMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYWJq6Cl; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYWJq6Cl"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35c2fe0d90fso162275a91.1
        for <linux-ext4@vger.kernel.org>; Wed, 01 Apr 2026 18:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775092546; x=1775697346; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1mNywe52Px8TWgPsbQl9i0MoEn1zPrcJBjOf8FgHIGQ=;
        b=VYWJq6ClBRx5a08YmiaTj/dSMjLI+OA+JILqSIpKf7kJIgPEphMr8qcWXnjpydQnZz
         PwxfqwBFS2sK7JzG/iZfL73vsH6m8SQyjJT2tKE549XrOUubATgAdOr6uNJcfs+Rv9vx
         2ZQ55wlg0rLU1YIbu6EygC/va4NXeixgrN+jQKgoGUnk3UekNtOAaFnqNZqJLd91w9+i
         tihA1FaAVkSUV4mhQLAkzD/yLF5+ANfu1lA7OGVnes9vN2fw4C93jY3bIHjphUSNnpcb
         +hRaP2n0tOodQ73dFpfMlgFStdY+eZvnYo+0QDjvrkxVdoRQ2sK4B9FKm8hTKeYgFIEN
         zurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775092546; x=1775697346;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1mNywe52Px8TWgPsbQl9i0MoEn1zPrcJBjOf8FgHIGQ=;
        b=Tajp21ZVoAtn0V+WlZSNJJ8B3IwP9j1qIrnvgXqsX/+ZN1Hz0Q3GNc0NtLZ4UfOdIx
         ClfjoIckSi42X++cm8BxtqpjcpMnu4Abw6B7X76cgD4928HajT5JUuKISkuB5dV/GNkX
         g9pAVfavcr4uzNmbdqXan5Zq/6M/EfTmuU/X2HkYJCZRQqrciqaBTF2xRNYB8Ib5bvhk
         Wv4orkiatqoHieiPKeDD4XWRHOli5vJIpvY2gdRgl1LPm4BY3eh3+eFiI3YB3t28Wo8f
         iwam3VrfvmXyPMred+5Pjn9l8JnxtpuOa9UyFmxXUNEEt9OTbjaqtTRjdNiEb5HgnCws
         J4WQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPxOmxqvHcU0Frf3UuWpRx8rVP6XHG70Xfkqn6qHaidI2VZwkd/+WX88LU8dQ1cfoWsUbu71BzoDCW@vger.kernel.org
X-Gm-Message-State: AOJu0Yz97xrQa7V79W38Qm7ATjp2qXrY9cUg6dp059eigPEnItxO/WRf
	GUcqWbBf7vLed8ksXg2hMtFCDjFxLD8gq/iy1w5cFy7X07yzSCZNMeLtjx1hEdd6
X-Gm-Gg: ATEYQzye+t46ocCFfTeWcNMz/L03n6/ws0hyZnPvLOSe7wQVOmYN+uqW3iE1zTzAaxZ
	is+X2wLCDFiNNLF9TmarwBjMiGbCJplb4We7CJf2DCQvMEHO4Z8AJ9OrVdYnzv0wG276RxK8WP0
	NqfmcgulmyhBp7m9ZtEsHWCNBjdyBbyi8h9b8az7jnWRePsyn5qnU8Qtyv0qHXqsWdOwhiP0NSw
	HbMagnPZ25ry87FI5LaWuHYF1fAa6dVq85WvyZrJMQzX/QsK7zyTmGS1MI85QMyobGuIAB8Sybz
	mckvv6gZI2Ep7pf4fI0CZp03clgmHYbKI6c9ltczsXbCiuQy4B8GdMw0h1Jkwguo27/jdJ/2Llw
	Hsc88SEQON3WN+4jMY34oNh8GRrLwOReLYca4bcF2xgO9EHHJXgSP9XIKezFth+swrbjpqfBTgs
	JeXuP8Z0P8lld+jTgCnR7t2A==
X-Received: by 2002:a17:90b:3c06:b0:35a:329:73c6 with SMTP id 98e67ed59e1d1-35dd3e1630amr1277624a91.3.1775092545884;
        Wed, 01 Apr 2026 18:15:45 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6476301sm1004776a12.5.2026.04.01.18.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 18:15:45 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: skoyama.kernel@gmail.com, linux-ext4@vger.kernel.org
Cc: Sohei Koyama <skoyama@ddn.com>
Subject: Re: [PATCH] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
In-Reply-To: <20260330174248.71268-1-skoyama@ddn.com>
Date: Thu, 02 Apr 2026 06:34:36 +0530
Message-ID: <jyuqmau3.ritesh.list@gmail.com>
References: <20260330174248.71268-1-skoyama@ddn.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

skoyama.kernel@gmail.com writes:

> From: Sohei Koyama <skoyama@ddn.com>
>
> The commit c8e008b60492 ("ext4: ignore xattrs past end")
> introduced a refcount leak in when block_csum is false.
>
> ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
> get iloc.bh, but never releases it with brelse().
>
> Fixes: c8e008b60492 ("ext4: ignore xattrs past end")

Nice catch, indeed we need to decrement the refcount for bh there.
Since this patch made into stable releases, so I guess it's good to
Cc:stable too.

Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

