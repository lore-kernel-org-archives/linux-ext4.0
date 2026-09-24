Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F0640A926
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289000; cv=none; b=bGEMCgULIbW6djiy5F3Ao0VtzMWAKAzI1V6MTkGWc7Kg6aYcvVwyv02u47lnKugWBv10r/9Q+Za329Dz1tdAe2qgwW6b8mqF0/WDVPr3KyRPVtHWdXqx+NSXm4dZ3232Ci7YPg5Gpyv5++04gmZqaMxSWr9Y2Pp0aO09rRH+WSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289000; c=relaxed/simple;
	bh=IQZ5Qz3B02DHilP8/lrHynVk/gWCWnZRlP5K2MsqtuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVm58Db3SCQvcNnhzCTOkwe71wuW49+S7QcGtRLNn0FJeedSrBD9pj15DANaUeAjDpbDAm6OD1GgYIlC01U7DU0FqQT0726Jg9d3bAil5Z+qW7Oo+c9tJeaQJqHleTSZsqT57JjPJ9h32QxzosFs6sf+fnYe3OIipdHQREZucC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I/mAihiN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYBLjAQq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I/mAihiN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYBLjAQq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JPbKcTBOygIosoT5NJIzt0x/bV8oQDNYyTuHPzROr4=;
	b=I/mAihiNIPVUz6mZpa44Za2iOAKyfStWhOCj9ZDiBv5/HcPJoDfqFMwQw6ksGYYTXCmVud
	W2wghTMRVVjCglnk0ctdQdeF/+VjOcQdigEOqr9SrtoWa0DCzBGg7Nstpf63jDuevvE7wH
	9OeG+h9vMyegBQZ97uYTbo0Uqw9bk6c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-SYxe64uDMUajuuYBmxTOQw-1; Thu, 24 Sep 2026 18:29:56 -0400
X-MC-Unique: SYxe64uDMUajuuYBmxTOQw-1
X-Mimecast-MFC-AGG-ID: SYxe64uDMUajuuYBmxTOQw_1790288996
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ae8e7e546so59587185a.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288996; x=1790893796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/JPbKcTBOygIosoT5NJIzt0x/bV8oQDNYyTuHPzROr4=;
        b=GYBLjAQq+d5u6do1eLJ3ESihX6qUNACW55NhFnZjDJvxq60VRFeoGnsUY62ynSIEHi
         sOHG+UdUNqinpVVBIbVOgd3gqeAOyQ7MK4VlCOTqVh6+r9W1m0JZ1NK2RD0Q00eQx8XI
         NSazJM17TYDR/c1GAFuMplU8OAcZnHlvKSZmuLstSjZiyAuAALVKHnE2wkWZBLokNg2/
         glnsaZhWQiaPB62cOsVvoyowMUYLur16qytHUAWOtmgInxjfysZ89X2bm0RJQIbH0xEm
         x42vPHs5CYjypTUKCnzLFqK5dc64+nw+EvUXIg/eB+v3f99KYC5Bc/ioOmVWhC3+RBCj
         3wWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288996; x=1790893796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/JPbKcTBOygIosoT5NJIzt0x/bV8oQDNYyTuHPzROr4=;
        b=xlE2ggeEKmeKpsENEMOoYyk9SHG05l1NppFJeRTv0d4tF5nbsjwKs4vXe7/SRj0G+U
         KoZhQ6AA7rYAESXd8vl3Hr8HO6ufD0G/JaGErxSSezF9zXRJmdqghKXQAakzrxg+yWmJ
         NDn664/Vbjgcw0fzOAoiX8cBNtCvGFZgouCeHZ+KU8/TNRiOeVBmLtpNxg86q+SgsCz+
         kaVrnUEtZFMBUeaGFRYBAUzfs2t7QmaQ2ceuGMsB3e7LVwN9JgkZNmXha9tvKcpkDaKm
         nlIxWXFUvA08zEOxQB0Wtwvb8Qwsl0H0peeL9floXB6iqC7q29Ts9T/eg27TANbmMC02
         ueeQ==
X-Gm-Message-State: AFuF++lsO4akyQghQonCZPXNUEqPgu6IZXQRFqEQNUaL6Utj1+jsczQR
	49x63L4B1d3LqtRAXUblhPIrcdcutALDc9AolGAXAwe47FER76dTptQI5RdDoKLiiVw5AjC2u/S
	mrzvk/tEoOJo4S22OXoaq8f7JmsPVAtT+lVgB9pY0jtsgc37dLdU29Ni/elvASYUXFN4zfUxTWQ
	3sW+DlRCiFDwaRNmRhCkcb6Hk+WxhaSET8aC7GtOjtZ45ABDfj
X-Gm-Gg: AYBFou3ipVtvd1UZrKIxr1DmTFO+vD+i9/z5M0OIIDaQa/u/BDb1XUReUJ9WPocn3Es
	HeBHtOPAB+h6kUCXorIZpLEC4fNCeYCQeY2vra3UwOO6HPb/eDE6StYoMVXD4e682soOKuDr2ol
	6xtQZNqDbqVbWhfYa8KdaVqz9LTG7nfJMPfcsVPhc2889ad9/6MsmZFJG+vc9RyJysvVVWIU6td
	51Uri4+Sh+V+Tl2t4kbe4qncqEiRcWxBOnJCV+50SGEcaxotpUjsSaG8toZzI0l79DHHhdjVmwa
	a7miS/vvCzSSEgYW5i70fKY1a3g4x+FdD+7CIo7aH5dzEdtlZGt0P2b5KI44i6HIvN4hvP8yrV5
	lskeDx4+4Kp+S2qg1OJKzvejTjkScZT0FhzQI5w==
X-Received: by 2002:a05:620a:414a:b0:939:9b1c:ea4c with SMTP id af79cd13be357-93c43bc93b2mr151443385a.28.1790288996044;
        Thu, 24 Sep 2026 15:29:56 -0700 (PDT)
X-Received: by 2002:a05:620a:414a:b0:939:9b1c:ea4c with SMTP id af79cd13be357-93c43bc93b2mr151440685a.28.1790288995533;
        Thu, 24 Sep 2026 15:29:55 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:55 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 8/8] libext2fs: fix ea loop in ext2fs_xattr_inode_max_size
Date: Thu, 24 Sep 2026 17:23:42 -0500
Message-ID: <20260924222944.3683556-9-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924222944.3683556-1-sandeen@redhat.com>
References: <20260924222944.3683556-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

Fix the same problems as in check_ea_in_inode().

Found by AISLE in partnership with Red Hat.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/ext_attr.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 6f6d2f4f..f2ac8911 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -1211,8 +1211,8 @@ errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_ext_attr_entry *entry;
 	struct ext2_inode_large *inode;
 	__u32 ea_inode_magic;
-	unsigned int minoff;
-	char *start;
+	unsigned int minoff, remain;
+	char *start, *end;
 	size_t i;
 	errcode_t err;
 
@@ -1241,14 +1241,25 @@ errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 	       inode->i_extra_isize, sizeof(__u32));
 	if (ea_inode_magic == EXT2_EXT_ATTR_MAGIC) {
 		/* has xattrs.  calculate the size */
-		start= ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
+		start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 			inode->i_extra_isize + sizeof(__u32);
+		end = (char *)inode + EXT2_INODE_SIZE(fs->super);
+		/* take finish entry 0UL into account */
+		remain = end - (char *)start - sizeof(__u32);
 		entry = (struct ext2_ext_attr_entry *) start;
 		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+			/* end->e_name_len is within the first four bytes */
+			if (EXT2_EXT_ATTR_LEN(entry->e_name_len) > remain)
+				return EXT2_ET_INLINE_DATA_NO_SPACE;
+			remain -= EXT2_EXT_ATTR_LEN(entry->e_name_len);
+
 			if (!entry->e_value_inum && entry->e_value_size) {
 				unsigned int offs = entry->e_value_offs;
 				if (offs < minoff)
 					minoff = offs;
+				if (EXT2_EXT_ATTR_SIZE(entry->e_value_size) > remain)
+					return EXT2_ET_INLINE_DATA_NO_SPACE;
+				remain -= EXT2_EXT_ATTR_SIZE(entry->e_value_size);
 			}
 			entry = EXT2_EXT_ATTR_NEXT(entry);
 		}
-- 
2.55.0

