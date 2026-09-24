Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A7A43304D
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 21:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283878; cv=none; b=Z1t4g5R1U9MYHpqY5FtoR6GoNE/kVA3Od+ahp3zUSu+vIC/QOBoTjnmowZf1G469su54ybJgFC/uMTSKNQR7iI+ES+IAbgEDEth4DovvbV48K72HgTfsy59OE4FpObRGdXjWfDg52WV3GXGDnGOV81StKmbOX34M3XxEU0XSFXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283878; c=relaxed/simple;
	bh=59LQrto0WXLgCf+srrduXnE9Q7LrdvVWonjaQm4iIBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7MmjGjfUuRaZtatwMyEKtJuYh0rTgW+dhvoAEDHljPbkFpL5vhDc05tsoAtH6Ox1SxwxdFqAeUNXi/48cpE28nknULaD3wfrARlq5D6drnRXzeJNVwj732Gu5CZchxNAoczGVt7X6fTjRYyOmpHoeuf0J2aqVbKG+01f2H4Njo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PGZZSDJ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VdjOpYXH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PGZZSDJ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdjOpYXH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790283872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utyeaOhS6QYe+xzDpAT7qdAJrLmzqnP5QAo469XI/uY=;
	b=PGZZSDJ30mk/4U6kj8irSznHohonG/ac9fAaFFOUT9N9dhVqYx2htXRmI/bMQth+puB+Lw
	GWfjf72WlxaQ76AfoNV+jKqsjz7QcdEpGW78E9nB97WonNcvTt1VT+/GGNNaFgx1UAnwWC
	+DfDlR4n/RQtfdIhJLs/ACxiVQxMgXQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-mBa3b9WfOHCbB8o-A3YbQg-1; Thu, 24 Sep 2026 17:04:30 -0400
X-MC-Unique: mBa3b9WfOHCbB8o-A3YbQg-1
X-Mimecast-MFC-AGG-ID: mBa3b9WfOHCbB8o-A3YbQg_1790283870
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5304f2b5946so5492581cf.3
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 14:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790283870; x=1790888670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utyeaOhS6QYe+xzDpAT7qdAJrLmzqnP5QAo469XI/uY=;
        b=VdjOpYXHPA9uGgt3xE8QozkwuO1ep2BrGSI9x/L8tXu4k9TJDNix61pum7/Rftj2gC
         5OvVOTF0AHfnrNUucppzZ981eEH5aWXcQKT0n9X4HHGtAPMItay0DgJH/wjkYlU0qmsz
         TnpqUeWv49U0w9c4aGaA1ukywd8jbv/tT9qn6m7dDUd++kmKfteo1NWt9gLWH3g+1obX
         xo6Rb4iIgSzye+I/SPaG6GGetO2rJLLkBAcLab2D0jD7PEMZSk8iRtoo2siTCXtwLyT+
         TnEjdixCP1VuGc6ddponbWn2K9hvNcrJjNIPP3cW8IeVKLpE0TVxflTh40RoTAsMOQI1
         L7Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790283870; x=1790888670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utyeaOhS6QYe+xzDpAT7qdAJrLmzqnP5QAo469XI/uY=;
        b=RHZhBvgWAwVFCPd+ogGMW/qL9349gdiRJlwWz9uFlrlA/i4Cu4abDDUdeDKowoPKG2
         z2wPvSpmmQDzqvoyVUKQy5iKr/DpGf7LE0rTPdRlOCMYlfv8yMR2mv0KWTX2Vb85MxYb
         UwJYyRjJ96Em5RFiqcm2/UTb66vFhCaWKdibZtxFUWA3L+ZNYWwsz4h2gtVqm+0Vd1Og
         awnYxIrVlovLERz4rTwhmGRDeKrmtKixE2h4PhcY8vpg8dew0vrGxJzrYiCRfCipSTGQ
         c5+we0+uXN3svcKweC+u52svzkAAM1GjwwkL/UdN+FQjRsllKOpAg/y1x6mz1TSZu2Qv
         X4Aw==
X-Gm-Message-State: AFuF++kd9d4QLiE3R5yfM4rEMJBPyPt7Cj2Vssg9OTlkM/NNpe0IXSXL
	/QxN42cu52bD1N9tFs8IsYzEIPc6HdHPNlrFUr8uB5qGmNgBnNka8G8sCsJMirQ4E+TVWNDd495
	rwrCeP4hnFINmipqthfHHdU1CWPY2xL65mC1suj97kDYa6n9FAYlVxpN8JBzvlSphdg0ockd8gA
	oR+o9lcEgYOF+cwX95+IL01Xpv/iHax+V42bIsxX7O/rLCFNB+
X-Gm-Gg: AYBFou3/PHqeWgBzUK2CCJV3DVmqpkTdR9xqq1/jIScJH5Zk5OXWwePaabvQAvbBP4P
	QCa6cBXliZuvHATEQTk+BP6nb9fhCIF2vC4sVe92zjCpss5LMAqKxd/LWTOvHknVCknGqsWvyjn
	xj6F8CI8jsLaJSE8IHwLTQW8PTtUp7t4c5iGLkZMwakbXWvnKDVLfvJzF/i2YO7J+RKlB8eJZZG
	IDeO3iI7OFdFW83jgM6XET3pEJsZfVx9GJyYomlMsquyRhC4KcJv9TP4U5YwE63btANKcBjfl35
	MP0lsX5uVLtrS4UO9wkwL6L3GHv5gcONBOSg96gTOh9fyYltOyx7Tkzcm6AGHTetBXIuGVaiclM
	OCq3PRq65IfLehrMjrvUNFBk5ss2oNWScVgcUsg==
X-Received: by 2002:a05:622a:5517:b0:530:e0b4:cc6e with SMTP id d75a77b69052e-5330b6f3f0amr8827851cf.55.1790283869863;
        Thu, 24 Sep 2026 14:04:29 -0700 (PDT)
X-Received: by 2002:a05:622a:5517:b0:530:e0b4:cc6e with SMTP id d75a77b69052e-5330b6f3f0amr8827021cf.55.1790283869233;
        Thu, 24 Sep 2026 14:04:29 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5330c06e5ddsm2112091cf.22.2026.09.24.14.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:04:28 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	Eric Sandeen <esandeen@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/4] blkid: probe_exfat: clamp untrusted label->length to valid size
Date: Thu, 24 Sep 2026 16:02:48 -0500
Message-ID: <20260924210421.3631790-5-sandeen@redhat.com>
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

A corrupted or invalid label->length in an exfat filesystem may cause
probing to read past the end of label->name. Limit it in the same manner
as util-linux uses, and add a min() macro here to match.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/blkid/probe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 87167171..c371acea 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -38,6 +38,8 @@
 #include "uuid/uuid.h"
 #include "probe.h"
 
+#define min(a, b) ((a) < (b) ? (a) : (b))
+
 static int figure_label_len(const unsigned char *label, int len)
 {
 	const unsigned char *end = label + len - 1;
@@ -1535,7 +1537,8 @@ static int probe_exfat(struct blkid_probe *probe,
     label = find_exfat_entry_label(probe, sb);
     if (label) {
         unsigned char utf8_label[128];
-        unicode_16le_to_utf8(utf8_label, sizeof(utf8_label), label->name, label->length * 2);
+        unicode_16le_to_utf8(utf8_label, sizeof(utf8_label), label->name,
+		min((size_t) label->length * 2, sizeof(label->name)));
         blkid_set_tag(probe->dev, "LABEL", (char *) utf8_label, 0);
     } else {
         blkid_set_tag(probe->dev, "LABEL", "disk", 4);
-- 
2.55.0

