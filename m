Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872337;
	b=KGhABByny03DcqWCySJIErlBHYHyhxW31Or+JX8ArpVBYBSaufz9G3OPIuiiYtbHgCMY
	 NXbA9kjCIqgN7xWUrbErJd3bij7q3+kbmG8GdQTU/15nUaK1DS1HZjrANRs3bbryM3P/G
	 NI3tzn3LNw7pgYWR3sMHgBuv6Q/Da9JBYrfFtqqfYcZ43AyjdmE1IhDPeIrVGWgcOzO1H
	 hhZeFXHsogDtoshvsFypfc7Si8tsCUXa/2GT5MsFeUfooh0Zd8yODpsz4BFncnzPNbuMy
	 +B+ESQB+P3BzhwBuihn4G24pO2q9Dq5bdUzZF0yTurOpWXeQwwpgI7SgvoKHQNRDpwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872337;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=mXghsWLg+1RtSTFTT3Qec2Ks71PjOjJt6aXqC+dnJJbt/EyGkSDqa8Kl0xKMv7ryqBR2
	 4rWfBuZC02CW/Y7XOj4j0VEwBMOMHVW44MYaYuOBjevSGIGreV+zlxluiwspQtC80N05+
	 kkEHRgvgD38WwtEJPynfRg1lnhOjk65BEqXOLFdhIcB7uwX6RRSR+ckBJHFq9ggXn2uNq
	 aUk3+DnSrL0TBcaeMf2JIwDqaD4U9wkhsYWNSVU9MoJ8owSvnAa/4yjodWut4GvKP2nfV
	 7UMsFQcKt3IrJOLEt0BT1oFzJpiRPXyL7W8VU7XHRlNmoplu10hOLsCmKoYp/sO8Dqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABC3606A339
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 09:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ABC3606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53653e30353so21936891cf.2
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 01:52:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872336; x=1794477136;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=0R7LgvDU6vLA/ra0wW+l8m1DsFRL+7maRGTR5oRToBYdSyMlCXd/tP7O9ua57+2Jhc
         yL0hCHyqjq5m2hSq6VhN0yj3ibgedPUOWHWOPipZbezLzr4t8ZXujcxXJmvMHRGdKo8b
         talev4en9zFQslqRzAmqFiaZ/e8bMxsQPsO2szC/YKtRJcyMpq6uyEpnIwX4yqnBlVQy
         7p3j6TNhpkXUCe46aH/ed0nxCsyL134VLluz0bO4KsEBYD8EarnFxZtz8UyzGSdH3gs2
         HFK5giYASjW0ZdEXtb9pqaOrk0JZKU38N+FYY6XbDUUbUwWw4pP4NqP7b7hy3FXENF2R
         V5lg==
X-Forwarded-Encrypted: i=1; AKwUvBzZ2QSqA0AOQOCLOkGdTfxHXhVBsahH22/Ha4qmfCElMN6Oaw63qAbuFyUsLZN6o2sdl1w9/qtGkpHP@vger.kernel.org
X-Gm-Message-State: APuU4Z8hN2gVR+Tcra/c7qE+D0TaJAZF1ouYfw5Fbe/kWsBNa4482JrE
	ke7eF/plD44oYQhqwkX4NpEa8sR6ViQkASbCOA4zo+O+Gvqf1LtMzzIPRbeYr/iqpDY=
X-Gm-Gg: AYBFou00OgC+M2FuNV3RxpRYU1ERNCoqiUMzJwApd03JOvQl/xabbOOMsbTagWdFvXH
	2wdmSxewczqW4TV1TnGb0N1BTtIf0tr3NBlLTZumqtd0V09hvXBHBAshWztQL0kJe5H/jV8jctJ
	SC7afce4+xOMol3ZW++uit/g53d0IvsaBrapckHK7SkdEwrXSVAdCdKpQ8GtS2lTmEuGaWw8kIC
	gSvNggj0FvINiMCb73oyRS17H4FHpGEr/T+fcZPy2SxWTvvX0PrA/tBw21tCaT0PYeGlyKDHW0y
	QB+4jUwTSkk8J02uXlrAnPMOhNMrjbGFtr579TWH4C4a2Q6f4l+u+TGDQaK+Ni7UimJ7OLCQt21
	o7ZD3rB+U0lYCjpVmmAFfTemF8qYFJZmWT/Z1dwVz8E6kWSEi4r1vfFD7G1bCEOWYpMNGO+QiUg
	KfvqIYV9rjudibR+kg7tQ586x6cw8OiebrhajwbfCIxk7Cg4PLu8H4wgDGJGrwETHOmJqbFCd+P
	meyBeBtFG+4W15a4SYIObLX+9TZZLEn/s7BHpv9uFEyQfCDxAnVQu8U+bg4gi4IHxIKHD+0Qrv5
	29UA9APyeM/0DNy/RaFkNoyApGQTNXCssHVdlcaXiu97O7rWtl2uPczN0kSmkevc/pVyi6s0BFT
	IzcMXMekkuiLvGcc=
X-Received: by 2002:a05:620a:6186:b0:93f:3576:d43c with SMTP id af79cd13be357-94421630cdbmr2937040485a.19.1793872336515;
        Thu, 05 Nov 2026 01:52:16 -0800 (PST)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com. [209.85.160.170])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d468f904sm420105985a.5.2026.11.05.01.52.16
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:52:16 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-533778ab0bdso18444031cf.3
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 01:52:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByH+lAN1yxCMvP1zJlPWQBIQFxsKa/Hl5cVw+D3+0PCG8pUt7aPzCjiZAHEms8Y2oTDFAJ5w5w5YVzN@vger.kernel.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
