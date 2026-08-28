Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB6B3F105E
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2026 21:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787952664; cv=none; b=VsW8nXl0tTpmAUX9wmcil3dOlM2+ONwowUpQvDvc8L0+/O6cXPfCneL09xMbDpsSEMTAktraNvb+ymMaQNQDRb7r0nLeiFRgBd9QAOCqO19QpJ3v6qk7GK7QWQz8M3DUS1haxrISLrYPDZVLG36pGuCrFIk4Z9/IMji5kU9cGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787952664; c=relaxed/simple;
	bh=2sDGdbmEulnh8eSdR1+HxciiahqySlt3wjxZ5slsvTw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Au3Cs27WpWmdpqaJmKg1a/mcLOc1TH1YbFt+q0INcHJQmTFH4Uph7Jc6ayQ2DsZXMfLZ/CSnoe83/citsbLnMoEKFGuwiNMoLjeRfznjObCDlgtT/fwRUnYGbUelk8G/cmX4n+xGTaJE1L3e0wUuxfLqoiSxqa72iy6i7XaCM68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=aAcO7IlY; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="aAcO7IlY"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-85dbc24d398so12964107b3.2
        for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2026 14:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1787952661; x=1788557461; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:references:message-id
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2sDGdbmEulnh8eSdR1+HxciiahqySlt3wjxZ5slsvTw=;
        b=aAcO7IlYNfnXuneVJslYa35eUyqvNa5lfwhglBLzzsPDLxNc4RQ2k2CcxCCThGu1X1
         kxoQJqPCLE1iRn/HwCuvg8pDowv96SJoTE+itdGvdgjWbVqhXfMVcpOtu8kPA7YEm+Jh
         6hynt5wEtBqtLmT+PGSxNZX4E8aCEoU8NIv/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787952661; x=1788557461;
        h=content-type:mime-version:user-agent:references:message-id
         :in-reply-to:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2sDGdbmEulnh8eSdR1+HxciiahqySlt3wjxZ5slsvTw=;
        b=MY5/RLybHrASB24BcrjKyU472RYA6HtLxUQiwE5KZ4XP/COuxbVaOffJ0wpsGrDdli
         tgEo6h/eq5m824jHXIcG0O2BM59V+/IOwbA6WbL7gIzYgx8CkctKlr+uSSNqR/f07FMj
         8eJk5CUdYkwe7ZAufs9TOqnv7fb+/PM7DFCerSznGo550zt8IKIprwDiRzhCdfbRDzJe
         XM+URoOHt7IU9D2xGug/+NHihItak4Ft5wBdXrGNydfOhrM0io5LJiw/enr4jSIuR3mt
         nX20WyfBH+nmIcymkVqvEX7CD+dGZeVnTqhEyBZJJFgvtEc3h4i5+y2D++vjJKh0e+KJ
         fu9g==
X-Gm-Message-State: AFuF++npUtRX1TsEXT/Lqcq4U2dc2LxThcpt1IAcy5z+yCqs79dPihFX
	JqrUDQ0qxESE4SsTBgk+MN9+l/Z/AbjHRRB31dMk7FaieUyLImsYW65MahQMD/Z+Pg==
X-Gm-Gg: AYBFou2U8bKFlzhC25uJ8o6vMQUAgRxVqMzGrdkh3dNvxkmsckUevFgHMgac8DV/q9M
	Ts/aahvJs1Pc9UwDjZxrCjKXMRyMHxx8x4HmvDipGMbLC9jbFCxt4guPfwvjzpy4OixM4L3v9iC
	pCjbDfMKucmJBSCm7UzMix4dypWCdATZ5zgxnZMdIOSwT0hFC+0/Ad9ELnLbOvWPI47TDUbF0cY
	Z7AMi/dNmU37liVt+rU+uezegHUa13U5FVcM52gbjBxpyTA+MKTIflSews//xrxT8YUA/8Q2QZP
	LxumoFJtkCua92hLDt67lOIV2ut23+z4fB24MA8WS1tEK8iVBie0dW7TIXdVHGlIWxW0nF5Xvvn
	smtfqJAv4ZrJS5Msp5he4AQnwmo9C43KnbCAYnnF6dXP7ZYOEygoMt0Psw3+uPpAnLKyFPHGrW1
	L/NuDCrM+rGk0t4nKksugPTUW3C9K5hb9qsSiZDXJ+OIWLyJut2TjYHQ==
X-Received: by 2002:a05:690c:e0cf:20b0:856:8468:95e8 with SMTP id 00721157ae682-85d69641377mr34929477b3.6.1787952660694;
        Fri, 28 Aug 2026 14:31:00 -0700 (PDT)
Received: from thrain ([2600:1700:7c0:543f:98a7:54ff:fe4d:e97d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e679512easm12451677b3.48.2026.08.28.14.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 14:31:00 -0700 (PDT)
Date: Fri, 28 Aug 2026 17:30:58 -0400 (EDT)
From: ddstreet <ddstreet@ieee.org>
To: Nandakumar Raghavan <naraghavan@linux.microsoft.com>
cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, 
    srivatsa@csail.mit.edu, ddstreet@ieee.org
Subject: Re: [PATCH v2] e2fsck: take flock(LOCK_EX) on whole-disk device
 during filesystem check
In-Reply-To: <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
Message-ID: <2c2c9212-4989-a1e3-f81c-e3036010bf2b@ieee.org>
References: <aoxF8FvVffocUSyI@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net> <20260824161512.1332649-1-naraghavan@linux.microsoft.com>
User-Agent: Alpine 2.26 (DEB 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Mon, 24 Aug 2026, Nandakumar Raghavan wrote:

> udevd already serialises its own partition probes against whole-disk device
> access using flock(LOCK_SH|LOCK_NB); if EAGAIN is returned it requeues the
> event. Take advantage of this protocol by acquiring flock(LOCK_EX) on the
> whole-disk device before opening the filesystem. This forces udevd to defer
> all probes on that disk until e2fsck exits and the lock is released, by
> which point the filesystem is fully consistent.

I believe this was already part of fsck, and it conflicted with udevd and so was removed:
https://bugs.freedesktop.org/show_bug.cgi?id=79576
https://github.com/util-linux/util-linux/commit/3bbdae633f4a1dda5f95ee6c61f18a1c8ef12250

That particular problem was already fixed in systemd-udevd:
https://github.com/systemd/systemd/commit/5d354e525a5

But in general, does it really make sense for _only_ e2fsck to lock
the device? Wouldn't it make more sense to add the device flock back
into fsck itself? Or if the problem is during boot between
systemd-fsck and systemd-udevd, wouldn't it be better to fix the issue
in systemd-fsck?
