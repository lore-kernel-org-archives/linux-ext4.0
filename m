Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EF0224B05
	for <linux-ext4@vger.kernel.org>; Sat, 16 May 2026 06:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778913821; cv=pass; b=gL1NgJe/0QCfVPIN6xzg0uRNGgpcRWazlAxfBO8HLlsgqO2LPh31VnKys9cJ07zyKEj1uDa57dmZQP75xdcw6D5dONlKZmf/dG1Qpq0vXQQUTEU3S9OzLrn+A8+ucHjSZPjeuQbtCt9bVHuimoyZIQ9ZBJX/M4sMDkzBqlJ7+vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778913821; c=relaxed/simple;
	bh=BOu7AkGfzBlU/bzal5lpBXqw/o4zx+y8OCCvr0FI1sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z1arXFUwPUjb9kRyZYFqhLrYJcTkWqOjfPVXwVuJCHl/+dNSaVEzZ2EhinddvbJCt1QaFUbF9pjORyniIoC8sB3ZKNXeIffO+RmDQ2YaAavSSAbggS9nVyAuUUDDaCqOMvpP0tybf39tZK1XDXGmqNr6vPnqrXDEyLQRwKIQYIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lte6xRJp; arc=pass smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lte6xRJp"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-47c6f914617so307771b6e.1
        for <linux-ext4@vger.kernel.org>; Fri, 15 May 2026 23:43:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778913819; cv=none;
        d=google.com; s=arc-20240605;
        b=j7UwN3z1Xisot9orj/w9bKofpax8AoAzTMzJGOPSuDipXy1/cjHyna1n2Ggzwlwzdv
         IbQkaNxa0Jrn5U1gGLb3HSzQaUVpUh7lkJgNm1XgI4HoM5EdKvw1qyMy6eKJhSlTz+TV
         8hrHXCrbsRmWd45QqX1LEYpvzQ2t56Hu+HXMSqZcjCYik4bCid9fQRk4sGc7K5flQvdu
         sYsNdH7URHDEb+8qs0TeYAgkWezQDnQVDgUqXx5idqqhfC7lBmStloK4QGH56Rp6rcc/
         Ydk8bVAQcnW7dM9oKOPTAXS+8ZIe6VbM4Vco0YiXZ8OI5TcoZ16s9wpsP7cCRioNW81G
         FY5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        fh=Qbg1/w4PeC6GDfvKhE45g9kwK6hxIIbWqWCskJyX080=;
        b=WMdQAeG0pCRY+U5foqTw1tMcgpwZzylBtAG066BJ0qyLN7s1Q9OiHTuNzKKExgx03P
         GPHwlsHM++5r/t2lcH+1VGTgbjayqW7RJ8joOGcX3IftTP/awUjdO7wCl0/IFQi9VVIS
         vKQWWCpQDMou4oMSttx1kgKOinss2Qj11xUw/XuuX4wk5r7MjjR6xE0GoeuW34QDw4V2
         9PEnvIEwTtcAWXv+XwnGC4d4f9EmOAjxJZP8Ha+FYtkd7Cvs9JGji+DX+6DiozUfLgyk
         LQdv1E612Q+9ilVAes+mbX37Qo2vMUkXTeqooO0ZCBWg6/k5rCbznEwaBchnEzaU7+1r
         1wkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778913819; x=1779518619; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        b=lte6xRJplRGmp/PSskcPRMRcmRHxp/3AN6A1XynLI6uXZlluhAn8u2h7mZQg7APZLK
         oAbu6jVFzk3P9a62b4PsoqoTNSJkE7FzjLFpOPv5Z+lsxgwuhtlVTrcbfv9MbnmVX5Py
         k/kzYjGMlhm8+gRGJfuzaDpFjgrS5WI83cFpH15WHsjn/iy/5C/Ve0iDz9Octg/QEDrA
         DhdqK6z9WrgQK213b5HL2plz3FNcI+orhuzLw1gTevyVgHFRj7CbGxDhPlje1LF0RZp7
         KU79gd97VCPt1LjtMq72jZt/AsJhd9asWIZ2PtbrgPLo+/sBoYkMDD8j7+KHYkro1zzO
         kN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778913819; x=1779518619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mxy2GpAHGinIR1PnXVMvug0ztGXvMspUp7huk1TMZs=;
        b=K3hIL5HTxlFznecPrA/ZSaK9trQCDQ2e7Nek5xjNsG0/Ab5VEMM2tixbD5gIBP1iW9
         t+Aehpem6mdcEc/+tLekjVEZb+5kWx091kLXsbnZOE5Wc/IzMOkJjvJDok1//AUVdGzx
         UF+YiXNsNNXoUban8j9J35MIgValud9AN48CQoiXfbB1au+621cdX2n/8ay6KYkxSfMr
         fl5IYihnIp8u1JieRkVI8/Lo7mGXOyChJIYNgJrM1vPdBOuhaoL2BRKGPIEmoEZW32Ir
         2adtCeXyYIs2jmIx0Wj2fr+3w8Kte7zGCY5FQoar7D+wxJWa4QVTsmvMO/thSwsI1V/g
         /WCw==
X-Forwarded-Encrypted: i=1; AFNElJ8ScEQucFIAeBt+8mvuWqvcZDiy+fjIH+U5xnGYND8qJ3QlZ75Go6MLbV4bKaln2Zm0YnDljZXqMsF/@vger.kernel.org
X-Gm-Message-State: AOJu0YwF7s6CXRGgvd3vT1NOlFDsm/3Z70tggDm62haPEr1gODXbVVSV
	Igah25vgGnSsT61IzVMLG/Y8GFSE+P2OOFZKCfpxhdjMmFegDfilq2mkPbprAfKRcLm3aT66dPW
	DerHnpnozzvsTgdgPI7pP2VPs41mkzWI=
X-Gm-Gg: Acq92OHAKyT8k73LGk6AboY2YMQbgBrovyQAy4pUBXI5OOtnYnVEMWmcFuJhpCXyXRQ
	obTXYEim2eZ0L2K2f0IF1cX1dTkHe+a9uUFMxKS7Vbgjpa3vBvARgfQ2OaTibLwBsLvqfpCgBQx
	pbj3emGRLUgjaJsjGEyHdN5q1h3aIvASoSMqwamSREObR4MFLwrz2ReoPiWP/YmnYsLMAgEuJ+R
	bW8y3fI76AV7a1CzXizTr0uBqid/m9t/MxmveQ0oCILS9uaN/BRfoSX6OwlJFi/3eoMi+u63Dyh
	3lpI+hlyhKxOQoPCHA==
X-Received: by 2002:a54:4e88:0:b0:46c:e542:cc3e with SMTP id
 5614622812f47-482e55e65a9mr3386045b6e.6.1778913818672; Fri, 15 May 2026
 23:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507-case-sensitivity-v14-0-e62cc8200435@oracle.com> <20260511-wertverlust-vorbringen-070f016f3bd4@brauner>
In-Reply-To: <20260511-wertverlust-vorbringen-070f016f3bd4@brauner>
From: Cedric Blancher <cedric.blancher@gmail.com>
Date: Sat, 16 May 2026 08:43:00 +0200
X-Gm-Features: AVHnY4LulXSgBXmlt-XknhPT4FGQR5_lEWwUy9GN7jO6BYSv7kvOdT0vcpcWCyI
Message-ID: <CALXu0UdsurG-ayuYViqs0HXOfgyDw8gpNC+f=5y59cuuSPUbBA@mail.gmail.com>
Subject: Re: [PATCH v14 00/15] Exposing case folding behavior
To: Christian Brauner <brauner@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	hirofumi@mail.parknet.co.jp, linkinjeon@kernel.org, sj1557.seo@samsung.com, 
	yuezhang.mo@sony.com, almaz.alexandrovich@paragon-software.com, 
	slava@dubeyko.com, glaubitz@physik.fu-berlin.de, frank.li@vivo.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
	hansg@kernel.org, senozhatsky@chromium.org, 
	"Darrick J. Wong" <djwong@kernel.org>, Roland Mainz <roland.mainz@nrubsig.org>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 May 2026 at 16:11, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, 07 May 2026 04:52:53 -0400, Chuck Lever wrote:
> > Christian, let's lock this one in. I will post subsequent changes
> > as delta patches.
> >
> > Following on from:
> >
> > https://lore.kernel.org/linux-nfs/20251021-zypressen-bazillus-545a44af57fd@brauner/T/#m0ba197d75b7921d994cf284f3cef3a62abb11aaa
> >
> > [...]
>
> Applied to the vfs-7.2.exportfs branch of the vfs/vfs.git tree.
> Patches in the vfs-7.2.exportfs branch should appear in linux-next soon.

@Chuck Lever Thank you!

Does that mean the support for case-insensitive filesystems will work
with Linux 7.2?

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
[https://plus.google.com/u/0/+CedricBlancher/]
Institute Pasteur
