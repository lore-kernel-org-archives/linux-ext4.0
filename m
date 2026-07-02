Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBFF1DD0D4;
	Thu,  2 Jul 2026 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782955255; cv=none; b=faE/BysqjqMbV4LLkFYBqImm0lcid71n0RQ5by5zvWfuS1C8BHWOs4arGSTnTaAiG5gFvSHmn71A/gF0cGiyIdurdZzRTvkk06uC9FQTLS3KxNs1vtk00FsRyEu+KVixXwfp8kfT36PcbTYIFOeV32Lnjl0jK+RZR1g71tmoAJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782955255; c=relaxed/simple;
	bh=pxWetWcZKm4YRiJlbZoFEOLoJhXqeysXIJ8VDBomI7o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=acfJ+4oaO+/+TC9Z6BmWpf48YQhQu4Fmm/61SVwbMG5LAhIQbWbxzQ23dABNyT2dM5W5wUMLVWwE24yuIKRm9bVy/QpGYV46qj+wq67c9mS5wok0jQDKUe/FQUhjT+1RR/G3pgz3QdbuqGS+NaT4gRHxzyfIeQNhIjFNIMssMqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=B7HDc6Wr; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="B7HDc6Wr"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6620FTXf574135;
	Wed, 1 Jul 2026 18:09:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=0M2Y7rSs8
	GoEKrRf3wEUHnslLfYKhIz/uFRUgmau+pw=; b=B7HDc6WrMEq1+1VHrxjzlKcuB
	CY3FWzK4rZ6tfTnz3kNyrfCLbOfNGeB6hwoi8b1ToevnJqUtkwNOPXOoWM4YGabF
	YXVLE1binIx01n6SWBMLQLsEZ3lCmW1OPkNmTs3CCQL29BYHoxf7z7fhUrQBwrCi
	Hr6ie87xncDr8czt17dxqWhZKJT0BsKTztfYZEhnobdjP+rjTBfUtOplHleIFevC
	b5qJC5eW7k9+sqd4KliyWhaAZ3BDzSjLYxJE5v3QQDKWiTlFT7GrgSVTI74OGyPc
	+kITRGl0kOSdXOqYTZ2NP8ERAR7kwX2PR2avZNgA8W+9Ahl2XGwBBIHiX5RBg==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f2e1gxnch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 01 Jul 2026 18:09:10 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Wed, 1 Jul 2026 18:09:09 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Wed, 1 Jul 2026 18:09:07 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] ext4: prevent inline data creation on extent-based inodes
Date: Thu, 2 Jul 2026 09:09:06 +0800
Message-ID: <20260702010906.3213788-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jp-EK9bbbeA2nrIAydIlTyjJs45LX6MG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDAwOCBTYWx0ZWRfX8h3PLlfztZl3
 SGjRBfcJaW9F/IBCV1okIOFeeR6DLKk93SctwISZXYqvV5ZNwIY1sOzcOPD05TBzqCrsGbb1QyD
 Y9y9tuANWQzEexlhEENslPtBiSMOuvUMOEZ8s6x/CmbELDiJj4p5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDAwOCBTYWx0ZWRfXy886GBBJ3kba
 2QaCXYDeSii2l6OM2ZRx9BMAoa2D8lVDkiVXcvdylw0JLhS2c/eLexkgAhdcjwKK/9CI484JTTG
 z31BRcEeTvCHYDGFPoWlTwekmvxufk6LbgTLZg+nVqlX2cF3ZvpqoP8RzE9nbOlJjDYg+XE9TMl
 LMK73TXugZd53wM8MGqNiwZkM6alTCHo9BdyduV8MbL5GABTSdsF5pyqiXBF1yw+kFaHiizEF0d
 8QNYGRbeyZiQ0nT+dsR40rHe9+rVBfwQmXwZ3rfHG5ni53zgCMWIB7Fl4wTYkWcKaEz0OHrd9Sv
 8U3V1O6cUomPPw6feu/VMU8QMBri5NJ0AtHLM7NcdQCQHE4NHY9TeLhCc5QR77aEQ10UpdmZBEV
 if3Z4Ariww4HV9Oxt2RAAtt3O4Q7yA7yq1w1cnh0ANaC8E62vo2M3aqGzM7G17HMyAUCWWSMpMI
 YUT9VmBedac3EEkrE2A==
X-Proofpoint-GUID: jp-EK9bbbeA2nrIAydIlTyjJs45LX6MG
X-Authority-Analysis: v=2.4 cv=GsByPE1C c=1 sm=1 tr=0 ts=6a45ba36 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=58zYM9HpCZnQhBkBTDgA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_05,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020008

ext4_prepare_inline_data() only checks EXT4_STATE_MAY_INLINE_DATA
before creating inline data.  However, after ext4_convert_inline_data()
converts an inode to use extents, a concurrent write can race and
re-create inline data via ext4_create_inline_data(), which re-sets
MAY_INLINE_DATA.  This leads to an inconsistent state where an
extent-based inode has inline data, causing BUG_ON in
ext4_do_writepages() when dirty mmap pages exist.

The race window is between ext4_convert_inline_data() clearing
MAY_INLINE_DATA and the concurrent write checking it:

  page_mkwrite:                     write:
    ext4_convert_inline_data()        ext4_da_write_begin()
      ext4_has_inline_data = false      MAY_INLINE_DATA set (from iget)
      clear MAY_INLINE_DATA             ext4_prepare_inline_data()
      return 0                            ext4_create_inline_data() success!
    block_page_mkwrite() success            re-sets MAY_INLINE_DATA!
    folio dirty, PTE writable
                                    writepages:
                                      ext4_has_inline_data = TRUE
                                      MAY_INLINE_DATA = TRUE
                                      dirty page exists
                                      -> BUG_ON!

Fix this by adding a check for EXT4_INODE_EXTENTS in
ext4_prepare_inline_data().  Once an inode has been converted to use
extents, it must never go back to inline data regardless of the
MAY_INLINE_DATA state.

Reported-by: syzbot+d1da16f03614058fdc48@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
Fixes: 7b4cc9787fe3 ("ext4: evict inline data when writing to memory map")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
An alternative (or complementary) approach would be to convert inline
data at mmap_prepare time (ext4_file_mmap_prepare) rather than at
page_mkwrite time.  This eliminates the race window entirely by
converting before the mapping is established, making both this fix
and commit 7b4cc9787fe3 unnecessary.

 fs/ext4/inline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 26d9164d0609..f9af38620cc7 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -418,6 +418,13 @@ static int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
 		return -ENOSPC;
 
 	ext4_write_lock_xattr(inode, &no_expand);
+
+	/* Once converted to extents, never go back to inline data. */
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		ext4_write_unlock_xattr(inode, &no_expand);
+		return -ENOSPC;
+	}
+
 	/*
 	 * ei->i_inline_size may have changed since the initial check
 	 * if other xattrs were added. Recalculate to ensure
-- 
2.43.0

