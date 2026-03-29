Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F851DED5C
	for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 09:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774777680; cv=pass; b=DI6urBrsrN4BSnUtSFvkBI1J395fDNBkJglSC4MY9zZAK8tLhBx5X7ck5jcW+xNU+SzVyuZ7rhFSrwsPcWkCdumqAKXAgvdMsyOgDR/GduPCJs7SUiA+GEtR+Fk8PbxiDv7ftKMyr7sknzKzINcVqXclll7hj2gL5qCP/PsTaBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774777680; c=relaxed/simple;
	bh=uisHWGr9w7wEjo5rU4whWNRepfU/9ghDXVSierhMUqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NbFvI8mqZfnOyPI8Jd3G5aTIzllffHUf6tmiGfRlNuL6e8jAl4JYoF/8CtDkgUWsSi+bQMypc6IoIRo1JZs0l4qTK4wLcV57Rh+H1teJJIuUEMq13D3Ox64OLAYtUrcCrLkSHVBtASP9s/qy51ScdObyJbRVYOkgHP2T7ulyh9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tpge1fLK; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tpge1fLK"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38b3ee785a5so29598671fa.1
        for <linux-ext4@vger.kernel.org>; Sun, 29 Mar 2026 02:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774777677; cv=none;
        d=google.com; s=arc-20240605;
        b=jVz2Sxfb2eLNKEAdgaBRyKztu4PD1DoyIjkhXP5uVey5LeZx1QYi6eBpvKseEMLNoS
         NxmuIZfKGoPaxnxtsk5FN9U7hEY/kZSQQfZaER5LDe+ZPH4oIrd6wGldKPGvtaBAPLAg
         BPlNLfQEf70QqePvposOTBQG2rtgsDqfX92o7jkN2M67TkVWmCpU/XS9TGoCdWUOXl70
         K1e044hj1DIW5bOxgC/bEL5lJ4TMjVa1tGyxTI3hKWtN9go5X41a+KqtrwT3iF0Yu35N
         8apPdg3yPxAJKRCGT1tQhng6O0Mbq0ORZ6IT5tYRMczZGw9nOk2apouSNGYBMpAN4QjO
         vbSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ys6OW1HAKtgnjRfnCjtlpJyRBvf+jJDNEhyq9aWffjE=;
        fh=brVo8UUqq8B60jCpxKJwjhXZMukL7I8gqPvJUPRyh9Y=;
        b=StXT06Mv5WlQ9r1XpjuC/+SOsjbgzoC5oV4VdSTCVkxBTxd62bAayZEJPnBTYZUcIA
         9357IKAPg5v5/HUPu90JO8gnmBdrFKnmgeFntYyeOdgmnn0ZELehMrpc9nQPp6ZL9dL3
         bblHYwZVjViD0D36feJqT8f7mwsl6qoD4GaOQ5oo/729SvWPf8p7ePc4oPP34J7HkeDS
         d7QmPPzqBUMRg8C1Uy+5xXWAMsy55z6kVuQ5rO4YGtgITlPkFWgznrmI/lPjnIXB08OI
         fHdoV22mkA0GuiZDWNO7FoiXKA2ixysED1r8OMKyrWRHdiKImZfGMPhG6s7REuyozoB2
         GO/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774777677; x=1775382477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ys6OW1HAKtgnjRfnCjtlpJyRBvf+jJDNEhyq9aWffjE=;
        b=tpge1fLKiXMxvZduSUaBn3fmM3Hh/lPw8kxuCn0eKbxfPzxjTUJOGlY1RYo2nbrb6V
         I8UaEx4tEhwHxiQXMmQzCY77wNhBo5jJ4Y4Lh1C1zBjbRG817v/17wxcAHGITmfYIua1
         5bJCp2X8YSKyoxwHkDHe7tfRfFPWXQGg82wqmuMX7adrwxdBO5miP5cXR3tK5vIdXqq6
         BIknbBeVVGBOxnrSb3nV9J15+OZgOzs/cDofeYawAlvoJbWJEJBYyNx0YOwsEJta5kz9
         CUMKgnxVw8vJZPYnyTkoUerbxtUelLRcNs/fwkz6/2Fihx16IzdcFN6phaO11clPoaCL
         9KhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774777677; x=1775382477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ys6OW1HAKtgnjRfnCjtlpJyRBvf+jJDNEhyq9aWffjE=;
        b=Hb8Gjoyi+TYlCMlKsnOkof5k3yzi33lcKvAn8SIEYUyR4leffZfjs7c/Cf56NpZyu4
         0qEP2+QuZ/YEIoBdferEgEaocnh3xq5zVNY7ZPpPe77JxYVG+XKu1SwfMizebFkQP9hX
         YoRaA3anF7f12O0p/DSEHbTgWcbQaIT+gRlI5vpUeL+CiOZwGFw5lDCXh1jXENjrk45g
         kDtJFpQgPm3osSIZ/sK0JX97eHDj/Jjp6clsdk3SUeGrHlF4oz2BFr46D/0siU490mPm
         yu4RXexXhU046xUkJaG4rpoOVdoCbg0nUVH63E0Xa75jQMA2gvb8rai6mCgRzvtmtP4x
         eKJw==
X-Forwarded-Encrypted: i=1; AJvYcCV+66gnwk2N6OXaL/cwTwylgb4gpaKQjRcHUgrNrXOHV45VDWwKfngNaBlxGhqANvn7tqCadOVrQnes@vger.kernel.org
X-Gm-Message-State: AOJu0YzleQm1aPFQQwPKVdyV3DifZifKZf36+zJWEnCOknHNUiKnH6LI
	hKbIUnFyL3fzSJIzs7Z2KkSVvI7I0A+zKqhGcNVEZdWf12yh45n7J1egY6mt5m9SfgAym6AeoYL
	+X4n/WdXFe8lFEcKlt+Otw7PBF3Hl6JRpttPGpb9B
X-Gm-Gg: ATEYQzy0uRN9QZE4bfrofPEo3Xuzbm5rw3KBYZVp10i4rn6vME/6XlQAfSPbvT/9oZI
	hF9v86Fxfz1MsopZXzD7nwvqdqsqqb4emGA4twz0vCuupY8TAce0ZL99qRT5arBhCA5IYStYSN5
	HKC3oDKUcoJX/XLpaBIMp/z5p0PEpFfbUWgLwS4ISPwnZo8EH2KGyo0aalAVLcbhfAwi4rl4oIh
	PKT5sGmgufCC2t/bNWAR4DuBgNSWRffNrX1CzjmRDOsFrUeZQGoU3S6E9QyJDrxN/NPZ2zaCNym
	gDYhfLBepBABHNDJcBWEeGIQguEGclr/C7e0DcRpUGolIEZmJfmYcklh9CNLlr6kBm2SCA==
X-Received: by 2002:a05:651c:1a25:b0:38a:4e8d:747 with SMTP id
 38308e7fff4ca-38c756d1ca8mr26992851fa.1.1774777676495; Sun, 29 Mar 2026
 02:47:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224231429.31361-1-kartikey406@gmail.com> <20260326054718.GC4383@macsyma.local>
 <CADhLXY5E_4Hi=Uzu3LPwg_YNgcFR+UcAbfY-XzwVnmFBaJqjkA@mail.gmail.com>
 <20260327163135.GE4383@macsyma.local> <CADhLXY6QjWHiyY2MkUutzJK8utKghMTxjG9C8X7e=WDL5xKvYQ@mail.gmail.com>
In-Reply-To: <CADhLXY6QjWHiyY2MkUutzJK8utKghMTxjG9C8X7e=WDL5xKvYQ@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sun, 29 Mar 2026 11:47:44 +0200
X-Gm-Features: AQROBzCebvkMiRqEkSvgNsB-rruuWqgDIrO1VXYi1TK5f1KfYbQEi3ymB-TV66A
Message-ID: <CACT4Y+ZzbnD_puTRMx4MpcACpp5m3aMhQYvH+1LAyTKOz6otEw@mail.gmail.com>
Subject: Re: SYZKALLER BUG: messing with a mounted file system via loop ioctls
 (was: Re: [PATCH] ext4: add bounds check in ext4_xattr_ibody_get() to)
 prevent out-of-bounds access
To: Deepanshu Kartikey <kartikey406@gmail.com>, Theodore Tso <tytso@mit.edu>, syzkaller@googlegroups.com
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Mar 2026 at 16:02, Deepanshu Kartikey <kartikey406@gmail.com> wr=
ote:
>
> On Fri, Mar 27, 2026 at 10:01=E2=80=AFPM Theodore Tso <tytso@mit.edu> wro=
te:
> >
> > On Fri, Mar 27, 2026 at 08:02:30PM +0530, Deepanshu Kartikey wrote:
> > >
> > > Thank you for the review. I tried moving the fix to check_xattrs()
> > > as you suggested, but the syzbot reproducer still crashes. I added
> > > printk statements to trace the code path and found the root cause.
> > >
> > > The issue is that __xattr_check_inode() runs once during ext4_iget(),
> > > but ext4_xattr_ibody_get() re-reads the inode from disk via
> > > ext4_get_inode_loc() on every call. The reproducer exploits this by
> > > shrinking the loop device after mount, causing the re-read to return
> > > corrupted data.
> >
> > I consider this more a defect in Syzkaller than in ext4.  Syzkaller
> > already unsets CONFIG_BLK_DEV_WRITE_MOUNTED because modifying a
> > mounted file system is not considered a valid security concern.
> > Unfortunately, the syzkaller fuzzer which corrupts a mounted file
> > system by messing with a loop device using a privileged ioctl bypasses
> > !CONFIG_DEV_BLK_WRITE_MOUNTED.
> >
> > I'll accept a change to add a to check_xattrs(), which will protect
> > against static corruptions, but adding an extra check to a hotpath
> > (this would slow down SELinux, which aggressively needs to read the
> > file's sid) to protect against a corruption issue which requires root
> > privs is not something I'm interested in.
> >
> > My priority is improving ext4 --- not reducing the syzkaller reports
> > against ext4 to zero, since there are false positives like this.  For
> > people who care about reducing the syzkaller report gamification, my
> > suggestion is to either extend CONFIG_BLK_DEV_WRITE_MOUNTED to prevent
> > these loop device reconfiguration while a file system is mounted on
> > that loop device, or to fix syzkaller to not create fuzzers like this.

Hi Ted,

Thanks for the report.

https://syzkaller.appspot.com/text?tag=3DReproSyz&x=3D17a43b3a580000

Do you mean LOOP_SET_STATUS64 ioctl? It's the only ioctl in the repro:

ioctl$LOOP_SET_STATUS64(r0, 0x4c04, ...)

Does it mean it should also be prohibited under
CONFIG_BLK_DEV_WRITE_MOUNTED to avoid kernel memory corruption?
Or at least some changes should be prohibited? E.g. I guess changing
lo_offset is equivalent to writing to the mounted device.
