Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135389;
	b=29StUYv3JOwF/hzCtW3CVtJua7kRD6xS8Ghn07W7mJjs0H6/HNV6RhDIWbrJMwsn9z+G
	 flnkvVdw+xx3+S/mR4Ui6DvdOkMgA8sHYgCZ7Yi4srzowhFqINBhnqOOOmSfrJm03ihR9
	 ouyS0yHdHJTjKpZYzOcpiGpJFYXUe4XJRtOk3p0U2iiJGoajGGTKVuKf9sC00m7BwwIuz
	 BqOCBoc+6QFgpgjoF90KL/EwCd9la0vVPtkEqP/RSKapGZa3g8V9Zsz0k8FCOjblV/oPg
	 mzXrWKHUg7qKCvhKI8mXs+t30nOYm/daAqD/o1NV9JQbwKXVcQmsw/awae4g2tJKWgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
	b=wevtXe6qpTuu50SabrU/gU7BSIOFiWwhmMDpzRpzJYyDlGageFdHftabsSZquIv7EfUM
	 HJjaAWn0RZZ54osO0TYuPav6lCQKb+MceByvk73szV7Wy1qFa2wc9QRJ2BJucPSdw2ppH
	 0oYNbUA0AEW91G/i2DK58InpGmWr2uJ+YXMN8DpiHfyoZiqAWC7gZdyHoCMsYNrRAmZKn
	 bB0WU23IpOVKDMl6ITwzckhYLwhVEWGUcEbMjaLwSx7JD9hT/rOdgdZZmKXqsb25/I03M
	 ycV6Q/uIbRagPFqxUIFg4S/ZBh+UhWFChxfyQ9VuwoFbOuCFwC+R4Pnc/CYzuYjblpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU;
	arc=none smtp.remote-ip=209.85.219.54
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED6C606A326
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 21:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ED6C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=n6hOQTUU
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c5e31bea9so4550656d6.1
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135388; x=1793740188; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=n6hOQTUUqngfoaAVe+wP7OipaQREpIZUTmr+9ABQ9A+RccYPbJ0xQON28EvRuyVBqt
         r9HM2iZE5cGg3PPNbG9WI93phORSXncFRdrjqv+ei/9HVJWZHrloHKm4dVwJcpKUsKIZ
         1pKz0CoBUEo0w1+Bv4ggVwqXdAraxzEKTXRBNPzZwya47RBli+DIhmUMFp4Ur5xfJGEB
         DVacZ4aD4hdYD/qdT08/V59jlYOFpWLjCJ5MJCxwT0+od31pmaugcsv9ZAAyt0DtpK6/
         FP7MKuzv8SSpxsigqar6AIaK6iqcvukWr6ltLO/guLJuuQgKnfFpDgSU6h1AfRjjYQvv
         B6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135388; x=1793740188;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JKFrLSjwDHREmSvEFmSCml+HwjIVnw6Jy3aXf6F/H+Y=;
        b=QRYPBQCZWVcRLf6Bq10Jcg/x6KU8KCacXc9ecOxJP2aRiXOfDybtX1e+S20jx6xOKo
         4NCXVSt2vUX1sC7VtOwDQONIHW69UnwrnkPpX14s2RvtdamwwbYJGHx0p0cGxxE1o69t
         /BBZNCO7gKg4axCbYLLZUO9iPyTQKUsInzzODdoGoDN2FxO0y2rgJ6zIMqwVVF0Jc5EC
         G/RuqcwnXbhuH1uz1+01RUzE1CZoW+vfxDib95tAQAJBlgRmeTzxTsQHM8s8xLoeCoRl
         jtuJ6i2WnEhiJyWVu3GafwRN6O6sUL9XSe5L2DVXkKYa/eh6gY1pbyzse6UicsIApL/i
         0FDA==
X-Forwarded-Encrypted: i=1; AKwUvBxvJWUZJSOAaE1nzRy2Z/5fJRdW9p71w4t+lIIu/S4R5qQ09Z0rezHeHAlAs0/EoPwNwbtrx3EMroHg@vger.kernel.org
X-Gm-Message-State: AFq9FYKjXItF3V019KN7cpGngWtGFNb5XwwbOSKOYNW0pLE7JwE8+mV4
	7dWlN0XToR+duz8EzQRVM+9T80rEYrXNsVYnZ5ztqFQ+1PGutE88w6SYncPIUPemcws=
X-Gm-Gg: AYBFou2WkAbnOEKPoIHC1OEPYugAUIZqVxC82WexEYjC+3alzWXt6GLPykxAdWfBHQZ
	wktsr8x9RR4iiW3ZXt799McYzHIrPQrPgsJCsPuluNYBYGmVsAUTTnahfuDQmMzbNTvrsj2DhMa
	qmETvUqPArMIndqpF14HE0byaLVXEjsaip+u4d4c838SxHp1vpSHW3LC4k0JwwnZ4SPZlG4/ufl
	Ugzab73wzJdFOTZLvhA0LsDZvWVuQQPkeW41/XlhkrERfSC1mOvADi9uVYb/oD39sL3UD3wdBv8
	971cwGg0utnrnRfnmVENo5+uhLHd/tMLyuFVCIHSOxFsHNmdbCTQO3zWb9XfdiqibF1e2yaWKNJ
	qL2Ng0Kjnq5yo/wbfRwB6OrPnpl0on0h2G+9shC+h/Nov62b+SdIY5O2QFSnodtR9LqC2i0id6I
	DzWjhpLCnNmSBx0TrBgK/F8RZZaJqZho7fLMURnh0XgxB5nGvr1aAwg+tJ4Dt7vPtJ8pOWBQ/O/
	pUle47JlUOwhyl+CLq4w2DxRaJDeTGkENEpy157EEOGHHgUIRuDKxg7REub7+C7+3T5EPE+
X-Received: by 2002:a05:6214:8611:b0:91c:772d:fd7d with SMTP id 6a1803df08f44-91c7cf8f9b1mr5253166d6.26.1793135388396;
        Tue, 27 Oct 2026 14:09:48 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c8c2b3sm113364796d6.31.2026.10.27.14.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:28 +0000
Subject: [PATCH 02/10] ext4: set SB_I_OVL_USE_SYNC_FS if there is a journal
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-2-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=855;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=aO8AZhSXBs2aP15NSjU103SL3h8/eCNuFcd5jsKb2vQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLYucfR36lRP85t2sKZ2ZLaJ9rWkQsjCap0MbdXMa/mnYx1Aa41Uw40CeY2ykt+WukwlWz8EyZD
 bupKVdGj8SQg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With a journal every change of metadata is part of a transaction, and
ext4_sync_fs() commits the running one.  ext4_write_inode() has nothing to
add to that, it only forces a commit as well.

Without a journal the flag stays clear.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ace06b4f9e3..037e274dca8a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5542,6 +5542,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		err = ext4_load_and_init_journal(sb, es, ctx);
 		if (err)
 			goto failed_mount3a;
+		sb->s_iflags |= SB_I_OVL_USE_SYNC_FS;
 		if (bdev_read_only(sb->s_bdev))
 		    needs_recovery = 0;
 	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&

-- 
2.55.0

