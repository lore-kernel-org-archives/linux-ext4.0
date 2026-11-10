Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273581;
	b=Eqt4V8RO2UOqqwYdV/d6nbPXZaoQ17daYXudnstY3sycq8NDEv/6USR7WkO4S6GK8cLs
	 3BPu1PHRnsgQ0+q+b8trZ8ce+wMnv1ngEV/fDEpKTEX0eP5fokh5w6dnooo9eqmvlZWTL
	 Ji9dnM6MsxK1A/s1afcW2ZtEeerrWW1NGReH9PrEhVIz2pIL94gJVdfzye26l7uVV28Id
	 d94e6lvp7WiBiI1ylp997X/0OTBdVSONGNrnTJXhb1hguKIu8Z7hcj5OO4HjxoSMNyUhD
	 YnTKlDeH8N8/Yv+4acBL4usDwLrn8hvUMWIxKzzkXRVUUrPMrqkBxP8JunHubWIbPRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273581;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
	b=f/dnWvcC3wh47BFe1xBXYtv6T1UPBs3WvCfHnH7+Y2JuOJ8SImV2BRy1EuW9yHJSA8Ob
	 jJTcvI8AeVmboWiHKXLSh8vbOQdWWFMeqEogFFZhAAaVEubpref3kIyaFLCt+DjYb5+ho
	 8bNR63RWQmlLnz+3KehijGdIdRbomyCUifUN1HS3AEeLMjwFSXt9HxuwVKWfgcRQR8I2X
	 rRnPcg74k6dZwS7nkVbPPHJzjaoapo68j9LU/iICWQZ5cGiBqOMMiT5KgO/sMG9DeU+wU
	 F0robzOeGRemmsn/nleDu5VYYoS+3cig8hZ4IJNMjTXk5C7y6PKL/OWHZlcsvpbv2Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dpiWm+je;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14639606A32A
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 01:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14639606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=dpiWm+je
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4cdc606b47so217107066b.0
        for <linux-ext4@vger.kernel.org>; Mon, 09 Nov 2026 17:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794273578; x=1794878378; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=dpiWm+je1SHpvT4ZXrsM767YR8u0F3WTNujXZVVW/Uw+rTh1dJhcVp+ln2fo5iKs2B
         YLdu1yciLQdr0QJEwE3Z0RLPIoOcKp06GSMP2BZvagwchev89rkma6O/+L4jIavozM+r
         DxlnU5eIIgRTb+8xI3RAeMSCTd+KfhoHSoJGs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273578; x=1794878378;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=P2+EV0Sn56jTNRgOpsle6R+wA9gXbVrcbjxXDGJ91dHoS0cJOqI39dXCzih18pdVik
         QcFLRaJ6fF3U/3CQGfLzT7OQ2OabFnCYCMJUOC7IK/KggXKGhJZ0w9FWN+cBWI9f4Xeh
         /+SLF3yMXIQGF7+vfKT2o8JKCNPzwJ/IYqQ9yIRosTaHHAlfgLoVwRvXcDhtMNcDJWou
         GbxwUJXl1oJ57DPz8+7wTKQ2aBocS4rooFAKdgo03E/ZyGxvf1oy/o1S+b2R+l1iuIlT
         IbUMwtSRQW5APELgy27OHZ1Dxo71MviNkauKfNGKDpLaG6RLsSwNac+OMWIcw6OuFNHj
         lMOw==
X-Forwarded-Encrypted: i=1; AL+hErFRyxrOPvgUTSJQ5KK6/PEhpC78sKZMWW7UkfJbsgrng2vKxXGUmyuyxW+f7/zF9815stHicS6O6NON@vger.kernel.org
X-Gm-Message-State: APuU4Z8ySsyUq0KcNes9GUnaHVJrrGJAJlvwGc0ckWUwOglV5z+lK0pf
	9MMfGXIfLLH93dcJVoYMQcOQ1C7TMn55SDcXbFLT/LbDpWELatoPdkp+BTRpm7bOztPRmWbvRSD
	r8lAZrKLebg==
X-Gm-Gg: AYBFou32IGo1/2odILwkUHGAWBhHQnxG0Qq3Wh64H15ecyAfPav8NVt8bXjXxcNLNCd
	BfThKnsYm1q7zHIwptj/sqXPGCjU14Sifc2OAmc8x2uGdBJ6ImZ2N98//IA38w7Emn/IpIUKuLw
	6dMAQHST+ZKpS9L72jXLKdYUrapzZtGHbxfqCwCBDkURGoXv3odHDALI8PDPv46sbBgMemGBuN5
	TF9dbEEYU6SnWYoRkaKedcqCpeqtdZqeT8LFThTgaKT4/Hdg8a9b8iVSLZ3+S56Flj2oVyW75TS
	7vOUOVa7fJYkDFpSuJA7wAqkVhitnoYY4idGIIoyJNQtl7Y/8FTqypQauxCeyLpueB04tkszE6U
	+JqjIxqPqr74HPK30WQYG3MiQkB9LVZN2YonAnFvFWk7ETDrzbR+39oo1avcusqbj+Rd210cpHE
	/8TZVHn+estlrXE55NaqFYOHThirqCAzLMtI4Gd3OJw9Dcw4sf4UD3KS6MnF9R0CVoWqW/4VpJ9
	HIAwf+LZnaOinRii/ojf1PyKhqVjxw18V43R9WHnnzB4ibJjNrQJ92Tt/+H3lUHDgMkbEO4d6rg
	ykQQ1Vw+ry2t1OcJ4pbiRJbD2JaMvHWHp0uDSTuepVNv+7IpEB1mswFUeKbzxq7buPaSDrXQcrE
	18A==
X-Received: by 2002:a17:907:1b29:b0:c29:f5d8:9c75 with SMTP id a640c23a62f3a-c50496cf7a4mr80903666b.36.1794273578333;
        Mon, 09 Nov 2026 17:19:38 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a57088dsm40276866b.27.2026.11.09.17.19.38
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:19:38 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c450ab1483cso245677366b.3
        for <linux-ext4@vger.kernel.org>; Mon, 09 Nov 2026 17:19:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGFZIQ10eO5PuRJsd978AjgWYTiH3UuPwcfcFF5GG4PfZxZguLI9sQlJxnuqyqphNn4h4KN5EyWvrOm@vger.kernel.org
X-Received: by 2002:a17:907:9451:b0:c41:1750:59a2 with SMTP id
 a640c23a62f3a-c50495dfbd5mr87253466b.12.1794273275844; Mon, 09 Nov 2026
 17:14:35 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
 <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <20261109214558.0d9d5228@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 17:14:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
X-Gm-Features: AclHuK-x8jcOOQUqd2amGoGEAKER9jIFGaeL4LxxWAd0cGV7dz_RR64PtDogpPU
Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: David Laight <david.laight.linux@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Christian Brauner <brauner@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
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

On Mon, 9 Nov 2026 at 13:46, David Laight <david.laight.linux@gmail.com> wrote:
>
> Just that the cast would have to be:
>         u8 *foo = (u8 *)bar;
> where 'bar' is 'char *', and I don't think you need a cast there when
> char is unsigned.

.. and just to clarify: 'char' is always unsigned in the kernel on all
architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
unsigned") back four years ago...

            Linus
