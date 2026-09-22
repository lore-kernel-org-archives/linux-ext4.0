Received: from mail-pj2-f34.google.com (mail-pj2-f34.google.com [74.125.227.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAF1539764
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790075082; cv=none; b=LCgeu1rt0ugBiK6YLoLHB0P/FcEZ3wukkKjOzHJeMocjxk/x+lZiRueNBqD5aDNtqP1g7UC3iw4jnIoe6/ERphHQOjMRW4XF/MDz2Q50isWltlcjiBb3Hk/7ilfHy5thkFkfd9oHyriS0vcQr1pUlmsk22v9RESpTROa+aK1V1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790075082; c=relaxed/simple;
	bh=jlleyKQ4xOX5JPZ8yJ7FAlQMxnT2CneS8DubZB/qGO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+tTcNFJLvya74k+8uwNMiL0eQRXfknqlS0PKPDYCqdOapNnfAk02X+zwv5jVVzzy+3PUg4ASPNmRfAMOFOZvLst1rceKyAWXT+27Vi+pQkGom8H+HKdWzEJgXPWddU30DHWISGH09MTi6wq7rDtKaLwP44vCte7w8jshC+TVWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aNdib1kW; arc=none smtp.client-ip=74.125.227.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNdib1kW"
Received: by mail-pj2-f34.google.com with SMTP id d9443c01a7336-2d747eb79f7so27401295ad.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 04:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790075081; x=1790679881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OBuuCSVaovNO/WjZ5rO9/fuLOMxcuXau4s48Rrjvlho=;
        b=aNdib1kW8lA7qVx2h5JfWIRb1F9j4rwdjaRK8BIP1KonE49hwoB2WrOXoXaYH7bscj
         8iFTe5y7Nb3zEPUkgJ6PFYXcD7UHa9jWohovVwBEOH/yo0pGhXo7Fb1TyHFx5WHUx3g/
         3nJQx6ASRShkbK9ovB0C2eSIMR0a3fS8foWMlGrk7iIZ0qLveebL+QoAudhB7mShV3gs
         O41xP9Jdn81DagRyrUBbQ+SPDeIGo6TEAzQ/hbA3gNDS30A/AWF43vB5rxMQ0OuXagN9
         utZFXIOdkxBXOemv+pdbgmT7ODOPHCBbeHNvCZ06UC463b9ickLEeVGE6oRoypEzhQFn
         cazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790075081; x=1790679881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OBuuCSVaovNO/WjZ5rO9/fuLOMxcuXau4s48Rrjvlho=;
        b=QhYjIXoQaotH4bNKOJQUfNP1uWL4u1x3D8lUqAeGkdjzW87/15WQl7TGQ6xDSbNTsG
         NxmU9vQ7xRrw4eoAb+YoqmU65Lf0F4K+K99Bt2ppRq3TlcH7esjsfkAfDFimsWbYyd1x
         xJnSP0jih4sIQ01Zf+GVgp9YPnk6yD2QBue1Y03d3JfVcJ2+yByixaoVrLjA97TjRlkv
         4nFyj6wVChUmpGf3rbFjwnukFiiSi2mLYGYQQof7al4gJYdu+BCw+4ateysFGIOOovol
         X01h/Eyy27AR3lRRc2C9NkpxowkBveiE2nRxgCKii8av6DTd55GY8Xr9uzhl7iTh25Ml
         lWEA==
X-Gm-Message-State: AFuF++kT1x2SysmxkJOTbu6KM1T0LeTXxXDG7Uo96CoNBRCgCHYMoNac
	jRP9SfDvhfItMEssylCIi8c0+SriT6CWjUgvhNEr6bWxGGEXbPPu3sX/1UQzPYYM
X-Gm-Gg: AYBFou1fgqS0XV35NF1oD0Zt6ipKGxCL5m0Qsvf7neyw985kJhZ/SCb9IRxoepReaC5
	BmPOUQuzSeUzkVWDQ7SIG5wc8zNiGy4/ueRwPbf9OoBndL90xs6T3bXhhSaBFcOLJckMYscUKuh
	hMV3S1Be9MrsZszYxlgxBa2dv8anYe+elMg+PuM27tEUXaykYnaNu4a0MkOFIdsUruaUNtBqbR5
	slaq0pT7YId/4lt7hp1mNkXE62p/6yuBvQ6/guCK1K3HGYLVa7XI5bsJm2Z1+lkT2bF80IfGRp7
	3TiIlx9WznDJBPfZaHnTe2NDfP4IKuIUVnX7ffn6Ko6yxJ8Ei6rDBCU4xRhRjWaOBarQuR7jC1j
	991VIJNlHXHVKcDNaEIKKmvZfaLYaaLdhe3jODnXmVSUheLs3xyG2fD++MwJXOIoNjczPajGUyX
	xbsg6E+RcohmXSdYdwcru2FlqMmchRq+LDwPASZ2hhquPMwtFpGULRErG0SskWmrX+bSQMTzLit
	y8oTXjqyBUMHLB7bxbiAO6nkx9QH+Wl8sOIZ35sb24c25ZpcyZGqO0YLST6Ms8CQ9ucsq5hPfrg
	U3BNt582Dz/YRSynaRfeo4OLRoPtBeHHpnMRn4CM8tPqI2R4Z2acQwHlf6tLgfVr
X-Received: by 2002:a17:903:98d:b0:2dd:ad73:c984 with SMTP id d9443c01a7336-2df609d501cmr9198535ad.28.1790075080553;
        Tue, 22 Sep 2026 04:04:40 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d019a83sm7999465ad.26.2026.09.22.04.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 04:04:40 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH e2fsprogs 1/2] libext2fs: fix self-deadlock in flush_cached_blocks() write-error retry
Date: Tue, 22 Sep 2026 19:04:34 +0800
Message-ID: <20260922110435.1528332-2-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922110435.1528332-1-matthias.goergens@gmail.com>
References: <20260922110435.1528332-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_cached_blocks() drops CACHE_MTX before invoking the channel's
write_error handler, then re-acquires it and jumps to the retry label.
The retry label is above the while loop, whose first statement acquires
CACHE_MTX again:

  retry:
	while (errors_found) {
		if ((flags & FLUSH_NOLOCK) == 0)
			mutex_lock(data, CACHE_MTX);		<- second
		...
				mutex_unlock(data, CACHE_MTX);
				(channel->write_error)(...);
				...
				mutex_lock(data, CACHE_MTX);		<- first
				goto retry;

The mutex is created with pthread_mutex_init(..., NULL), so it is not
recursive and the second acquisition blocks the thread that already
holds it.  The first flush that has to report a write error through a
registered handler deadlocks, every time.

Found by fuzzing e2fsck with corrupt images.  An image whose group
descriptors force bitmap relocation makes e2fsck -fn fail hundreds of
writes on the read-only device; the aborted run reaches fatal_error(),
whose io_channel_flush() enters this loop.  e2fsck then sleeps forever
at 0% CPU and does not respond to SIGTERM, so an init script waiting on
fsck waits indefinitely.  Read-only checking is enough to reach it.

  unfixed:  killed after 35s, no progress
  fixed:    exits 12 after 13ms

Drop the redundant acquisition; the loop head takes the lock.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 lib/ext2fs/unix_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index abd33ba..29968e3 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -738,7 +738,7 @@ retry:
 					retval2);
 				if (err_buf)
 					ext2fs_free_mem(&err_buf);
-				mutex_lock(data, CACHE_MTX);
+				/* the loop head re-acquires CACHE_MTX */
 				goto retry;
 			} else
 				cache->write_err = 0;
-- 
2.55.0

