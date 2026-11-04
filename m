Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753735;
	b=1CUQd8JhQ9jTGclUa8da0CjxjHPW35faIjUYgPT5Q4w2YEraFEL2LbscI6W7IeIicKPI
	 +EG/tJgeh3CBbxKcRrqL5DGCwHhoRkBDa7H90L1sFbnQFoA0Le8opvTHy/7h7qUzSj1Yl
	 RhVb1HkU/hqx+mEzv8fIfbKKjxwsVYodUnIBtrrZD7CZOI0DZG6yzv7MKcZStk114MX6E
	 5attBGOl61YfLbcmvcsLZjluOAGfmrh5Dj74+2ekKpSxemV5QKPVyPAMvoZV2YwnhP8WQ
	 HRI2X+YwRiPpJw4pWIhRQFla8RBID9R0aAF28x0nuiHmD2PKFFnreKV8oK2sFYW2fEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
	b=mZjfThLnSrYUTDNzU3WvJSU5nafsh0nCZtfwBgswVbNsdrPzoXekhcvzHr29vqcl/npE
	 7TOwvllKc0blzg3015Mlta8ZjTWxfZDrAGeR4+NJV1NinKp5P7kTDoWDsjjFRQN0FpSJC
	 D6xAraaydqJyNWSXjT6DQUZEa9w9PqM/SnGAXcjB6w8JwpMdMFgCy3PNopHnuVV29eT+L
	 4u04tuerRYn2S1Kbgc+b9ofc031fFT+yLx0xiNxMypEO1QXudaAXWsazOYy1ra5Vr2cTB
	 ygXmR4g3tJfdBm66QH9jsbnu9vT7NveIv2NPN04TZKcb5+ukHy78OuxjKQAcLKxVuKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF9B606A32F
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 00:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AF9B606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sudo5wuz
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdab938dc83so71805a12.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 16:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793753734; x=1794358534; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=sudo5wuzf8me28sIhbntLBwUiKNWuwSV6wtIncQpUBbsN4Zu1yMj1uOdtNMULS+qse
         p10GSTbsQZQej+RmcaRVIPfYXpiJc7DVP332tBPCeYi6iIxYHtw/pCGnwu6pUZaiYkuu
         1jzqj0fIApJI24vXlIZRW+4LFyo/2rv7mV5cIr8Gch74DjfIbhBYVLv8/dyYnqAxTrWw
         7/Kxsv4asQfbrP6PWPBOlk/xWVzyI0hLDQrJy+RjayW+oFANYAqhfVZpq60HUf6srI5f
         LvFF0LRAtEUesVRTlzKq8hIDxyh050q8ogJnunYhdFI0Mss29VGLQmid0PHrrP/vhgJw
         FudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753734; x=1794358534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xG5t3xikeZrgWEXDIQ9E66WF0APj2TRUKkrk3j8LkpE=;
        b=XyNj9gumW4ZvKrylX54+OBxmOIImsh9khjjCKItGp0hJ7MbiZnZRv0GpNkAvZUMklf
         5GBsfdjIbo9InBhOlj25vkVah4ixZ4GK+DNEr6b4pSFzAk0wsJyR2EkC4JqpyRB5ahaI
         oN6ooXtofVktayVCoAsEYKmzOaT1IBQv4OHKygUorEZPV6FhPNNLv+xhz8lDVNv3DvN7
         aQSjbZSqew9Qh2tlVSKwN1ZZxO1x33aBNJUoQFaeHb+7IzVh9nHIeVSk4Z0GmgHd1KIh
         /M5g/juKwISWV3wryVvt3e02TlWlAY7M79mli1Jv/3JL1UtKgUY7LmH4uxO8dNDe1mVg
         WN4A==
X-Forwarded-Encrypted: i=1; AKwUvBwT1Wy5GmI5NNqxVRFAWLsklFWn9or9Lyu28Vu5WeI0KXLGb8+ClFj3l6gpkk9B7col0eXLON93GKzS@vger.kernel.org
X-Gm-Message-State: APuU4Z9Jv0fHJS8AVxZwcaVNP/26PMGhqJ+5OmMNWiYK/4PP0BXQ0s75
	96Fi/R9H1vO9wCsgVgSghJ74cY6z86yH1U391Q6cVzmdfB+podEK2pj6
X-Gm-Gg: AYBFou3Iyub33B0xJI1IpSXgnpmPviil7IDafzt8tJ+56oRdJ738vS2REc7Nz/CbWiP
	BKbZco5AT2Lc9D2eHKVG8c/D6X7MsNZfBj8nL0XwacIwp/Xv/gKoHgIPLXYCqsMn2qVqXpl4RHE
	fJN/60W8moiCHXJX0UcI7EKW4zS6sa4cducRPvgMg3+b619RQNRSZl79K9kSPnEoMavt7lm9lNs
	T4QArkPl03Qg9RvLw/13nm/h9xhmrx6uK4zjoN9pdGfi/xHN1gqdFsiPP4b8Twohi1X7xV18Adl
	H6b7QjMzy63dmb7trbN7bcUjmRatvrlqWoxcOg9dnD9w4B0DRFC1cj0uLKua5q+0NKN1YBKGZ15
	zjrKzJK2nuEZ4MGPXvh+KM+wkh6i2HA9JYcL99ESXxKPNb9eNzLe6ktEILuDQy5OfTmUNs5CmU7
	tGTwAHXP3OC5eH76wjz6bn3VTvGaUMKl/DzHtq31KYWeltARuOppvAaWmlZL4TGm0pbkeGFj+MG
	6fsWuK28jTCv5T41PnHs09Pl6gh9w6LYxOHow8FHiq3RmjFBbHEFPndOWwaCSiSbTPV2k2MlMqW
	jqvKgxVB9r2g9zz+gw==
X-Received: by 2002:a17:90b:184f:b0:3ac:83c1:2c0 with SMTP id 98e67ed59e1d1-3ae897e06efmr11479861a91.64.1793753733906;
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Received: from localhost ([27.122.242.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b09445f7b3sm1222403a91.5.2026.11.03.16.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:55:33 -0800 (PST)
Date: Wed, 4 Nov 2026 09:55:30 +0900
From: Hyunchul Lee <hyc.lee@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 18/34] ntfs: use the generic emergency read-only state
Message-ID: <auqCgguXEsKCq9p2@hyunchul-PC02>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-18-2f44f64f0b66@kernel.org>

On Thu, Oct 29, 2026 at 05:07:09PM +0100, Christian Brauner wrote:
> Set SB_STATE_EMERGENCY_RO instead of the NV_EmergencyRO volume flag when
> an error makes the volume read-only. ntfs_emergency_state() keeps
> telling a shutdown (EIO) and the emergency state (EROFS) apart so all of
> its callers stay as they are. /proc/mounts shows the volume read-only
> again.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

-- 
Thanks,
Hyunchul
