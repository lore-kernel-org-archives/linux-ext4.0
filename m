Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069982;
	b=RNh5wlnikh9hM3seg2Z9rq3Aq6CChwRFgLX+d1XOmgd7u8hxwgTTlYK6N9/f4bWCDX8D
	 8Rr2a8XT4yPBOCIwTx78INEIEj1C7kQQObdDVxtE/dHRozuDhikn9RUIlQguHifU76nYm
	 pWx5PsH9uPJ+2fm9NjGe102vbuBpEO+RvGAiKo3XpoNeB/91jx76DIoU8K6WRtYvqx8kX
	 Kc+AAHotmi5H93myO32zKbOT/UQmEEPRvPI8XIHopzfhQGFvqZeGhCOoycFmUCrBLUVHI
	 S5e4AUKqWru1d91AAsQ/8thkTo9alggZBZcUb9AeeNFN8qHf7lrQjya1UliDYFi1ApQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069982;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=iQPFcguwJfJnGIUghj3vW2cnp0ZTKsyoI6OiYKG+trA=;
	b=fjRHb47nKLsx1wy1GbPkMEGR+EqiDglnweWrt0G3kqWF6H6XFzloVWk/bzNBZH5uf7bk
	 UDCg3OdSbJP/VDllYKt7b+K6TcV7nY7HnaGFou/njEUEU9X1grDttckHl2jhp1Fuhr/05
	 QCDNWPOMcGhf4AVOrPSNSsYliKmETEaSSAw25ivGnDQwJA+kl8u/h9mbRf0sKrTTN6vqG
	 SsiiugnK5x0zK5x1fcUTXw4xtlFEtCtI7NOkALdfCMrHxPlH5SzVCmOpg8i/328Z286fp
	 Ta/8tGPrZiG09C0WYDOZgp8CCwY+RpbdsbWIn/g/okvTnZRHSlTjLJK2rEvUAvsfk9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VM9YuiWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCAE606D80F;
	Sat,  7 Nov 2026 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VM9YuiWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C841F008A6;
	Sat,  7 Nov 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794069982;
	bh=iQPFcguwJfJnGIUghj3vW2cnp0ZTKsyoI6OiYKG+trA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=VM9YuiWnX2AxixylKQUoq+kcitnOG5EzbF2X9QExC8KlL2MDA2iyK+MohWy7Is5c9
	 XVSDhAm8H/yBVlmhN+3IQseSQF2jGl1M+I2ez83FRgJrdtIoEzyyJH3UteHcMNBF3J
	 CIxYy49tvs705sBEv6+oNmDe+XeTRlWWJAeIlasE4z+WjzM0vX46Vs29hEnM0d2wZb
	 W1dkb+g9MV6DZn1boZSIdWYUouaQYtnA2TMkW/lFIttT5mLiUtyZmeYkxA+HrJ549d
	 6AW15GkyWYPIpCmvFv4xURMQ9MDEdEzTK3dhB19k8mh2nE5zuDwmhWf+JnyyfSm3ph
	 PLuUxIL3o5qoA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8E1DEF40067;
	Sat,  7 Nov 2026 11:46:19 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Sat, 07 Nov 2026 11:46:19 -0500
X-ME-Sender: <xms:21Xvams7wVEmHspjWmbwhLpib2xNIptoVYE-80X8WqZqZcb1XPT-CA>
    <xme:21XvamRC29Zg9ykNiW0vwrANU0AC0j8D3WACLizfxgWZ2OLmopVNcj-qyZCZTBqLn
    FnUPDv24PUXWdCZGoMgnY4GISxXuJoqj_FJTWVyN8AgQyPiOZVj9Iah>
X-ME-Proxy-Cause: dmFkZTEtlYS0+TY9rHJo1vCDNDBgG/0TlQu1ZgAaexztyT5e7mSb39t8Qfa0vTeatlfpwP
    5ATotugI+S69Aq5UXpsB8wdUtjDvDqFpA717Gwij4u69sZUh6KSv9WWk6Jq//TgMNLfNVi
    Uz7LSIH08qzFkhYYh9/35LIN1zJWwwarlCDU1iQg4wt21opJj09VkTQ37+xtOv284TX8B8
    yl81LC5xmVZyo6A9GjLU5A0F5I2dYlaICl6rU5kYsMelZGpwWY/AOYhI+JMNgaonKgFQaK
    ku+gQcY5aJl2LKRp0R1zioHZwwCKpV/Rgf4D5rEiKrG8xxXM/BULju0eld0dqqIZyyKUfJ
    GW19ru42mbqsCpPSyXWqDBJxl5bN5OUlD62byk006CGbw520QKU/yBNHckj8/a7Aw/pswE
    cEiGWvUnIlIDfqqhyBtbUxKdieVFtOg/Nh7ULYvIP/0NmKpXY6WcXU9anidEQ88SbIQjDc
    p8Yn7T3r8Bo4iwmbKTgS1vVIcIOOKv75MyWqZv/+HCroxzEXbbFU7dyYNipmhzrf5va650
    CqAuf2hfcDqsbABPPTHxkCEDCl/Z7jZw9/P1SXCFxyI0OJaeowmrBr44zHzsSCW7ueEBOE
    v4mcadw/NREalORTbhxI6N8vjS1sruRGJ2ATEo0TnxHIE3AAjUR+ONXu5PSg
X-ME-Proxy: <xmx:21XvanTCUxiRZL_4tn_RpzN8CzyhB8rLiSKq-UOIyotAbmuEjI7sGA>
    <xmx:21XvaurCk3dCumlVKotKWDf68V8MDwwzlx-dEeK7pWGM9HqcR4oZkQ>
    <xmx:21XvavRZiOL5frHmdBkAVeJ6cjpU89f7VYn1Ikw-RN984COqc-2ICA>
    <xmx:21XvaoJKJLPj7VOMrYps6zuTHuKL8ZgDDK4Gr4RreYxXio5VOww0yA>
    <xmx:21Xvag3Tq78e8w_19g2SFkvau64M8X7d5PUoh2FKftcFG01vhemSEsb1>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5E62D782738; Sat,  7 Nov 2026 11:46:19 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AjxZksNfZZQV
Date: Sat, 07 Nov 2026 11:45:59 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <a1e2d05f-08c6-41ac-a8f9-6985ee00dc97@app.fastmail.com>
In-Reply-To: <20261104-work-procfs-net-v2-10-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
 <20261104-work-procfs-net-v2-10-221e2437fed1@kernel.org>
Subject: Re: [PATCH RESEND v2 10/13] SUNRPC: let procfs own the wait queue of the
 procfs channel files
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, Nov 4, 2026, at 4:13 PM, Christian Brauner wrote:
> cache_poll() sleeps the poller on queue_wait, which went back to being
> a static queue so that a poll() on a procfs channel file can't be left
> on the queue of a cache_detail that its network namespace freed. procfs
> owns the queue poll() uses now and it outlives the file, so the procfs
> channel files leave the poll_wait() to procfs and an upcall wakes their
> pollers through proc_poll_notify(). The channel entry is remembered in
> the cache_detail for that and forgotten before the entries are removed.
> The rpc_pipefs files keep sleeping on queue_wait, procfs has nothing to
> do with them.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
