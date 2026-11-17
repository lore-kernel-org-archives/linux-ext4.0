Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794944367;
	b=uD5MHShVvMQ4jHvyvfp/i5U5JtqdMSc54N79W0VGMNlthoUo7w+mNy821HK9JCtyvdEA
	 /BySSF3GL1Oa7nGqofDL7e0KFsQ5D8UdhVmk7mtWYvJJEj7OZCX4Y85h1K/ud6MlUkR5X
	 TmkVCJK/8NxQ0Y22rb0YdN0WfPzaZfs3DbvFQN2r4umHcbFzWX16s97Piz1ZmfGvTOKy1
	 x9pXq2vJYTqyeCmKFgbe7eam+1mSc/HMWI1I42lMlJY79iLsCKnSPumL7miPe85D7U41s
	 sG5lKRahjIqQSrQFI9NtaF5q0oj9lCv1vqKoR2JAGKwEirQSYWSeFIZWYP3WWXxN6KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794944367;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X24LLs2RrK+lA3rnWmeXdxswGXkvA2QXv3w3PC5997A=;
	b=Axq3hAN85xd8yuNysTxW+EHmADmAk24vRUMdAf5iaV0lzG7uRX93hDDxKJ08jwrXCXe6
	 2NbgPiIj7G0OlpqVz0k6fl1YtbFvMuvBCiem5QDq4oxrZeLoqsy3DQBS1ikITNa0lOU0K
	 7eUTFN1Mp9Pm4zV9+mBhshk11r5JUPYqLLBHYRuG/70/pcE8DVv1Br9Ilo472stRvOgx7
	 0E8Xdv3AoaQLgLs3H7FSC0TwgM0udbDqIrEdAbQcO28YtMVhSfFoNcLfh0HwkJQXYOqSc
	 4DlGb4FT5TYQKgUwmfyGiQxBKA7JpdqdNaX7QioaQKsvHp3KOsWX8xxmOgsbonToCVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="buqZ4+/B";
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4937B606A33A
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 19:39:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4937B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=buqZ4+/B
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49412eb1474so72435f8f.3
        for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2026 11:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794944365; x=1795549165; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X24LLs2RrK+lA3rnWmeXdxswGXkvA2QXv3w3PC5997A=;
        b=buqZ4+/Bo9e+N24UUPYC17NFKAdU3HfgJsD6u3noM8uJiz3iiLUQLrQBL+vSAdZ/Ra
         WfwGpt1XKwdl5lYtJsKqbbK5BmFxy75q3DltcusAgIVFGfLOkyDgk8d74cha8JP30ISD
         BMGD7+qjDyXsPM1hS6JILeVssoE1Ff5GR46SCwdyMIPpXR1uES33HO64Dm4vnBC2ECVp
         up4jkuUIywG2HoR3dVY+Gmq2TINJ7632YJ7jQ2EijqYnIQihOG9GQhXHiIjk6wcwnuIF
         ny691NFOEJ0w072ZWJjLPFA176HpyPJp0C9HxKvn0htH4bFJ/G9P/PXHNYb621/z98dj
         f7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794944365; x=1795549165;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X24LLs2RrK+lA3rnWmeXdxswGXkvA2QXv3w3PC5997A=;
        b=F0A9uO1AfWjPMmvIFqcMQLAn1w8xEoYZtZA7sY5DXGUUq9A0tRokZQXqjuFyiCuZLN
         39IXs0gZEY+qJxJKGQsHRJon/e7y9dLLz8pxCLhnOiQKU2mImBPRQx+ezTpwxiMi8z2w
         NkU8b6xJ3varvGQ8MgIR8oEcEEiL/vlI9m8f7f72VIbP4hvTI9ZoyCZasw3CIr4esUw5
         8wZIwD2fYDUX4IesSEjnhaBO6NWOTwMFzmlokG0ojZXbuUgnRgW0lt5puzEEGciIMnnK
         R1VyEMvjEHdBWPbhvppxl0Vf+XewTF1mPX6G0vOLcrko9JgqH2v9+onv5jAEtZkDSroT
         KX4g==
X-Forwarded-Encrypted: i=1; AL+hErErrxiHx2iLIE3/6bVSIPUdgCBk+nzrY+utqH38cReb4vfYAjxUHA8o/L1vbrlp8VjOtpmJIv4IbX/Y@vger.kernel.org
X-Gm-Message-State: APuU4Z8h95Oi+8JFa2PiJU6scQdpEKJFmjL4MED6x2OmWhg5STr4Z328
	ZcctVPKHgnFICkbrQZ3/nR0AsLIAJNVdL51ea2xE2nMKUn1AdkFqZkuE
X-Gm-Gg: AZFdTZeAXu31VNy0JEK0JuoY+3VEUpVjWnfVf4yU+TwV8Q5caMESomM0LRBCY8A+hfW
	DIbkyN9VUp/b5G6GZtSNJo5HJPA3fT2Cwaav4n/Gkj5CcZ2ufOibskyllTQ62icz9qE5UyvMuqb
	PAXfxdnB8dPADTHjvqV5BdnLHAq+Rf0xxePDr5NTOTjJZj5g73LZp85Zvnv6MADAwwAm+4jvxj5
	J2GQuXApNRXfu7omRWJKPHPrFvisVcGMOyjuAyTM0rUTqdH8i+nWqou2fL9Q5yc5/r3hjBS4vrU
	LfcWuHyAZ1JIbQ+vIA3kDV95xQJGa2imwhY70bRPTRtzRM0C9feCJXn6ePnAL9PUoxaOKDxpdvI
	0Rc7TpWZDg/6H48YWODhdgD+l3x9vzuIeVz6Obf+fXZEJWXHmoLic5Zi3DU6e4j/OeyzD4eNaf9
	Q502RQjNBsuh7eldfQQnmd7sSoPiidDsxTQuouycWnbWdJnwnLUmEl1sW44/YrXMINoj821QsD8
	GvIx9r9+baivdRBbnKCqN//lkN9he6Yn2cWrwSxYI319gwfuldHpNOVNBCvaEOhpjOZ2n45hYrF
	XeaNHlXQ679TNbCXcDhyt8SsfCQcixgPyi+n3WEjCr9J1Gw2LzYVNcRn+VZDnC4KRw==
X-Received: by 2002:a05:6000:200c:b0:48e:bf0:352 with SMTP id ffacd0b85a97d-4a6346da7e2mr1023911f8f.5.1794944365440;
        Tue, 17 Nov 2026 11:39:25 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c1145esm424374f8f.52.2026.11.17.11.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 11:39:25 -0800 (PST)
Date: Tue, 17 Nov 2026 19:39:23 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Gabriel Krisman Bertazi <krisman@suse.de>,
 Sarthak Kukreti <sarthakkukreti@google.com>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
 Eric Biggers <ebiggers@google.com>, Dmitry Torokhov <dtor@google.com>,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libfs: reject casefolded names that fold to ".",
 "..", or empty
Message-ID: <20261117193923.795e6129@pumpkin>
In-Reply-To: <20261117175917.GO989762@ZenIV>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
	<20261113065332.929085-2-sarthakkukreti@google.com>
	<878q2swoxp.fsf@cartola>
	<avu0X5E298dHRBHY@mit.edu>
	<20261117084727.0cfa196a@pumpkin>
	<avxe5v6r1C7ZG7E2@mit.edu>
	<20261117175917.GO989762@ZenIV>
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

On Tue, 17 Nov 2026 17:59:17 +0000
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Tue, Nov 17, 2026 at 09:54:32AM -0500, Theodore Tso wrote:
> > On Tue, Nov 17, 2026 at 08:47:27AM -0500, David Laight wrote:  
> > > > Sigh... I really think these characters are *evil*.  I wonder if we
> > > > should simply drop those code points unconditionally when they are fed
> > > > to the kernel --- not only folding to themselves, but *not* preserving
> > > > them when a misguided application tries to create a file with one of
> > > > these misbegotten Unicode charactesr.  
> > > 
> > > Doesn't that assume that filenames are UTF8 rather than just sequences
> > > of bytes with everything except '\0' and '/' being valid.
> > > Casefolding is itself so evil/impossible it shouldn't have been allowed.  
> > 
> > We would only do this if casefolding is enabled.  
> 
> Which is to say, on any distro kernel.  Besides, it's not just a matter of
> filtering that dreck out on getname() and friends (syscall boundary won't
> do at all due to the things like binfmt_misc opening files, etc.) - you'd
> need to scan what you get upon ->get_link() as well.

I also hope it is a mount option?
So you could cross mountpoints several times (in both directions) to and from
fs with utf8 casefold un/supported while processing a single pathname.

> > For better or for
> > worse, it's better than what it replaced which was this terrible
> > wrapfs hack that was a trivial to trigger deadlocks using fsstress ---
> > which was even more evil.
> > 
> > The other way we can deal with this is that if case folding is
> > enabled, we change the VFS to call the case-folding for incoming
> > filename *before* it does its special case checking for '.' and '..'
> > if casefolding is enabled.  
> 
> That would penalize every pathname resolution, whether that misfeature is
> stepped into or not; hash_name() is fairly hot.
> 
> '.' and '..' should be recognized only as literal octet sequences 0x2e
> and 0x2e 0x2e; if some misguided filesystem decides to treat something
> else as equivalent to those, it bloody well ought to recognize and reject
> that something else in its ->lookup() (or ->d_hash(), for that matter).

I remember when "." and ".." weren't actually special.
You could have great 'fun' using the 'link' system call to make them
refer to unexpected places.

David


