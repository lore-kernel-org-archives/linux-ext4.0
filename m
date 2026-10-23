Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736343;
	b=sVbqG/Fgz7WLBS5oFEo//fbWh0x1XWfo4f1LBizITSPUzkwTPvemr+QVgRZ7Y6T5jaip
	 td6y029ShoEC/Vv1lv0a96S/Pbsa41yoXqq9j3nKatcz+FdwI5/GAr/1jMIdRNJw7tArS
	 xGZz/YF0vpSzmtj88UajAHvT3ws9+SdRbDaGxZZUllwUtCcr18guRVO6Xk4x3W3X+CAQQ
	 NaMmKEGPP5JEBKbNuanhBtd+hxaH4KdoUouvUWr+/k7GN01QRwJNC9SYTdvS8EgnD6PE0
	 cRlezbIhpow1Px0w8nChj0NBqjAXvGkBF21kb0VKHNpTbgvjiCacUbyM3+loM2ZbaPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9CmoLcYgKGQj6UAwNvGE5WfWw2RZjuj12YYmCaSAOdE=;
	b=J4hrbfHtvo75NO3SU0MgkVWAwFDY4N+PlgnjCI4A4Cl82Zd1esyeMpKragsT9X9RVpVr
	 KmmWl5Jbs+43eEjy68r1/H3ctRs9onYNHgq7HPa6XKhcv8vRXfNmiZ95GE1AIWhhh1BAQ
	 UCnPK8VOwte6VdTNcAwvui+tkbRholxtMBdm0DxqSN7/GZT8m2aJyl8dDrds3q7IeDpO9
	 ZShc50XW5S/o6Xyp4VHbpvJD1AiC8y+82KbQs+B/pvxRyhwPVQtqX7Qa2QCAPrX2FZAtP
	 eqQoMHzpc229JsVv2Bhkqifc466LGZimZzatuxRYOYTps51SDAVugbTdCYwiFxPeUuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GPhr1+ci;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6A606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05B6A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GPhr1+ci
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a058315c79so229335b3a.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 23:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792736342; x=1793341142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9CmoLcYgKGQj6UAwNvGE5WfWw2RZjuj12YYmCaSAOdE=;
        b=GPhr1+ci2/ZkwFZ7n6NSL/2eAkcXyS2NWKVFd/D3n/YvfTDuuybY0zSdngwaS5OaUW
         iOjXfvq+jMeULZuHbfXoXb2UMUdAllnRpqDu42rkVkfF7A/ifQ9WvGcOeYLjahDxkYDS
         gWSy0ByAS5DiPZ0cfRuijZ8okytQTC6W7ejnGBqjmMZX72q5Xs0hoOI0ZX1sE8Fo6Yzp
         AjEDS57gMJ3WBworQQnAg9HmdWZH/RHemgf189jgdU9w8hg8vsE1sDf9YVS0tr84A3eV
         85KBxsqCF/qEHNe/g1q7k11ZVARYYAygyTd0ZHgSF1Wgr0SpyJ/x22ixQjbtwO8yEz+2
         ON7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792736342; x=1793341142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9CmoLcYgKGQj6UAwNvGE5WfWw2RZjuj12YYmCaSAOdE=;
        b=iwaKcd6XO5LDYg7kLBVW492FHwaQUvdeRTC/CHGpT5oHPBOIgwAHGINb9OlhEAljW5
         UIokwSnP+na2spucxJhPXrA3ysxX5pUCFGBg2QKiNH7v0PD1FJTdxWj3e98Vyexj5v0N
         YGR/9HKGzaw8NlduqfIxXwuJDoCPnhsr0GcNWdj1MPQnSR91VkUK62fcgIGCLCJoUC9y
         PZYfSg577Xo0sM4Qt/efJ72oOd6Ws6LkIJcE1Dwrrm60WU4mHLbI83cu0G9iqxCDh1Sl
         1BD5dHsZlW2M4x7WWh824VTCB+bRYkBs153DsP4DM/ECYnn2NSTm09INj2zSGmO5tqQH
         62MQ==
X-Gm-Message-State: AFq9FYLyNEvkRkQDvGUklDsxUwomUMw7Ey5dFpSyT/kqMrXEuOih6+0T
	9G+t0IKH+fuBZ5wOv8aMxDCIu2C7A0nQmSb2zbys+jAYWw3GL2fZ16RzKcno5fVnohlV7V9LqyB
	WKVL/6UU=
X-Gm-Gg: AYBFou2FWPERHixu2mybXaXeqSo4zcPKkuntIN60FrHyV3fvwSf5uTCbaXVpTTiVz0n
	mienQ0cZpQqIq9jjqgwrzj/vJls4FqPtIsDT8U4sYbUsTfMa3kzDiIyCw5KYiY7EaJV3mO/wl9J
	phxkZ/pXuA9cs81Z/HYyuRHZKYLaIA1PpJoZOYso8h5Fp6cvlATCdxMBhGccFU7dmFFNGHkATVO
	AjobPXiGVlnUIwrUfAoip54XQT9NhwnmgiCCMVbBtbm6rE3NYn4DtDiozLr1uCUgteM1o7OZPX+
	3oklVzLM0rdxxVT2ARCiY9hwfZXox8+t31jrgH/BmNmjnTKZ1qg/py4CRDyIKu5O05dswEdgN7f
	s7aCob0Bx03N2TD8r/vrWFBH7yrSPmZMbxxmarzdVG58B7F/aDqGN1EY5WZ1PZP8pFAlXJTceb/
	eJfGrnsHSCvwDVF5SNHWFg1F6oEcXCtZx6wCctuo/QO7ev/iV5IMiCsCZmCuWCMI+5fCwKTXM7F
	n5U3NPLm1Bv3R4O0qBySXENo+W0+kRgzGNU57ek/CPe9/oke1BiRgY6aA4=
X-Received: by 2002:a05:6a00:3486:b0:886:73c9:89d7 with SMTP id d2e1a72fcca58-8a2c669c5c6mr1038831b3a.11.1792736341881;
        Thu, 22 Oct 2026 23:19:01 -0700 (PDT)
Received: from localhost ([106.38.226.73])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a2c8dce57fsm335620b3a.28.2026.10.22.23.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 23:19:01 -0700 (PDT)
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
Subject: [PATCH v2 2/6] ext4: submit mapped buffers when io_end_vec allocation fails
Date: Fri, 23 Oct 2026 14:18:47 +0800
Message-Id: <20261023061851.45579-3-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261023061851.45579-1-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
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
index de6fe4f0117c..74437fe6aa24 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2352,7 +2352,7 @@ static int mpage_process_page_bufs(struct mpage_da_data *mpd,
  */
 static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 			      ext4_lblk_t *m_lblk, ext4_fsblk_t *m_pblk,
-			      bool *map_bh)
+			      bool *map_bh, int *progress)
 {
 	struct buffer_head *head, *bh;
 	ext4_io_end_t *io_end = mpd->io_submit.io_end;
@@ -2396,6 +2396,7 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
 		}
 		clear_buffer_unwritten(bh);
 		io_end_size += i_blocksize(mpd->inode);
+		*progress = 1;
 	} while (lblk++, (bh = bh->b_this_page) != head);
 
 	io_end_vec->size += io_end_size;
@@ -2420,7 +2421,7 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
  * mapped, we update @map to the next extent in the last page that needs
  * mapping. Otherwise we submit the page for IO.
  */
-static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
+static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd, int *progress)
 {
 	struct folio_batch fbatch;
 	unsigned nr, i;
@@ -2445,7 +2446,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
 
 			lblk = EXT4_PG_TO_LBLK(inode, folio->index);
 			err = mpage_process_folio(mpd, folio, &lblk, &pblock,
-						 &map_bh);
+						 &map_bh, progress);
 			/*
 			 * If map_bh is true, means page may require further bh
 			 * mapping, or maybe the page was submitted for IO.
@@ -2601,14 +2602,16 @@ static int mpage_map_and_submit_extent(handle_t *handle,
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

