Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316963E7631
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 05:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499823; cv=none; b=H043VLLypfk9bjY7l1aTBRwbv8SeprclXggCAzjartrfzDnwtjUL0dL0ztcYBxtsbPk0i2HRDUkrah+FXrwKh4VZLM1STwO9+OUYge0j9Uj4XCCJUevFC5i/TmIWr1Tb5oELD4Mq1TNPwfuDF1Y3ICDbyYweSgI8OePfMp+nIds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499823; c=relaxed/simple;
	bh=DDsae5PYRHBzB8MMbUqjMxYCjTAfs5Wrghb8LnCGy4c=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=k6vTzM/6EEo2XZabVeoe0jcBrChcxww/HO146m8n5pTRr4OzejQ+iBVPf+388+Iu0F83XSWZCSYdL6Turu3mL0GeO2nu9sYi/de0LTZfyVJ0TdXfP/Y6jf4wjUp684hipNMNfLA7DdCi5Dx4+hX1S64DagVL4wSrdqxlf6DwBLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ferrisoft.com; spf=pass smtp.mailfrom=ferrisoft.com; dkim=pass (2048-bit key) header.d=ferrisoft-com.20251104.gappssmtp.com header.i=@ferrisoft-com.20251104.gappssmtp.com header.b=KfRyhIyo; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ferrisoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ferrisoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ferrisoft-com.20251104.gappssmtp.com header.i=@ferrisoft-com.20251104.gappssmtp.com header.b="KfRyhIyo"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so795027a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 22:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferrisoft-com.20251104.gappssmtp.com; s=20251104; t=1788499819; x=1789104619; darn=vger.kernel.org;
        h=references:in-reply-to:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=g4XHZarYyGiNGF21Yvcw0I+AYGTcuONz0i7wXp0V4/g=;
        b=KfRyhIyoYKgUVLg3FinxS6CDKv9PnKJXWAG/DKURb5chJ45YRhNnYQG2ahGMZw1gM8
         mg/o/Eey8a0NNqX33DT0cfgqNJVbZtEagxlYu8yvn4E4inaDGHPD0Cd35eBNuAQ/sGjA
         6p/tk+qbhAwABL5ebhMynMjeGw7RWHWn24ixPJ7ujIl/SuhINgD2+OkbdmxQF4c/xcBd
         B/+BhzhdkNiWaErQNZ7aoKgIq0hcIDDF0/mg/TjEyemLsaf2qRo72WO43mHP1odDas/E
         lOLrK94h9sxg2hNTxacWzgX69vUoDe/lcB2noG89Z7ZaYHaLUviZIsiWzNV/w5p+xaDC
         xwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788499819; x=1789104619;
        h=references:in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g4XHZarYyGiNGF21Yvcw0I+AYGTcuONz0i7wXp0V4/g=;
        b=BK/7JPGBGTSPyUfnqWMDnCAPADuhEMNg33WVoeuveXSo8SeDwid8UhmNzSIt2BKEPd
         UPU9UOomkW6yCtvuUkEo/Q0IZoBCvkNhObAmY6KmxXmQvC/PPzagAsiCHodM9tfMnxou
         2XXL6b/yxHnRxRGKrcRW+1tceZFAyfeXpbgY1d9i80z3e3M0OChvoFqq791JG65L16BG
         bEX4czXf/QFDSsEfCt+5eHmZeOST0qskjPo5CRqQwHzzZnh6MYCa/+ul/J1a64dzSfqC
         A45FF5h+ZscicJIgGLwKLbeeMxVgdbZdSPxipMCnrK96A9UDpUiC9xFel5P2IifdiGGW
         oU9A==
X-Forwarded-Encrypted: i=1; AKwUvBymCQYziwGi6swn0ucBI5sbrCdbiEJbXudhzK1OMFpjkWU45NmubppXWzB0hklEkqqUmzxg1Q9K7KMt@vger.kernel.org
X-Gm-Message-State: AFuF++kPlFGgB/rKBgxsYJ+HP3nCSPiMPgznGzr8pU1xZ9iK93fFLnLZ
	p2ZYes3sCKwuehwJgNHE7AqCQWdRNfErO1llwQodsxmC/OMWLnJAz58KRQcaZeJB6AZhpim648q
	jc2klEJ1o
X-Gm-Gg: AYBFou0WKnF87SLeHtXSp71Ds/HOm4Emc6R2uCtlTOGmkPhLAytQ9KxlhaIz1/1DZi+
	DG37d0zRbXeEGUqxMWtvUZO2PS3OXo6Lo96ZVInkyuhZ6fbyf5axo31zweIsqhlb8LFL0f7MwqQ
	6ZI4OlW7zFU+o/m7TjE2FYRXuj1EB5quuJqZsaAEqRNasZOV7zpDclflzCQuh5gN6df5+GMmNYo
	5pYIoK8b/alAGsAcc9YSQ6au2J/KQlikPTLzIoh9w/qEMqdtSwwpiH+y/YaNxxay3SJXkeXDcu8
	+5Nmzw8S76vVHzjZXX/c5MnSzXKqAwOQ1KILdXztaW4ZAEp2qsX2UqKYknITnzDBvwde89vjnji
	defBaBeDCEHpbjn/QqCbIETgwdOVY4kBtQRbNFs58EMjz3EANmCivzuW6R7PTGpL4DcW/dk3FTZ
	Gx8hADdcn3YnYntyjhTrSzKDm0GUWK6lcLxqcADdrlMDKcp0LKBFq0eNYP8NH6UpBek03kuB/Nd
	81T+RJsN3pom9g/pg/Y+/RU9UGS/S7FaI7u
X-Received: by 2002:a05:6402:3215:b0:6a7:ea53:f618 with SMTP id 4fb4d7f45d1cf-6a7ea541009mr554153a12.23.1788499819053;
        Thu, 03 Sep 2026 22:30:19 -0700 (PDT)
Received: from outbox-0007-reply-tested-by.eml (45-11-61-69.ip4.greenlan.pl. [45.11.61.69])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e68e8f2fsm714179a12.19.2026.09.03.22.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 22:30:17 -0700 (PDT)
Date: Fri, 04 Sep 2026 07:28:43 +0200
Message-ID: <20260904072843.tested-by-bh-submit@ferrisoft.com>
From: Greg Ociepka <greg@ferrisoft.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>,
    Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
    Matthew Wilcox <willy@infradead.org>,
    linux-fsdevel@vger.kernel.org,
    linux-ext4@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in __bh_submit()
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

On Wed, 2 Sep 2026 09:33:57 +0800, Joseph Qi wrote:
> Since commit 8deae2284976 ("buffer: allow a buffer_head to point at
> memory outside the page cache"), bh->b_folio may be NULL.

We hit the same NULL dereference independently on real hardware, and
it is nastier than a fuzzer-only finding: on an ext4 root filesystem
every boot of next-20260831 (and every later tag up to next-20260903)
dies about two minutes in. jbd2's shadow buffers have no b_folio by
design, so the first journal commit after mount oopses in
__bh_submit(), kjournald2 is killed by make_task_dead() and every
subsequent metadata write blocks forever - journald, the flush workers
and eventually all of userspace wedge in uninterruptible sleep with no
block-layer errors reported. After an unclean shutdown the crash moves
into early boot (journal recovery commits immediately), which makes
the machine effectively unbootable until a different kernel is chosen.

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  CPU: 0 UID: 0 PID: 357 Comm: jbd2/nvme0n1p18 Tainted: G        W  7.3.0-rc1-next-20260831
  pc : __bh_submit+0xa8/0x210
  Call trace:
   __bh_submit+0xa8/0x210 (P)
   bh_submit+0x24/0x38
   jbd2_journal_commit_transaction+0xb80/0x1ce8
   kjournald2+0xb8/0x238

With this exact change applied on top of next-20260831 the same
machine (ASUS Zenbook A16 UX3607OA, Snapdragon X2 Elite, arm64) boots
reliably and has been running normally for 11+ hours.

Tested-by: Greg Ociepka <greg@ferrisoft.com>

