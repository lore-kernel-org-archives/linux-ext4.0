Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2426432E96
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785187503; cv=none; b=j3YKJL+F6kJdsMHNbGWTPibhEjwOo8IDpY86iP5g6Istj4iGpmT3V1Hr/Jy5byHoacPeFD7XqzQkV6AcAWjmfjol+6Idanb+dhEBR2Zx6M47I3DJhYo2wVGut8awWM00j1FiCKZGTPWBhGewIZukyO91oZQ/VYucEeGNpwkcjYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785187503; c=relaxed/simple;
	bh=bAIl0EYJtqhiY+G9Xwxws/qkXqkeERtNBUa0GVKm6tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1nPbuOUggIRL3HhvJmslbszrzfnwDAgeGQMBGAOD8cTvEQA1G2LPBKx+It9gcCS+FZbGc7Is9f5E2ugK/6T7QAe4mG6lkowbExhDwrWZ86d3R+EjMEdvc1t6c4ntf6Z7HpShwydi4LirQ9Re3gwa2DmHhNqMD1aVWOPuQoldIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P3Ucnxfs; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3Ucnxfs"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84a4d8fd6ecso3236681b3a.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785187501; x=1785792301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=P3Ucnxfs0Tt0opNvR5KixqqyPjRUXWwKTfsspysTalwXYX7UA2+/e8xfO5OJZ6ozwf
         zrLjcCsiz5uGfrdCqWBrtg9l4wExQEL0iJkl9SC+EfFz5WPsDzjRTG+PU+MC1sfbfp17
         obh7hEGzuUh48o5cLdPE0sz44w3GigVGkUP9DfT1gmpogd3MiJ2q7g6o3HdTCs6tEsiW
         6LmJG1jtc9ipEzjpUiVySyyYzLCrdba5S2Bs//8m0+XOL4vttDyqh3TQ03nWXMP25NEb
         65inHwFkpJPYKHa0+26sS1lSIlALfGzWCoY+FdXJAVeFLZxv3fsfo0snxKB1RTsyHdHO
         8zZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785187501; x=1785792301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2JkSd7oYJPFcviDB7E5uYmo6tGTEnQPMBBxrAZJVXw=;
        b=rTq9lStXxo39hwByCW6HSL8ggTbhjjXO+B0j4F2mplsClYXpJf+6NhUaKuu7ItbyTg
         Dv8bYOq7xOSg50cmcqgiGHvLR2/8X8tH/fNtKHva5cxGbAr/0r/D5MobUfANI3nOicfb
         ucRBF0Bd1QwJSmBPNGe3Dw0VBj+sEvCWPckhRBSVOf7s2fO7QJTh94wn8YBJMhwBbQht
         Uyz2Yc4v2hHKkkQ/xGXtbA+hXVG0b0HQ68ZBZoWD74P4SxF2G5IFRP7t8jbuskPsZrqc
         /ZtFL+6vXHhyjdK8gpRMAVV/4sutdXjCiPk4ZHZq2EenY1eLvdPPtFNUfWHD4g4G0b4g
         lqGg==
X-Forwarded-Encrypted: i=1; AHgh+Rrc6vGPz4L8LzniZmLptWQMDM2sqc+Pqb11pFj6/vQ9ums9EqmFUjiqVdKKK/xBPM6zZVaTb7cjL8dp@vger.kernel.org
X-Gm-Message-State: AOJu0YzH8MOMldA78fFOt6ZVheABaX8i8OCMY9DOtiTqrTPcJ42trfRX
	G72rme9H8CsZxrRKsnFMZ22dpbG6gQ2QCnzg4cvGTPA9qSWLahcrzcQR
X-Gm-Gg: AR+sD12IuiGJ56I3upNFN+Vbcr6IJNsBcv/4erBWT0bAHuRyloCbk+9g3mofG0zKqRY
	9JOOMybxUxulqYrnOcgQYytlgJSpeSnVXmdqAD+ZM/2fkZcBeWzUL9+Quty7GTFaK4/dJEqrY8N
	dLY8/wG4SbKPTZlw+h5slAcUsZGb3YofxEX6TtoEYOliLldHVN3uax6J8Pqv0aExY7lOU1Ky7cx
	MZyBEioJkhl6zff6E/ivhDVKzKQjO/rjem5iLEhkFxhX1jzyoVNECoWl/CB9zybUP13aEJEbfNC
	YUvDWYNQJJXcs8sRR0IvqjdmzoLq1bCNLe3GGyF7NPAYwhMGMFwxIehD39+Gu0eLqkyUlA+fUgy
	XbiRnCuZA312kL3I9v7lvvDziEQ86xmAnEGcXmAS/rYgq2iu3aNlrrKsyw4W/n8gs6uzKpFqY5F
	Q/wfj47upqI1+PPQYlkISR06Rg0wGXoNph1lZ0rBfXfGUv3JmP6kzU
X-Received: by 2002:a05:6a00:b83:b0:82f:9d21:d352 with SMTP id d2e1a72fcca58-84e59425aa8mr8011998b3a.9.1785187501097;
        Mon, 27 Jul 2026 14:25:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53426628sm3568830b3a.49.2026.07.27.14.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:24:59 -0700 (PDT)
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
	tytso@mit.edu,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH v4 16/21] hpfs: convert iomap ops to ->iomap_next()
Date: Mon, 27 Jul 2026 14:17:53 -0700
Message-ID: <20260727211758.1116539-17-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260727211758.1116539-1-joannelkoong@gmail.com>
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert hpfs iomap_ops to the new ->iomap_next() callback. The callback is
generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
iomap_iter_next() helper to finish the previous mapping if needed and
produce the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/hpfs/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index 29e876705369..6a629ab956fc 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -156,8 +156,10 @@ static int hpfs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static DEFINE_IOMAP_ITER_NEXT(hpfs_iomap_next, hpfs_iomap_begin);
+
 static const struct iomap_ops hpfs_iomap_ops = {
-	.iomap_begin		= hpfs_iomap_begin,
+	.iomap_next		= hpfs_iomap_next,
 };
 
 static int hpfs_read_folio(struct file *file, struct folio *folio)
-- 
2.52.0

