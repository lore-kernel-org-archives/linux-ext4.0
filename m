Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E1D33FE0F
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 20:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783110418; cv=none; b=OnwsZRgXmscpYqMjDTnucupKg5kkHauyfPdRbpTokfwXkymHNFY0C5eNXSV3uRzYKPze9lqR0lv63WtzGws8rRFQ1nZryNVKMaA4+puo/G/fJobNErowi145EJIeabKAlUxUiKjPnFhAF7b9XsCbuwaUYUUFFZcxJfKjvsxPN4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783110418; c=relaxed/simple;
	bh=iXBZJ8L+mG98bU84N49mbNQPOGrIxjux/quY7diSetA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LZU8G48735m+7kGxfA3TofAYk6eKm92DXFaYED2vH9O8lR1VZxkCfSETfAupvFSV4Yss8MNyXvZnxR7es7W/kEusrlucrNEhlBONTUlbYo7xlPN5ZCId02KcA2H3p8Km1RrI/QgvnqzXPlbIQKcuwM3xkhO4uIiuTD4Lhu9bSsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=ZmYCq0oH; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="ZmYCq0oH"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84783bce476so655206b3a.0
        for <linux-ext4@vger.kernel.org>; Fri, 03 Jul 2026 13:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1783110415; x=1783715215; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ygT21xtxbgY2EF3lI1wZfyPOslZuu5UzD03uiCP1+c=;
        b=ZmYCq0oHdXyYyHCM276lhpJFSnrvzQXClhzCpYgD3Xx2wNiipEJcJRELLy9f5NZSWh
         a0QwsyO2kKsNXypxZTLMhel+3yC6QK+/XJPrb87+KnvJfqAcm4E/gsXAwKZE20lgOLVL
         cfjfu0Iybk4OoMSoQdSWKg+PQ7taJYNSZKy36vLJvVobv2AVDeoMjjmpFrb+9wL1ysWa
         ihRwfgUd8VsnkiCMCnipcSov1JhJFvrSgYTwL857rGzfc9GLNngyrJSVPCmeMqfHlT37
         GBbB7SeAEFiniFNRiLLi2OMCnZ1USEgmK43vM4S1jpCxGYu6TEh1N7p/2znoee3MLqaq
         229g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783110415; x=1783715215;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ygT21xtxbgY2EF3lI1wZfyPOslZuu5UzD03uiCP1+c=;
        b=n9P3hhyOcLkMC5z5gUFeq450q8rRxQvFnRXUFJ6NRV3NB0BtCQyQoKkLjhOv/XNlMz
         e2VBIb8acGJaXfYcArH7TsRirqXIMS4qpX4CAESOKqSshXY3Cy+nruIUoKW6vYxg/xW4
         7+4T3eoD1G6mEUyXSqDxzgxPsrSHMHsz4KYUrBXLgUHlxyiz8KCNAMYgYpshcgDXNTn7
         YPmGPALQxg3ceGzlIdHTMqhn08DHce8B9drTlWGbH4drEolfdrdXn4l3YAftjo+LgkWN
         nq/afchnNnKnq+sVx9jywnZ/kjI7freX+okb+3NU1xLFu+L+1Lt7ku1RPcSm7xmXi6IB
         QFYQ==
X-Forwarded-Encrypted: i=1; AFNElJ8F/wZh/gDuLGrYENZ7uvaVhVZxl46uoay3IqlyZx1wMC0ORESctak/rQRWba0lgzhQ6pDBUH6/BZWc@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6lWWykPXqVfSIk5QHzCXuKkQ+PEqum21dw3jX+GY7sAyuFgXs
	cjFBN+U37gQYq9QWeHFw+Zwv1jp0uPBxMzE3lQ/t8gCzzn8ucMBgE6Pp5dWGmGOEgk4=
X-Gm-Gg: AfdE7cldrTbngyng7kmK9MnB5kgN2uvbi9Kg492D7pz+e793rB0Gd/4Oh/jHX+mdXHc
	1NLXfY3b0VKhemJzGd2XhG0WdFGMUe+u0L265dVqE4o74VS8QamiFSyjH9E4aAxZ62bnkAjCMmG
	ASAT97QjPVvZlyEry545bZWv/MTCqlznwDUB7besNQfHk4JK9qkgr3lg18UGSGT5ZSwC7PdQNEG
	mxyzeh2oR42FIKp8Jlywwb1yUOGCbWsLttTZhi/georrzi4TjxsVgDFCkBAOPNjDX4BoBlycxrf
	pLdb8WB32CB5WtyJ7d7OP1da6PPa+crreQ45noPWcyfxRNY0TD21ru4QzfJDtvAkgFwzZFk1WVi
	KLPogtL938ACjznoXrT2qPOvbean2rgXPiDSASKLgjgr5QSMmJJUqwQKws5d54V8cV7x1yk3DDs
	1H0782d9vH4fy1hs3Yv3FW0rjEYBO/J59CnEcw7pskOF2spCYvm6VPdA/TAP143ZVATg==
X-Received: by 2002:a05:6a00:4b42:b0:845:d286:1fab with SMTP id d2e1a72fcca58-847f6fb84f6mr769395b3a.58.1783110415141;
        Fri, 03 Jul 2026 13:26:55 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d44d48sm291058b3a.39.2026.07.03.13.26.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jul 2026 13:26:54 -0700 (PDT)
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
In-Reply-To: <SY0P300MB007035C26C7FE1FB71AA5D6D90F52@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
Date: Fri, 3 Jul 2026 14:26:42 -0600
Cc: Theodore Tso <tytso@mit.edu>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D42C0FBC-62CB-4D0C-ABAA-048F32EFA146@dilger.ca>
References: <SY0P300MB0070F750CCF6F2C3A2A91FDE901F2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <9237265C-CB9C-48BD-A77E-25AE61DA8550@dilger.ca>
 <SY0P300MB0070B3B68E4E4FC0C78DE355901C2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <uzwt2qkkiwa4tzb3wkvx2fgguptmno5wbqmglay5znqvus2qtr@ggkveweeirpa>
 <SY0P300MB00700D68702900941BDE4F7E901C2@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
 <SY0P300MB007035C26C7FE1FB71AA5D6D90F52@SY0P300MB0070.AUSP300.PROD.OUTLOOK.COM>
To: Feng Xue <feng.xue@outlook.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Jul 1, 2026, at 18:30, Feng Xue <feng.xue@outlook.com> wrote:
>=20
> Hi Theodore,
>=20
> I haven't heard back from you since the 8th.
> Please let me know what is the best way to move forward.

Hi Feng,
I thought Ted explained in his email that the debugfs issue
should be fixed with a patch emailed to the list, which includes
a tests/d_* regression test that confirms the issue is fixed
(test should fail before the patch, and pass after the patch).

The patch should preferably plain text in the body of the email,
but as an attachment is also acceptable if your email client
cannot send the patch without corrupting the whitespace.

Cheers, Andreas

> Best,
> Feng
>=20
> From: Feng Xue <feng.xue@outlook.com>
> Sent: Monday, June 8, 2026 3:48 PM
> To: Theodore Tso <tytso@mit.edu>
> Cc: Andreas Dilger <adilger@dilger.ca>; linux-ext4@vger.kernel.org =
<linux-ext4@vger.kernel.org>
> Subject: Re: security bug reporting: e2fsprogs: Path Traversal and =
heap overflow
>  Thanks Ted!
>=20
> This is really my first oppotunity to submit a linux patch.=20
>=20
> I am not sure what is the best way to do it, my AI told me that I =
shoud just email the patch as a plain-text attachment (or inline) to:
>=20
> To: tytso@mit.edu
> CC: linux-ext4@vger.kernel.org
> Subject: [PATCH e2fsprogs] libext2fs: fix integer overflow in =
inode_blocks_per_group computation
> Body:.patch file
>=20
> I will shoot if that's the right way.
>=20
> Best,
> FengFrom: Theodore Tso <tytso@mit.edu>
> Sent: Monday, June 8, 2026 12:54 PM
> To: Feng Xue <feng.xue@outlook.com>
> Cc: Andreas Dilger <adilger@dilger.ca>; linux-ext4@vger.kernel.org =
<linux-ext4@vger.kernel.org>
> Subject: Re: security bug reporting: e2fsprogs: Path Traversal and =
heap overflow
>  On Mon, Jun 08, 2026 at 10:18:38AM +0000, Feng Xue wrote:
> > Hi Andres,
> >=20
> > Thanks for the quick turn around.
> > Agree with you on the inode one.
>=20
> Anreas, thanks for the the patch.  I had reviewed Feng's security
> report and my assessment had aligned with yours.  I had it on my todo
> list, along with a mental note to make sure that this particular
> corrupted file system would be caught by the kernel's fs/ext4/super.c.
>=20
> > For the debugfs, yes it is not what people would run on a daily
> > basis. it turns interesting in scenarios like incident response and
> > forensic, so yes it depends on the ROI and definitely your call to
> > whether it should be fixed.
>=20
> The debugfs concern (as well as another related one) has already been
> reported on github[1][2].
>=20
> [1] =
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithub=
.com%2Ftytso%2Fe2fsprogs%2Fissues%2F272&data=3D05%7C02%7C%7C60a6bb8e8d8b49=
0abcdb08dec55d5000%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C6391652017=
28676605%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwM=
CIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3Dm=
zLQOqoj5D4v5qwUTXnRSBJn%2Bx7LroNXlCgYmjFklgI%3D&reserved=3D0
> [2] =
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithub=
.com%2Ftytso%2Fe2fsprogs%2Fissues%2F273&data=3D05%7C02%7C%7C60a6bb8e8d8b49=
0abcdb08dec55d5000%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C6391652017=
28746474%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwM=
CIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DK=
eWTYEjXVk0WBCeMQG0t%2F3YroLFHCGZ90rhI6VBE8k0%3D&reserved=3D0
>=20
> It "should" be fixed, but I'm quite busy these days, and part of it is
> many kernel developers needing to react to the large number of
> LLM-reported security bugs[3][4][5].  And so we have to prioritize the
> order in which we address security or other bug fix reports.
>=20
> [3] =
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flwn.ne=
t%2FArticles%2F1063303%2F&data=3D05%7C02%7C%7C60a6bb8e8d8b490abcdb08dec55d=
5000%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C639165201728803442%7CUnk=
nown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4=
zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DatKoeWdjGy%2FcW=
IteAhtQmbIwucrkPJGKDQIIlCzErJI%3D&reserved=3D0
> [4] =
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.to=
mshardware.com%2Fsoftware%2Flinux%2Flinus-torvalds-says-ai-bug-reports-hav=
e-made-the-linux-security-mailing-list-almost-entirely-unmanageable&data=3D=
05%7C02%7C%7C60a6bb8e8d8b490abcdb08dec55d5000%7C84df9e7fe9f640afb435aaaaaa=
aaaaaa%7C1%7C0%7C639165201728857735%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcG=
kiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3=
D%3D%7C0%7C%7C%7C&sdata=3DQnLI%2B1k%2FaYkI%2FR1h3OODzjF2eHo1u7W1Vza2sbKgMP=
E%3D&reserved=3D0
> [5] =
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fmedium=
.com%2F%40tridge60%2Frsync-and-outrage-d9849599e5a0&data=3D05%7C02%7C%7C60=
a6bb8e8d8b490abcdb08dec55d5000%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%=
7C639165201728892950%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiO=
iIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%=
7C&sdata=3D7BhfNoqi1vL5MOtChccYkO3jmNsIqDk1e64VOJIfHdE%3D&reserved=3D0
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
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.ke=
rnel.org%2Fdoc%2Fhtml%2Flatest%2Fprocess%2Fsubmitting-patches.html&data=3D=
05%7C02%7C%7C60a6bb8e8d8b490abcdb08dec55d5000%7C84df9e7fe9f640afb435aaaaaa=
aaaaaa%7C1%7C0%7C639165201728921079%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcG=
kiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3=
D%3D%7C0%7C%7C%7C&sdata=3DnjldA9H7oUOGBeymFrVB%2BqoZ5qaOp8X1bMwdBPQCznE%3D=
&reserved=3D0
> [7] =
https://aus01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flwn.ne=
t%2FArticles%2F1063303%2F&data=3D05%7C02%7C%7C60a6bb8e8d8b490abcdb08dec55d=
5000%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C639165201728942831%7CUnk=
nown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4=
zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DoEGoMXgNXGBSIeb=
JW%2FqzyOW%2BxFB1kxCFNhWOphPutQU%3D&reserved=3D0
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
>                                                 - Ted



Cheers, Andreas





