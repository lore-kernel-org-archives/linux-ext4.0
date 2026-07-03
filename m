Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C082325F994
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 23:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783119751; cv=none; b=bTXVFIclwBbT/UO7Pqis7gQJoTwQPBj62HFZmGTlJaQj+qtgqVZEqn7kG1EoEis8zMoHk++PVLdJXlAnVmOQzRG/5Rws6oVPutwQgL7IJ6M1ZkGfjN9eAiyLtTNrDDWdpLr9MJcvTyL8t/RJiCc/QyWrfBTB224++GAsqqZOV10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783119751; c=relaxed/simple;
	bh=pmVFq7juWqiWKalKPegtn1cc6XIgfH8dh6LifpR6dAI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Mawqg1vTrv1J8ujbJh+9Sk7DwO3xPdnh+DplYkd2nx/0NW87aOZGEG/SKp7ty+ThxvaYzNKt8+hIKe1vLw2LQ7MerbUIGHm3Mnl+Mo1ud+GhGlJWDPQjg3zMiAsDf4T2DlhN4eT60/XHdXcNB4pD0WMXC+0f1IhMe9qQlY/LYFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=yTuCnO1F; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="yTuCnO1F"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-847a483e344so828651b3a.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2026 16:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1783119748; x=1783724548; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vRcrrv13wsfLxqnsWmgQP5FzBGprSMYqiXlNaIQC1w=;
        b=yTuCnO1FPph/KRA2tST6Rk9JMKItDzLOAny+lCXlzdzbKWhLMeBhWWVZ2zqiE9A6zB
         1x6iHTk81ZefJMO6C7ihAsEXS2NAmXz2Cze7thBVmStv5Bb5Iist/wvWXOd0zc0NNDE2
         WebvS6ZpWdrkjEuw3G2ykb09d9f8yrhDh3Q+J3ju1zrsMpEoPkK7CS6qYd0s1vU2CD5a
         OAWfK5GoCUGJpUwROeu2cJBIo/DAHcy6jp0ytW2l47zzR0cs32bRehYkoBeGL2PE5c44
         0ZL5RusTfFbWbMuEboE548An+PB6KaayKV2HxNvH0PNyjWU4lEFd/u3NDF/mF0z9tJT1
         nx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783119748; x=1783724548;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7vRcrrv13wsfLxqnsWmgQP5FzBGprSMYqiXlNaIQC1w=;
        b=H6gNXcUsOIpz8nQlIs2E8P4uohPg6LChXIQdn/S0x56vFZALX8/EcpEwd3bTMRAz9O
         D66K2JE/5ighLH+6W0x+vLJFOebKwzdRt371Yj36NEfiPr7q04DmqIiZ9dK7QCl/HUBv
         Ia8mQVK4eQwAVRwtAykg7eeKe8KLta0ulj3pcPpzFc1cC9U0cAjWfaWyHghjFQSqpM33
         tqmujkkpqVsFG8h4HHJ5HN4aNl0aBHjiMSB/zEBV9YrRlPD0I9tx2hQurd2qd3gGHFkG
         KWHwEezstBWKNApyLkb1uRlzBxZYQdSuxzp/uxqC7m89An6yXXv/VrJsXzYZNB14A0LD
         /8SQ==
X-Forwarded-Encrypted: i=1; AFNElJ8xrNmVGtvquRsfsAGqbKlrza/yaH3k+CUaVxAOWP97lJbs+952AeZf+CON0VtHTnxHneH1euPaP8Zw@vger.kernel.org
X-Gm-Message-State: AOJu0YxNXj+xJbYg9QyTLsHMYfouHJtWif1hipW64tPTJdzZA3oFa6PA
	nFUwCFTT1Pv3G71YSGGd42Ve5ob43xSZVo6l5arQIrWCWAblRHLOHivTrt+2dfzU0uZY3cw3bjY
	aka3SRiWRrg==
X-Gm-Gg: AfdE7clKI02qOygd+8IAAlJycNZmh4Rxo7l/AOYV8ipsrUM9kMqcLZsC6dnxNJROPmO
	1YbcAJRqFsSGI6AsOMRZaP0u70RjStbe7jS6Lh/eiDzP019tIgv0GHHlL3U4gEtN7sHFIDBis27
	539h/PTQD1dvETXB4Qw6t/7uZ2QmJkA67W4gIM8UZvVEYFiUALCD+TipvnnTAUQBrmfkPO0h75L
	UzKuwb2nLg7nO0ad2VjH/6bPcQg13VBR82Yf40b9YXEuR0rty5P8jYLTeJAA+tmyG9QssC1xcf3
	Y7ekdwPZBmPyL5CieHdhEoU5IsWnqzXrv1WAMEKM3sld7+463plKG6qMzDgRh07QFjaCL5wlhv3
	yX+LMVxhmEJd17UorVgt/TLNNnATAY3pRarzkebQ7j0ELYijxA/wMOIr+3QxJ/PHcdOM0r+F87a
	i0+4FPK5HffLAxEr9O1bUXM3lCIL+TxfDNWr/QoMuDAyJOrbExe7J5qpcttmQXpCPtOeP2bSyHh
	lDk
X-Received: by 2002:a05:6a00:3315:b0:842:50fd:4c13 with SMTP id d2e1a72fcca58-847f846d02emr716419b3a.4.1783119747727;
        Fri, 03 Jul 2026 16:02:27 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b9e12csm414161b3a.21.2026.07.03.16.02.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2026 16:02:25 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: security bug reporting: e2fsprogs: Path Traversal and heap
 overflow
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <uzwt2qkkiwa4tzb3wkvx2fgguptmno5wbqmglay5znqvus2qtr@ggkveweeirpa>
Date: Fri, 3 Jul 2026 17:02:14 -0600
Cc: Feng Xue <feng.xue@outlook.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3CF652F5-80B0-4026-8C5B-CF8B55CA1191@dilger.ca>
References: <SY0P300MB0070F750CCF6F2C3A2A91FDE901F2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <9237265C-CB9C-48BD-A77E-25AE61DA8550@dilger.ca>
 <SY0P300MB0070B3B68E4E4FC0C78DE355901C2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <uzwt2qkkiwa4tzb3wkvx2fgguptmno5wbqmglay5znqvus2qtr@ggkveweeirpa>
To: Theodore Tso <tytso@mit.edu>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jun 8, 2026, at 06:54, Theodore Tso <tytso@mit.edu> wrote:
> Andreas, thanks for the the patch.  I had reviewed Feng's security
> report and my assessment had aligned with yours.  I had it on my todo
> list, along with a mental note to make sure that this particular
> corrupted file system would be caught by the kernel's fs/ext4/super.c.

I was looking at my patch again and realized that the test case exposes
another issue in e2fsck.  I saw that the second e2fsck is not actually
fixing this issue, because there is only a single superblock and e2fsck
has no way to know what the right s_blocks_per_group value is:

    e2fsck -yf -N test_filesys f_64kblock/test_img
    ext2fs_open2: The ext2 superblock is corrupt
    e2fsck: Superblock invalid, trying backup blocks...
    e2fsck: The ext2 superblock is corrupt while trying to open test.img
    e2fsck: Trying to load superblock despite errors...
    ext2fs_open2: The ext2 superblock is corrupt

so I changed the test case to create a larger test filesystem with two
block groups to confirm that e2fsck will fix the broken superblock:

    mke2fs -F -o Linux -b 65536 -g 262144 -I 16384 -N 24 test.img 300000
    Creating filesystem with 300000 64k blocks and 40 inodes
    Superblock backups stored on blocks:          65528, 196584

but this shows that e2fsck still cannot fix the issue:

    e2fsck -yf -N test_filesys f_64kblock/test_img
    ext2fs_open2: The ext2 superblock is corrupt
    e2fsck: Superblock invalid, trying backup blocks...
    e2fsck: The ext2 superblock is corrupt while trying to open test.img
    e2fsck: Trying to load superblock despite errors...
    ext2fs_open2: The ext2 superblock is corrupt

It looks like this is because the "trying backup blocks" is does not =
handle
large blocksizes properly.  get_backup_sb() is using (blocksize * 8) but =
not
limiting it to 65528 blocks as required by EXT2_MAX_BLOCKS_PER_GROUP().

Revised patch forthcoming.

Cheers, Andreas



>> For the debugfs, yes it is not what people would run on a daily
>> basis. it turns interesting in scenarios like incident response and
>> forensic, so yes it depends on the ROI and definitely your call to
>> whether it should be fixed.
>=20
> The debugfs concern (as well as another related one) has already been
> reported on github[1][2].
>=20
> [1] https://github.com/tytso/e2fsprogs/issues/272
> [2] https://github.com/tytso/e2fsprogs/issues/273
>=20
> It "should" be fixed, but I'm quite busy these days, and part of it is
> many kernel developers needing to react to the large number of
> LLM-reported security bugs[3][4][5].  And so we have to prioritize the
> order in which we address security or other bug fix reports.
>=20
> [3] https://lwn.net/Articles/1063303/
> [4] =
https://www.tomshardware.com/software/linux/linus-torvalds-says-ai-bug-rep=
orts-have-made-the-linux-security-mailing-list-almost-entirely-unmanageabl=
e
> [5] https://medium.com/@tridge60/rsync-and-outrage-d9849599e5a0
>=20
> I do appreciate that your report included a suggested fix.  The thing
> that would make it even *more* useful (and gain you an a win of a
> patch landed in e2fsprogs or the Linux kernel :-) would be if the
> report came with an formal patch submission.  If you send it using the
> git send-email (and see the Linux kernel's instructions for how to
> submit changes[6]), to any mailing list at linux-*@vger.kernel.org,
> including linux-ext4@vger.kernel.org, the Linux kernel changes will
> get automatically get reviewed by an LLM agent, Sashiko[7].
>=20
> [6] =
https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> [7] https://lwn.net/Articles/1063303/
>=20
> For bonus points, if your AI agent can also create a regression test
> much like how Andreas's patch, that would be great.  And if we can
> collaborate on a skills.md that can teach AI agent how to create
> reports that are easier for Linux developers to consume, and perhaps
> to even create patches that require much less work on Linux developers
> (or which Linux developers can use themselves), that would be really
> exciting.  Yeah, that could result in a certain amount of LLM fear and
> yourage as with rsync[5], but we have that with the Linux kernel
> already.  :-)
>=20
> Cheers,
>=20
> - Ted


Cheers, Andreas





