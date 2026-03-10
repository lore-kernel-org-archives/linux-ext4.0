Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFD83B0AE9
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773148932; cv=none; b=FS2A+oYNiBh4A25+p3H3IXLzrqxdzde6goPemDVnP/iw4kSyp2EXR9cJvA/xz25bZZBXWIsBIG1Pt1/i2DuH2uJU4GyRm1Hv4rW/1Ni5wCPHT8AJ93FlIblK1UD5ESqAWM5djvYpmBfiPF2I5fTDQoQLJFgiFAPE3wDF/T043MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773148932; c=relaxed/simple;
	bh=7C48eJwQxF2SZSyojjO4eehKdtPdDBqSboD/LkVXOwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrfGPWZ4vt+pehsXSyeT6hv9iLuvUkrzAHelV93QNbdblLT02tfzcDcW1dJJp5DJZ4wS2JRR2f6eM/CVy1da3iHdCgLnpvNhhIkjBQee44DunehxcRHyYvwa4HjV+b848EOIKAPqYeygc7R/RcysgiloUzgbFriRIgbN0OJhfz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E51kNjIN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cWw8/5Ju; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E51kNjIN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWw8/5Ju"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773148927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
	b=E51kNjIN4UKbGW9DyZ5aBLaeo/X1fN08TYjWYCgYq8Q8qw25+tZQtb5W5ajU6MN7BBBW11
	0YDBivfD6ObYrVaZ07AfmguXniohVg3EyJDviAgsAuscNKdssFGgICyGTgh1yznjOgNpE3
	ekU6IHdwiHFWZVShb4nqu/2AD28lhx4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-Ai9hi5AkNyG1Z5VxZXSdLQ-1; Tue, 10 Mar 2026 09:22:06 -0400
X-MC-Unique: Ai9hi5AkNyG1Z5VxZXSdLQ-1
X-Mimecast-MFC-AGG-ID: Ai9hi5AkNyG1Z5VxZXSdLQ_1773148926
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd81506677so1375238185a.1
        for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 06:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773148926; x=1773753726; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=cWw8/5Ju7zxznn9mOxbZtRGP57yWDqx8ETM9vE3NCs3Kvj4CriRCeHSx6jn8AUlVJT
         +I/Gsr0HGGPFYYrDlGd+zHB6BRSju4MPD1kgZ1vAi7fkFWsVVqop5TGK4m7os1pYUEl5
         K1KZk8g4/r2uuPKbZADHHaaLVoxMo2kGnFe2GWYrvN+bOJpgFb3Qw6us5Mo2ieKOACax
         PsxNVYuv70RBqBAseWHKh9EXpuhyCZ3kGBcwEtH0oTS6lCvM63LTS4lWuo6EbN7sLNZz
         0TkHU0wPmUKbz78bVJImjb2zDp8cbqifmyA1ibykSxHyeuQmEkHpTfpK835DIItllhdI
         ytfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773148926; x=1773753726;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5/adDEbR57gUpYJcJq84OoDVxrrM3xMPFmZCRo0jKXM=;
        b=lXEKt9PhG/BofoEpacOO/n5TnB2sUkl8P47EqZYKMJd7U4ExPHdB3oCzpW8ResLEwE
         PYnC5bxzpfkI/38rpDskyw4Wr63JiL5Y/2HRoqqlUNzT4tE2AncyOhE/+sQwX75NSyij
         QiWkDuGtRb1mUw1u1E4yJ9WC5TRAUHUMJVskWhUgrydeCJ6RAKtAnTKzBIlaDQkdP5VA
         WDFaK1i05Sm058z6mZIpPpdKVBM5WC6b3wUE/LwtyVmmeEni4WYj4KhlgkzZo7qX3uO5
         CTrHUzgovktnn71cES17L47gPujTA3yz/4Xx0szKm2o8h/WDffwfA4C29uJC93GeXICD
         HbAA==
X-Forwarded-Encrypted: i=1; AJvYcCX1SFXVuPt6ZCavq2KPjjkJtXqeHmAe/lkeou/zzKNRD8+qOyalGAcAxeB9+n4+zoA+0oK+t18G2TCn@vger.kernel.org
X-Gm-Message-State: AOJu0Yx309jYKb+EKM5gfCEKGzNnx1AmLFjlzD0MSOGJKRa82HJfSkIa
	I012VxFtvfq+Iob6wYXvAhDdCPVZPneI23mE4P4L4/CtU6gwtwHpgtHXxVBayO20hvD+QkW0Ppv
	9xhmts4c1TbEg7LBg63DS5wUsmCQ2Z3A+ebg5U9HwiXA6KNr9bCKqdoUjAFmLZS4=
X-Gm-Gg: ATEYQzy3Sc+4+3VcUojq11ZWpPZEDrYdgxxEt3OqE4PKwXvuHgj/N9bmP/GzPsbHXW1
	jWR5OI1A27IELWGk1ETqlgWcQ2shok2S0Tb9NckKlBItRnKUPp16OcBrr03Iu9nJZVWJcZ6udVD
	gVj6E6TjTH2vG+EGhUipuzBWj9+r5dtJFO1b+GHqYSs3l3lO+QEXdKZyNIMm9KlHKB4bPDlWiFu
	j9+fIoHbEwXi5hdY6n91hlwgU6aiYtIHA1pSEMJJo/ecUA9DVx7tu0XYVCnGwH8wp7g2IJfiG5d
	ezB8IcWjHZyDrAm6dt9YFA0BYU7FYqMi11juV99r1BUswMeugcZ+p0xZdgpnsl0fS79Kkr+8205
	Jsd77V2aM0vXQAQCHwL5e/MtCP01VPbkXYi+jMAARRTidDKh0tjZLLSsX
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830784185a.45.1773148924657;
        Tue, 10 Mar 2026 06:22:04 -0700 (PDT)
X-Received: by 2002:a05:620a:3713:b0:8ca:1240:4991 with SMTP id af79cd13be357-8cd6d4f9469mr1830766185a.45.1773148922638;
        Tue, 10 Mar 2026 06:22:02 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8576db0esm474754485a.47.2026.03.10.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 06:22:01 -0700 (PDT)
Date: Tue, 10 Mar 2026 09:21:58 -0400
From: Brian Masney <bmasney@redhat.com>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAa9vQg4BSxl1BJ@redhat.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
User-Agent: Mutt/2.2.14 (2025-02-20)

On Tue, Mar 10, 2026 at 12:49:22PM +0100, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Semantich change: Previously the code only printed the warning on error,

Semantic ...

> but not when the pointer was NULL. Now the warning is printed in both
> cases!
> 
> Change found with coccinelle.
> 
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

With the minor typo addressed:

Reviewed-by: Brian Masney <bmasney@redhat.com>

