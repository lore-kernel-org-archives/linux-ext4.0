Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B777F4F4028
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 11:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790853945; cv=none; b=DAVJkI4tsHNjNUsxspkIuOIXTiZmdOiBiyIsI0WUn9pObgGfLTW8g0DkqhJ4dQBoUhi7h7t1TXoiP3fIxm4eGV2MJMriEcJ6KQHeft5pR0Gy5CHP4IAVygOK0OgcJ4p75QPeylzAP/6BoIKvMkJ9vptrqihlGC7/ONYPZhdT5oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790853945; c=relaxed/simple;
	bh=zYI2pA9oDdC9aLVc9kEClqnlrJ7JHA61KbG8dwrNEBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV4OAVlbImSPiZydJQWLmT3qnCi3FmhlX+5NujMDnAlh90OLCGqnMOc08Fx9Qsogn2ix/ZgU//66lLBqrvSvE9upQKXTzNxbtem0jk/WwM2Gtm4mFKdCJmKSs9BrfdpvyQVdfqcFy6mp/kceaPc8izqZJf4PhHGJkftChpc0VPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tFGxB9O9; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tFGxB9O9"
Received: by mail-pj2-f41.google.com with SMTP id d9443c01a7336-2df9754484aso34812785ad.0
        for <linux-ext4@vger.kernel.org>; Thu, 01 Oct 2026 04:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790853944; x=1791458744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=46Gnvw4XZP2m9MgaWkI590HFmj3sZHED3T66VPv3/js=;
        b=tFGxB9O9CBJFk1K6eVPURg4FN3reHcxWKcUIpNsXVoZ9Sy16i6JxOBNx8/ngOvhpKm
         /DdMmyQB05Co7t5MoBuAR09sv7e/XmGV2d2C7lcHirBTOgPjTn0zNjk1ZR9VMr/SB3Zu
         BEEqlTQn/74GjzB7vGqN0AuCHN12eaa2j/Gg78i502BhmzhbLSUlVPCoDYkmhi/fNovl
         rii2uLrsNN7BsK46ztz+P3Pqg1aA9M4nYelFPT6/xjN3tcKsF+jLSFT+n1PIS+MP6Lbo
         nOgFPtug7a7maJD6wMSoQb7kxIPyhbSJ3JhTkglOgKP+R/1Clz74f6awy2c9skHPtBWJ
         hGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790853944; x=1791458744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=46Gnvw4XZP2m9MgaWkI590HFmj3sZHED3T66VPv3/js=;
        b=PPtI2aSfH97Inums0yN3LCbQjmavdYO5tW1L3VKWBp2dRllMjCo0BnTSHzY6u+UJhc
         +fRw+O7bo+oR5zdDNlrmoAFEqyo9JwwNxaKIV/HkIhyJCPxtutmusGyMH57rWK5EtDqC
         B5UBIcQ4IGcT6wjEUyp6HHG6XpAOzJkF+iqVO02heIuX1nhUc4jATGwBNb1epGImwAzV
         y4uMPcBMYYpwYb2JI7u5AGdXwWMcRSqb1CEm2i01kpkwgfxwRt61LAfYI8PQqgKD5vCN
         yMZPXuIdcX/h0TgKWtyyKP8nhodwYeyYaq0h2gCvPGLTA5oIGP5GUhgVSZ8+jJksNx/F
         g5PQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZz3lez6QkLP4eTIJKrqyexWZQMm/dlavwD4CN85TkYLLvEoIOHS9yLGKQzvIpVqiq1j1WwBSGudjW@vger.kernel.org
X-Gm-Message-State: AFq9FYJ++MWH/BW2RCe+aylLHhylZo4J2qdxyu+rdhb5t2MlmHsqWRJw
	E+zXAPfOWNWGngIA6vCRPbNK0qX9LunR0VJcYJSvUxw1GJB99l+CykUB
X-Gm-Gg: AYBFou1BJG4Q7LhYFLWdZvo9VhNaB+mGlGbA/dV9WmZB7Pw6BeudJIvpl7G2P+lDJmy
	lJwLCQhiL/DHBT10kRi/VIIoVDL7MuvzvcYTsPT4wJQwYmC30VaUJBL1330rtR5SvgQnXHQPRfN
	DKVSSUIN2zhEbbrwkxcXie79DEdqk1Lr0N8slPbuSOJyGCEwhunmj6R8TwxGX2J70OEvAcNRVio
	EgKVoOy3v7bdZVnZb05jmm/n7QyjceXNvaJAUVZ5KfKubvG76AWL9IiO4sH7taEw4FQzsFY1CbM
	qzITiZjqRouL2rVpScQvCsnnkufEoWqQSeKRJOqjYd19Z7ePFhWJ6lZiRNH2xz/kBuxlYX/qHVN
	YqNjU5jiHZ0plFENOgh3ow9tubBqUP8Itd0RY4IEOHCfYUTK9YM99U56mKB0veZ9YcNZlrztfD7
	EI2u139JWH51lX6F+7CDjiQ+kIb2G72QtM87Vl+0RXqV/WHSOBecovTiHBYQphIwGNNltuboK6V
	Jh0piPt0RBw0xbqdz6h15Byk+rJUqZ3p6Vza+Mdj/N7dWVhXnbzoBPs98g8d2bdEEja34DF47na
	4OkbWdloXe7SYz0JuruCqYUKIgoLOe5xXNhISlm7KAerghszKHrAqibzvPm6
X-Received: by 2002:a17:902:ce90:b0:2e2:dc54:3148 with SMTP id d9443c01a7336-2e2e4bc9c5bmr34756425ad.66.1790853943929;
        Thu, 01 Oct 2026 04:25:43 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e300a90dd5sm9311015ad.22.2026.10.01.04.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 04:25:43 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Date: Thu,  1 Oct 2026 19:25:40 +0800
Message-ID: <20261001112540.3822983-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260924033200.3615554-1-matthias.goergens@gmail.com>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com> <arSMwd1bGO1vrif-@mit.edu> <20260924033200.3615554-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ted,

A short report on how the T: cleanup went, as promised.

The documentation patch is at v2 [1].  It now only describes the
syntax: a git T: entry may name a branch, or an entry may have several
T: lines, and what each branch is for is left to the subsystem's P:
profile or the maintainer.  Niklas Cassel, Krzysztof Kozlowski and Eric
Biggers reviewed it and Marc Zyngier acked it; no word from Jon yet.

I sent one patch each to 18 repositories, a few a day.  Three were
picked up (libata, clk, mfd), three have acks or reviews (ext4, phy,
fbdev), six had no reply, and the rest I withdrew or am withdrawing.
Most objections came down to two points.  One branch cannot describe a
tree with both a fixes and a next branch (Greg Kroah-Hartman, Guenter
Roeck).  And several maintainers want contributors to start from
mainline, not from their next branch (Fan Wu, Marc Zyngier); Petr
Mladek and Miroslav Benes added that T: names a repository, and that
review tools should get their own pointer if they need one.

The trigger was Sashiko, the AI review bot, reviewing against a
repository's default branch even when mainline had long since merged
it.  That is now fixed in Sashiko itself: since 28 September it skips
such a branch and uses linux-next.  So I am not sending the 46 further
patches I had prepared.

For ext4 the patch is still correct, but no tool needs it any more, so
take it only if you want it there for people; dropping it is fine.

[1] https://lore.kernel.org/all/20260925120047.1093617-1-matthias.goergens@gmail.com/

Thanks,
Matthias
