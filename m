Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794795947;
	b=fq90JvPmpNFTp/4waAAp34gKOuEZ3o6rYOQqSCmJEYBtN5A7aGLDrD7T/Tq0av1xeq+u
	 QIvOuQBYEizSQEXKmbXI6QTRYRFy/odOG1Cl45BxmuBg69kYFMhC+fyIdF4++48khFyWX
	 y4rToUjHRZJn7uCfl0aFSQFTKfl8/Nl4c09rRzq/Tu60sSgBHp8I3cPf7Az+6VErGgpGx
	 J3sMwZ1NacCgUHIcc7O+YAjzoDZjWFbev//JxdXWFOHLJGcS/G+BNUKl+iDoJc9yUSw9y
	 Zs/QWCFFErsIkpix7Z/W1XXc6rMgz7dgDuJ672qaO3tf6dcrNvG1L6PKdSTlUzNYETQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794795947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 Message-ID:Subject:From:To:Cc:Content-Type;
	bh=4cVn2led5HgP5xLulb4J0qrBX+b1Zaf9EJxKInsiKbE=;
	b=bvrvtKvf8AzwIiEqQ7E4+yZBGhrVm6aBq5HUoa+G5LtlSZQoOe7zSJi4cLBKCT//FG8Q
	 U+Zv8pLeOc0SsJJi4Tsi7UKZb79HGgkOCm7QwyVjDOUa2qt/vIoaaNtaAHo0Np+mma+V3
	 Wp9joDbngQajlA+JyhQa4wYu0h558SCAL8HTwjp1aCi0hHm5gk22b3SJ1NATraWphQW+t
	 Hwp1SrPueVl8HSrqRCfC4CwF9A313dctSbZmVSvtPV3xIQjt19/aqvcnFonpRMv+sDn97
	 2FLgWUoaSGiBVlue4y8mEKMwDVQgbtKHYZkrXnAGN49GZtoyfJK/UVHtNvqttyztE2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--chriswiseman.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P17l79qk;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF01E606A321
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 02:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF01E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chriswiseman.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P17l79qk
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36f479b9819so1249775eec.1
        for <linux-ext4@vger.kernel.org>; Sun, 15 Nov 2026 18:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794795946; x=1795400746; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4cVn2led5HgP5xLulb4J0qrBX+b1Zaf9EJxKInsiKbE=;
        b=P17l79qkCUNCqxrxH8hhdLwXXjDr3K8ukb7w3haB77kS8pl1erTNufHo5yDAZB5Qdh
         ntN+1iXzCQ+FRe+FxTM6NrDrt0X4f1xPrlekTsEk/FsnZ31hjHmP10noPwLpsXpl1VS/
         OshLsCafXGBQPN+QgN6qsB8CRSc576QMIfuLf8MvJp7M6ffpked3v7Enbf3QX/FLyn9r
         VEOab6gZIL/+xghqxRl1p8GCylry/BvxEdalIZRyRx+6taFhRzwMyiwJVYD916INoA7i
         qH4dVnHZBXVjKi9XLiolttvf0tm2PwXHtBYWe2THV/hFehHEjJ9RYDSzeHP7IPd2t1A+
         ASpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794795946; x=1795400746;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4cVn2led5HgP5xLulb4J0qrBX+b1Zaf9EJxKInsiKbE=;
        b=ra0nufW+1u4aRaQdfxiT3l5KA2LdXEinxaTNp3B1T05Al/40UEiFAp1dX/bXQG27pa
         PrvYPm0rJkG4WYuev3qUmOX9faJlNu7fKKCPoHctjEhkOarAOjUYyG+Bsqr4gBYc6F1P
         3gdOpJiZxOPNgn3BTCL+9Uo+O2//SgEn1jD2uMtnV2OBeFHPFzwt0o8oAszMcI/sdGXp
         pNPdb/fCRBvQPASeaJYb7wVSWyoD/m5kIiaFszlfWwOeOSHr11X57P6seYoz/jyfIQqf
         D3zkp+5ohA6sCCrGC/W8EEgUUIpHEOSRhqPu57GPLqx65NHl7t8x5A3Dm2nJ9yJsqUWT
         vW2Q==
X-Forwarded-Encrypted: i=1; AL+hErHlJh2htkun+E+7VWKzc9/OSpBsB1trc/y2XaK5yURk05a7lL8fGibxIFRNIPgn5xqj6skFP+/sXje7@vger.kernel.org
X-Gm-Message-State: APuU4Z99QWI2sNJkTaSYJOPgSWCYZGrT0gC6epIKSXXsHDCUXfL0HBKW
	KcpQR5xjvwKcU+NF78NAiCOls9oKKksOsqgeDeUMo4C7duWxfSy//uYGIIjdZf9C+jBRHz8E5+9
	Hg4U+fdsTAvBhEsrtKEZpClQMkCPY8A==
X-Received: from dybnj40.prod.google.com ([2002:a05:7300:d0a8:b0:36a:de0:d28a])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:895c:10b0:35e:f1a5:9ba6 with SMTP id 5a478bee46e88-37963a4f1femr9418441eec.5.1794795945341;
 Sun, 15 Nov 2026 18:25:45 -0800 (PST)
Date: Mon, 16 Nov 2026 02:25:44 GMT
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Message-ID: <18e865672dda2d41.3137322e32332e3235332e313736.36f4d7.0000sendgmr@google.com>
Subject: [PATCH] ext4: free HTree fname rb-tree at EOF in ext4_dx_readdir()
From: Chris Wiseman <chriswiseman@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"

When ext4_dx_readdir() finishes scanning the last HTree leaf block of
an indexed directory, ext4_htree_fill_tree() sets info->next_hash to
~0.  On the final iteration, once rb_next(info->curr_node) returns NULL,
ext4_dx_readdir() sets ctx->pos to ext4_get_htree_eof(file) and breaks
out of the loop without calling free_rb_tree_fname(&info->root).

While ext4_dx_readdir() frees info->root when advancing across leaf
blocks or resetting on seek, reaching EOF leaves the final leaf block's
red-black tree of struct fname nodes pinned in file->private_data until
the directory fd is closed in ext4_release_dir().  Processes and daemons
that keep directory descriptors open after reading to EOF retain those
slab allocations for the lifetime of the open fd.

Free info->root before returning EOF when info->next_hash == ~0.  If the
caller later seeks back, the existing !info->curr_node check at the top
of the loop repopulates the tree on demand.

Benchmark results (/proc/allocinfo, 256 open HTree dirs at EOF):

  Metric                                  Before        After     Delta
  ----------------------------------  -----------  ----------  --------
  ext4_htree_store_dirent live slab   1,007,616 B         0 B   -100.0%
  ext4_htree_store_dirent live objs        10,496           0   -100.0%
  /proc/meminfo SUnreclaim delta        +1,246 kB     +133 kB    -89.3%

Signed-off-by: Chris Wiseman <chriswiseman@google.com>
---
 fs/ext4/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 8d7b81e6948e..435300cd2c61 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -640,6 +640,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 			info->curr_minor_hash = fname->minor_hash;
 		} else {
 			if (info->next_hash == ~0) {
+				free_rb_tree_fname(&info->root);
 				ctx->pos = ext4_get_htree_eof(file);
 				break;
 			}
-- 
2.56.0

