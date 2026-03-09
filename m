Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED019E97B
	for <linux-ext4@vger.kernel.org>; Mon,  9 Mar 2026 10:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773051960; cv=pass; b=IWdUVj+zaRuWbDiiw4RzOOjEXC5h5WHLdnevC1Xuc3k9WKRSDIXzWB1vuxYJYTTWehoArWOA411pnFIkJGUmOWrOYcU/EVoImRVNEO9HOGdLZ/JwH35fPzw0jHKmVmCufFvEGkWS4GejnYlMvMtskB6DKmjfY1DIQONJnR8kab4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773051960; c=relaxed/simple;
	bh=XlET0r0ILlBLsgrzWfDF/IrYSTzOj8AjpzWUoFItNZ4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RhGb+xizc2PE3/3MM3up9RCeVnF4QTB6PUBv8gWk/kVra8r0QE9ZkhIta9Vk2mqTrzSQc6hkuqerEDsQ4h18M79kh8KwD2rj8WdbwSty8MeEIW773DhLiSFfwF+ThsY1GmgXHiOFps2Woh5vlGiSeFwxuIx9Fgq8rwh2fSk9+sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPoOdWvE; arc=pass smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPoOdWvE"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5fff18d44fbso1788383137.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 Mar 2026 03:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773051958; cv=none;
        d=google.com; s=arc-20240605;
        b=EIaUyHv7/4cF9uGlNldp5X16f+ZpI6q6oJohi+uE/PQp+Br5DDn2kNYybfD3WRDobe
         KxgexJSqrGwlfoIlJk1rGd+dKiUaXKFlsT7A1G5LZyeNMPhd6OO/C76K9kGeLXnVqUqt
         h1CTUeupKxDnLhPNhbWId60/J7KgWdyTiT+PBtQyzzsSs8hw2YmB/r36mkPRUM1odrZQ
         CVrhLlwDB6hT2HllEgzInBr0Wl3go2boG+TZxKTBb7tfR6Jl64ziRgAj+wdpwrhdAncP
         +TsJYHBbIimXg9Gc3VXGoLdLsUWtSCF92dFTIPQcZPDuEFirLAdawNajGego23Or/hCT
         zlPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=XlET0r0ILlBLsgrzWfDF/IrYSTzOj8AjpzWUoFItNZ4=;
        fh=Czcxc9mpJn8xF4Ev9QINohC1qFtO92BMAsgQPPNBK6A=;
        b=d87HN9gNZwjK6dSWHoLJWs5Gp4tqs3tigTi4Ws+SACFSZIlhXFd0241rh0AJYJ3pwU
         CGr8qkdGco06sTgN80flXPFz+Bb0mukSRvm2fpbo01SPIUKc27uz2B4zfdulfyxdVsZ/
         2MLG4LAgok8Ud0kk1OKxKDlT/s6NZA0B4m5dq81Wkpe/gFaeCYG0C6A/MznsCiKQiXBB
         ZcxX/XfQ3ek9C+FHvG8sb18YhcUmDIvk6vNGqFFjX19M9TyMBUz9LDHnvWDu0uKCbgO/
         fnuzRsRUyik2Vb9RWbT/Qbfnio//RUP5Kg+WJExjG5lSvmcgeRuhnvIma+A8cDsGqX8u
         oVfQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773051958; x=1773656758; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XlET0r0ILlBLsgrzWfDF/IrYSTzOj8AjpzWUoFItNZ4=;
        b=gPoOdWvE+tOihIBK8rPvHAABZ7ijtPJqQWtQgmsjFj2jVR7ewOUo3e8VIqMnrueKsO
         2t2zIA6G2CyJN9XvFuHeUyNKletIJ1jwMYDjf4U0Vvb1wKNgHQFgw8bQWC2m5HVRVhtl
         cmeOE8BnNqNxLNWQjEH7C4TcSMQoqXhZ7NtWe8b4xHSnLGynBbnmeHPF2ti4QQOKQJ24
         8EO6iYZxSVirJcXqEkHWZWJUNjEItmFxLic2NvgVy6YE0pxA5/GwL7zeeL6J+cIqjNgh
         +aYqSmTO+2R5pP6Z4Y7zWARfVBl9c0w1UTLx/uWJZko151g7XGTIc+pKZLmifdSjGgGw
         Mm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773051958; x=1773656758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XlET0r0ILlBLsgrzWfDF/IrYSTzOj8AjpzWUoFItNZ4=;
        b=sYdvlL6AImy+0lRgRjgYS47Uem5bTtW4h1fY6dXI/GfDKG7Zl5+t/ya2eHz1eENPiA
         RnE9ql8ZTxG3AC5XjkLIIVaQywq3swtNnrC3T6khV+27RVDMhjq30gcGfw++LtbzCall
         VCC+mN2HGWvuTQW0dhHuHv1X4QW6ID0fdohMJcAZJAJho5uLAvm8LIewSTGJnu3MsF7h
         TLePwoJVSlipDqEiYfq5ncrw2A4WJQlFl4ld/rqiMt1BrfA1BP9fuF/2ekDEtUKY0Or+
         Lbce9o7iRLAS45Q239XLW2Cs9mMxA3RNy7Sf3mqo6AML1c+xB3DdRxNIUKgvUqwxTgKE
         01uA==
X-Forwarded-Encrypted: i=1; AJvYcCUaPfEouaf+B7hsfFMopYiccd5Vd/dDDKcSvslmvSGntftKcsTR7Bd8rFRvH/dE8yYVJXm/lbsuqUR8@vger.kernel.org
X-Gm-Message-State: AOJu0YwoMF/+tqUJBZAkRrNkutR1AW62Y9QjTYrJbVr1nZu5t0i/PnXE
	fWHTkxwsSxCu6ImlGGFD3GkWO4hEwysbgLxpibkHz73I6UQt3xNAACsxv+jEDJ9YnTKFYu/ZKGc
	FnZ3XhtJzbm9mIqVw7r/lyJZJxpttriQ=
X-Gm-Gg: ATEYQzyB563GhBfRiDngORoQZkn6TO7qIwrXJ4wlkAb032Vyt/SYHM/dj2d37v74UiG
	P7i672XLN1Nn6zE7iC8I+Nk2bswUFMRwmXkYAK8nOA4gK79/+uDYq7NBd0lbDXCA2UmRbxtwPbb
	6Zt4xg7/N4HtAmxufZoLJ0hTkZEJGmXKdjvE1NExXk09B3705RLHcZiaEDey1+vURsvlKELeBsJ
	XbfiJY7PErWb4ET45AGJmi8/4h/vqRAKGaAqJLR1BORGLzcqqxYPi7Pyb43DfDFwacKALtbnFeG
	5nmOBaNcAbkXPHAGYL2bJTM7fm2XxwCvnV46D0g=
X-Received: by 2002:a05:6102:c53:b0:5f8:d3b4:9517 with SMTP id
 ada2fe7eead31-5ffe5b7c5bamr4246079137.0.1773051958273; Mon, 09 Mar 2026
 03:25:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xianying Wang <wangxianying546@gmail.com>
Date: Mon, 9 Mar 2026 18:25:47 +0800
X-Gm-Features: AaiRm51Qhy_lyxKIEOF8UxcBhhI3Jz4Lf5Xlrod6LxZXW0eAq0ycheVB_1aLj1Q
Message-ID: <CAOU40uAEtabRYb8xdqvbFkLYNVfbbjQp3q9J4gO-emTsgb_rtA@mail.gmail.com>
Subject: [BUG] WARNING: lib/ratelimit.c:LINE at ___ratelimit, CPU: kworker/u16:NUM/NUM
To: tytso@mit.edu
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I encountered the following warning while testing Linux kernel
v7.0-rc2 with syzkaller.

The kernel reports a warning in lib/ratelimit.c triggered from the
quota release workqueue:

WARNING: lib/ratelimit.c at ___ratelimit

Workqueue: quota_events_unbound quota_release_workfn

Before the warning occurs, the filesystem reports several EXT4 errors
indicating that the file system metadata is already corrupted. In
particular, ext4 detects that allocated blocks overlap with filesystem
metadata and subsequently forces the filesystem to unmount. After
that, during the quota cleanup phase, the kernel reports a cycle in
the quota tree and attempts to release dquot structures through the
quota release workqueue.

The call chain indicates that the warning is triggered during the
quota cleanup path:

quota_release_workfn =E2=86=92 ext4_release_dquot =E2=86=92 dquot_release =
=E2=86=92
qtree_release_dquot =E2=86=92 qtree_delete_dquot =E2=86=92 remove_tree =E2=
=86=92 __quota_error
=E2=86=92 ___ratelimit

During this error reporting process, ___ratelimit() receives invalid
parameters (e.g., a negative interval), which triggers the warning
about an uninitialized or corrupted ratelimit_state structure.

From the observed behavior, the warning appears to be a secondary
symptom triggered while handling a corrupted filesystem and quota
tree. The initial corruption is detected by ext4 during block
allocation checks, and the subsequent quota cleanup path exposes the
ratelimit warning while reporting quota errors.

This can be reproduced on:

HEAD commit:

11439c4635edd669ae435eec308f4ab8a0804808

report: https://pastebin.com/raw/yJp9p1dM

console output : https://pastebin.com/raw/tyPquTTH

kernel config : https://pastebin.com/7hk2cU0G

C reproducer :https://pastebin.com/raw/Sh3a62JM

Let me know if you need more details or testing.

Best regards,

Xianying
