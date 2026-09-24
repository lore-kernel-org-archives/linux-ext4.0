Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC63401A14
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288993; cv=none; b=TcL3sdcyKX5FOmNu75v/RRIUChZKdddCevC7xW4FL8fyTyh8ueSFnA72ZEO9McU89gB+38m27Ey9Cr5BponzTaCBYAa6gsseeQrbe2UKBp1gTwKl+9ZPoNO13d7QYfk2GcaATnfEAW49EYIBwwXrauS+2xfga/Jg25tP2qUbTJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288993; c=relaxed/simple;
	bh=YKewhQV3t+qXR7VOIoLQfn8r58VjM08NCAraoc9ncrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn+dSLrlt4yFmsNXemqyvwAXEL+dWgvhHJs+RG5JAdnhhWZ64nKzPautbhdwpbmM08glMsvbBilNI85ySh4jEQOtqY8nQLdoZIY7h/lxyb70f58QevHim3wPZEh/YUj6eVK4QpJ9WgPtDfBEgzr3BG57vTRaaQpvi6iIZcG1hBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnoJfrRl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dQknURvo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnoJfrRl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dQknURvo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790288990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTB2RO/CzG7LyVzrq9FrGnKwZC4VXatX5TG2iW5jeXo=;
	b=BnoJfrRlWozTkDUBTNME/RhjQ+pCiNWOHY/bLVZuNQv32F7HLFC5U1nGIRxkbxqiF/p1kC
	bBkl9m17UQqBUxvqk84IeCL/jRWFCIXOK76za5HTxK/Czg7d3beYYo05mVh0KXDE9Smq5d
	J+8e+jv47bDlJViDe/4YTafy/lNg89I=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-S-O1j5vdP0m9ITuwaYRekw-1; Thu, 24 Sep 2026 18:29:49 -0400
X-MC-Unique: S-O1j5vdP0m9ITuwaYRekw-1
X-Mimecast-MFC-AGG-ID: S-O1j5vdP0m9ITuwaYRekw_1790288989
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93bfb2da664so81716685a.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790288989; x=1790893789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rTB2RO/CzG7LyVzrq9FrGnKwZC4VXatX5TG2iW5jeXo=;
        b=dQknURvoGanRSkMGtcD1VEtR4nHKYt0wUTmOhTjEDZs1uroJi3JhE5AZ9SMzr6O0zg
         Rqdmt3ADv3kkQr3PUS09RE8XANh3+9gCQP4hlFBcSNbOs20DEWicWHoINQ8IPOtghoJE
         rflVxLTgEfg4mALfc74RtPfov8MS/c/o9tFNcdTS01tWaAMSRy1a8Hn+nLl8WBa78A5X
         LtAki5ZTO01v9rttv429PvdgShNthDDnkfPOHr1Uy9caGVU1o0abyK40n1YNlfZfXpOe
         IAKR7oxKOaKGKXCLskE0wF7VB7jZ+jyBJ0zTdOKWsi4IK/j1sb8YaFTCz30G74X6xrbl
         wsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790288989; x=1790893789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rTB2RO/CzG7LyVzrq9FrGnKwZC4VXatX5TG2iW5jeXo=;
        b=NjrMUDKAxkx4xMjqdK21UzeUouyBhDIhyfWr+MKO3BmpfNy5JDnNj4df7ikx6tLPFl
         6veDJBuVIl1srsKVfMerhvCDb/8EbakDTXcItyI9veZuLD7GZPcY96uR/WKMdC+fax94
         DrGoJdWRZ9rg3ql6tE5x+zaHqtMyCce9/XbkUxgSKpZJc2MH9dw+1DQBnmOB6A/n08XL
         7fqZ5Hqay6TRyUFdsTqlJDfLdbca6DYc/TIqD5mFe8FIDQMtDjD+154qtbF0qRitztdP
         blrBQDPnD5qiJXW0cBVpaj882N+eCfxzg1mCysIm7FyyN44PM7/uTToISitBoZqYtSMW
         T9GQ==
X-Gm-Message-State: AFuF++l/j4BcB0eiP/B2K5naSSv5LRgVStRDuUM8ffqWQlyVML+o3SEi
	zov8MNxshBVFQeqOeC2FkoonKpLWxQGPcXbIi79rJkr8P1fwBpWqRH4g6ZVMhHuqj5fGNXxizqS
	GxvfYLS3s1xP9QqRJ9xIeiHkZRXoZgPdbO8BUEarRV3M21Nmyw0w5kW+cBjJNbs7O8m2z59KGmm
	8TAuB8HXDhFEyUabx1Ue1hP+4Tap2aZrPIEYMoH5cGbkqfJInQ
X-Gm-Gg: AYBFou1KLQnT7aKQBTJJOyGKzLzdW/oKv1w3jpR7K8Vh5JMAMcUPyl0GZoMEDK7ers/
	6/Jfe9dIsVfVycBuEsGURefULRiGPsGROE/IAgpAH9ntI8mVSUDhL1pMIP+DmuXDZmcHufssGsE
	1QQqTnQQb8IZEWPxwSKrQ/X98Mm7nWac1+3DLt+Ky6sP4vKSayFzriyP3ZtV8D7FHCwpIQPf9jj
	yRGvYHgCPIsu2wrjaI7bP/sMr903P6Ayhhl+6+1196Yr5GMj6yeW4uB1PB+7YSsMWfO/6aIeBaa
	0utNUnJxcutBTqayY1nWSBQxIg+Qq35er11Li5C+PQEs5NKSD1ATBo8xil3c8ceCCpua7l7huYq
	aJOOpzXtkQ9q+qEZB9oyNjuFrzhFCNd5/KX4Fmw==
X-Received: by 2002:a05:620a:1d05:b0:93c:739:dd5c with SMTP id af79cd13be357-93c4738b2e3mr30115685a.25.1790288988954;
        Thu, 24 Sep 2026 15:29:48 -0700 (PDT)
X-Received: by 2002:a05:620a:1d05:b0:93c:739:dd5c with SMTP id af79cd13be357-93c4738b2e3mr30112285a.25.1790288988306;
        Thu, 24 Sep 2026 15:29:48 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c44972febsm37216985a.39.2026.09.24.15.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 15:29:47 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	sandeen@redhat.com,
	agruenba@redhat.com
Subject: [PATCH 1/8] e2fsck: fix in-inode extended attribute checking
Date: Thu, 24 Sep 2026 17:23:35 -0500
Message-ID: <20260924222944.3683556-2-sandeen@redhat.com>
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

Extended attribute areas in inodes and on separate blocks are stored in
the following format: (1) first comes the list of name records, (2)
followed by an end marker, followed by any (3) free space that remains,
followed by (4) any attribute values that are not stored in separate
inodes.  The name records and values are all variable-length and 4-byte
aligned.  The end marker is mandatory.

A lot of the loops iterating over those extended attribute areas get this
wrong.  This patch fixes the loop in check_ea_in_inode:

- First, we can safely assume that the total size is at least 4 bytes.
  Take 4 bytes (the size of the end marker) off of the remaining space
  to make sure that enough space remains available for the end marker.
  (We can safely assume that the total size is at least 4 bytes.)

- Second, at the top of the loop, we can assume that the area contains
  at least an end marker, but we cannot assume that the list still
  contains an entire ext2_ext_attr_entry header.

- Third, since the loop condition now no longer checks if we have a
  complete ext2_ext_attr_entry header, check if we still have a complete
  name record of size EXT2_EXT_ATTR_LEN(entry->e_name_len).  The length
  of the name is stored in the first byte of the entry, so we can safely
  access it.

- Fourth, value are 4-byte aligned, so take that into consideration when
  calculating the remaining free space.

With these changes to check_ea_in_inode(), an 'Extended attribute in
inode has Aa namelen which is invalid' error is detected before
allocation is checked, which masks the previous 'Inode extended attribute
is corrupt (allocation collision)' error in test f_inode_ea_collision.
Adjust the expected test result.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/pass1.c                      | 32 ++++++++++-------------------
 tests/f_inode_ea_collision/expect.1 |  3 ++-
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c9711446..555429b6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -501,36 +501,31 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx,
 		goto fix;
 	}
 
-	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
-	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
+	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
-		if (region_allocate(region, (char *)entry - (char *)header,
-				    EXT2_EXT_ATTR_LEN(entry->e_name_len))) {
-			problem = PR_1_INODE_EA_ALLOC_COLLISION;
-			goto fix;
-		}
-
-		/* header eats this space */
-		remain -= sizeof(struct ext2_ext_attr_entry);
-
-		/* is attribute name valid? */
-		if (EXT2_EXT_ATTR_SIZE(entry->e_name_len) > remain) {
+		/* entry->e_name_len is within the first four bytes */
+		if (EXT2_EXT_ATTR_LEN(entry->e_name_len) > remain) {
 			pctx->num = entry->e_name_len;
 			problem = PR_1_ATTR_NAME_LEN;
 			goto fix;
 		}
+		remain -= EXT2_EXT_ATTR_LEN(entry->e_name_len);
 
-		/* attribute len eats this space */
-		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
+		if (region_allocate(region, (char *)entry - (char *)header,
+				    EXT2_EXT_ATTR_LEN(entry->e_name_len))) {
+			problem = PR_1_INODE_EA_ALLOC_COLLISION;
+			goto fix;
+		}
 
 		if (entry->e_value_inum == 0) {
 			/* check value size */
-			if (entry->e_value_size > remain) {
+			if (EXT2_EXT_ATTR_SIZE(entry->e_value_size) > remain) {
 				pctx->num = entry->e_value_size;
 				problem = PR_1_ATTR_VALUE_SIZE;
 				goto fix;
 			}
+			remain -= EXT2_EXT_ATTR_SIZE(entry->e_value_size);
 
 			if (entry->e_value_size &&
 			    region_allocate(region,
@@ -571,11 +566,6 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx,
 			ea_ibody_quota->inodes++;
 		}
 
-		/* If EA value is stored in external inode then it does not
-		 * consume space here */
-		if (entry->e_value_inum == 0)
-			remain -= entry->e_value_size;
-
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 
diff --git a/tests/f_inode_ea_collision/expect.1 b/tests/f_inode_ea_collision/expect.1
index a67a5f19..dfe49a9f 100644
--- a/tests/f_inode_ea_collision/expect.1
+++ b/tests/f_inode_ea_collision/expect.1
@@ -1,7 +1,8 @@
 Pass 1: Checking inodes, blocks, and sizes
 Inode 12 extended attribute is corrupt (allocation collision).  Clear? yes
 
-Inode 13 extended attribute is corrupt (allocation collision).  Clear? yes
+Extended attribute in inode 13 has a namelen (98) which is invalid
+Clear? yes
 
 Inode 14 extended attribute is corrupt (allocation collision).  Clear? yes
 
-- 
2.55.0

