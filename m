Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9D93D3498
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779788156; cv=none; b=Bpih5irMNX0UtdjweHAUMyeH4oXjtuqudIUZ2y95Lgv6YqJuNepa6T7OEPEsImTGxi8ijUR0YRMqE1aLyxg84NT6vpKtXsgeHZQ+ZcZMZAxSY0tTI3vTzzULsx1cSS1GDRAeV4c4z5X2otuvOOetMCRC8kUqqnzjdklAQFbISH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779788156; c=relaxed/simple;
	bh=sjU7RHyInlH9mxFug2LKz+GK48Ojh7vR1sjgQ2TiRGM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtDAhr0et50KorfErspu91sdhMlhMo9R7jmjw0AzIGyNGVota2EtmDkfHZhaeB0l2rsanjdIyBMi9VpSXu0SJvHmA2nzq6QNJ1qxpuSDqrNAJ5SnCzrO/63WmTFHRKOXrRQKCUokbSGvw3YY7raLo/GByCvpVTH47GyxHtsv9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=seiq+CXn; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="seiq+CXn"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d73422431so7314659f8f.2
        for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 02:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779788154; x=1780392954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=seiq+CXni9aIGbLGM0VXkKywgsa47MjhfAeycLy7TY/OhjQlRKHdvx00QtlkzFePb0
         94cFvPmHHU26vJWePAZj2+oA9GlBflkrO2GbNq1VpcTR9q7MzohCl2Dd1X6Ng7rQil8y
         HdVIbj3NgV4BzluSo9r4qPLEaCSRDsKBiEkYgwXEJJdERZJsBJDWjY3UA7NIhDpqnege
         QtFQRzkX7QvdA9XHnI+h01j8LEiDgfS4JPMni7ZC4le0GIdAHwnucmFIdvGFq9b/9vZV
         EsuUHym5brztgaVyeivqdcarrbd8S4BvVUFDB/IExFltz22m1SxB6Dwhzw0ror8XE253
         I70A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779788154; x=1780392954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bHfAVXmh3q3FWdhM0EExqsSxnDVRJkOcr0NBrLZ8n4=;
        b=T0vJBs40ym3n2IuA3TBk+SdR+YCBJvKT2KZuQf1tA6j57Y2tB/IDkTfH+bOVd5aL88
         PgSWg1S/Okk6Pa8leQI1S8eMk9VAVvk8VeDMCNt7ax89BEKcJvi56aNc8A1TA1J1PmtN
         aXJHSrpt7kYdaHl2g2/xxFDpYeADCHI8QiJp9/NobwLMYVw8KEMAOFPnTipWolgQyQfr
         ssSkRSr9AaZCLpUb5SnLCWlHNhgl8CzUGxwS66IX3LfCjJ4Y/o6Xkdd/ChbReDkdituq
         xPOWNq8bsvkxsDDQNZc0HmhPCaTlIsAnAEucDErOO+r68xCUjKu2IFhP0AS//gp4ggRZ
         ATGg==
X-Forwarded-Encrypted: i=1; AFNElJ89B2fIPinLrDNU0a4y4k3WNyqYwczk1Ngt7UYU5HAWLU7/8cgFd63S068pzkR3omym68Dr0gHsvBe7@vger.kernel.org
X-Gm-Message-State: AOJu0YxpbDVSxICUbjnHwfyedBpHlkmxxHD0BCistnulv4pJYsfp3LWM
	dO2qovuQD48o9lgduTjxNPwrZVp5WTmH1JJSv0klSafNJQsDOqQUvn7X
X-Gm-Gg: Acq92OHqRJa839OycI2iuhz+rAkqh6pDM6iJVsoWVyr7tSF8ls7njCnpKOYGyCCiSQF
	YpXZCa9FAuM2scFu2jOKXUcdzj37yh43m343W3qq49/aWj23hyMqB5MFD8fJFC29CAOk10wIePC
	2pl32lB5u5MrhwcJoAZzK37s+c55QTK5kAeSl63T/oxkvlDlpPfXFaHYq/rSJYc30j1BsrP5Grk
	pJ3nsmwIYQHkdH8wlw3LhyPB9378SPqZvQpNknIjMTiP9PiSP6RrbVzId267fuckMZL/P6L1sli
	hEqFxdBL5fPf35wHvBHZFYijhoCpEpJ394C1THSE2mQpnsykQLXB9/ljquQyjuKUpLwdDQ7c2Tg
	ACfvaEvhq7BDdTKi+G3RNRBviQ2sBp6pypdmS792nBhmojYV3KPIih70SRi0m9H7gBDYverlLcs
	kDVhWYa7DxEw1xKtCY8w4SUES5XzykA1lb/wuv2jvZyBkSmX2KCnhqsGQjsrAuzYS6xAGkRpVuX
	20=
X-Received: by 2002:a05:6000:4b07:b0:43c:cf25:f29a with SMTP id ffacd0b85a97d-45eb3689049mr28173297f8f.8.1779788153530;
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d64eb1sm38023448f8f.32.2026.05.26.02.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:35:53 -0700 (PDT)
Date: Tue, 26 May 2026 10:35:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
 <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker
 <anna@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Olga Kornievskaia
 <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey
 <tom@talpey.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, Theodore
 Ts'o <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook
 <kees@kernel.org>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260526103551.0a05ec07@pumpkin>
In-Reply-To: <ahSNFmwAA17pMy6o@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
	<20260525182134.04045610@pumpkin>
	<ahSNFmwAA17pMy6o@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 May 2026 18:55:34 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, May 25, 2026 at 06:21:34PM +0100, David Laight wrote:
> > Would kvalloc() be more appropriate here?  
> 
> no
> 
> > Does __get_free_pages() return physically contiguous memory?  
> 
> yes
> 

Thankyou
