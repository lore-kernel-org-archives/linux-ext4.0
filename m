Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2139318BB3
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 21:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283875; cv=none; b=jmvgqwGZm6XjUSLuNGyhS2rW7J0A5IA+HUjvxRxG7Yadm//uv+2Lkb2ajCVnpCfHNa7C1UBy95GoKbExzndM8eGIJbEdijS6bsZAZfrfOuywedxn2o2W23VrPe0jQ7EDjj7UTav5gFF20iRR8pd3Tp7Ym0MscVP6/YZkLFV/VWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283875; c=relaxed/simple;
	bh=Ol4C/zff9kZJf6qBK0oZWG2rXKyYAp4IbCox1X3gWzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPz5XAFOW6h9hmGXhloJUsGvelITq4Gs0/uqGPywUFvYNgMC4M7oN+neGJB1i3Ro/nFLNB0rlKCxz8fJsrCTF38dHJW0Xna7ocJUA/uCZXiQ2TjN1cGVFvV2/FUCIhxQUHbgodN4ql7/Lu8a4R6WTnYsK+QqmXIVxHPCRGKPO5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aahTHjBH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ah5jVKeR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aahTHjBH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ah5jVKeR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790283870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Zt9gUNeOKPrdTfiRKc8EciOISO0/eSZXG9YD+0Ggig=;
	b=aahTHjBHkPg+L+o95SKtUyxuW3+9lqPhCWcgQXnwK7zbRM+8AjOhWkkti1QjOcKI0FzZt+
	PRzulTOPiybaADVIIP5C5xYBJuv6eVEx+8oiNlEW3LY1vpkbEHoogvcEcuVSDAdOueHpgk
	tV2oudRX6BqjsTIt/r4KXKj+K0qk5wQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-9JQFkp_NPlK2ApkdtfXyIQ-1; Thu, 24 Sep 2026 17:04:29 -0400
X-MC-Unique: 9JQFkp_NPlK2ApkdtfXyIQ-1
X-Mimecast-MFC-AGG-ID: 9JQFkp_NPlK2ApkdtfXyIQ_1790283868
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52fc0097865so6388711cf.2
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 14:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790283868; x=1790888668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Zt9gUNeOKPrdTfiRKc8EciOISO0/eSZXG9YD+0Ggig=;
        b=Ah5jVKeRyjPt0Ti0MGp7eUYFzQu7XAeumFO+qXi6VXO57zUsZAt3X2M9b1CVo9AcTp
         166JUsjI6sArmiJ+1SpFV2EB25wFcLTvFdnF+shNRpWRGnjAbkeNSosc9cUFSBkz+baY
         vR0kKPzGTRP0xGPTI6c+5hIhFoSw4PNjlZRY5+Ohsod7VUF8AjQlw+QUWH1CAnr8+2fm
         /StLezr2qR9vxVh/RGIdWdl4rToG6Siq7ReTBNya5EOS2D1KKXgLWm4SudmvcNojUGAg
         ipNzP/K+9nPnQx8/NzuKsxnvnklaFuNS0zaIghuyKUKjKMfjQpwmTkEGCz6Dns5huzww
         8dVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790283868; x=1790888668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Zt9gUNeOKPrdTfiRKc8EciOISO0/eSZXG9YD+0Ggig=;
        b=1YDSUiitDtZTxtpsazgafdXNWtiLha4EG2oChIRjcmwrQkPMkEtgR58z4hJ+FuMS7K
         QIcj4uV3D6H9IU7f1YRrn7UIUC0lD9r+DjkhiqfRh17byTGbeR7aMmWSLqsG60CsChu5
         8BvqJNTMjGY2rC32EULNy1ugn92/yekDYABnhlXPs+hlCLI3EGUZfoydnPZDIC1b/Cck
         JWce88btgMGVN7vmazM/TJyPTBPZjbkgHLOBzt7Gh4zU4T+BB+MSWCNkJsVKK/wvBMbL
         Y1d6ju0BhxXlUQ2j+EHPWHjbHRFQrDKcYReK0SU0U935rVzn642LCkU4gA3kmXafBEbR
         Unog==
X-Gm-Message-State: AFuF++m8UvsbMdGtrA+SzWNDJ699HKdhXAsIhNkkEEc76NjJX5duefoW
	YoLqlhYBJD+SU2zGE+QFAJXnYSOVCZH/7IMYNABqLoV7pbKO4juQNNuM7HGJ3EHQQ03vmVnkySd
	cZ45FuhcD4kCKyxLx3qWiYc6DgSJnTBp/H5dyeJqhEyO1EGp3CirQZjp0QK1/F4QC5IFmylULfK
	rH+CsZV7rbkGRBCcbo87fJOAYaeqcc8hTsG/u+02HMCqUf9iRa
X-Gm-Gg: AYBFou0ao0uMFqNrzlLYqqMayydsS5LJu+o79SoLkF2/5AUgk8en11h4bl4eGBJx4pw
	bahsyIggLHhP4XHe29wWe60DUVXpRkK2IIv8V4BpmWT+uAvayUHdYFmJ1Izrw2SbKOAtjJld+CU
	Dus56JWTwbbq1eMz6V/zEQ5vkJeePxcTJiNDvulDNy/+o78OzKegExu6bCZpW484skxov/yY62K
	rH867UoRkm8GZpu1G12YGVfLGGbICA7wDlHOHolY/iBi4+FKODkC/DzokDtENouZT3si1t+6aLA
	yybR9CuUKHKUXuJEoa0jFlD4hhZA/YuIc4mxph1KJRw/LbYVVwvcKxQ/eS0ZGVXkrJzx5M6qlI+
	5eowVCsdgIh1X9Z7Noss/QlaJkqT9G4NAJhA9Hw==
X-Received: by 2002:a05:622a:4d0f:b0:530:d1d6:792d with SMTP id d75a77b69052e-5330b5b8736mr9335741cf.15.1790283868437;
        Thu, 24 Sep 2026 14:04:28 -0700 (PDT)
X-Received: by 2002:a05:622a:4d0f:b0:530:d1d6:792d with SMTP id d75a77b69052e-5330b5b8736mr9335021cf.15.1790283867807;
        Thu, 24 Sep 2026 14:04:27 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5330c06e5ddsm2112091cf.22.2026.09.24.14.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:04:27 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	Eric Sandeen <esandeen@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/4] blkid: probe_ntfs: validate offset and length of volume name
Date: Thu, 24 Sep 2026 16:02:47 -0500
Message-ID: <20260924210421.3631790-4-sandeen@redhat.com>
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

Ensure that the volume name fits within the attribute offset

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/blkid/probe.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index ae769a77..87167171 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -773,6 +773,13 @@ static int probe_ntfs(struct blkid_probe *probe,
 			break;
 
 		if (attr_type == MFT_RECORD_ATTR_VOLUME_NAME) {
+			/* Value length must be multiple of two (UTF-16LE) */
+			if (val_len & 1)
+				break;
+			/* End of value must be within attr length */
+			if (val_off > attr_len || val_len > attr_len - val_off)
+				break;
+
 			if (val_len > sizeof(label_str))
 				val_len = sizeof(label_str)-1;
 
-- 
2.55.0

