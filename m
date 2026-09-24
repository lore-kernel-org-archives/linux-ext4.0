Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEE24DA548
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 21:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283875; cv=none; b=SNmgJ4gmdmMP6pCpGaQ0feVo9zAxpjUaUVm63dGvtIuRH9NoHEQLclaaNeTyOfJ4OhmbAvKJSRe7UX0Vpx3IewSF+yq5wh0oQh6dPtyvVFe27i4mHJrdK2OJuZtR3wLqINpaknKPVDwZNJkvQAmfjckkedKSkERv6gjGfvxBZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283875; c=relaxed/simple;
	bh=mKfrjvrs7nx6YRr4AggLbdGSmMKa6TVZ0OGss+C4zfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFffOqZ2pObx09PRzNTtJnVEIzkTd630kYhUL2x2AoINUSrpcD3uMumzWvmkw4uLrWRUXthYoWLLa6hrawEg9N0iOXr7eZFtvNz6ZGbe2ef7b7X6ETO9XX9QLSa/MeBPLGYUYDdpjLHo8k74x1YPsJPcXLtvVMdDl81+HZGdOqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/6AfcTK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=R18Nbai1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/6AfcTK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="R18Nbai1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790283869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03Qsuh+RzAP2qxyRnLfzz8//ZNYiaVjLtuj1Txhukt4=;
	b=g/6AfcTKbWGBr5BjJ/vtqOdWncvoWdbb5AhahzwbuqhlU52bZviQyW7CuYm+qR6flFS5Je
	jNxbI9SIXx43adR7cwfIv8pnXr3l4D2ZzMixMsjKnK72V6fh51l4sm0tjQiaaOIuYr5ydd
	wEBOy7YMZDPG0XYuo2LmRbW9MvaxSko=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-McNy9qKbM8KYbj3yGFH-9Q-1; Thu, 24 Sep 2026 17:04:28 -0400
X-MC-Unique: McNy9qKbM8KYbj3yGFH-9Q-1
X-Mimecast-MFC-AGG-ID: McNy9qKbM8KYbj3yGFH-9Q_1790283867
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530e5b709b1so5327431cf.0
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 14:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790283867; x=1790888667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=03Qsuh+RzAP2qxyRnLfzz8//ZNYiaVjLtuj1Txhukt4=;
        b=R18Nbai1wZ4h9cCbTveG9w0C2lDwqWNcgjxrrMJXv3fFoEf/MKqONA78BxsEzRyTBS
         OkxWVCRQxoXysLxV1Euorx9R5NaIJSir6DFzuoXVg672bWC7bh1anJjUAEhyRrl+rZMI
         z+AnvxqhaintcQ664m3B7bElfRmknsIik+twRS63TWAjsK75aSko7+M8+enWeQLfU6dL
         PMiBVRZJG40XOy8GCWUtVwVhialo8wmdLzy4F3QPMcxtBiDlA+H0NqUz2Pi6HIgEDvZ6
         AWQjj+q0/25OhRAGEzUsQ2XZotIKPTWxSiaqFsvJrrUELV7uinBtOHxH3Gur509NL4m6
         aFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790283867; x=1790888667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=03Qsuh+RzAP2qxyRnLfzz8//ZNYiaVjLtuj1Txhukt4=;
        b=Zox9tnEV4VTeMzezycZrLU4S9LVGCP0W3YoAYISTbw1WWh1pMosuIKhz2DHfspfLOt
         tbsMJSDvMq8BMS5HFK0GNajm2ML3zkOaqs1xbcW6WrTmjDAaXo2Zq2gMKzYo+KV5ogNY
         mwEkmWw/NnDbVs88GwcOOfMQelE+9Su2ZFQJREmFDzhogMkWSbVVoBhoOfwzm2uhUEyy
         kC9Rt2JHYpSa+u7yUx28yUbcDSrYAFP0xgshO+FTiGHi9nBX8aGfH5nYpVnGk6iJKFAQ
         0sqTN2SQjg3rHeHUm4CJ8IHKR8dveKM4PlysFW1+zbw1xdZhsKQX0dIf2VSemmwIxvos
         wD4w==
X-Gm-Message-State: AFuF++l1zDrxmJHMNw/BEgVBAYC+f0A4rk6cXV7fHNfKlH2IbPfQt3U8
	OQwHtNdPW0ysvmDAdpkJGDtL3+td9LJixxQaUd6cQSXew2zZqtgrzC0V7jUTd9SRkUo3pMeEAIZ
	IFyxdAhAApXbfRSYyeh0D69Vb7m1gLEMUDfTzOseN9e8vdNQQmDBA+ziykhO+u0w4cCtu5TkPq+
	WSJ1JvELs+G2/OGX+uGEMisr/hV3grEqfvgQGctze/bDOLNgrw
X-Gm-Gg: AYBFou1fdDsvxFhA4vgXBPnkDKXv/aHCEWNP12dw9/nBt4k3xgU9976EJIGAjFWc8L7
	R3bVgEibVeDGlxk7aKwIbPin2qCrfKqMLdjtqXA0k7KRqQpLgAZxN5UU/K1F6j9XERltx37EAWk
	IwHIePjLeqOFFJps+b07/BR4nWjfBLHhFFLMa/NCHz4viMKq1FU93QKKd0YaCFr5sAWwvj8Rt1Q
	/FN759CGLjd7OcwiXYVZEqeSOn+QJ5FF1xu+uodrlYhcFsFlOs4UyfDJByCUCsRsx/X8f5sNbmL
	mkHpWZMSQ7ndvSfYegEqwE6MBAAhDtLLeFok7yjBaycakCM9kZA2vv/9VNUZYr1LyGpn531nQCF
	+UBRSQKVxG+acpzWoQPnwBB7h0nIOBz2k0ONuFg==
X-Received: by 2002:a05:622a:2cc:b0:530:d7ef:7262 with SMTP id d75a77b69052e-5330b69080fmr9551301cf.28.1790283867269;
        Thu, 24 Sep 2026 14:04:27 -0700 (PDT)
X-Received: by 2002:a05:622a:2cc:b0:530:d7ef:7262 with SMTP id d75a77b69052e-5330b69080fmr9550591cf.28.1790283866600;
        Thu, 24 Sep 2026 14:04:26 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5330c06e5ddsm2112091cf.22.2026.09.24.14.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:04:25 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	Eric Sandeen <esandeen@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] blkid: probe_ntfs: validate on-disk attribute size/length
Date: Thu, 24 Sep 2026 16:02:46 -0500
Message-ID: <20260924210421.3631790-3-sandeen@redhat.com>
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

Ensure that the attribute length itself is valid, and that it does not
extend past the mft_record_size, which would result in OOB reads past
the mft buffer.

For tidiness, move attr_off advance to end of the loop.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/blkid/probe.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 31d048db..ae769a77 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -751,16 +751,22 @@ static int probe_ntfs(struct blkid_probe *probe,
 	label_str[0] = 0;
 
 	while (1) {
+		/* Don't read past mft_record_size buf on invalid offset */
+		if (attr_off > mft_record_size || sizeof(*attr) > mft_record_size - attr_off)
+			break;
+
 		attr = (struct file_attribute *) (buf_mft + attr_off);
 		attr_len = blkid_le32(attr->len);
 		attr_type = blkid_le32(attr->type);
 		val_off = blkid_le16(attr->value_offset);
 		val_len = blkid_le32(attr->value_len);
 
-		attr_off += attr_len;
+		/* Attribute length must be at least as large as header */
+		if (attr_len < sizeof(*attr))
+			break;
 
-		if ((attr_off > mft_record_size) ||
-		    (attr_len == 0))
+		/* End of this attribute must be within total record size */
+		if (attr_len > mft_record_size - attr_off)
 			break;
 
 		if (attr_type == MFT_RECORD_ATTR_END)
@@ -778,6 +784,8 @@ static int probe_ntfs(struct blkid_probe *probe,
 			}
 			*cp = 0;
 		}
+
+		attr_off += attr_len;
 	}
 
 	sprintf(uuid_str, "%016llX", blkid_le64(ns->volume_serial));
-- 
2.55.0

