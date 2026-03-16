Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03AC34F486
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773689589; cv=none; b=TDNtxdlECI0/aOvO7YPOZ3yEFDppmfxgbZQO8s/DxbY0E8PKZW+BcxP68A9sMZg1Y1LltwdQerUIFht8frnL8P0NMhGMoHO6ANqmYtW7XdSmDMgnQC0lWPhHLg6FGRF4IpML85MFMajQ3tYnBjUts/3LlsRQjKXxuvxf4NFsKUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773689589; c=relaxed/simple;
	bh=BKyb47DDwdSsnpL1XTkfexWMuZ4TBqZJfWxM7FwbfB0=;
	h=From:Content-Type:Mime-Version:Date:Subject:Message-Id:To; b=h8kGJw4sVZ5Wovdb6WyRBVdrYshhuCWjyTE+wNq0hYfjToW3y3IQElS7Zd/quSP0q9wcaUWJloc/89HYYzh4X0t+dL8XtViy560og9tdXNnYdeRDkNLOpv8fKe0y/9uN6ZgUG8XTCsUzwDST8LCADAbh/RhKx3xIn0hmXU/ApgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqWp4ree; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqWp4ree"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2c0cf039a45so1401856eec.0
        for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 12:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773689588; x=1774294388; darn=vger.kernel.org;
        h=to:message-id:subject:date:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BKyb47DDwdSsnpL1XTkfexWMuZ4TBqZJfWxM7FwbfB0=;
        b=bqWp4reeTgR4lkdM/M7/v8Biqed0MJba1qPj8qkg5TxuhDtDMV50XvSatAlL2Csm2y
         Sxr/b1KeDCSBSkR1CgmjsRc0mUYzBubzoQuh77Ao4lqZWkrsl9tloe3p6RfMoYt3OCmY
         F17m+/fSxFXZdX5N6HpcRiMfPt+I+XErHcsWGuokir+/H47ovh+y1Rm8eszaX/klZjcu
         IFmHaAYuVtjQ3g0IdqKjOG2oyg//IMTETIlQ3R0th2HLG306oBcup2WbuSOGpZlZjH/R
         4ZARnVVNvyHF5sN17apNLz0wsqNhGqEDGZG9VDpUIGdpLEjRkHbUDTJtxIMEe4mHGsr5
         D8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773689588; x=1774294388;
        h=to:message-id:subject:date:mime-version:content-transfer-encoding
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BKyb47DDwdSsnpL1XTkfexWMuZ4TBqZJfWxM7FwbfB0=;
        b=oZetIPAQPgc4S7gaYZbN9pC9wov7jxzSXrWbMmMio49dJyQFyC/gcLGtoLNeRRZGEH
         vhFFX33vXQNkn+yku1mqknsD+0rNAY+mqC/7zntvEQrZt+1Mz+ZZfv8Tx4+5JvxSvjWm
         8WnHH9UPP7aDKTKa0d7hBX+DF6ib0PMSzK2S5bYHrDxtrU/n9h/OBR+yuDlz6kEYpA48
         RX3qhC4lSlb5o4GlKUwGBOFeXdwmqBoZ++Fn1nHD4XPjUi6nr64FSFonnCKmYGzM09U8
         RKpDzHKdvOIAdKSnBdThc3yGzd0Ugulh/OWFyCqWVsNxa+is9a9T/nFpbiYZJyncT17e
         Ri2w==
X-Forwarded-Encrypted: i=1; AJvYcCX8C7dOdCRPIAQOOT9r+PSWosxIicwRp6cAiCMYMM56FgvzyUqVFa9Grzyvb3rYQng+mP5pwKmjH70e@vger.kernel.org
X-Gm-Message-State: AOJu0Yz01Do41MMWiecZCJ0joQVCTeEdKSRfl89G3ZNjOLXdfscVWRJs
	YlVsteFV03drNyt7xAB3dQvv0JqJNoqAP2+mStC4NqaU4/KzLSKUeerb
X-Gm-Gg: ATEYQzwUJcdLsBJPXpGpX/xk9D+ZDQDg5YMkSoaIi16ywq/J3kHn+sB0zG5/9B97of3
	dU4/yjTvdRIHiuNOfrqZDxW5t/8K/sY4WmMrUVcirOSTcFG8SGpZUb/GvcN/Us4yWL99NBg8h4Q
	EXPX+Lio1AFl0DcsP+OKXGENmgTVP/ufgHV8wR0jlcQ6RCXIOEM0A/kck2qJsxw7cybgr7Simy3
	KcqpJ5HgWRrVk0cA0YqzmhbndJ4TtR/DPAH0Zh1ZzYy1j3T0G36PryFQs9sAwS/tndhmypvYUJR
	WM0F67Ba0GfJN0j+lp9L0TUiWeWzqYhf069pbamTougPGYQIv999jWOOFyqqchYlttq5Q/1fa0t
	2jWoTsdzUHZ8GCf+WKaKeki4ovXfNj8CT9fEOhv46tDd+s+s/GmFEPAEHiTlEAQAhtmmMN6I2xA
	LU5iud9jR5DNJ4CVpfhecNgxoxNRUnTgi0lWCcOn17EwJMgJJ6qPiBDW4=
X-Received: by 2002:a05:7300:e788:b0:2be:142f:d48a with SMTP id 5a478bee46e88-2bea55a4a89mr6554425eec.27.1773689587753;
        Mon, 16 Mar 2026 12:33:07 -0700 (PDT)
Received: from smtpclient.apple ([128.107.241.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c0bfd41aacsm8334565eec.27.2026.03.16.12.33.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2026 12:33:07 -0700 (PDT)
From: Shramana Chakraborty <chakrashramana28@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Date: Mon, 16 Mar 2026 12:32:56 -0700
Subject: Warning Trace seen at
 https://elixir.bootlin.com/linux/v6.6.69/source/fs/ext4/ext4_jbd2.c#L73 post
 remount-ro
Message-Id: <E3FC477A-39B2-400F-A990-F703233B915D@gmail.com>
To: tytso@mit.edu,
 adilger.kernel@dilger.ca,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.3774.600.62)

Hi All,

I am following up on this bug, =
https://bugzilla.kernel.org/show_bug.cgi?id=3D220299, I raised last year =
regarding warning traces seen during systemd shutdown.

Warning Trace seen at =
https://elixir.bootlin.com/linux/v6.6.69/source/fs/ext4/ext4_jbd2.c#L73 =
is hit by the writeback system even though there is nothing to write and =
the filesystem has been mounted as readonly.=20
An ext4 fs is mounted with journal=3Ddata and a large file is written to =
it. Then the fs is mounted as readonly-ro post a sync. At this point of =
time, data consistency is preserved through the sync itself followed by =
a sync from the remount-ro action.=20
All the dirty pages should be marked as clean in the cache. Yet post the =
remount-ro, it hits =
https://elixir.bootlin.com/linux/v6.6.69/source/fs/ext4/ext4_jbd2.c#L73 =
and prints the trace as the fs is readonly now.=20
Even though there is nothing to writeback, the wb_writeback is scheduled =
every 5 secs or so and the same trace can be seen if changed from =
WARN_ON_ONCE to WARN_ON.

I found that this was reported earlier as well via =
https://lkml.org/lkml/2024/5/17/983.=20

This is still seen on 6.6.x LTS kernel with rootfs mounted with =
data=3Djournal option. I wonder whether/how this could be addressed.

Thanks and Regards
Shramana Chakraborty=
