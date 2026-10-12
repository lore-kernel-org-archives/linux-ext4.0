Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75C7490C0A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816641; cv=pass; b=QA7blpnHSDKDR8LvBBSzxPielI4JKUUkKhjbC377YIsl5CBcb2NchA2VxIw/iruSa9MeJBKmaZ57QNcVmvVYm6KmbJEeDKZs0s5maW8c51FINGXfhSbCnMqQBe/Ol1PjsuS5GNe4kI6fgIN6E5vGXAwTlfmcKagWZgJIxMIKJQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816641; c=relaxed/simple;
	bh=mk5C4xIpedNzFRA/ZjacwHFWwKYAtfbpdgBn2XfCb40=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tIxChho9szvYtH+qBpurzbrZYh6h5GthfcG9DwOvsql3kJLiRh/FLrdvWvJV3jDJZ+c5rdJT4wYD8/7WEaMBRagW/Av6H4NwuTSUaEMtx7J45xZBr3EyLZDTZu0ugFi1C7/mJ39i3WkPV5Wdpk8tU+t4qdZqCwGNDX8YsJSxvYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rzspzEZ9; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rzspzEZ9"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-7c3b6e8225dso1205834137.2
        for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 07:50:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791816639; cv=none;
        d=google.com; s=arc-20260327;
        b=A21hDhSub5lGYNie53SS4Fv1h3YD3sD8GQQ9ZLpz0CLAKyUhHHPR9+s7jbBlbTFaRx
         SBIIMKb5LiBnmgU6sU6lizupMAcZAFzEisdO7zOjWimUAcqugQRQSfR9AaEV0+y2esZe
         YOH8ozsG6CE4sJZyDG5jrfPqdOaBoKnmRB0PbqGZwSI6E6O62Ad9FD4iPbkpd7uf711W
         1/RpvYY4/Ya0lSEBJZUmJXactnbDWfU55dtaWfhWYl0tvS7ST/Qy2vyO4rIzTSVC8lt/
         Z7s9wcs65CNs9oajg2B2TRaueBtu8DzSRT8yrXpaYzYkv9Umps3TDJnGCnszhF9cIQSD
         G2JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=mk5C4xIpedNzFRA/ZjacwHFWwKYAtfbpdgBn2XfCb40=;
        fh=+qPamVkmnUHPU1gHRdGT8A65fn/ulYKxvpShiZX08tY=;
        b=Yx1lGZ9itWcOEljFfOrgZy7pj5dKnEzuiXsWeeGem3Tnj6TokeA/MesLmJaO1T0N85
         rEPx3cUarP9C9nxYTxQzcgcrGz4/rBIzw3FZVo9n1uRp6fNlMMiwP3+3I+c1OZQ6M4qw
         nvpj7jX6izMYQqMlJ6Ry/wCe7P8GWq9aHIqUq3t3g0BnuKhGkcIZzXxYy+FX1ybQ8seu
         WLNFILuG4qElJ8jR1htcBBp9kLxFOW2nEovlzNdVnT8JiDG4fTmBlARYJpiOAwJr0eKS
         Wd3zLT91XVAAKPYeEgRnh2M+eDcwIcKLDU1mf9tYO9AiCV8di8BDXr2Fh2sMHRHYWCYL
         0XPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791816639; x=1792421439; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mk5C4xIpedNzFRA/ZjacwHFWwKYAtfbpdgBn2XfCb40=;
        b=rzspzEZ9KWggKmxYiW7XAj4DcXQnt6EqHJKKxigWCt/7J1z5DQEA0y9yeaFmYv1+Ne
         AdVMT+U++rbTgu4dsHaixGfiJ3ynuFK9BKkjwo/67dZop9kZ9NwzIQw/cPLBU4ePDnOl
         2LnGYDiLUTx+7LXQ9iKStbcBxGjslsi2oUxDgz/lYiZzQ6xu2VD4L1RIfYBz9tEpldSB
         c3bqvIpM+IFNsLjLC9vrYS9O67cwSgwcDccFY31M1lwVaKHFO8KHdMbTINfDyL4Fl6cO
         488HxIaB/ynSRtaJKGDluNw/z0rBy3csyvaL5OH7qPUMnIh0XWY6b3KaEri9r6+aJJ0f
         uvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816639; x=1792421439;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mk5C4xIpedNzFRA/ZjacwHFWwKYAtfbpdgBn2XfCb40=;
        b=rjIPTDd2rFwQ/gB7NeV0iOCYovDm1BXqwdqshRfhXDi/3D+M+9zLjh1xcA0uy3WPPK
         wu81pO3/h8NFLNEZfXJ6Oru91uOS//+SsVMymhBngIbx1X8xK+0Kt47mGKe87wXDXdTM
         Y4bHVvlbh7fh7qtrpHuxQVeRNKnaQrN2Veqp7k9aY0QuadtxP+sOzFFcDtVfbEV03urn
         KsTPa8RCNb+/Y3D4aqJdKx16blrlsvMfH8IZxX8pqcoyK8jx8jYtt08sHsqt59eNb7vR
         qPaICSpjz4h1hHPJbaA8TuBP9mC3S8QDt3tCISBA9zjVpJ459yTc0qHXXJl1iBWPRJeT
         8Tew==
X-Gm-Message-State: AFq9FYIoK/NekXNNFTsyMJkJ2Zh47UM8nyqL3Sql/WGgm6+iX/+KdOp4
	b1nRSUXoWRDPZa2mhWdnMER3hWj9QfqNUvkWZYwWVmjGLLYnesP481brLRf5PZOh8ao9TmMngQ8
	pI5Ef+uQ7Eek94RpfRjNGyDJuJZoIa5yQXY1B
X-Gm-Gg: AYBFou1D1viRffi8km26BCffbTE2l5icHlX5XTm0UkqmKoS0dEHudHwKavJfslMNz2M
	dkU380JEHTFxlI5U93JRnbBZYJaGZY0dH6P61fYW1/oghYfR2aAQ8TdMdWjvgoYR1bKN/FRxrdq
	FXQNZa4gFOAbIBdjWFriFpYfVOaJmtVi37IdSoEudZVcA7YxPvsN20CePEFETok79be5Jt5Ekqj
	cvEJqX7z//85nevkNmqcQsMyvf+LZSZqXLuqfuXvFe3c4T3d0FhBv3eWBnDtJq6raBwdxUO7eRO
	NNdW7dwvR3IDH5ztwzmNWqWDSSzyYFLQdto4Uaf+N2vTjNkxKgwjDCQONWTKMf9ocf89gHFfoU8
	Ln08rHgzjeQ==
X-Received: by 2002:a05:6102:6a83:b0:7c3:9982:67d7 with SMTP id
 ada2fe7eead31-7cb3729b303mr2820509137.16.1791816638730; Mon, 12 Oct 2026
 07:50:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gabriele Moabiti <gabmoa@gmail.com>
Date: Mon, 12 Oct 2026 16:50:27 +0200
X-Gm-Features: AclHuK9VBrlOEuN_gGqL9Qq2su2EQ_X_I_iEOssILvYwMUS67-4-6XNv037YeD8
Message-ID: <CAAbJaeD17ywBhbxoXYOqPXMCUbqH3L-chjD4ufT97CTMcqpLZg@mail.gmail.com>
Subject: ext4 data=journal deprecation: long-standing industrial use case
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

I am writing regarding the proposed removal of data=journal:
https://lists.openwall.net/linux-ext4/2026/09/24/40

I develop and maintain a Linux distribution that has been used for
approximately 15 years on thousands of industrial PCs. These machines
may be powered off abruptly, without a clean shutdown.
We use ext4 with the following mount options:

rw,noatime,nodioread_nolock,nodelalloc,commit=1,data=journal

In these deployments, we have not experienced problems with this
configuration over those 15 years. It has been a reliable solution for
our operating conditions.
I understand that data=journal is deprecated and scheduled for removal
in January 2028. Given this established industrial use case, could the
decision be reconsidered, perhaps retaining full data journaling as an
optional feature?
If removal goes ahead, will ext4 provide an alternative with
equivalent protection against interrupted data writes and abrupt power
loss? In particular, I would appreciate clarification on how users
relying on full data journaling are expected to preserve comparable
guarantees within ext4.

I understand that data=journal does not make application-level updates
atomic or preserve data still buffered in userspace. Nevertheless, its
protection beyond metadata-only journaling is valuable for our
deployments.
We would prefer to continue using a normally writable ext4 filesystem,
without introducing an overlay or migrating to another filesystem. I
compile our kernels myself.
Thank you for considering this use case and for your work on ext4.

Gabriele Moabiti
