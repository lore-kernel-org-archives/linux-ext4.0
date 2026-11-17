Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794905254;
	b=y0iEz9er+fbgJXQ//3sp0Dsw75Y69ddniQG9DJlLB++Y0MkBGdTGOCKgd5VDZ7qPd49I
	 U38FkUYb/nKaO6I1DK0TAGdQ4dzk2SvZYACz732p+ved8lHel/AkPP4cWKO2ZiygQfKDW
	 kujxScW/7VBaf4aSk2VWHYOtjKH7mSswYdQwHdOAJ4c4qo7eU3UIiDvA2CUv+gMhQe2mb
	 Y1IOC8bi+q/TyzBm0pI0VWjVquHtelAU0AGMSPNW2LA/XCXJjembTrpfJegs+wkt+DtBO
	 EasRM06NiviaIzgSK+bAGS07xkZ17AZ0irmoFkIAmCbwUOHyz95V4ZxD2bt3ryEMsFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s3M1bSOBYt5gL2unmdOFOAn92UpRxf2onmyD1mml+iQ=;
	b=ajmGjvt9Q9b52AcRJHOR07dInPXYV3lUnu0U38HVNoPvMlrkFXci8xx7nlSkQ0ZXPD+0
	 BV8hpHqcN4ZlfxXNqxsHKwyzeDw4+B9qUFjvCpiZXplbxQ4GyvlZPWdo6mmBrE+P49ruy
	 wEpNXIs+5vbPSDCnQPMxDkpjV83Mzz1YPf90pVtpDWEEbqK0POmwicRVzOp+rt8DTIz+t
	 jIXDdQXPvMLgZVYy+coE+0sgY9oAZHN5OFDLRlRkEr6Q8mkh/8SoYeSSoYzZW9x/aKKbS
	 HXmKNsLXhDfpZkcYG9TDT5cJvjyUglRlxIvcbv/6C1hpxvAF2oEEDkBdcnmJZYSxr/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=paG2evd6;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCEE606A8A6
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 08:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DCEE606A8A6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=paG2evd6
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so4528874f8f.0
        for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 00:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794905253; x=1795510053; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s3M1bSOBYt5gL2unmdOFOAn92UpRxf2onmyD1mml+iQ=;
        b=paG2evd6MD9xh5NrI3KFfHIvZHv4F2/vrRCU9ssrPWN5wCLSTZBF23eoz4I8dCC+/c
         2ugnJY5Wxct2xzBsFpiEAthtgG0dlSHV91NMwhNci0H6Mzz+l8+LsJnw2bh89kHjn4Jt
         50/dLxzD5nqtaxJXY6wlIkg+FT0Ibf7E2dBQJdcgLlc9mykk8YCLZrbJePv45Cu+t340
         klDoQtgwpY1C81Wm1chUo9HmWscyCgQ4aOMSr3RQXcrRlou+8WjbuKgAItgYH7F819dN
         6BhWO11IagfyEvdROrCQHJv3QvWsqAuNjHVu68TEumbWmFXtNmbSKzmEeaBfWM+/+zeJ
         ooWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794905253; x=1795510053;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s3M1bSOBYt5gL2unmdOFOAn92UpRxf2onmyD1mml+iQ=;
        b=kN3sdiWc9muzmAYDRhwtGZEfj2k57YU+HAGND+/TmivtDM4nvUXO05tM9sr9cjWRaZ
         Jka5U8XnTftkxn53cFyMsigou/ppPzUitL/7g56/UHA8HnqWSBnwISbGZ0151VSKdatS
         ep58H9iBrV2HDSKmswAmNgVDmZTJRGqXLf43XzvVpnSOXcZcnO/5xzwICv+9BzhwcBTk
         NtWOod1KewW1dQntOGxla5Dr+nnUqMnuJpCwNm2HtmGnels9NAQ6JYHn7Gdw7Zfty3pU
         3wmPFAiqjpzsvqiFFwQltsSYsYjL5IJAUgItqYqlKStlqwGlH/JmW7XDURebdSnDoOXd
         HSmQ==
X-Forwarded-Encrypted: i=1; AL+hErFx7rXm1BSRIbS4BwP0KNKFPmCtxoj54XL84IWwKuGDVWlQwq9LMd0YyWScBTGFfFRpnQDLkjOQ4bo2@vger.kernel.org
X-Gm-Message-State: APuU4Z/qcSYfDzO317DIgYZtZ7CdCAWH+H9EDjOQKNtkq8vVOTGgMhDr
	OJmn7Y4VpijLqkeMMqgOSnKqyIcg5niu6R9/WwVrKyBP4jMvgiKGaIw3
X-Gm-Gg: AZFdTZcBXuDfXcaqG7VV077lUuexSUVfD+E51IjCp4VMJtAJDKDFq3D3r/2XM6EQ9XW
	z10YBPIAYvNX/xLg/1vbc2PG3kWWD5H6XJ89Durv6zzBFW0aQugtEdr5o1A7sdELcnshqD9sQQj
	A1kPCwjJie8Gcc5/HC3i9yd0aGYPOK+31sQpVF6hGji6mqgCnRX4Xo+8bj1pM6bhm9i7Q7fGwTs
	ZEkWDzUX4VYwJCjjK8VKZV8npp3fxdbhW1Z8MNEqs6AqDjucCnHRcGl6OeYXUqz7pU6K7Dn03tL
	BAgL3nMHbNlctELfu0ulaVi/AIcOgUcg9z3HW73jy9M7bIBNxBcU/G7WX9gU9G93iUZzStheQ+C
	exMkbEe1jy+KQ94CMILeuEFEVfK7DVOxpp9BeZlnkyLbvqqX6FDrvysmnRE4LryCI1vVZ3ZzPgL
	Mzg19NurlxbdYLxAehCwQeOFYq0sFEI7lg+v5KE8c1KR2lV36tZHwjmHQG6evSiSeoyn5/Ikqp4
	PBWv1lwXsuh6b27dv3XHQe3QR9TEC3tsktYaIyqeE6qLX3YuKqqzD8qmsV9F+CTpWEz2uN+lr2v
	euDvXCkNST0RbmWY88TbU9TEEbjh/rDARSx4tfaSs0RBDgTUVKSDu6uO9usXh9MVGw==
X-Received: by 2002:a05:6000:46c2:b0:48f:db47:6ebf with SMTP id ffacd0b85a97d-49c729bb31fmr19089884f8f.38.1794905252525;
        Tue, 17 Nov 2026 00:47:32 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a43775f9b9sm2739633f8f.26.2026.11.17.00.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:47:32 -0800 (PST)
Date: Tue, 17 Nov 2026 08:47:27 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, Sarthak Kukreti
 <sarthakkukreti@google.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu
 <chao@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Gabriel Krisman Bertazi
 <krisman@collabora.co.uk>, Eric Biggers <ebiggers@google.com>, Dmitry
 Torokhov <dtor@google.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libfs: reject casefolded names that fold to ".",
 "..", or empty
Message-ID: <20261117084727.0cfa196a@pumpkin>
In-Reply-To: <avu0X5E298dHRBHY@mit.edu>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
	<20261113065332.929085-2-sarthakkukreti@google.com>
	<878q2swoxp.fsf@cartola>
	<avu0X5E298dHRBHY@mit.edu>
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

On Mon, 16 Nov 2026 21:00:06 -0500
"Theodore Tso" <tytso@mit.edu> wrote:

> On Mon, Nov 16, 2026 at 02:34:26PM -0500, Gabriel Krisman Bertazi wrote:
> > Either way, this issue is another example of why treating ignorable code
> > points as 0-length strings was a bad idea.  I'd very much rather
> > utf8_casefold would treat all ignorable code points as foldable to
> > themselves, (i.e. commit 5c26d2f1d3f5 ("unicode: Don't special case
> > ignorable code points")), but that was tried and broke applications
> > that relied on variant selectors code-points being ignored.  
> 
> Sigh... I really think these characters are *evil*.  I wonder if we
> should simply drop those code points unconditionally when they are fed
> to the kernel --- not only folding to themselves, but *not* preserving
> them when a misguided application tries to create a file with one of
> these misbegotten Unicode charactesr.

Doesn't that assume that filenames are UTF8 rather than just sequences
of bytes with everything except '\0' and '/' being valid.
Casefolding is itself so evil/impossible it shouldn't have been allowed.

David

> 
> I'd prefer to simply reject creating them with an EINVAL, but it's
> likely that will break those stupid applications....
> 
> Eventually we can have e2fsck offer to fix directories with those
> characters, and eventually we can make these characters become a bad
> memory.
> 
> The other question is what *other* evil misdesigns are in the unicode
> spec that we should be preactively trying to addressw hile we're at it?
> 
>      	     	       		   	     - Ted
> 

