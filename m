Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872498;
	b=MQOJCFv7bj1p31tBG1G5bFhHsX6XNBSYowq+IipbDxlhrq8oiHDaYfmt256YiYFaDJ7X
	 QQ2ua07vqhVwP7FnK0z31q9XmPmNTzwQBsaecYEufDbLOt8ftNh+rRQJ2IDZUqfSpiYJn
	 +mhLw8JHoJulA3JRCfxBnpC8RhZhinXzAayUfruICARyFS+0/JkFxSh5b+c92oHnKJyEO
	 1tLTfJJ6Gmw5+eTUXEbUdmW3WKaI6V3I+dacXqegn2tx3hOwEFEgmD+y+G3nlv1+MYZvB
	 LDBq9hILL0WIVCvBdLfI7UbWJA2Juwt3mozHezgE1xCeMuYaChx3mPWInyiTjGG7AVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872498;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=Op6j9ZnDaVsRJgt8ViOmdwSZ+O2ZNJ5RlMHgp+XXEaQkFZnn6yqfYkFb3n2aXNagsbjD
	 C6qKPe5RGThpVKXE611l4IjgIN6+5NfQZwmfC2gBr0kE4ZvM6yeNlEFHwj8ljSDVVzSOf
	 YlzxuU/ZKqXybo6DK8vZ3jVxRTPcJ+qPgZQqTGN4jRyV8MzK+vfkqPh0SqBzxrKCxQCzQ
	 aUh6FDLrfK4mZvBxMOIQWVHfPYT6Ly42VqKAmzZlrcgXbPKewQeff0IlBR+takCWaJehi
	 CXW7eDLm2tSiDiFthYYKncj1ibrd0JXOsmNxJVHfsyx4HeFGRqarXexfIfrxXz1YBAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040AC606A330
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 09:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 040AC606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7cc013095d4so489267137.2
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 01:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872497; x=1794477297;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=nEA0xwF+V2YVFUTQAsb3LC/83Tdh2THQRLx1gE3iaPx72TGezj59SgJ9QLTdRU+vsz
         Y5agqd7u7zJPMKKAX0Gl/ArPNGB8PngS252w3YBNyjv5v01wxdDIKUBwgVcylTogG0G8
         W0cW830DyVNq3+eB07vWANYtfx5v0geP7WyI5GNCvVA8tkd96GdVGpSJpEABMCd+J+pW
         cqS+e5I6ADV5JzlXMDHQHyuma2RDYltdIxtUsLM84smtUNBO7t68vXGvHjdr7EbZtdYT
         aEV/PhkHQC86QBVWbshtWytymTpT5A23UUMru1C740xau2ovB5TN7TYvv7IWE508lzFG
         lwUg==
X-Forwarded-Encrypted: i=1; AKwUvBw6+gLhLCLNKtsIJth0dmEcVz7v4A7bJWPN2hiIEqEEby9ERluEr6ogWUW3p+WskdfWu5Mi5lvhrk+Z@vger.kernel.org
X-Gm-Message-State: APuU4Z80Vpz2mHuTwWLhMayXBcMDbBXPwAIz3PSiEhT+W3dmfzm3YcY6
	AzYE3HXI+zWcKKD16ZyM7fixdRnHeoWWmzSKzh8qEO4hZ6OQUAKe+8o70RkdaYUfKC0=
X-Gm-Gg: AYBFou19Y1bS8Wjz7g+DImZ/niyym4fHl9Yd9guKBScbiCkR8LcCJQxzv31YpM4W9x9
	v1qfOzUtG4M5t1mLRfmdSDT90eGKcng/TxYs0Bo3mV0QptH4tfiXDBy8NgBjarw2swEOG+DtM1R
	GIVQ8l5HgE70o2iZMExyDJSntDCqQFw+BmSCl/gLgGB2ud8bjNV1qmMhmXjuhwj8MhEB/FOHany
	tnZjnWHGtUdezj59wynkX6HBQjVyz4bFPUnm2zANPvwiKhDhnMA0ZV4pNahO2Jl9ZAYK0mdIMNb
	dlBMJXN2WJJAbH3CAw/w7aLp3xIuo/9Vy33i+ZpU4CnYeJpHd789LaPPqomV/jY34naEVK4f4ui
	7YpDsE2wojP5oF1X4oOYXJMWdz+oKm2G2010foWf9WfHqCxJcdGOebvB6P26Vu5bkSdR5AOxsJy
	wOyMhqJWkIcyb/SohpneJWrpK6Am93o3OFtp/Af9QN2faBwMp+mikfGp4jxpH7FhyIH76/jMHHK
	XV3h2Ys4dMnRCkDPesU0LeOTDoTpWYuK0ehUaFYhF50MJrevs6QkMc4L9n5VZ7S8bUrbNZRYN8Z
	Ni/3zpFBL25g1OK5NVqduiTlJTGFlPlJQfx9OMtdtmU7yKcOKOqvX6wEI8lXgFbamk86zw==
X-Received: by 2002:a05:6102:290c:b0:779:5049:87b2 with SMTP id ada2fe7eead31-7d0723d710bmr7549274137.0.1793872497047;
        Thu, 05 Nov 2026 01:54:57 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d69af4fcsm3848129241.2.2026.11.05.01.54.52
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:54:53 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5eae1276409so540510e0c.3
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 01:54:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByfhSiI0ykEvt6p3DkfbbwJRcXcczl17XgsXgtunKJmZFcpkVUuG4ZeX6FYVxVWly9r3P/5BeDUfKnS@vger.kernel.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
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

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
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
