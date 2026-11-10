Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347886;
	b=f+Bm9TbBsPJh/ck7d3S7N6uQfe6j0JKlvyS/t+4yxMeVzKRl3ltXvGwETwIGNX33CkVF
	 szRktnYarbKLblTCi5PtzQPWC4UFWfxrtV4HNsocmW4a4RRhjpv9zCLfOrOVTzFgMFxLh
	 tT6LD2qRz5m57sVh3rCcXO2sO4vj1lwUVC1ULDeV/4KsmYw7BbaphvbtA9FCyLCbr16FN
	 J1j49xPyhegLSDMfoT0hjhZOffA78LVwA0FS4WTLdhhxKEyWOTPNepdzropafhQIYBz1q
	 /+ZCA4/GedxOJwPCRN4utWjy0KPiw4BzGozx1b5mu2myOUH3KlTj3QOK81qiyO4HFkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347886;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kCLtDsSduJN5lzJAUixPHHYwKmpqQ8jqEr8sEL58PF4=;
	b=to9oXxXEvEC07ewDYEcbusBgGIVV+6JEBVsZxwOZ7GKAetD/RkLeX87EX9W124g9wjfd
	 GuKJZ+qeFNQOcZtbDe+6NZ0vN3QNCM8PHXgnl4Qs64YOhbscuH7j+vnoi0PmZZLLyu+RR
	 oD9MLwKYPm3x8kND5SGetX01E9DbLlmV9MjzLDwSm9+rMuC7EPq7Yod1GPJl6NsWwhPb/
	 a8xV6vQ8o3lE+nVgj+E8ldOnkGzD/4RU6bQiJudZPUFUw+YpOXEgcqIax1NoQqAYUISGG
	 wJnWcFN+ZkKGRB7NE/TQ8HOe+b5bE9UUnmbqblbUmlqBgSGKssvGQIYruuB1gPe2DdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RU2cjMWh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EAF606A326;
	Tue, 10 Nov 2026 21:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RU2cjMWh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35C91F0089F;
	Tue, 10 Nov 2026 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347885;
	bh=kCLtDsSduJN5lzJAUixPHHYwKmpqQ8jqEr8sEL58PF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RU2cjMWhLWTMYaymg1ZzNblHwkcH4bTSYnInlSJSLxQsbLjC6we9+twDh/aNKBpa4
	 ZOKhki2iaWRw0swT0pifRUi3rxOXErfR7rClmPQEWk31ubc+5+qXPLLxH13EM0akS6
	 0ZWYESXcdj7/o5BNONbMOR2vOWEz13IA8pdcE75+hgsg7BgI5AeW2dRxttIvda4X6j
	 J+6ShQT7+OblzOw2TgJHbu68zmtNalFHLGuAc4d8x00CSXbWGAs9iRbgDbZMC8z7LO
	 YGPMXyraW5fb57oy5qxA1F0oSNcFfbE9f48qSfbZOj8UrmeiMqncEm2Hj0LIvZK+0g
	 FMQPrk4s2OT9Q==
Date: Tue, 10 Nov 2026 22:58:00 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 02/34] ecryptfs: fall back to a read-only lower file
Message-ID: <20261110-eliminieren-raubbau-gibts-97763ee773d7@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191221@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191221@kernel.org>

On Fri, Oct 30, 2026 at 04:09:48PM +0000, sashiko-bot@kernel.org wrote:
> Because both flags remain set from the failed initialization, does the second
> open short-circuit metadata validation and succeed on the uninitialized empty
> file (and if the lower mount is later remounted read-write, allow writes using
> an in-memory key whose header was never written to disk)?

Pre-existing.

-- 
