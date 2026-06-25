Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED0F3594A
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403324; cv=none; b=ShkrJ5F4j2vKOyu3wALwNEi8d28FyprVKD/o6vXNo75xGBAQdUzl1p3xzJCU51rtXOmMw+0sWYxT3cGalMeTL8KKhIEz+WXz+ULitEgoTanJkR1yT2ot3E5vb4X+Eo4dqqIb25I1wnxrir/0Eqf8N0INRCIF9abHIHFnLEgchAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403324; c=relaxed/simple;
	bh=ZVUdaX39cciik8oymsDnTnRfNBQRZR/at9uixyQ3+88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A4PVb+b0TOlr+x/5mWiMv53ey7BM39/CZChCsnXsB9L/Z2g17gzOf7RUi4o7frOAADnXlCH6o/218KKt3RyvSt2stxv8fFvOBG7EhJjmlAsXNnjEWMAFBJzC3QIgVrYw9fRdf+UPUylmaBOoFVGhXl3AbDbXnLelAu318FbtGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=JSWM8k+a; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="JSWM8k+a"
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C96B53FB8E
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1782403313;
	bh=HsI/zhaHcjURUsS0gYFNBz5PQ/oAtSwS9o+2GT8rorw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=JSWM8k+ahzsQ6xP5FH4QkFnYgBtdc4Xxcr89wRCHOxTFa0sXdoZKfSYZNoD4+Fytk
	 SMonNLAOGcwBgktbHSQBek2Gj/v4yBKV0qWQYWYR9SUphjqIp1WAylKkwVtG5TA5SI
	 7pHgFBjz85P+z8WNI0wsyLiEn8rlCD4zng6+vATIzw+UrsaKxzbAoHZo2FTTOvDIOq
	 LgnRK7xx55CGKa/KHNvuqe/D8agR+IocMUrDSbuc78BB6a/IzXRqlmVduruVo+9P+K
	 GS3LvNtdFJkphWU7PG0f+CoHQz8npi7XgNCp2avGyySzv+/fO4lnr8T9xG+TeUgnz2
	 9iRUm79bj0VGamw64U+lLpBcZWNQtcYxGjd+v93p26uadI9TE8A/O2cF8VAZ1CIcxj
	 zjVRN+TsDre0El4yo9Z6nMxJLhR1I1od8Ju5lvKJIbAcSSP6Vp2cQomSkefNmYQzJt
	 bTja43+bMwi9RwWP4U0cISmd3Ro1fVpGHwk0ak5g/zKKaK0PhiRWZoOlpcXLLaG+r4
	 2BY9g73LQ3BwY5x4g1TE7JtDmoXyzf6jX3+E6JgdrjqO5FX8Pui7Ve4lMfuj+hRa11
	 KajYFT0rGjj2tbij4UCm7CSJU+obEAjiTkEYfxjAhcZZ5/Qj9a5vBKTO5gdcirG/Eg
	 uTRBxaOqY1GX/kZZyKaFHTiw=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8422382178bso1740444b3a.2
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 09:01:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403312; x=1783008112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HsI/zhaHcjURUsS0gYFNBz5PQ/oAtSwS9o+2GT8rorw=;
        b=TJ45CrVg68ojDWROC4xnIivaQmqx+qFrRK4KFAYyTUKwqhh4TfhA9qnSgFIOE6NjXX
         2UvJ6u+dbSVGe/8wl38NdqUNUppZyCZ2bim55WG0rAwWX+u9teJwYW4TXYBxox5/oVju
         mwGKQ5xB6H74uA/ihoY3zTcpYN6Oij5PF1iVXLjB3kZ4C5nRQKHMjCq2O8DEASCzCzfy
         CN6pQrH8BQmuKfl8h1QrKCHOHbpBqB4/wZW+3km4c5EdgSWAZvLCGE15f8HkBFgZ4dm0
         z5+ymfu52DIbB+uHk8T3YrCqnjeFyxT7DTB6/WC8O9gBMRT14qRILw9gAukx4xD/4NkW
         Y8yA==
X-Gm-Message-State: AOJu0YxzXwEFnAUpa2r40Dz+yyxMem6/D8O9eSWUPl4AFCK8q1TaC5rj
	Rz5vgPrW8aesCXTN6bS+05n3OPXtrWgCQib//gsKcDegJuyuQULiFRSdnU0QFNZOUqmHyY5vM7F
	JSgXAIfkJFFlxYKbWaDtWyrkHFJkmdNJrzhrJec731hrF4WGeow//FtvfUFYHjp41HEK8qRThdB
	HbOc7lrYIE248=
X-Gm-Gg: AfdE7cnvLETMfMNk0EbdZ//wciiv4xN6WuBqxUgGNNMXOqnzg5kunTwNMu2X5VQuFtn
	/Vmy62Eoaz4U3fF6asx2OqsY/lyEgasZbZyhEAC8OPNFKH6/oZzbmv0hOasnxBvAG7WpO/oZ3Zn
	rJLYt5Awz8+0pE7Hdb6+Hjvx+YWLFMDdLjbzFo91LOR8VB8rIFgf/rkHs3m5yvAC+rRtMyLeBrY
	vRBNLa2EWJJlpFkfvBmwbCHf7IQ1vvKwB4pKBEwj1ipG/opWQHAofZ4ug9DAcSCcSOL7sp4e/2t
	EnWTVUmLJv9SBwd8p0I6oKMP3LxQrcSCFRqQoko5F7kGg2YJpv2Jt5Sir+Ef8ip52YPdk4/TdV8
	2OV32aft4yPslCSp/1+HEp6kxoY3biwOXVZkN0xFYn0rJJCYe+DPGQJuOqLlHdlpPPzkP
X-Received: by 2002:a05:6a00:2387:b0:845:4397:df60 with SMTP id d2e1a72fcca58-845b3b8c70bmr4001501b3a.30.1782403311929;
        Thu, 25 Jun 2026 09:01:51 -0700 (PDT)
X-Received: by 2002:a05:6a00:2387:b0:845:4397:df60 with SMTP id d2e1a72fcca58-845b3b8c70bmr4001457b3a.30.1782403311380;
        Thu, 25 Jun 2026 09:01:51 -0700 (PDT)
Received: from localhost.localdomain (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845b8655227sm1536396b3a.5.2026.06.25.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 09:01:50 -0700 (PDT)
From: Gerald Yang <gerald.yang@canonical.com>
To: tytso@mit.edu,
	jack@suse.cz
Cc: linux-ext4@vger.kernel.org,
	gerald.yang.tw@gmail.com
Subject: [PATCH v2] ext4: clear stale xarray tags on folios skipped during writeback
Date: Fri, 26 Jun 2026 00:01:23 +0800
Message-ID: <20260625160127.162272-1-gerald.yang@canonical.com>
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
Changes in v2:
Split the top level condition based on Jan's suggestion

 fs/ext4/inode.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..150f8789f0aa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2694,13 +2694,25 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
 			 * page is already under writeback and we are not doing
 			 * a data integrity writeback, skip the page
 			 */
-			if (!folio_test_dirty(folio) ||
-			    (folio_test_writeback(folio) &&
-			     (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
+			if ((folio_test_writeback(folio) &&
+			    mpd->wbc->sync_mode == WB_SYNC_NONE) ||
 			    unlikely(folio->mapping != mapping)) {
 				folio_unlock(folio);
 				continue;
 			}
+			/*
+			 * If the folio is clean, skip writing it back.
+			 * Cycle the folio through the writeback state
+			 * though, to clear stale xarray tags.
+			 */
+			if (!folio_test_dirty(folio)) {
+				if (!folio_test_writeback(folio)) {
+					__folio_start_writeback(folio, false);
+					folio_end_writeback(folio);
+				}
+				folio_unlock(folio);
+				continue;
+			}
 
 			folio_wait_writeback(folio);
 			BUG_ON(folio_test_writeback(folio));
-- 
2.43.0

