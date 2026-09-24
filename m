Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E48A4D5983
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 21:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283874; cv=none; b=ODF6AFmvTNjMxOHu9dPRjwtZUk1d6DTzWqyIm5CogoAePx/IBreA78O9tdHryPVZMJyYBb/ekv7P7nc572gTlygV3mly7eMv9HkL26lG98aBBR/7Rlg3RkxHDTL9VRHKAD9uh7aUySHrSFMB8cGNlGVV9NVWSkU9J13z6jHkWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283874; c=relaxed/simple;
	bh=xEkq7XmhI9u80PhnnngeJ7k7eukuHmFV9/4gEhN8+8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9ekIhQWP6sCNoS2apR2FF5bEKm6hjp+zkAacoIFIqdSwLr2AvpVwxTmkJ3hmbgStvBOz4EZDWQBem6tAIyfdVGV92CcjNLOiso4ozuTixp66k0Mm3mEWqORt3WUknmv5gc/xppYc1wqnxBkkNxCmmq1bZ4CeWGgOi2iOpmL4Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cJDmA6cq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A0C4H3oQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cJDmA6cq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A0C4H3oQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790283868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hH/t7ONJ9byiWBJrdZycLsCFM09r3UHLzPk0ECufJWI=;
	b=cJDmA6cqtMWxeoE2YocLn63HpgdDg0RMnBMO0nqw9Qh+/LNfNQ+6o/+1I6scBMr1sj1xtl
	OQ6uVWg02G0DVLfTnq/8uurCLmos5ZF332N1LaGfRSOuycvL4RqVtj86t/pB8NSvdqGJrF
	++UEX4XRGEU3xPlb0oTwQpSLkDqVWMQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-1YryuJwdMoeJh3ok4fPJVg-1; Thu, 24 Sep 2026 17:04:26 -0400
X-MC-Unique: 1YryuJwdMoeJh3ok4fPJVg-1
X-Mimecast-MFC-AGG-ID: 1YryuJwdMoeJh3ok4fPJVg_1790283866
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53094ff7090so6852051cf.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 14:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790283866; x=1790888666; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hH/t7ONJ9byiWBJrdZycLsCFM09r3UHLzPk0ECufJWI=;
        b=A0C4H3oQWpTRStS+iIy6fcfuI8CW9sQVi+klRZS2jtRkU37CJh4VGcnw6WydKZYwLb
         Nb/IfIKe0Gmw5UlYpvhChUy7SKlIBJMLWpuJEcFKP74wtfI8cc5duKsFXCjSUrWFm4Ew
         eom2wAUIV8k398UFCDP+pYY0+N9aDrT4sJ1w9p4W279+aaXcIrQ4mLExWNyBEQFe7noo
         /1BBPNhJlyb63WHMmE6IWsV6tAolwBoIptcsTUHUWsD5JMmbMsiXAdp4MfhiIwlax7It
         vsv1g5kMZP0CJ/KIwKDz/tUxuOh3gBSQu9hSms3OnmD2m+EyppNq7nesTTQyEt9nI/Av
         ovTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790283866; x=1790888666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hH/t7ONJ9byiWBJrdZycLsCFM09r3UHLzPk0ECufJWI=;
        b=bVXntW/WHYKJ0rc5fUSw2NDBpPojOJkZ0ktXvFI5BXVYMzySjuj377kjil3okAy8nz
         0+QVrhm+wfue69NJF4I4SsiO9jjTdVxf8uaZzgd81wCCnhDrd2uatCJkuExceJ/ZKPw7
         h+R7yQADI4+N3euIQDQ4LeX3CUOGrlQPuVmtXqSSRoy5iqUcCagKARlDrjMvEcaC5NIW
         OKWGCUHj+L+Y+qCOvva6rVO58wJielalOxZjfPoaJjuNJ3Fs+DXIQI0E3GdGzI9H9J9U
         VtR+XPxQ6TPnMYoT6uL7uQ5jh6C4tjyptKE9qPFUE+rHLod68kUpX7+d4i/lcjs3BM5E
         HLWA==
X-Gm-Message-State: AFuF++l/rfem7kkLkc6raUuzMhT9mj5A53Lg0D/Krnxu38GRsgQjOjzy
	f1GaKvy6W0FpJ9iPTCypsR1Xvy1KS/8XcVUL19ovIfEqAUfC6pQuSuuuRYMXSTOliyqf0FQ/ZHg
	14PxW980PVGm/ieC0+qMuLmP6tM9X/cy2I0xFHzfu3p8d4h+3Qu3NTGxJYL3hryDvnCECb8lcFl
	mUCOZFgJyXCU6V+EskoHnXVFkn3lWGSQBfLf27sWkJ4qS5XYxv
X-Gm-Gg: AYBFou1FnnffwpeN/10clmKrw0P2dR7vuWhlJVhESEwbjPlr0IdtCfTwYLWQYvpHqwZ
	ObU5cy1fN/6k/dcXv4tnJGrQW/tfIGusJxfNmL4nMn6ACYtsaYDQs3esQEBddNJwdu6hswJJ/AD
	T8to5gS/MKHu5lnKODwtirAGPRNwmMP8XKXAcFmlO/cBP8kFspa4cTBzkT+d/oaUe8Q+l6cHrg9
	n4AzYgUlEEwY5QuV/65yuLpPVDtn8XmusXB5YcF8bp0Yg88x4D2ebpXcqhmtCvJocmQrgPfR9rp
	sKuKjiSZDKGuguu1m0hT77kUwksEs+4F/PLOGJkvumexSg9HxweWzsRr6ZoM/huTFgh0AqDi88a
	G2npxBGl2gUwlkinRtfazCvJHpHkzgURmyXyHoQ==
X-Received: by 2002:a05:622a:229d:b0:530:1b1:72be with SMTP id d75a77b69052e-5330b68310cmr9554541cf.40.1790283865979;
        Thu, 24 Sep 2026 14:04:25 -0700 (PDT)
X-Received: by 2002:a05:622a:229d:b0:530:1b1:72be with SMTP id d75a77b69052e-5330b68310cmr9554031cf.40.1790283865454;
        Thu, 24 Sep 2026 14:04:25 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5330c06e5ddsm2112091cf.22.2026.09.24.14.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:04:24 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	Eric Sandeen <esandeen@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] blkid: probe_ntfs: fix attr->len endian swap size
Date: Thu, 24 Sep 2026 16:02:45 -0500
Message-ID: <20260924210421.3631790-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924210421.3631790-1-sandeen@redhat.com>
References: <20260924210421.3631790-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Sandeen <esandeen@redhat.com>

attr->len is a __u32, so use blkid_le32(), and change attr_len (to which
it is assigned) to an unsigned int as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/blkid/probe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6a3bb247..31d048db 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -689,8 +689,8 @@ static int probe_ntfs(struct blkid_probe *probe,
 	struct file_attribute *attr;
 	char		uuid_str[17], label_str[129], *cp;
 	int		bytes_per_sector, sectors_per_cluster;
-	int		mft_record_size, attr_off, attr_len;
-	unsigned int	i, attr_type, val_len;
+	int		mft_record_size, attr_off;
+	unsigned int	i, attr_len, attr_type, val_len;
 	int		val_off;
 	__u64		nr_clusters;
 	blkid_loff_t off;
@@ -752,7 +752,7 @@ static int probe_ntfs(struct blkid_probe *probe,
 
 	while (1) {
 		attr = (struct file_attribute *) (buf_mft + attr_off);
-		attr_len = blkid_le16(attr->len);
+		attr_len = blkid_le32(attr->len);
 		attr_type = blkid_le32(attr->type);
 		val_off = blkid_le16(attr->value_offset);
 		val_len = blkid_le32(attr->value_len);
-- 
2.55.0

