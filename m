Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793822729;
	b=1bgBS3A9Rlf86w/buIwLXB4k6cnIopW98gd4D12lkNWFfQAtVVbvdyDabDufpFgPKCSH
	 4yE27YheNvt+y9r7zMk3/BwNOpZsyXVDEkWrZC6b8TYhzw4KPsGWUr79ZS+iz6v50pair
	 qHU70XgmIosDO1j4E/m4QIWibaQDdUVIIwawf0nq6HCz7stDtAJpq5kWvEyiZ+t/I2Yuo
	 WgJDoWipjfPa3JBnblwcZqU6ugs37axmtfxPCihYmc3gTN9pAi4W58TVIKN5od06xKzHu
	 IF62A2SLbOg/TmWRjwxZC7zfiodA5Ji4l/8sFw1WcvIBLYo2AGI5HK4t9z5tKdfRFAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793822729;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=J+XrLi/l0x5xWw9K2aKUTaOz5vpVpv43KKXe7ShOiW6wR4ZCquufGnwLGK8bWRvM01at
	 sx4JSQVpPBD/SKfyCWpNjY2DhLEKhZy8Vc9iVJ6psPyYvC54U5eSB/vThP/cLaNvN8gSG
	 PUH+ELT8a75BG8oXr6OAGnd67ztctW3wN21A7fGcZF809L/H5MzoSqLEa3BMqJnXD+yOO
	 dgOJegm/7gDG0uf5P7K/2p63g0aw4dkRIsh1vxcXPFvkg5x1Ujs8OJB6NKQr+IxXsjaaN
	 ZqZepNa0Ns9CrZdTQThZUF3WDzHhndNngWavBZO/S2gUFiLJktlmO0TkbEYcrTQC9LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=fI2nmlcI;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3B9606FAD4
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 20:05:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF3B9606FAD4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=fI2nmlcI
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c418e215671so166827366b.0
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2026 12:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793822727; x=1794427527; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=fI2nmlcItpwZxqRsmDWssHJaMT2IN8dLg7E1xDQbx0Et/5dAwJ3lC+28bQvSn3TcBy
         jCCz6aP+hY985kmEWKQ8J3n3DZJgb7Mf7tqsXWxEtttRySDwTo9j3SEkofmGPUukuzUB
         aTxGLiQfrDGmJiexVo8c15QHheFgr9P51oFII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793822727; x=1794427527;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=lxPYGOhEIiDEwt+s8/NwPW1yRffRwlBR2b1Vw4uiwIDksskN6zHp7T+XEIw9WdU/Ms
         aVHC1YF3JatylKB4wCgu/OXIwbj/+a77SZvrwOsM3pniyz7mS0W3n0ardGUzJ36W8QgB
         y90cPLK4fA7Uw/eZki70V+j3Qp8gR3oVIm48o50dyaZl+mvb2r4DCXsMw6S1JKdOz3kK
         K2vK+2/dHpzf1S6Rbebet3w77Q+z+bJPaUpIabKafDVt1bPjdNIl+3gZicagYBTggaPv
         wQdTKz/LoMQrjx7WOVLxJDg09fhWmQUbaPXtqRf7W/uKNdSjQw3jU5yN+jCPguT6+uVD
         +VbA==
X-Forwarded-Encrypted: i=1; AKwUvBzn63mdzEy4c80E56Nwx9PWl25KNVpNGFxn9u9P8p6zzHOUe051i6ihV/dCNEHM8/X8DbmQisPYYXpB@vger.kernel.org
X-Gm-Message-State: APuU4Z9RkRD+fNcbjBlk5Az3PkFSZnfK9qyGYVtps/+xng1Y3JDe0OE4
	Xy+4Woj+MpRHIZgil4Bk8jTEyQbZcrpOh3kvyBjy8Bk7jfOe7/SDD9opXiu07/ZqVUv9KNZN8q5
	PH54yW808Zw==
X-Gm-Gg: AYBFou1pJJ44IjqLR+10RWYN392bIdvK8dzc7CPq4tSHo+1UQKGtO7Qaf6rca2Xshg9
	RFaUI9i0wEyH0qza/OvCmam57SmE3B+khmuEf0KTvGF5wfqC8C1URgnvW5ZDGL1r1GqhukQqoU5
	1YbZwB3ObLceSiGOqJzh9/Q8g+CzJMciMdjerTs8gDaUV7A3SCtTZAersc/cunBPv0dmxzPbDzS
	lyP+UYXWu4XhzaT9gPKsTSnbcwSHLWkvMs3i8YCtQGSYd4iTRRoN/wNbZKWvvo6uT/waztOM83m
	GcR9RQUDKpvZf45Q98UtPxfhIa6bTu+NNRG5Eq+/uHtbgUu0aFKz6cmlWPvuUTTW0ZFgEDE00La
	dE0hijESfhnMg3jJo/D7xL/lx3TPIjo4laMPVvH2jFJ1oHlr3bMTBvXoSlSYNGmXMl9rLkOHwoQ
	GdO3bVCAS3h9+ihsnnhiaYZgiZ4iQ9Mduh4Nes8T074N6HBlfBKZOeaOVVVqQ10f+ENdmGg71n8
	2NL8yIPvah62dwDUXaO59yE555Qk28Fk2jr2FB3wxLNtCQTVCokz2pe62rHx27mRG8KRU6mDLci
	t/WTzvki5DopqoVPMUjk7KWtqNMj2YebEvMrMbD2MMXY8LH/XHgLD8r+IWuOv8j5b4ZqcsFW+2D
	vNw==
X-Received: by 2002:a17:906:1b0d:b0:c4c:bff4:202a with SMTP id a640c23a62f3a-c4cbff4325dmr831692066b.49.1793822727385;
        Wed, 04 Nov 2026 12:05:27 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e4a76d6sm104586166b.84.2026.11.04.12.05.25
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:05:26 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4550d8ab15so175921566b.2
        for <linux-ext4@vger.kernel.org>; Wed, 04 Nov 2026 12:05:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByF5rYLWOBMcdLdspwCagMxufvaPJyLmDvDs0pr22WsQVLEmSrS42yTcFtM+D+4jDqILmilXLq4EXce@vger.kernel.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
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

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus
