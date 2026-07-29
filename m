Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB823C584E
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353415; cv=none; b=iLQIuScgaDGbXx3aaq7uAr3ziDYgyvKvWT0fw4SAiEvx38f974jmGzGAgPmSEP8gpbd2fATMdxeP/+pR+ojorN1xrPfDrAEAwP9If0nn47wUw0+Ny6A083YIIgT43ucj8AE9qr2a5++PR9wEL8h0Al+20wRDt2/vBM5JSDgiNlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353415; c=relaxed/simple;
	bh=BB0sPqRZ88+T3km26e+GeLS3s0vMjVM5Qt+LGf7fCk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfGwC2rrSiaidAExz1z98IgxoWHE0QwHEbFs+/Nc/SRjy2XfFKi+1kHXTOOrRjED0+FRQUa06+MMKtlhKaa+PnW+Wi7fGPdFNML0j7L+5wjkYig2LAQSovcyAZVlxwENPGK9w4WJ18J95rMQS1i3d+uHi9BXLH15zUT8XVxVIog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVtuOpiJ; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVtuOpiJ"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-848643382fcso1499705b3a.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785353406; x=1785958206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q8M3ZYr7j0Vv2huOSINRreA5KjJf/RGJ9R7Nsb1zC5k=;
        b=FVtuOpiJjlY9BaC+J9TS+8Pu7eUI/LxnOMdM8kGq+AyojpDoWmhlnaAb2MXv5Czmmy
         Gs35lYe0m8dz6eTiH7lpBloK4z4BzyRTjkAfj+wfFXrhKRRkJMdjcyDxSG90U9xZjFID
         3kUVuyOhdjvdRzN1QcW1AdW00oF9BTmk5z8Rt0f2ZmPz6w803se9rYyZVOpIHid0pgtV
         Qc6FleITsOd9vQmrhiHXgCCiMrlURahcw/DzdsScmqtNohrPAT8YDq1bbfS+3soUcclo
         ApZRV6XFa54PA7qMTYC6mEBe7zAVjX1kqXCOJAqhLeZTYkTX7shncecrh/uzrHu+SuFL
         J6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353406; x=1785958206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q8M3ZYr7j0Vv2huOSINRreA5KjJf/RGJ9R7Nsb1zC5k=;
        b=DtAszqU3mWwUvGwEYdJb7+N4h1QWi3TWEGM2nlOJGsYtzSDKX1T41/r1EUKoOfHS/2
         iCiX8hXSnwSaRmGRuKrmqHahRmTfdsfrjv/s0RdTaizUjN7VdSOclGaMxIaEW1kwESkT
         x4JWhCijXZMu6tzReaXaXP6WmHd634q3hcRjteKNG33K0NCAzKSHK341pD06BiagQacy
         8GNmh7QMwJ+BtyastyUp0p8DUtH7XpLXPMwjBjP0dUW6sdZ6J0xa9c/uHf8oUWHxkmI2
         0IOUOqYCZ4O6bLLRrZVBlOJZ2KMxYJNWGs/pAf33W81U8ugDRpk9YQOmFAFAmbLIObU5
         9ZxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8qWLyiiB7cfKbz+KTgCz/MFjRy8WJO8qG7Mni5skkWJxOdBt4tMETCY4X+7jysdHCP7UrrHA1pw1d@vger.kernel.org
X-Gm-Message-State: AOJu0YxBj3Y+2diqtg94gLiUxVy0G8jMBgLK3D4st+FGdZYo10r6YDPW
	7VqNJQsV4xLf7u97hYeqGoEDHsP6OdzgWy/x7QKp1cjyBAeaz/Rk/5LU
X-Gm-Gg: AR+sD11txV0CYKBBdbXXR/0hlj59oetAvJ4MnjoFed3NvxMcIamgOrqtWdW6sLSNJdB
	aW8EKS9P3JGynosdUbUSmjenOR8pWUt5XaDZo8pv4FxDPD4BPb8J6ENOwlB1b7ljzEYiEy38kDh
	obtrblco1Wu5jpMwrDDGDMunajL6kXuIxFntmft9rsl9foAyYWHnzRCO6jZQW3XHnab2wvMYpX3
	YA/6aYiH3Kp8A1y5kxZngPPyIfhH07cxI4iJ12gRqkYUgXGVz7KMML9ims4Wk9pc7Nzn8javkVV
	uglTxG2RSZKcIWRjRhNZj/vxFZgMwd1CDQX9JduIo520H6lXmVWz59jcJph/+v/22ZG4MkiugY7
	F00nuPo8Pon1ps6pI0gzlZgW5+R5eHDlBOIauBL26mvpIfULspvh4gwxejJTSac6SQUWGcOmAtT
	E/MXFdjf9Ownt3eqjDHRDM2RUwB1VzHQ0z8sVm8aY7gyyIoO8l8gKY/Woj9+6kBNOVHRjqIlzZr
	jUSvoHFGogNu7Mv1HFxrjyPd4knhpDX1/mSNEat
X-Received: by 2002:a05:6a00:a10:b0:845:ebbf:e7be with SMTP id d2e1a72fcca58-84eb9ec29f6mr102540b3a.23.1785353406354;
        Wed, 29 Jul 2026 12:30:06 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0374c15sm1847600b3a.51.2026.07.29.12.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:30:05 -0700 (PDT)
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
Subject: [PATCH v5 08/22] ntfs3: convert iomap ops to ->iomap_next()
Date: Wed, 29 Jul 2026 12:27:23 -0700
Message-ID: <20260729192737.3190206-9-joannelkoong@gmail.com>
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

Convert ntfs3 iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT_END() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/ntfs3/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index c43101cc064d..53031e71c8fc 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -2101,9 +2101,11 @@ const struct address_space_operations ntfs_aops_cmpr = {
 	.invalidate_folio = iomap_invalidate_folio,
 };
 
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_iomap_next, ntfs_iomap_begin,
+				  ntfs_iomap_end);
+
 const struct iomap_ops ntfs_iomap_ops = {
-	.iomap_begin	= ntfs_iomap_begin,
-	.iomap_end	= ntfs_iomap_end,
+	.iomap_next	= ntfs_iomap_next,
 };
 
 const struct iomap_write_ops ntfs_iomap_folio_ops = {
-- 
2.52.0

