Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164398;
	b=OHqvtj1bPFijanWccr2KJm3sqFMkUjeb6FY+7tpfWtSHpoawBpYwNkixIAHY2wvrnvpW
	 6VsmbfzGm0q3X44Qb7D3EDqlBCawJiHg/Yh1/EEBdhUPhO6j7SLjymPeT7X8n+6nnTaZH
	 dBA5Y1TPudfvCVdojBDj1kgDxmcqbA1d7iNbTy6PUzg7gnEs2a+4Y2deJ2tNyHyMt28X2
	 sqCHGrc1Wl5ALHIbcimyJMnLJJwn9nagt/pCtiVPN8Qu8njWjMQs7NUWsipYhXJc40uFi
	 15Q9MgzV+mArYkbHbqwhchKLzi+U/IP4uyCOiTA8YZqCLOj9+RNMvdm5aBCNHU58pnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
	b=0mczNwhpZD7X5OzZumWxYL0E9Qap9z6MsqujAkfKGDfL5rCnRzGjtt0mRaxJQ0UXnN9p
	 NWk7OfWJ39QohhOVlt8Llsn7pu8tzy2XpnDjWbvpgBsT7jFTJnr66azLfiwSc0OMQq9Ir
	 AXwkPxs1YURDFk/obIxB83bsHyXRYlKRq+vjigIXuxRah5mjUu5343LM6wylsJTKxtgQm
	 QU+wkGl9BIbG1iL4DWGxtH7tUK+FlD6Fb1QuqVmTDnlVyB2S7nqGDix4ruC9v9/YZDFFX
	 AsVK03562DFB9GroGvAhke2v6ks9kUjWgWZVaigt8A3OvJl9NHDYGoKak7BZ/o5sMmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C8606A335
	for <linux-ext4@vger.kernel.org>; Sun,  8 Nov 2026 18:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 385C8606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so1416395e9.0
        for <linux-ext4@vger.kernel.org>; Sun, 08 Nov 2026 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794164397; x=1794769197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=XrEUEgHUwv+lt2Z0T4RzlOQuYT1yMbnY/MJrtF5HY2pc8m0ujKE+1IGJbqc3A1SsPJ
         Pz+po0Wh7ECcrOl1hyNdZBme+OsO/r11IeCA1lW9KMbstFhlOkC0Hm7Ef+TTavGsfrDk
         7T2AE8nlcorDhYFpLo0KTCt4xOv09AacMRilfH2h4PS2mZ0iBReAF8XAcgtI3iT+qlRY
         EJQPYUIUlDRCCjadf1+24R8V0flZyhCZpLCroCVsidoQ510350k4POOaAcSXgGRrBTWF
         rbpUnz5O6K0TOR8uz/zwLHiObwDAqnCJFWP0+ssCNYCBYnXJwQ2yMfUqdKkv6ro/lp/q
         XMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794164397; x=1794769197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=fY9e3vXfjBePqpI6rVWwBsVyK34bnBlTgepQZfY1iy4TJfqoUtjlXg2KPcR+vGAkWE
         o6HwNW4IVkD1dkfNWLV+ATsFSk60BPt6/oO9yHh1zS55sY3xhqdDhiSSp9FOfAIKNfV2
         wh3AxV0lDw4dBI3t+aXgXeW1FDvBoQdfRGWzbCkNgkaWTi1smykVNRGcSwfyc/YUffL8
         Qkambd8wek2OKXyN3c3F6/RnI/iqr/nznVQiYEHlyD1GxsUp86qZMWy7jGoj4qk5QVTC
         KrcOLdX/1csVFzlqply6vB+JKlH/yZYkHy+psu508UIRS6soma+k4a+LUI0AEF3WVkWI
         lyNw==
X-Forwarded-Encrypted: i=1; AL+hErF2NVQ2aaKThhRMQE9dbhWy6KDj5aqRVgnlxXsmsNi3XpjQEWxAacAQcdGd8w3uIFiFxpcmXf9q3lIl@vger.kernel.org
X-Gm-Message-State: APuU4Z9XqLEYAmJ/ueBKXWAyzhxzH8pP3bnP7QUvT8iStVtkPypX6nf3
	q+1f5sl704WN2u9TOy9hyxojcag4ghg8KIAMx1/doJA48hAMFlDfAcGR
X-Gm-Gg: AYBFou2vL+25GEHkPObm9hzrv0ph+sjqo8I/tvoUmp+D+ClWNLT62xntnPyZLxfeC0Z
	3sBbUUwNaIDCtLhZ4+qEKUbo+J4qefiDII8e4dh9+LhxaohGJziMgE2nNyg19acwvHNQmkgRl0f
	NcbriWVF0Q7NZA+qYUf8KOxbWNVN9Y0aRbFQx70wCKgdTyR+ZtuYX/VrikHaeZZlkJvJ5Pr4nli
	gFpXovhLLShVnX4+7oLUrv+WR/ERIyIOt13vfWH3Vx+ZC6MImM5stMLCL7zBfRiHSWyPluyN1SK
	NSi2R6hkfFD2YMYNq31VW/BS3qCWYNIGLUnOjMlHyTqm7NKkATW7N7inG5U8xrFkQIIsjtsEv4U
	yFuQTngj/6U87RlXkHOXtvHilyxHbOWiCM/Z+1p71NhXulLJGiujpL3Ex4prXoKn0VmGdt7wLGK
	CuC8yfXy+WqDnws7r4fwxO/HC+dC1o6g8NIJYIOzC/t7SmeehQ8MtVRd4Ie+p2c7o3pp2gzebgJ
	roSF7loco5bPJhtMYKnm/qXZ2UsM5brDWAgeYCuZBYWDXfiFmPryuPmtecJ7afmhcGw90Mrref4
	d5/KGPILbBi0nBr/9NVOglvB1EB2UTH4gDO1buD7zKpDqHirzx7y5vCZ2F7ykNS+
X-Received: by 2002:a05:600c:468f:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4b960d9b170mr35982125e9.5.1794164396406;
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1f3acsm185228445e9.14.2026.11.08.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Date: Sun, 8 Nov 2026 18:59:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik
 <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet
 <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph
 Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara
 <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mm@kvack.org, linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261108185953.28054fb3@pumpkin>
In-Reply-To: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 7 Nov 2026 10:48:35 +0100
Christian Brauner <brauner@kernel.org> wrote:

> > While at it, I think it would be good to use this conversion as an
> > opportunity to replace "char *" by "void *", which will probably let
> > you drop several casts from users.  
> 
> So I tried that too. The thing is it drops exactly one u8 * cast in
> ntfs3's label write. 

Since char is now unsigned that one isn't even needed...

David
