Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792681973;
	b=rD/NwAhmVbaC7ADNKRyyhad+WZvm3Pn8yF7TKvaAqWuvOhN549qVW2tEvYyrYjjG2eml
	 Ew5MVGJHDUs0rVyL5IKcpFjPv9tKx8RrsyD60nMcL0g+gWUkC9KU/e1AWpNMFl8vyffvl
	 eTI1898Lq+RHA9jCuQmqysSFmhwqWSgfrV0GnI4NWv6JLvZ33Z7Dprxy//d2VDZjgVx9x
	 xlRGmCQL5Eh0sFzSiY+WNQH+lpYqOgWPFuR3fQ9Ix4E52gDTMBZ2vdPgS2l5gdfiHaPjY
	 B98TXMgEr0I0l770Hnx7kiv2hDqoKwTPo3tFRNI5O8ELcIukF2ivCDISbmbj2n+0x8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792681973;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ig3J42FTr/ez7DDirYGwQTLeRb4N/BrLAbhbPtAfxC8=;
	b=OsS3qdyYfO8bqE5Mkm/0ARTzjQxPrMHfncb0USpOWdJM4tOQR7Mh9ADmbGJz1SZ58ozw
	 nV1es70qqeZB9C6oUcZMnNwY3RLsvPZnhf9E1uq+YSELaf5gjnZPLz91nLq8AJuJeOcNh
	 UsBj9PE/ZGHI1X4Krin543Nq3FEHJ3+0dlJ2TLpNp9IHxciforEUWJp6+2v8Xx03jOCOF
	 Lzyjq2r99rfVdgpTvtc/KTw8vo+FNDJTNkI6rpBaM7DalN9A+OVZdV5EtN1AIP/VObKfS
	 8fWTp2svlgQZQaj2OLDH4A9FoPC0HHvSJk6tJ9jCWFwK0t2cKPq1xwEPB340MHuNlQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=jX1f84VS;
	arc=none smtp.remote-ip=209.85.215.172
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60638606ACD5
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 15:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60638606ACD5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=jX1f84VS
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc751eddf25so991345a12.3
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2026 08:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792681972; x=1793286772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ig3J42FTr/ez7DDirYGwQTLeRb4N/BrLAbhbPtAfxC8=;
        b=jX1f84VS6DxRqXiOqOwqsWRCSxtyglx83PTjTGIgJXOyF8XdG96LgI2ruRPew+wDoO
         ra4gx8LXArQxtprKzkzNRV27Kb6/w+/GOHTS175j5/SQGTFInFzkyr1EPREcGA1C+tHa
         YoLUckYwFtHTqS0nPpQDyWnbhKFcSJAF7GVG78tRSR45XBfDdG1lJ4b7/Q5sKaTA4kKX
         qc0W1dOTSaYDPgIyuu3oo8Zi8LssuROPkwRn5tCsxTlUNo/KtmqPBe8ZzLYocl9wazAm
         QlHRZfbUz1Ga9yoCSowEx+1j/1EGXcgsl3Z76YxJffhDbLSmzHeNaBHj9NhViGHhjhph
         AMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792681972; x=1793286772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ig3J42FTr/ez7DDirYGwQTLeRb4N/BrLAbhbPtAfxC8=;
        b=1R/u/vVHJulvnGojxtDVdNi91mYN26mPDkQI3hZ3Li5zFMQmQol2Qu/sfIkpfLgpHc
         46gk/EOc/RPEbLuGqydbJnOxbN+9XCFZnGLVPloSOflHqJJ1aOpvIyMSupMM6fu4dylt
         gDiAcTMiWDXk0b7kZkzJtZnRmN0N/C9H+l4eFs6kj3Ct70jVnU14yZJ9ICj8OPbxN1ne
         z61t7RPrMLhoXJnuWAK+1IRH16dv9ECfHGnO/NdNrhMXI4uBjVjssKMBjhC89EDH+g8r
         iO2BkNx+OOMm5D8fNc4rN7GAZoXoXCtBzel9bb2SQ3y7vj4Jt2JNLLbF63buPDX++QJm
         AIow==
X-Gm-Message-State: AFq9FYKxQ+7ka0xm6b0ob//zbh2wCh5/z/stcSHl5VYnG0Zu5ACxqSl1
	6gPjvJNsXFPbtYWjzyveDh4XInvndT36k9E5AgYAOHTn0XLIfi2OS6jZhpTfzrVI1u9QF5S86YM
	3jJGrREM=
X-Gm-Gg: AYBFou1/nEO5Ur9QsLdmvWdVGvxvtF0aXoKSF3mF9tT2zbdlSXazDTxfuPkMRmIQ13S
	jeI6F9eZtqWfMSfRmDjeWsxfAf3cf2eH/t4j811vPe+KIf5lv4GC4m61f29yG5kE2i4wbSdMPl2
	JPUAvTTTJe3c7ZDDZE8nuCdI7nE0DdX+77zypCYAgL/affx/g/Xy+sejQ9eIeC4YSJHkVD+7kHQ
	hoBOzbR8yW23usR802T6F1WhqSBykIfr2pWxRiJ/mh3sm1A9qvg5odVgzqazHPJTk+LYz6gM+He
	wXS00CmV/ansMmDutehaPxXtky6+Bj8cT1kBWAmEK+0VPaSCiUc3nKYHg0L0WbPc+L0pxtFVCsd
	chRGEqWV5Wn8WquYfHUv4p/9cyyjZWmLolW1PuCD+YVsP9CZDy8VqQXxAA2TboMYF06EeCIzWKD
	MqS4ZU0VtWPW961tZF+aFB0zTz1LIQgxljNU1Mnm65PBlk4Ii4BZxVnGsfRgj2funQY2/jXWlTx
	XebWQXqzwJOVwdzP/CK6Tr18P/ZB534DCJTgSiIzuT0i46fLr3RqTVqdDdt
X-Received: by 2002:a05:6300:8001:b0:3e2:8c10:3159 with SMTP id adf61e73a8af0-3e28c103688mr3599741637.44.1792681971718;
        Thu, 22 Oct 2026 08:12:51 -0700 (PDT)
Received: from localhost ([106.38.226.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0894b37c5sm2305099b3a.11.2026.10.22.08.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:12:51 -0700 (PDT)
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
Subject: [PATCH 5/6] ext4: report unwritten extent conversion errors to fsync
Date: Thu, 22 Oct 2026 23:12:38 +0800
Message-Id: <20261022151239.2981745-1-sunjunchao@bytedance.com>
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

Buffered writeback can complete data I/O successfully but fail to convert
unwritten extents, for example when allocating an extent path returns
ENOMEM. ext4_end_io_end() logs the failure and returns an error, but the
conversion worker discards that return value. As a result, fsync() can
report success while the extents remain unwritten and direct reads return
zeros instead of the data written.

Record the error in the inode mapping before ext4_release_io_end() ends
folio writeback. This lets fsync() observe the error after waiting for
writeback.

Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 fs/ext4/page-io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0236b6b9785a..d25179938487 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -190,6 +190,10 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
 	} else {
 		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
 	}
+
+	if (ret < 0)
+		mapping_set_error(inode->i_mapping, ret);
+
 	if (ret < 0 && !ext4_emergency_state(sb) &&
 	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
 		ext4_msg(sb, KERN_EMERG,
-- 
2.39.5

