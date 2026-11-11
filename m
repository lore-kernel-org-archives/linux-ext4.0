Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794405401;
	b=YkTOirxkVNDEOkb/D5zIgpQ/Xwo2BcyZlGYQ7bVd+9TPSAYKn6jGmfM0LLV7LlswZJXp
	 mnH+bIjdHPLm1/6Fv1BWpLBUtC6PmLyHjSDF0iS3tPAtgoDeF5qa+QzFAOevQN0pmP5RA
	 Sj8sIKefGFXLx+i7xbloDWbhHj5P8zdUijYjG72X+wRj1IAIl4Cp66/2HgHUd4EjD2jCH
	 0PUNyKVqKsYD+VAtTbCBvZj45b8Lo4KQbBgF9uqQNabOsqYJhPOZrk0S66LtEETmsbT38
	 Cal7Pm45kaXcQMKEnxskxKugIFH9NhJKdXcpuKEAe8QqKCVNZBvKkFZ1h0SXSUmCiGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
	b=PxjtXEnG2z+G67qWJ1AmD5w7R81gkgeFWhh47VKNZ9193SvIvEZSdBft/NTtL7bNAvoZ
	 UTuIodk4ZmKWkRXJMI8puwkyA5kSBA59n7q+x3g3QFCIe7DK55sS6IFd9LWdcEIsO3Qb8
	 D+QVbVaXxIVjk0jzAA1QH3W8Ptr8lxrBCvmPktplJ/RlwgbWJJ3eHYOsd78VgSm4JxA+E
	 lMsgyPEkyNgKgRi+0KYgJd/nKcimgdej8HuAVymrNrE92mOgKSysn8sg1UYm26h3WhNd7
	 YuTCHZ2vaS+tGJFxbgL1Pv9XAcUhkvYBt/5SwN7lM3u2AquE4Uf8R4VU5235AzzPhow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jpjn3736;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A6E606A32D
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:56:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8A6E606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jpjn3736
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso24714485e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 05:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794405399; cv=none;
        d=google.com; s=arc-20260327;
        b=oZWlHp5hzNQ4yEH8kS0WKvOtAXtqfuIQ0y7kdfLdBL4Kn+7NtWdhr9kqWBvd1uyMkw
         jhHL846L3zhZnit4RK3qesdoK0SQ7SU02sdbD1xEWKbDfMoPgHaix/J5iwY0LBnfHUJL
         lBhxzbriKoIHNIa643MJMbbTMpKMSRX4oKd9X+blBeJ04wZa5RfEBGEbZH87zQdhBJ6+
         nlVGcmUZf6jVS9c3HGnaaXA6dSZy1clAfc57zuthOL/u+86uL4pvlpzJ4WKq00vrQ1jE
         yGiUXVCB92zJf6ry1atBIk3kj/KCuPajw0tWdIYgU1tabBOX6cjOKG6T+JHBeaSsenaE
         lyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        fh=0fPSYohWQw9SL5eqZhSmn7ZZIEywU6uYJhuk0AmcoYw=;
        b=MDg6LlJZdRsAZKrcyJLQlPos5kGWJ5IDoX0k9TrYdLM8Yt0uBgkNM8LX4MwnXYh28q
         sztPU07WpOpm7oJelLz7jVEsNJvGwaFyNabHI+qpmCNM39KYmI4xXmVowGlJk51Tf7If
         SSoEj8BgXFBnt7EOq2X+aVZhYEiCptT61iHM1dmokR6VtbNBwAJckMripxqHqoXTrKUT
         OsAWGOYWzb2zeF5gQp0DDAGFk+8GfVjtlAK3tyq+MUw3EbVtw+vOKP4X9nK/sSvGAMBe
         j03NDJ3SvD5kKJxRSV7gizINbkgJBLEoRojQJp174DnuJoG0hziamVz1rwWG+2iTGzgu
         CMuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794405399; x=1795010199; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        b=Jpjn3736+17VV3j8BY9HdEIk8rTF/SZsQTWCIIW7MCwGXacnTX9L9vLzL/yYMO2j+T
         /Tg8YarJp3KO+2kkZAtuCnyWFm6xfuCzu6xYKxq5A4LV8ZD7cejyZFDLGg3CNc2cW7qV
         78B7pJY3UjM7ZvDEDLEFLG9OoCiyETKx1LgjlIXgeh+oupn/V2v5k8kZkU/SAgbI9nfA
         vRcOi4TfjWFkhmeQsIZH3L6/BiFbwG6Oivumdk8otPWw5ZbNJcunNe4vnVvq9nfRxubF
         mC5bB4fQ7a4dpTCTfgEmrP7maH+TKrhpL9Kl1UA+ftxPHKFKc5kwnu0lbw3+IzTtTw4E
         asyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794405399; x=1795010199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRF2guphEyqLr1O9h9fq+s+FW78qBgZ0/k6wviHnruU=;
        b=cAzo5x/Z8WEYey8JWEkrkA7Z7rgo3B+JQQobOslLVMCcaqJQLE4ZytlfTxo+5QlsdG
         xZyb5TI15dFjCCQ1hjt1laZuUVJksXxYiw0hTt4gkSAZW5xYh1QrbEnn/wLfDdhExL2V
         tAAhDdEz0d/sqaUdjIByUBMQ4H0Xa8neu1G1tTOSY/Bo0VUvcTh2gj1C773UjqTdBawK
         QgkCJjFjqK/slHNgvjNvt4Xne4XoHAVlzzB6xK4lH3FM3QL5Du1Fmrhy47ksQ2OHCAab
         0RfC60Rw/RG9N5Oc799tg48LemMnd/jF/DUa5kF80NhDaYkBkpwtbOClVpHxXXhBrbv1
         peQQ==
X-Forwarded-Encrypted: i=1; AL+hErFkqbkShwV90cdTsvhaL0DTBClvNQKVdfOWy2HsdBLD4YJk2ADFLO5220SV1liUzoq7/jGUQuUufa3E@vger.kernel.org
X-Gm-Message-State: APuU4Z+/p8NS4qvqpsj11ovDBMqfcMJeZHlsvoISoj6yg5ge13X+KKA5
	zBgE28CGcBPjoGjgmhp7FAY5kS5qo34iQZ9dP4hQr12ZdEQ6K7g6brY7IDglxPT4dybsOL8aj2J
	nofJClQ2Gx35yy3v0ywxEwqkbYteg214=
X-Gm-Gg: AYBFou12DnTEC1BaTP/cuPZmuyEUO8qci3ne/wLarSrCE7dgaGxjbtU3tD0gIIfiVb/
	gc5xntCoq05bnD5OAp+NECd/XPkDgCKv+dkbpcjJnMmpujkR+pegGhnO4ADCZQ6GFYLPUR+m/eM
	uMcglpn76LIDFCdbX8ytavLxeHEJCcI7eY4t8CNiA0wGyJQlRoqrwwcvN3nMS4x2FxUuGUt/6wG
	Q8bKGcAA7yb5ezmUtB7A/smw+PkscjVdiEsxPcXDdNsxIIQOZkqzOPAtkheQwrftY5B/6HFf8fJ
	+fV1laesUld4AoYbRGKwxYPLUMW6NEXLb5cqE62FSGYxARY6kUm2fwWH6uMdyBEG8AaxjqcsUXg
	SvN9J6+p5YcaUaJuUz9xkgFoXIgIotS4WHjgVjSCxKUX3bp12M5XHyjUOPeE=
X-Received: by 2002:a05:600c:3485:b0:4a5:a5ca:de1d with SMTP id
 5b1f17b1804b1-4ba093a9321mr49991515e9.30.1794405398960; Wed, 11 Nov 2026
 05:56:38 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org> <sashiko-outbox-191225@kernel.org>
 <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com> <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
In-Reply-To: <20261110-deformation-knabe-geltung-3bb7600eaead@brauner>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 11 Nov 2026 22:56:21 +0900
X-Gm-Features: AclHuK-kg_k64kD5D3ppXkSngFLDCk2NlJ0a-lNWh9VMpnIyjECtxc1ueGN5wqg
Message-ID: <CAKFNMomUbm3JUBy2GthZwAuFZWh5TSb7i0+g8u1qv1aRviqdaw@mail.gmail.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem errors
To: Christian Brauner <brauner@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Jan Kara <jack@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 6:56=E2=80=AFAM Christian Brauner wrote:
>
> On Wed, Nov 04, 2026 at 02:32:10AM +0900, Ryusuke Konishi wrote:
> > Sashiko's point here has a valid aspect.
> >
> > This inconsistency can be resolved by inserting the following handling
> > logic if sb_emergency_ro(s) is true:
> >
> >        } else if (!ctx->cno) {
> >                 if (nilfs_tree_is_busy(s->s_root)) {
> >                         if (sb_emergency_ro(s)) {
> >                                 if (!(fc->sb_flags & SB_RDONLY)) {
> >                                         err =3D -EROFS;
> >                                         goto failed_super;
> >                                 } else {
> >                                         s->s_flags |=3D SB_RDONLY;
> >                                 }
>
> Meh, I'd not set SB_RDONLY there. Because it changes the read-only state
> outside of reconfigure_super() which is precisely what this series gets
> rid of.
>
> The superblock can be frozen at that point, e.g., when the error hit
> while it was frozen, and then thaw_super() leaves s_writers locked again:
>
>   mount /dev/sda /mnt
>   fsfreeze -f /mnt
>   <error>                       -> sb_set_emergency_ro()
>   mount -o ro /dev/sda /mnt2    -> SB_RDONLY on the frozen superblock
>   fsfreeze -u /mnt              -> s_writers stay locked
>
> It also turns the superblock read-only underneath the existing
> read-write mount without sb_prepare_remount_readonly().
>
> The busy-tree branch does what get_tree_bdev() does for every other
> block device filesystem. A second read-only mount fails with EBUSY and a
> second read-write mount gets the superblock and every write fails with
> EROFS. That's what ext4 does since commit d3476f3dad4a ("ext4: don't set
> SB_RDONLY after filesystem errors").
>
> If we want the second read-only mount to work I think we should do it
> for get_tree_bdev() and nilfs2 alike and treat the emergency state as
> read-only in the comparison without touching s_flags:
>
>         if ((bool)(fc->sb_flags & SB_RDONLY) !=3D
>             (sb_rdonly(s) || sb_emergency_ro(s))) {
>
> But I'd do that on top.

Thanks for the detailed explanation and the concrete scenario with
fsfreeze; that
makes complete sense.

While the "s->s_flags |=3D SB_RDONLY" assignment in my example could simply=
 be
dropped, your approach of treating it directly in the comparison looks bett=
er
as it is more conservative and natural.

I also agree with aligning this secondary mount behavior across get_tree_bd=
ev()
and nilfs2 alike in a separate follow-up series on top.

So, I am completely fine with keeping the current v2 patch as-is for this p=
art.

Thanks,
Ryusuke Konishi
