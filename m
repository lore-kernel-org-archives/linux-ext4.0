Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512C3CDBAB
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353421; cv=none; b=kpDhe43sGgYYBWSXKr3k6gRxs3BByw8JWu29xaAjjU2tZI5urYB285Nl2Q80hHDCmdOgRvpd9SPStuxq61XYBZIGaTcIJDcR3gVrI7KzZkRHGIWtyLRY7EAaz+bxcjtGl1qs16BhEx+z49nK6EW0S0EhKa92tu3mmSS8dX/jaOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353421; c=relaxed/simple;
	bh=opq3fTnsrXEXUis6orE/E1kvybn4ouWYX+/mNx4cXic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twqw/P2PhxdhJlGuuMQj+NkN/OdEWuJAdObLThSAHdEZoojaGvmWxkVRf2kG2cRRUauZ9g+poG+fKaQZakHOSFTu2k7jkWwAh67ZYmPMBAWaD4bu+XKykcPXXBKjmBnZsbPf9h4pFhZHoQ+Zl2pOUkjneiUP+tpBDgQYunI/grM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zh5YtyeR; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zh5YtyeR"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cf50c6f235so15183595ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353408; x=1785958208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hBriYrscy2lsMSBh5lhjAC8bZyEaS+6CxeuOVAvAWO8=;
        b=Zh5YtyeRdFl0TL6zqUNOvTlh/FQJRuMv3bQjVS2hInJqVcJWfAIN51ByLZ6z0zIFQj
         SFzfl2xbCtrZn8nK/OIiwahbR1cMT5zkm9JCSkqARsueJ7qkERpkTn/afsLjLejK4Rj1
         hMfC+83juxq9irK9M4+RJm1j4QzcrDHumL4dAVRTGZJThaaVIZINXB3ZsxKgZ7K9ro5/
         J1soiI+zQ8LInWBMVjLasKjU/WWcYzoN5O9W1Ka4DpJVgabiZfMGKQHTFAoKklbKRSY0
         0qVQBE/rhFNNZdWF4epHsMS6kXSSvaNUOgEuy3Xa5Gt3e++edLV0Cq9Nc64BoBLtC9Ta
         DHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353408; x=1785958208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hBriYrscy2lsMSBh5lhjAC8bZyEaS+6CxeuOVAvAWO8=;
        b=VS0CoXCIgimMqklnvat9svvVFYeChraXr+NW6GUCVjJwzrW5tdzFW6bYBeNlmXRjpw
         gSp2C8qcA8+wC/Bj5zmQBrrReDd37gTwNvm3Bs+MSr1bM6QmEf/nMimRzHziTgrSPRPw
         lw9bUGNcdNSE5oDHzVF9oCm0QUjxxP5xLAZ2l+hDN+G/psoi+JrCkMrFS3ZOvSLXxyT/
         dgGO/gREPvR5gyKjALVNpf9P9TPS+1zVXVmBbt8ASZALjbgFMKspESLSudh4KgL1ELkx
         asqWNvG3EwI199soBBehjC+xHNbYxm4EA+Ql25WFl+aU/zZV9inZbik94ap4qRECjONr
         n43w==
X-Forwarded-Encrypted: i=1; AHgh+Rr8ZdejM9YWb7sejl5+o7/497peWcf6W4LFYNhTcDzOv6WjBf3wHYIVSl0tFUSjShj6ZeJzFq6ZCoKj@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy1Jijr5nZUR1NXqvASXt0lPxxn612w8DG1hwbrFslhZ56S+A2
	JE85tKbODIuTXPSqtRguyp94ElrXbchXf3pojAAcFqVMZR4LhFd8WYpz
X-Gm-Gg: AR+sD12gbGuovm9tt72IH1/o5Q9hvSYPDhU1TndYRJyHxKwy4RuI9h+UaBbjxUqF+3V
	9WDgUiOXf2Kt78nWh+w+iTpOK/+olSderqeBBEW9zrltIc07FeuVnmNBNKaa6FBZreVI7jlXhj+
	fO1CpO17/JP0LnqRH88XcULkDNKdbz9b7QRQCqhaAYQk6EqUi+zAM5qQfHQ7722MetPTFn1lJ/V
	K0W2DobyhQwxGiWqoAAS2vRSRjM2PTI28tTzvC+aOuGYcj/fWWATqSGNmOAMD+7d39wGZyy8kh3
	lisEtYWv60QcrYVbWTZMofarYEw7attwb/9/pB3UQCBgBJhCo6Br8ZbtYzTlTwoLdTKmSPehZbM
	GetNLG9bDFBH27Fs1yenDITICUNX1L1kWRZcOKiKxiHkhmKPFdbqcHdctYu3fxw4RTbYjz3bJeP
	RUr9EPkuo1QoMoLwGY0FDcoZe7oQQqzhdHoDbsiuPnZcycmFfPkNmRxO26Fc+DO7upj01d1fB9e
	YXibjiN6I0kQVGdx1JO2jdTbbG5Rns4BbLfVuU=
X-Received: by 2002:a17:903:32c1:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2d0339fa521mr1833455ad.8.1785353408486;
        Wed, 29 Jul 2026 12:30:08 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a15885sm16022595ad.15.2026.07.29.12.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:07 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	hch@lst.de,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-fsdevel@vger.kernel.org
Cc: changfengnan@bytedance.com,
	kbusch@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	David Sterba <dsterba@suse.com>,
	Gao Xiang <xiang@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	bfoster@redhat.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v5 09/22] ntfs: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:24 -0700
Message-ID: <20260729192737.3190206-10-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260729192737.3190206-1-joannelkoong@gmail.com>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ntfs iomap_ops to the new ->iomap_next() callback. Each callback is
generated with the DEFINE_IOMAP_ITER_NEXT()/DEFINE_IOMAP_ITER_NEXT_END()
macros, which wrap the iomap_iter_next() helper to finish the previous
mapping if needed and produce the next one. No functional changes are
intended.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ntfs/iomap.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index 52eecf5cb256..d0964ac840d9 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -277,8 +277,10 @@ static int ntfs_read_iomap_begin(struct inode *inode, loff_t offset, loff_t leng
 			srcmap, true);
 }
 
+static DEFINE_IOMAP_ITER_NEXT(ntfs_read_iomap_next, ntfs_read_iomap_begin);
+
 const struct iomap_ops ntfs_read_iomap_ops = {
-	.iomap_begin = ntfs_read_iomap_begin,
+	.iomap_next = ntfs_read_iomap_next,
 };
 
 /*
@@ -329,13 +331,17 @@ static int ntfs_zero_read_iomap_end(struct inode *inode, loff_t pos, loff_t leng
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_zero_read_iomap_next,
+		ntfs_seek_iomap_begin, ntfs_zero_read_iomap_end);
+
 static const struct iomap_ops ntfs_zero_read_iomap_ops = {
-	.iomap_begin = ntfs_seek_iomap_begin,
-	.iomap_end = ntfs_zero_read_iomap_end,
+	.iomap_next = ntfs_zero_read_iomap_next,
 };
 
+static DEFINE_IOMAP_ITER_NEXT(ntfs_seek_iomap_next, ntfs_seek_iomap_begin);
+
 const struct iomap_ops ntfs_seek_iomap_ops = {
-	.iomap_begin = ntfs_seek_iomap_begin,
+	.iomap_next = ntfs_seek_iomap_next,
 };
 
 int ntfs_dio_zero_range(struct inode *inode, loff_t offset, loff_t length)
@@ -764,9 +770,11 @@ static int ntfs_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_write_iomap_next,
+		ntfs_write_iomap_begin, ntfs_write_iomap_end);
+
 const struct iomap_ops ntfs_write_iomap_ops = {
-	.iomap_begin		= ntfs_write_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_write_iomap_next,
 };
 
 static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
@@ -777,9 +785,11 @@ static int ntfs_page_mkwrite_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_MKWRITE);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_page_mkwrite_iomap_next,
+		ntfs_page_mkwrite_iomap_begin, ntfs_write_iomap_end);
+
 const struct iomap_ops ntfs_page_mkwrite_iomap_ops = {
-	.iomap_begin		= ntfs_page_mkwrite_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_page_mkwrite_iomap_next,
 };
 
 static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
@@ -790,9 +800,11 @@ static int ntfs_dio_iomap_begin(struct inode *inode, loff_t offset,
 			NTFS_IOMAP_FLAGS_DIO);
 }
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_dio_iomap_next,
+		ntfs_dio_iomap_begin, ntfs_write_iomap_end);
+
 const struct iomap_ops ntfs_dio_iomap_ops = {
-	.iomap_begin		= ntfs_dio_iomap_begin,
-	.iomap_end		= ntfs_write_iomap_end,
+	.iomap_next		= ntfs_dio_iomap_next,
 };
 
 static ssize_t ntfs_writeback_range(struct iomap_writepage_ctx *wpc,
-- 
2.52.0

