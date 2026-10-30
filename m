Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793329059;
	b=yqSou5VGGcrePRNoVgXPgFmjDuNBwKztX20nsqC2LvxVT/ann0ttieLSjeFOvmgK0lNN
	 JxtEdE6RyC5Evq1Lpg1gcGY88oYy5c6GBHzYAG2iFZyq44FtWIcmQ9upuvR5cab6K5V4h
	 fEXh46rdqZy1cNjnq91KecKpSwDD9xqaI2VSUeD/OlBv1VoEHH1SHb807eXXtwyrRwK1/
	 gJKzQZG5JsPyphJRyt9r/HQgiQjGcCzCuVyaE/IdCdxjHgQtVnzHdbILZhdn5cHh3p+f0
	 wtap0fOi3ia9OuWNGSNOOnUl/thF6oQw7rAAS2f0BjGZ3nZWyEovIMnBQ/h00YCLsUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793329059;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=R29eOO7MluwzQ+8n9YmxiuPXIbP8eqbXNdA0VYXai58=;
	b=ZwEPXQtwQdZzhPiDkj5U8H4PJ3VkFNDFJEDODF8NwTc3vMZizKkgN9QjScwL8AvC47s6
	 zkzrC0BNAAcJh7kFgpty/S2TuWyx2swO4vaSqkPe3W9UBWpFcYejr4/VpsVPEpdKuXRZz
	 /tcHm+em3v3UdJ+jZsapXQh1qziVppCROfP/zDT3SrcewImSXL8BSQcXEEss8/ib1I6Y+
	 Tkje9UKUwyWX2C2oja0fpO2kdF+b4evb1CjEG7eNs64I0GH/PK7xiw3AaATiPUe4Qn7sY
	 6OJVL1OtsV/h/DnktoLltFFM179m3+cd91cszFTodvMV5HIgrFA0giR+B2PQaz8UO7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unc.edu;
	spf=pass smtp.mailfrom=cs.unc.edu;
	dkim=pass header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=D0h1BDdj;
	arc=none smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB6D606A31D
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 02:57:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BB6D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unc.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cs.unc.edu header.i=@cs.unc.edu header.a=rsa-sha256 header.s=google header.b=D0h1BDdj
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-67a000ac7efso201807d50.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 19:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.unc.edu; s=google; t=1793329057; x=1793933857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R29eOO7MluwzQ+8n9YmxiuPXIbP8eqbXNdA0VYXai58=;
        b=D0h1BDdjx/7rfkEfgzolA/olPpLTEtkcAC8fILKxjO6ClRo7FoeIHl3TtFT2euqOQN
         zfMslcyqheQPRgDV9RBjtgAZPrzG/20Wbe5GarD9g4supvFu2wBlfk93dan3O0LFaWyr
         X0rqlIhGXUm8vgBa0NaY7mOutQnpxMs+jON9lh1Y+msRnGBSePP9tFvWcqfyofMUtiNa
         FuH1SvPNkoKLosDdYSQI8hbWWNbyE+QArk4pbmL1jeNsT1FPDznP4/UkMay7mtHk2ApD
         1JlZRH6aptNzMRLrluUniTEJ6jccyc9NCbjHEsRI+Ee5iGqMkoLCyTrfdx1wXyazjMV6
         h6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793329057; x=1793933857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R29eOO7MluwzQ+8n9YmxiuPXIbP8eqbXNdA0VYXai58=;
        b=dCe9N571cQ1XuqOg0R1T67nS9L1IUc+Piz83BZPl66RRiedU+qMd0K8p5ZdZkmM+n0
         bI4Ov8Kwgmh2wPKrabMc/tGp+in1SE9XGxutRQkGZdRPz4+jcm32R+cMOuuzAXzugjcL
         tSpjS+bQIKDgjlZpVqZ5WBymYCnUnL9RJZXEQSLuzQmn/sc9iuyXmHA80auW/owi7q+Y
         7lcTyxE4ZQB3240pLBOO8CuG6OK8C1q+fLS2xe8DMMu4EB3dZA5w13nNmw0vs5aL0Nkx
         KxOehX9DhKjV71GhhJCnqEKo7sleP8jjYrRhRf8cQ5lTZaRiSCVvhF973DeHXopCNTNB
         KUOw==
X-Forwarded-Encrypted: i=1; AKwUvBzOW/1+7k1Kp01sB7eum7gGd8TN9uSDo74fYan6O8luFJnwFJ4gecB3CNuYvV2Rkc1XtF6JQUWGpmAe@vger.kernel.org
X-Gm-Message-State: AFq9FYI7raWJ+JoPcPto7yrD6Rb5AOov+OF4oI6nm+sCl92JQMiPZ9mV
	Yj30Ns7qjpGQTMKJu9yhYmAzCvRC66RYnWGZbDcGi6wIU/b9Zgt5BIgdKgCCWnSGxneTNh3Iaps
	TGhwdPQ==
X-Gm-Gg: AYBFou1fLkcnLLNFmMACWMQFLoZb6yfz5IQFhfqcIQCg/bqJtQMjlnO9qM3M28eqQky
	sIVZjc8bIUtgNjZGD8AFTbD7/2u0Utb5jnZAQNiqVfCAL57aIVd+FTrSNJ1wIzGGcxwRRK2rRq7
	BNTMqffXNQ7LfUEG8ZBu521NOwJ8ce3tkLatdLvWnQ0Uxye2iyadEfEx4+n+Q1GHhivqYViMyP4
	PnaifEgfsYWdSMydzDaMdIZuarilcLeEi0kccJ9kphIdgbnWYqHASodZaOG+sBt+jWbxWCvtQyM
	hpZ4CeCR+VU7/5vdXZTPTk5z9ZZHOT5CS1MrHJgtdZXcEBTfGAw5QY5wD/qiyv43U8dlIAL1w3k
	SfqrQLxOi7EdWGwfT0WlyqpCYW8sF+tYZ4s2iaaHjJS/2XaswLNsahjQ4H5oHufBnDhGzgvaqK6
	aTu6L5HR1l7tpaB5a5SZHH6TNCnUyM5IRbv99Np4MYA6wJym2aNna7glKzsieiGeRQ8UpmR85g0
	4P3/i2zYO1ZJ0dtkfiPQxTLpK6ytrm8czO/baQyCz8I/N7ThW7x0EIFBGWCnhHjk6zPdfWdkGPN
	VpBEJyFTIIpuUvlrzjchQ/8lX0p8+g3kvon5uLWCQ11nBaXgJ0Q=
X-Received: by 2002:a05:690e:1243:b0:671:70d1:d6e1 with SMTP id 956f58d0204a3-67ba4fdb0bemr838413d50.83.1793329056973;
        Thu, 29 Oct 2026 19:57:36 -0700 (PDT)
Received: from cobra01.cs.unc.edu (cobra01.cs.unc.edu. [152.2.130.143])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67ba7509f13sm242820d50.13.2026.10.29.19.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 19:57:36 -0700 (PDT)
From: Hengyu Liang <hengyul@cs.unc.edu>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kartikey406@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] ext4: do not report inline conversion allocation failures as fs errors
Date: Thu, 29 Oct 2026 22:57:30 -0400
Message-ID: <20261030025730.3965245-1-hengyul@cs.unc.edu>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When truncate grows an inline-data file beyond its inline capacity,
ext4_setattr() first calls ext4_convert_inline_data(). If the conversion
fails, it jumps to err_out and passes the error to ext4_std_error().

Allocating the first block can fail with -ENOSPC or -EDQUOT on a healthy
filesystem. Reporting these as filesystem errors records an error in the
superblock and, with errors=remount-ro, aborts the journal and rejects
subsequent writes with -EROFS.

For example, create a filesystem with inline_data,quota and mount it with
usrquota,errors=remount-ro. Create a small inline file owned by a user with
a 1 MiB block quota, then let that user fill the quota in a second file.
Growing the inline file with ftruncate() returns EDQUOT, after which even
root can no longer create a file.

Return conversion errors directly, as other callers of
ext4_convert_inline_data() do. The conversion helper handles its own
cleanup, and lower layers report metadata and journal errors.

Fixes: ed9356a30e59 ("ext4: convert inline data to extents when truncate exceeds inline size")
Cc: stable@vger.kernel.org
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
---
Tested on x86-64 KVM with KASAN, comparing ext4/dev at 8c4f6e337634
with this patch (28 allocation-pressure cases per kernel):
- ENOSPC and EDQUOT with 1K/4K blocks, default/nodelalloc/data=journal,
  buffered_iomap and bigalloc, using remount-ro and continue policies.
- Failed conversion preserves inline data; 16 repeated failures on the
  patched kernel do not increase quota usage. Removing the allocation
  limit permits a successful retry.
- Remount readback and e2fsck -fn pass for all 28 images per kernel.
- A device-mapper block-bitmap read failure still returns EIO, records a
  filesystem error and rejects subsequent writes with EROFS.

 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ede3644a738..02011f65ab32 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -7123,7 +7123,7 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		    attr->ia_size > EXT4_I(inode)->i_inline_size) {
 			error = ext4_convert_inline_data(inode);
 			if (error)
-				goto err_out;
+				return error;
 		}
 
 		if (shrink) {
-- 
2.53.0

