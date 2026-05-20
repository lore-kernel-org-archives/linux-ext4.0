Received: from relay2-g-d.mailbaby.net (relay2-g-d.mailbaby.net [67.217.53.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142F3352024
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 20:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=67.217.53.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779307434; cv=pass; b=FgrA20867R47G0721Lju7PQ/pCK+VO+hVn7ajdqmPb3t7Va1V5CtE4c8PDR0MNjr1W/Fpgrwj65W3dELzilCWBSNT/+2ZS0FhG5bOfkaV6m2+HJ07xJL5NPGWfeT4oJPlMDY9J8bklgpH+ix5usQsanNmCwIWLRFg+ZTn3IK2kY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779307434; c=relaxed/simple;
	bh=p7B650ZV7SDGBRdDKR85IzRtxe/rcdUFYPh7t80Usg4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=KUE8qTBue7aFKDDV2r5yU/epUQ0lMA3l4lW7R6+0rV/fDDDwp/TVIUHn1EhvIutkKyd+Rx4lHKnP+gNOizbhm55WLZabVgJYMaEQOoN9Rn/sE7AJYxwm2a4gM6CyZstcFkfcE/Hr8tG5sYeZkqix7pD9NfdSR4XrO3w4t5tYRB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=agatha.dev; spf=pass smtp.mailfrom=agatha.dev; dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b=Ck0zHkkt; dkim=pass (2048-bit key) header.d=agatha.dev header.i=@agatha.dev header.b=syRX7Xi9; arc=pass smtp.client-ip=67.217.53.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=agatha.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agatha.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mailbaby.net header.i=@mailbaby.net header.b="Ck0zHkkt";
	dkim=pass (2048-bit key) header.d=agatha.dev header.i=@agatha.dev header.b="syRX7Xi9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbaby.net;
 q=dns/txt; s=key2; bh=EzGI7B5wsZbXljwXdvO8xwWkL16dR1z7IoYBQ4KdGK8=;
 h=from:subject:date:message-id:to:mime-version:content-type:in-reply-to:feedback-id;
 b=Ck0zHkktAiE1OUs8HHWe/Rtio1A4pg+dyW16RjHW7jUR7mbCMHH/ga1iop/8s4Hw/7kcQQ3Vw
 ngmii7FZyoz6DAxiC96PvQK3gTX4OZxOU+FCqJcV0DDzBYkmP7enulgbppUOiejmz5Voj8zRVHB
 kci3CsFy5R4TgaIAwn87NeU=
Received: from mb-nj-kvm1.internal (mb-nj-kvm1.internal [10.10.2.10])
 (Authenticated sender: mb6724)
 by relay2-g-d.mailbaby.net (MailBabyMTA) with ESMTPSA id 19e46f7ca7d000c7f0.002
 for <linux-ext4@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 20 May 2026 19:58:24 +0000
X-Zone-Loop: bdf98bd8de23c24fc736d4fc6fb330a0faabab0bc1fb
ARC-Authentication-Results: i=1;	rspamdcluster7.mailbaby.net;	auth=pass
 smtp.auth=mb6724 smtp.mailfrom=code@agatha.dev
ARC-Seal: i=1; a=rsa-sha256; d=mailbaby.net; s=detka; cv=none;
 t=1779307106;
	b=fzoDkqwNi3VOV9ECFUJ/GAKyJ9dW9L+dKmWhRn7z3I4GjYMPXAgTuiIWV+iI85gWHeQQKW
	iDZoMNfa3Z78qyKDCQ/1R6xJ3bBR3/AsrCYJeHsYQ1FwyWd1GPvUFqfAfEoEYIN0Vyh06o
	RCsHyyKdZywufJU7G5x3GL5kl7kmFuu6kXAa0QkXzgbGVOfe9CMdMWhkCGoj+l91iWKXn6
	Bs3SZ8qKkyj/0bG1vOevZJg999hfSFvdoAeTfUxpp3KhmINy2pEx6EGL7Opz1Kgtt4AfYY
	flsBCpT4YisqcDDyFU8ekMcmIgRpGbCRFllqHZs81ORCTvEQQelIO3JA2MSzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailbaby.net;	s=detka; t=1779307106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:dkim-signature;
	bh=EzGI7B5wsZbXljwXdvO8xwWkL16dR1z7IoYBQ4KdGK8=;
	b=f8H9AuU9xn5ZCvZCSCKmuJ7HQKRVQhbdBsayiV+uhBsWZ4HUIFxh5acWj6gk9XgaotPD9Y
	uADzrv3dmurB0fN2anDfsYjz5GQiBXvDdidc6+hjZfksSKpA/K8UkLkjEJyNTDwsvL60nN
	x/tKHDezys7YzJyJOm1dfHCH96n6DnU64W4O1CSYFWtOPRAA0JvI8z2holWK0HiJTbhfPA
	1QIZg10wy2H4TOCp7Gtrc8/EfIDrErtioxg4cq/hE1IgKWlscsoOr6NFRAjI6al5GnrZkb
	eL222ak3x8mEWAkIIGfP1YkxBzH0t0Fy4MnOS867jkuFMDybFsJEw9BXpRX/zQ==
X-MB-ID: mb6724|me@agatha.dev
X-SPF: pass
Feedback-ID: mb6724:19e46f:507c5a5c5e5d585f7d5a5951:mbaby
X-NS-SCAN: PASS
X-MAILBABY-ORIGIN: PASS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=agatha.dev;
	s=default; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:To:From
	:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EzGI7B5wsZbXljwXdvO8xwWkL16dR1z7IoYBQ4KdGK8=; b=syRX7Xi9ISjnjXKEMvYxVofPdB
	tzsf4+dSwrbXA8NBfL4rlfYjHlZC7mhd9iJUH7nCZEsE/ds87G9rRJBmiUvgIRN3lY3kh+Z+Y4Xnl
	fJEPPocnK3RgAtlqxBzAGg0eHZ1gnutnA41i/v44tHE+jJbqwmIsAXD6UjzeLmPyZKpSKrB97ZQXJ
	8NN8TLnMmr0hERPnGpHmn6XeGyD0NajEBdK8ywTpsH2RSWYsZnAS50/oVeihmLO0cztyH/gEWTMxe
	nU4Y3DW0QZtlZNGjlzgrdQZwLhiVsVxianizFb0Z06CgVGYYvzZp2nrG19PXUhwUoKPJ3vDgCZyII
	V9kwhIKg==;
Received: from [170.254.153.136] (port=34812 helo=guidai)
	by nyc3000-r.dnsiaas.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.2)
	(envelope-from <code@agatha.dev>)
	id 1wPn3i-0000000FBOq-2s3O;
	Wed, 20 May 2026 15:58:24 -0400
Date: Wed, 20 May 2026 16:58:16 -0300
From: Agatha Isabelle Moreira <code@agatha.dev>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, shuo chen <1289151713@qq.com>, 
	linux-kernel-mentees@lists.linux.dev, shuah@kernel.org, patch-reply@agatha.dev
Subject: [PATCH 1/2] fs: buffer: use clear_and_wake_up_bit() in
 unlock_buffer()
Message-ID: <ag4SD-mkmn5IbuN7@guidai>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag4PEP52c8rxrYPc@guidai>
X-AuthUser: me@agatha.dev

Use `clear_and_wake_up_bit()` in `unlock_buffer()`, since the helper was
introduced in 'commit 8236b0ae31c83 ("bdi: wake up concurrent
wb_shutdown() callers.")' as a generic way of doing the same sequence of
operations:
       	clear_bit_unlock();
	smp_mb__after_atomic();
	wake_up_bit();

The helper was implemented to avoid bugs caused by forgetting to call
`wake_up_bit()` after `clear_bit_unlock()`.

Since `unlock_buffer()` predates git and was last modified in
'commit 4e857c58efeb9 ("arch: Mass conversion of smp_mb__*()")', years
before `clear_and_wake_up_bit()`, it still uses the open-coded sequence.

Replace the open-coded sequence with the helper to avoid duplicate code
and reduce code paths to maintain.

Suggested-by: shuo chen <1289151713@qq.com>
Link: https://lore.kernel.org/kernelnewbies/agzoqV835-co4kAN@guidai/T/#t
Signed-off-by: Agatha Isabelle Moreira <code@agatha.dev>
---
 fs/buffer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..4348b240bd97 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -74,9 +74,7 @@ EXPORT_SYMBOL(__lock_buffer);
 
 void unlock_buffer(struct buffer_head *bh)
 {
-	clear_bit_unlock(BH_Lock, &bh->b_state);
-	smp_mb__after_atomic();
-	wake_up_bit(&bh->b_state, BH_Lock);
+	clear_and_wake_up_bit(BH_Lock, &bh->b_state);
 }
 EXPORT_SYMBOL(unlock_buffer);
 
-- 
2.53.0

