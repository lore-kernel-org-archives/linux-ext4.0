Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792680775;
	b=wNuf8aVLRFoSdVA8hjNRnaYM7tp/AKsdv6wQEdDgmqODjuYvxL05Y4taQui7rqKiUmyF
	 lRQr52dK9nodXYbdNOckTIMG0KkVAW11S4pcmjlIR/MFJEDA7qf5wA2MWWjlLawIE5TLQ
	 V1Si6ZJFdOQ3MopzH13MbJUK2IBQlGMJiNwqvxpY3MjY/85pFJDtXCXsu1L6oFL3Pq769
	 45G+aTikgYeCHyiEa+vyRGXW2zllKt//R/INUEsKrNqsPe0xkYH75223i9iY5R92u2iac
	 CML/eyRysypI5oBys1C6HdNr27HUf0OONYMQHIEDy7uRDNWF7WGtPDtVkLIE3LCn4eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792680775;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZHuqbNWWWqk1IBfZuqNiFFlbdhuv2/45o5PhktZ7Kvk=;
	b=UIyzwJa+b0ZY2CWvO8AIbQ1KHYNFjqt4imvJOnjj+wCjSn0IBlhaZY2K5wMsCkqH2XJi
	 t5G2Z5ZZTq8BTh+HKns3TSBvQUOQ6En8zsqfHv+kc7k1MXe/3plRbkR8zMrQYUfHh1HkH
	 2NqDLUbqnLXAcZ9KgezBN+6vkhAjrI4Mauxgys00x5d+pbpXDv4QcL1MUBvKnXMoKok9X
	 xPCPzY9kXKcEKCy92a67J+6vnaokmCoiBXMMJ+FJOsuLeMt1gb9GpWjZjws6tf2M1dEbf
	 +oQWSJZQ3Sv4e6FKD2YK/vLQGe091w3pH7choiHH8HWMOwkT4bM+5GXw8wgbzUmbo8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=ZfCYu+U5;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6423B606A31B
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 14:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6423B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=ZfCYu+U5
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-89d6bd67045so529448b3a.0
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 07:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792680775; x=1793285575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZHuqbNWWWqk1IBfZuqNiFFlbdhuv2/45o5PhktZ7Kvk=;
        b=ZfCYu+U5vnq3lkabMk4B7O/EGapfZ0T8mkR5vQTeIOw1H9nfT3f7Wj/bgWYMbwEp1v
         +0jKpvlTY3DtDuA1gvRVqmH63Nmn4vuUlgOXcVE6cZQe3Eikrc8o/ww+lCperHLF5Ljd
         cHOXzTEA1FIwWs7j3En3WlNRn0KNjZ9KgXoIU4RDfPc2D1GmH0HiWwrzNgKX+pvSmatc
         UNkDT4LOxujJmsC3zjR0xYlj5xalbK2Zlh5KhnfyvhiX6ZcuikOH/IRJd7PaME/NaGql
         VfiqNOre+ZMW5FZdblevgI2F3ky0abQdAoofC4sFsOCgPxnH4w1FtHdwdA+nWBcQhvP3
         xwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680775; x=1793285575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZHuqbNWWWqk1IBfZuqNiFFlbdhuv2/45o5PhktZ7Kvk=;
        b=aY9CWaEGzIXSc1dYFL4m8Tps+pZOL7ax7pHqDm7cHOWTOxD62N0SaQCmKStrCSnOGV
         V0rRT1tM/iqUT7VXSYTVIACmZ9LLJ4qXWoORz2G7xYMf7e0oyb4flNTx2t3r8iqGv0TT
         GeKMY0nwyO+oS1d7H3b8T8rNACgoGkWTUJESV6iXb50cQ35llDxiuXZGGXAKHr/FvZtj
         fMgioYxckOITNPGSwwOHhpyDEmtdfD+ByXAHVSYv0RtvgglgFvJTI5mhzFFK0oaDcIgW
         bRCLvz/XDCZm/7o1O0kT3AO23hT/frjFQqTBpqVKz7EHi3eQNkZTFOx5FdIXpfpHfiZR
         Pz1g==
X-Gm-Message-State: AFq9FYL0mj5mzxsLZfoMFh4BZKCNAlQQ+1y5DDf8h7+HbyLICflr2hGh
	Uju6fmD3g5vQQWpeQowp5ryiJRdAtk+DI44iDHBV33RugGp3YVok0xi6OtQ+S2kyVDyaZPw2040
	RjXjjXa8=
X-Gm-Gg: AYBFou0jWDeaFX4qAjAUSH8HLMZmh5zSeMz3mAdvpxPU0GSMx+64SUv30Igmn4WGuB2
	/lbWoiBvC1J9yHDyG8Yy3TT2OEJwEsVLiSjkiSufonnH8IoasXeVn0gSFjO6LXB9OFXb2biLCe7
	ij0MGREeK9f9ELR4MMXQ0n65cI0VIU2ad9EDl0HiphBz/xeaQ4h561eus1WZmfe7KODt3J+1d39
	DuS2Dn55unB+KKzAupwzsPvST5Vt4noueUYBlgaLfec08G1r2CeEbYP/LWu4U7niiqZ1w0RUSgW
	ugKe38WbE3bra/9UpIwzLnGtZ+QYfw1lQiEy1gNuV+M/JFAFj8WsDiCE5GhRdQ2/PHNiixtAbLW
	cBMiKHBj0aKREZK3lJKe0IeBRvslemaSqqxILH4aR6F1jfUT6sZX9QQxoCMPxM+WJuSVeRFIke9
	n5mBz+nBLojHVlT2qMnwtNJgQ2ZOiTGmnbFXVI+SFnSqhbaioVEvOeXhrDjTyD3Mng6OWsPLiuT
	ZnAlSX/TSo8vaoavfLqdXDjS7QbQOLsqVXlZ4xZ3udB3K0i16LKy/uTg04=
X-Received: by 2002:a05:6a00:9098:b0:89e:b19a:3bb5 with SMTP id d2e1a72fcca58-8a0a0486d6emr1826013b3a.15.1792680774470;
        Thu, 22 Oct 2026 07:52:54 -0700 (PDT)
Received: from localhost ([106.38.226.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0894b4292sm2206792b3a.20.2026.10.22.07.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:52:54 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	jack@suse.cz,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	riteshh@linux.ibm.com
Subject: [PATCH 2/6] ext4: submit mapped buffers when io_end_vec allocation fails
Date: Thu, 22 Oct 2026 22:52:37 +0800
Message-Id: <20261022145241.2950379-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261022145241.2950379-1-sunjunchao@bytedance.com>
References: <20261022145241.2950379-1-sunjunchao@bytedance.com>
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

When the filesystem block size is smaller than the folio size, a folio
can contain discontiguous unwritten ranges. mpage_process_folio() records
a mapped range for conversion before allocating an io_end_vec for the
next range.

If that allocation fails, mpage_map_and_submit_buffers() returns before
submitting the folio. Its caller skips partial-folio submission, leaving
the recorded range in io_end. Completion can then convert the range to
written without writing its data, allowing reads to return stale disk
contents.

Pass progress into buffer processing and set it as buffer mappings are
updated. Route errors after such progress through the existing
partial-folio submission path, so the mapped buffers are submitted before
io_end completion. Buffers still requiring mapping remain dirty for retry.

Fixes: 4d06bfb97ecb ("ext4: Add error handling for io_end_vec struct allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/inode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bacead801709..cefc4b97ac41 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2226,7 +2226,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
  */
 static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 			      ext4_lblk_t *m_lblk, ext4_fsblk_t *m_pblk,
-			      bool *map_bh)
+			      bool *map_bh, int *progress)
 {
 	struct buffer_head *head, *bh;
 	ext4_io_end_t *io_end = mpd->io_submit.io_end;
@@ -2270,6 +2270,7 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 		}
 		clear_buffer_unwritten(bh);
 		io_end_size += i_blocksize(mpd->inode);
+		*progress = 1;
 	} while (lblk++, (bh = bh->b_this_page) != head);
 
 	io_end_vec->size += io_end_size;
@@ -2294,7 +2295,7 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
  * mapped, we update @map to the next extent in the last page that needs
  * mapping. Otherwise we submit the page for IO.
  */
-static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
+static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd, int *progress)
 {
 	struct folio_batch fbatch;
 	unsigned nr, i;
@@ -2319,7 +2320,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 
 			lblk = EXT4_PG_TO_LBLK(inode, folio->index);
 			err = mpage_process_folio(mpd, folio, &lblk, &pblock,
-						 &map_bh);
+						 &map_bh, progress);
 			/*
 			 * If map_bh is true, means page may require further bh
 			 * mapping, or maybe the page was submitted for IO.
@@ -2469,14 +2470,16 @@ static int mpage_map_and_submit_extent(handle_t *handle,
 		err = mpage_map_one_extent(handle, mpd);
 		if (err < 0)
 			break;
-		progress = 1;
 		/*
 		 * Update buffer state, submit mapped pages, and get us new
 		 * extent to map
 		 */
-		err = mpage_map_and_submit_buffers(mpd);
-		if (err < 0)
+		err = mpage_map_and_submit_buffers(mpd, &progress);
+		if (err < 0) {
+			if (progress)
+				break;
 			goto update_disksize;
+		}
 	} while (map->m_len);
 
 	if (err < 0) {
-- 
2.39.5

