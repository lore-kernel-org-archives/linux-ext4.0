Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC603C7DF0
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201822; cv=none; b=fbBZm+eUj0jTghHTghbT7b4i5DoIvj69N/FHHyDrOIpGnNAnQBiGFJF5xhnfW0wAZZNw/tiiIsG5Fre87eFDjLNOndqyeC8GELK2LzhHrRqu15ctoBDabGp93GqYSxdZsLqfq4zOvjEuiSfQqeb+wWQWTh/ukmQCfQVgcyp80LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201822; c=relaxed/simple;
	bh=Uh4hktJJfVEa/Q9hDOkEWpzpxyEZDkhBZyqrP5449v0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UnRkuCrTOJtOK6rEUU0WSKBHTMvYf54KtkVZTQv8TOybTnWQOE1Rsu7i9aQ7CBjVGMkPZ5PJccoMdMCOGVLfeBGpixMr70CKZZk+XQWd2q/Par1OSnJY+7prvXaJJNs6zn+5bJGXmxcad+KJ37Kr5zFWhJFkVTlpbDhL3qP76iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=myvzHjUe; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="myvzHjUe"
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8063F3F2D4
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 08:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1782201818;
	bh=+/vPuxMasamZ72VY3mCyxM2JfeWlcD8ycjjCRQB8s/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=myvzHjUe9TtCJyR31+s+qVujrQwxkL7zvf35bfPoKRpjDG1KfLRuoAvjosSEB8wj8
	 Bon1KhGu65LZ7ktOGZZp8/VsKuVoKlOHsJAkJ03xuidQQJO2oXDolZDq1aK354x/zy
	 vm36R8JP6wad/1xOvDFHKwfmmZ6FLOkpr3uqC94LaxisxtH0BKCpHFHOpWb3qwogOm
	 MQ5PiziqXVlclxK5L+S7qAbaIgGwfpmDoM4wnsmc48Ib0npolboYCUAfzFkR7Lo4sy
	 CaQ3YRexNNzCXMvEoQ1epMTzaQQOHZn9l7SAf1XwKCRQW/dU0vpkDLatMvWWhpiZaJ
	 KGOb51vY+Dqem6LNQ2UPtWBf2dIaQC+HF+5ANeCGM8AjeQIZ4z69GmCTi7rHXPYrJx
	 gVX62BKfpU2E4KQ9eqaoRax75zzyqZIfv+q1E6QjyyL1ad40eCsN/kveVOOFr6H0aR
	 prx+MyNnR8+55Do85iqN+csSX0aqRmhJOIeyB71Vy7XcahyTs5UGGZPKynQTkIj1zk
	 8Y6Np/TC5bA6ikX0qPLG1XsK/CzFLYOgDIO0xcw41ZzO8xUeB/3ov1960HoOY7WEhR
	 ElI5j3SxmtmtARjWhEmcu/cM2/VVYMAv62+jvsNLpLkiDxynX/X+XNcqOBW3a2swy1
	 VmY8ctDmkCRjJtGaNd8J520Q=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36d992fa39eso6502539a91.3
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 01:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782201817; x=1782806617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/vPuxMasamZ72VY3mCyxM2JfeWlcD8ycjjCRQB8s/w=;
        b=E7YCDy/Yq5VJFusr+J7DJZww3sxU2P89+66sOI/Yy6Df1pFYWl6wGXNSV1I69Oyysn
         6jKGbDcoBwJMAQqyBx9BtYzJK8Pdb2T7Y8ThQ8beq89hm3DegKMxMirVMYEVYKa4RdYi
         a/NhKrppdQa4lNQLSIfcHDVqxN0JYsRt+ruTi8yKUn0akVwfDDjMLkhYeDA/XfCMg0Fn
         WnBvUzvT/dokgXkX9z0KEl81z3vAPDYHrDdPAFUFLZmxJk0vk13K7nD2W86CVzJPv5fE
         2OK9jstt72leYMOg/DfbOdiqBkqr2YiZdhSFt6YKAho/AZLtkStqgaIayhfjsVlM7goc
         MJhg==
X-Gm-Message-State: AOJu0YytQVYwN6tBHET+WXQXvPRB9Mg8rD2HdK9cwxAtMmYMxEsLRcwt
	TCSg2co70Y8w8G+fuHCvnr42JFJLyUmXjAlipZDpmYJzR/ixFCt4hiaLi+ax43FSZmhSYult3Vu
	AAkNC5cKkpgnkiu7BwstEctzyKDjjXZecPRVGu8iQ2h0xP6ZtyixVg36nR2MRsVgLLutGyhGHSB
	3ZHaE=
X-Gm-Gg: AfdE7cmNkkHcainb0DLBt9uQ/EeWBtIOOOeqWQE7FmpjQTFMWJTtJgGDhKPDfqtaXJ7
	o48VZCke8C2rOWobG7bvVtqjMJsjkgEb+7uVSpvm1KljBTnhE4zxH1sr/FTs/Rr7ZoJ7Febzyjr
	MyhZYaLD65TTRG9GtJ73RvRLTJ1jKG8vCQhJZOPkfniKnMJpTeK/AUzNGStxezDboeqrEaUAqv3
	4wNJBJfl/JQoKKwTIOI0cjsv8D8XWCvKIEfEmXJgC3YrnUaWsHX+0LygYduIXj7PYeVuTooKO+l
	BaZhZEz6QucJ5tkVNXlB+LpL+ZV3Kr+VVkjuA1F0Ps++I3PtGCkcQZXFlBSvClCb7fVcE+jl0zn
	VrcGLM9PM7wFVJqM/UKIgHT7P7Pmvc+62VAnyaTzGBgEmTArufmvny/nnaZCrJpE4pDyQ
X-Received: by 2002:a05:6a20:2f98:b0:3a2:f402:50fb with SMTP id adf61e73a8af0-3bd151a7dfamr2316160637.34.1782201816805;
        Tue, 23 Jun 2026 01:03:36 -0700 (PDT)
X-Received: by 2002:a05:6a20:2f98:b0:3a2:f402:50fb with SMTP id adf61e73a8af0-3bd151a7dfamr2316127637.34.1782201816440;
        Tue, 23 Jun 2026 01:03:36 -0700 (PDT)
Received: from localhost.localdomain (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc563c168sm9177969a12.20.2026.06.23.01.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 01:03:35 -0700 (PDT)
From: Gerald Yang <gerald.yang@canonical.com>
To: tytso@mit.edu,
	jack@suse.cz
Cc: linux-ext4@vger.kernel.org,
	gerald.yang.tw@gmail.com
Subject: [PATCH] ext4: clear stale xarray tags on folios skipped during writeback
Date: Tue, 23 Jun 2026 16:02:38 +0800
Message-ID: <20260623080312.2713478-1-gerald.yang@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In data=journal mode, the writeback thread can hit the
WARN_ON_ONCE(sb_rdonly(sb)) in ext4_journal_check_start() while the
superblock is being remounted read-only during reboot:

Workqueue: writeback wb_workfn (flush-253:0)
RIP: 0010:ext4_journal_check_start+0x8b/0xd0
Call Trace:
  __ext4_journal_start_sb+0x3c/0x1e0
  mpage_prepare_extent_to_map+0x4af/0x580
  ext4_do_writepages+0x3c0/0x1080
  ext4_writepages+0xc8/0x1a0
  do_writepages+0xc4/0x180
  __writeback_single_inode+0x45/0x2f0
  writeback_sb_inodes+0x26b/0x5d0
  __writeback_inodes_wb+0x54/0x100
  wb_writeback+0x1ac/0x320
  wb_workfn+0x394/0x470

And followed by the warning:
EXT4-fs warning (device vda1): ext4_evict_inode:195: inode #6263:
comm (sd-umount): data will be lost

This issue is not reproduced every time, but frequently.
The reproduction step is to create a VM with 8 CPUs, 16G memory and
setup data=journal:
sudo tune2fs -o journal_data /dev/vda1
Run fio:
rm -f fiotest
fio --name=fiotest --rw=randwrite --bs=4k --runtime=6 --ioengine=libaio
--iodepth=256 --numjobs=8 --filename=fiotest --filesize=30G
--group_reporting
Reboot the VM, and check the console output from:
virsh console testvm

But there is no dirty inode, folio_clear_dirty_for_io clears PG_dirty
but leaves tags PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE set which
are only cleared by __folio_start_writeback.
In data=journal mode, jbd2 checkpoints the journalled data to its final
location and clears its own dirty flag without touching folio PG_dirty
or xarray dirty flags.
The commit f4a2b42e7891 ("ext4: fix stale xarray tags after writeback")
fixes when PG_dirty is still set but there is no dirty page.
Another case is PG_dirty is cleared, but PAGECACHE_TAG_DIRTY and
PAGECACHE_TAG_TOWRITE is still set. In this case, writeback thread
checks clean folio and skips it in mpage_prepare_extent_to_map:
if (!folio_test_dirty(folio) ||
    ...
        folio_unlcok(folio);
	continue

And never reaches ext4_bio_write_folio where the commit f4a2b42e7891
clears the stale xarray tags. Print debug logs after the filesystem
is remounted read-only:
writepages RDONLY nrpages=2048 dirtytag=1 wbtag=0 towrite=1 sync=0
And all folios are actually clean:
folio idx=3 dirty=0 wb=0 checked=0 dirtybuf=0 jbddirty=0 mapped=1
...

We need to clear the xarray stale tags for such clean folios by
cycling them through writeback in the skip path, the same way
f4a2b42e7891 does in ext4_bio_write_folio.

Fixes: dff4ac75eeee ("ext4: move keep_towrite handling to ext4_bio_write_page()")
Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
---
 fs/ext4/inode.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..40da611b0831 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2698,6 +2698,28 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			    (folio_test_writeback(folio) &&
 			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
 			    unlikely(folio->mapping != mapping)) {
+				/*
+				 * A clean folio (PG_dirty = 0) can still carry
+				 * stale xarray tags: PAGECACHE_TAG_DIRTY /
+				 * PAGECACHE_TAG_TOWRITE.
+				 * In data=journal mode, the data may have been
+				 * checkpointed to its final location by jbd2
+				 * but these tags are only cleared by
+				 * __folio_start_writeback() later.
+				 * These tags keep the inode on the writeback
+				 * list and make the writeback thread calls
+				 * ext4_journal_start on a read-only sb during
+				 * remounting fs to read-only, and return
+				 * -EROFS from ext4_journal_check_start.
+				 * Cycle the clean folio through writeback to
+				 * drop the stale xarray tags.
+				 */
+				if (folio->mapping == mapping &&
+				    !folio_test_dirty(folio) &&
+				    !folio_test_writeback(folio)) {
+					__folio_start_writeback(folio, false);
+					folio_end_writeback(folio);
+				}
 				folio_unlock(folio);
 				continue;
 			}
-- 
2.43.0

