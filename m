Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B9221B9DA
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774710171; cv=pass; b=J/HFzy6RoUZNDM1lQPr2rZhQREKvD25c+4o8tz5e5NbZ5vBC/Qv5eAk5p56g3ykYs2oNUM/EHZb6BGnSxHUkgYFhySVPXexWTwiQxMFqIf/D1DpS45uLOyT817gxR6rfwVaBy3HlBezbuNjO1wpnM5i7pR50sLVRFT9jdM/b/uA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774710171; c=relaxed/simple;
	bh=7S821PBJ+FXdOmP0sWxEu/8M7GAV2RrtyL3JQpHVA1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ngHDetAsfb3dGBfn5LXKthu9weB3caQyVsU8Jcdjb3X34XLLc4q8Nv3+YwXmmlNKexedpX3gSPbG/0UdWEjfSEgJLkqiXLTRM26BHs6xKfA01uGRZi8Kd5oLk87TlgSdbzJlBV/dtP+LZwGeyrejXTruUjcy47ZX6PKMBV6dkcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Epkyk0eY; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Epkyk0eY"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ae2ce2fe1so3488602d50.1
        for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 08:02:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774710169; cv=none;
        d=google.com; s=arc-20240605;
        b=NLexD/Dl4HPYAdAFVMuiQ5mbgS+fc0Z3ju+oYgjG9r25ZFY9JjfX6FbzW0YIcqOgTs
         KszauLNRM7A5SXp33uexQPJDWdpNZ12CLcNQXNIMjAFrRofb/ISgmLtyHwb+3JDF1yI+
         FmEgdz1RP9emx49EW1/yf1i/EeQblB3pDPhz9SjfI+Onz8SsGyKGOtxlpu5wRz0qpLRx
         HXGYwMR1V7gOnv+wrssEzzYHmNpziBVL2Kicn1MoFmXUuEX8tSv+caYV8Wyi13JkvxKa
         P4Hp5ReA5jrnAdHIj4+qxMpiSxuCiuVq/bw59YMWstdknYTPSx+ya3HZOlven4Ha0wGF
         2ukw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Alhd+VYXuaI48nHy+UAXjIANLvwErpbrlzKzqIxEVqA=;
        fh=Uc9M+YxM9PXv2cB/hyHuRFMUUgjkxbyXuj9disHAXL4=;
        b=lJhWy29LMM5Rv4oVn5CFn+sO71TnfP7tSf/ekj+7k6O5bOqwlj56cEsA8YVqLYCYhn
         s8JIQnLliYG5oA8ozAk5fVSiv5Kv37EOzvuim7FHy3HBY/ZIwZbs1nH64DpKN1y3ExLK
         7HlPVunbdUximZShhlmMFYiPSYkGk1EleexZgrlyXsAhKrQF499+crn6Sm1XfHbL1AY7
         ltYKdU9zOInyE/U977QwzkQhLibXga2jJ/ZywlRU8akTgyOvp2YcPxz8+YVj0ws9y3dq
         e8cv2bW1E7jmEuFByYZI5lfagDQPZ1THFWoFk2IyBvdmnvFOOKti82NjQfV8chOPtT04
         hmaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774710169; x=1775314969; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Alhd+VYXuaI48nHy+UAXjIANLvwErpbrlzKzqIxEVqA=;
        b=Epkyk0eYeGWiumFje4tjzwkOlZTw0LObMXzGAXivDcZT//YoobOPPgmfudCgNv5XAB
         1Vr8fkqpfDGX5lBoow/Pn5jvb2C8jsFmyYEVQPgtYpx6z4viS/jcl1y8W9kPtCT0bmqv
         BPZ2tiB+oP1jT3eaY/EDg0o4Q4YK6sf/IkI6Xogi2gVuq8xZHm/iqDATLYBFyTMN3ntc
         JRv65aQeOLE12ptOQjhChZPptjI0MAwNyTRpEK74L5Z86y4akHIiJv+MKvRXK5yUbQxJ
         sHZGjyADRuF5mTcQihGO0i+9rQhxXZm/gOWnU7CZ79qjskNFeD7ztDjLPnegTYh3pHHr
         bH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774710169; x=1775314969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Alhd+VYXuaI48nHy+UAXjIANLvwErpbrlzKzqIxEVqA=;
        b=R4ipcfcHdvSLlGf6l7N2a0VOFaxL3B1e9QqAmSMCvR+fawAo11FBA9L7ikk26Ht3jj
         DpHEMzSMwIuMEutBmYBXWeCzP2oe8yy8zuwoKaLmREirImfj5na9vJRQRVJDIgzsQ9+k
         2lyPTWo3wVfqo43qqDXbyCHNc2c+b27XEmXdr4tJBxXtBkByFAA8leBUYKCF7Div1zkA
         uPjT7GBzT+WIu3weqX2ZmoIUP5RmaJeQSiu1CryDGxUl19qhvFboCq9uIh5mOoyvmcID
         wcitlcs2gScxLH1ndRDuAHcHD1XSPi2hBjbcv3TAaav5UdVOWDwJq5RDeXjZRUVCUJ3T
         wf7w==
X-Forwarded-Encrypted: i=1; AJvYcCV8tun6HeHLI0Ztmw4i+GyobJwM0G5owPAoaSu4u1syMygLUb1M4hSI9nd9pDxYaWAQM7rHLMkPe5fT@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx6gbtkfIn0liWpcOafwJsiKIjdHz6Za58vRn8ZGzUSVLvQsvE
	c6pEyXBc9YAWs+tDeJkNl+oSeorzLyxFMdTWkV4Z59/YXw31LOK2oAESf9zA3B6vI6uS3dTfmxq
	3zwh+MF37nRiWT3rN72FvleHb0oGy91M=
X-Gm-Gg: ATEYQzwJPOSlHupUZa7nx7BwPlAaqaTbD/aU/wH5kjll+Ag/tEAl1budBAbqFkWICXb
	6vjeBON4haenmZyaj8fjeVscc0UiQ+T4lR3rq+bzXf1drLYYlFgsDmqeskWe7zw8Ch/ids6GtzF
	et58L/W11XetApu9v2me2Dt69+by1taGBhG6IODKypc8ZqjeO5CZ7Y5nMhE3lgEUdl79A3QphdI
	9iy39h5bfuv/y7t6/IoX2CgkAPfzJL9e0CqV2krPT1U2WA6+Q9q7gASGBLtAllyZKahhA4cdeDU
	ZNwez7PDwNO7RX3S2i4D12Es5Yq4f+Lp+d38GA==
X-Received: by 2002:a05:690c:c22a:b0:799:2b4c:1d49 with SMTP id
 00721157ae682-79bde0b05dbmr67849167b3.36.1774710169310; Sat, 28 Mar 2026
 08:02:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224231429.31361-1-kartikey406@gmail.com> <20260326054718.GC4383@macsyma.local>
 <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com> <20260327163135.GE4383@macsyma.local>
In-Reply-To: <20260327163135.GE4383@macsyma.local>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sat, 28 Mar 2026 20:32:37 +0530
X-Gm-Features: AQROBzDHuC-FDeeI9CSHMJc1LhB6GdCqJnDyHrcHnCrv6R7Z6rzUiaFYDLdmJ3Q
Message-ID: <CADhLXY6QjWHiyY2MkUutzJK8utKghMTxjG9C8X7e=WDL5xKvYQ@mail.gmail.com>
Subject: Re: SYZKALLER BUG: messing with a mounted file system via loop ioctls
 (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to)
 prevent out-of-bounds access
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 27, 2026 at 10:01=E2=80=AFPM Theodore Tso <tytso@mit.edu> wrote=
:
>
> On Fri, Mar 27, 2026 at 08:02:30PM +0530, Deepanshu Kartikey wrote:
> >
> > Thank you for the review. I tried moving the fix to check_xattrs()
> > as you suggested, but the syzbot reproducer still crashes. I added
> > printk statements to trace the code path and found the root cause.
> >
> > The issue is that __xattr_check_inode() runs once during ext4_iget(),
> > but ext4_xattr_ibody_get() re-reads the inode from disk via
> > ext4_get_inode_loc() on every call. The reproducer exploits this by
> > shrinking the loop device after mount, causing the re-read to return
> > corrupted data.
>
> I consider this more a defect in Syzkaller than in ext4.  Syzkaller
> already unsets CONFIG_BLK_DEV_WRITE_MOUNTED because modifying a
> mounted file system is not considered a valid security concern.
> Unfortunately, the syzkaller fuzzer which corrupts a mounted file
> system by messing with a loop device using a privileged ioctl bypasses
> !CONFIG_DEV_BLK_WRITE_MOUNTED.
>
> I'll accept a change to add a to check_xattrs(), which will protect
> against static corruptions, but adding an extra check to a hotpath
> (this would slow down SELinux, which aggressively needs to read the
> file's sid) to protect against a corruption issue which requires root
> privs is not something I'm interested in.
>
> My priority is improving ext4 --- not reducing the syzkaller reports
> against ext4 to zero, since there are false positives like this.  For
> people who care about reducing the syzkaller report gamification, my
> suggestion is to either extend CONFIG_BLK_DEV_WRITE_MOUNTED to prevent
> these loop device reconfiguration while a file system is mounted on
> that loop device, or to fix syzkaller to not create fuzzers like this.
>
> Cheers,
>
>                                                 - Ted
>

Thanks for the clarification. I have sent the patch v2 with check in
check_xattrs.

Deepanshu
