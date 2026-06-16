Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929B843E4A8;
	Tue, 16 Jun 2026 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623008; cv=none; b=qqgbqwgvEvSVFtxZdgrwEpJeTfOutfDGkSpUvXKU++YwWo7F3E4/j0tcZDFNlDgHvYgPq9oGzaOgi+Hjm7O5G4m+gFITxu4Mc4+zIhmsQilDb1BEOwe4jdcuTVUqVxdXx6UyjC4SGF2foKRqJ1g0e/Cu/OSExZwOf5CYdNAIiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623008; c=relaxed/simple;
	bh=1957CvEqOGkE0aFPW4zH71XNvvCCdwhrwTcntG+dDAw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RcDs5zQbz6AuMkdUiZlB/Xv+wZe/m3NH/WvkcNr+akZIE16aytmlHmnJcsKG4661En/fBPXHC88ZYwhdoowPPIrNIBhxkBJa55r7nYpYtK4EHmxC9giMzvjV4eCzAYjtmoYDLcLwV9N6aVdqX1wBrnWgDIgoB0Pi8LP+CpkIt1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=gIQ0Bhkr; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="gIQ0Bhkr"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GDtE6M3878668;
	Tue, 16 Jun 2026 08:16:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=pW4d9ra6j3qOca/cVhQBU4nVP6/3a11aCcEotlswZ5U=; b=
	gIQ0Bhkr7fMQ+PxCzO6U8HXdXTDrXd8aU2ptyeo8l9nydb5PJ8k/ySEExIBnPL2K
	/+5thaAlyHWxrq64QPsI2XvqzQCzGwFqxia5K6Y0BsfSBx3fTg/8G3Upbbtf77rY
	vh3Zc8FKRkRWrEwGp1IHT1+RhMBVYJ+aRpzcVWxlGbqB/xmyOyQbc/b9x06EYjgu
	Lqe+a9S8klF9/8VP2aGMD/YjJqeE5o8bPh8cQYuK8FTdAU3eWXP3Ovpz+y19+gTw
	hWNNmeDidDSxbMcMrL9iYh0ZINk+1jyA36LEJG++j5OdtbW1kbcXzNWqGNZaPGNY
	UvF4S656m9zr0pB2zZBveQ==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es6qdvfqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 16 Jun 2026 08:16:11 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 16 Jun 2026 08:16:11 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 16 Jun 2026 08:16:09 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v7 4/4] ext4: convert remaining EA inode iput() calls to ext4_put_ea_inode()
Date: Tue, 16 Jun 2026 23:15:58 +0800
Message-ID: <20260616151558.1728881-5-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616151558.1728881-1-yun.zhou@windriver.com>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DLq/JSNb c=1 sm=1 tr=0 ts=6a3168bb cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=Jg8eUuF4kX9OvR1L48oA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 7BceUEJ7pOrpUQct-1iVqA4c3nAWR0vz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX2RG77aM8XSG5
 7qy7L0eX6iLiDZGgpGGmTyGVpER8orSwBTESy0U8k2SGEIDKDIqZ3svYyIpmSRpjxTx8c8E6G6f
 VZQJGWZ0gSqM4lajencSuPuw7pb53eci+WcleGlXKv25HUQsu0ByxtHuvFzMdzDMHbXPOUnwhl1
 8DfHUpjyLvYqEWNoCq0Vz8QotwE+N71evL+F2ACvlR6IbS4/QE/KS1rx4kBXypIMdAHcdkT/bw9
 ow84K59SOlFk/Q1uAPgIzzLN2yPosZxHyWB9ZqWIfouR+HgpFUycmfzhIsVPjte70liXDX5GjT1
 Wjdxa82MXYFgWlRRcPJwo8Y1JrrH5WixCd9f5YKS6vC6m4jvu01RszVco4f2UW75IDEDfiTjNuc
 uOuBKb/Hr2xfmfnwgpZ8It7McKVTwqapjNnjL+sgi49RMqJx64LipvbX3ZXBmtxCokPksBROsiH
 8TnJNdhrjuFW6KPVt2A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE1NiBTYWx0ZWRfX4ZaKqF4p5KmT
 1nSmf265E8TiOda2qCrASTmHzVGKuDTnFXCTFERzeVUZKoYyRCzEfUN306/USSm0F4JSaa+0Pk/
 qEravGZfgAuv2PwcxHA4U2uXPU1N3YUXQ1IZY5OwJ4xxysQBxh9U
X-Proofpoint-ORIG-GUID: 7BceUEJ7pOrpUQct-1iVqA4c3nAWR0vz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160156

Convert all remaining iput() calls on EA inodes that execute under
xattr_sem or a jbd2 handle to use ext4_put_ea_inode().  With i_nlink>=1
and !SB_ACTIVE, a direct iput() would trigger write_inode_now() ->
s_writepages_rwsem, creating a lock ordering violation with the caller's
active jbd2 handle.

Converted sites and why defer is necessary:

- ext4_xattr_inode_inc_ref_all() cleanup: dec_ref undoes the failed
  inc_ref, but the EA inode may be shared so i_nlink remains 1.

- ext4_xattr_inode_lookup_create() out_err: may be a cache-found inode
  where inc_ref failed; i_nlink remains 1.

- ext4_xattr_set_entry() old_ea_inode: dec_ref was called but the EA
  inode may be shared by other xattr blocks, so i_nlink remains 1.

- ext4_xattr_block_set() new block path: dec_ref drops the "extra" ref
  but inc_ref_all added another, so i_nlink stays 1.

- ext4_xattr_block_set() cleanup: on success no dec_ref was called
  (i_nlink=1); on error dec_ref may leave i_nlink=1 if shared.

- ext4_xattr_ibody_set() error path: dec_ref on a cache-found EA inode
  may leave i_nlink=1 if shared.

- ext4_xattr_ibody_set() success path: newly stored EA inode with
  i_nlink=1, just releasing the lookup reference.

- ext4_xattr_delete_inode() quota loop: iget for quota accounting only,
  no dec_ref called, i_nlink=1, jbd2 handle is active.

Sites where direct iput() is provably safe are left unchanged with a
comment: ext4_xattr_inode_create() error path (dec_ref guarantees
i_nlink=0, so eviction skips write_inode_now).

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/xattr.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 04e7f674340d..b8a2ccd0a958 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1079,6 +1079,13 @@ static int ext4_xattr_inode_inc_ref(handle_t *handle, struct inode *ea_inode)
 	return ext4_xattr_inode_update_ref(handle, ea_inode, 1);
 }
 
+/*
+ * Decrement on-disk reference count of an EA inode.  If refcount reaches 0,
+ * i_nlink is cleared and the inode is added to the orphan list.  Callers
+ * must use ext4_put_ea_inode() (not iput) to release the VFS reference
+ * afterwards, since iput on a nlink=0 inode triggers eviction which may
+ * deadlock if called under xattr_sem or an active jbd2 handle.
+ */
 static int ext4_xattr_inode_dec_ref(handle_t *handle, struct inode *ea_inode)
 {
 	return ext4_xattr_inode_update_ref(handle, ea_inode, -1);
@@ -1135,7 +1142,8 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 		if (err)
 			ext4_warning_inode(ea_inode, "cleanup dec ref error %d",
 					   err);
-		iput(ea_inode);
+		/* i_nlink may remain 1 if shared; defer for !SB_ACTIVE safety */
+		ext4_put_ea_inode(parent->i_sb, ea_inode);
 	}
 	return saved_err;
 }
@@ -1507,6 +1515,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
 				ext4_warning_inode(ea_inode,
 					"cleanup dec ref error %d", err);
+			/* dec_ref set i_nlink=0; iput won't trigger write_inode_now */
 			iput(ea_inode);
 			return ERR_PTR(err);
 		}
@@ -1617,7 +1626,8 @@ static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
 				      ea_inode->i_ino, true /* reusable */);
 	return ea_inode;
 out_err:
-	iput(ea_inode);
+	/* May be cache-found inode with i_nlink=1 (inc_ref failed) */
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	ext4_xattr_inode_free_quota(inode, NULL, value_len);
 	return ERR_PTR(err);
 }
@@ -1850,7 +1860,8 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 
 	ret = 0;
 out:
-	iput(old_ea_inode);
+	/* old_ea_inode had dec_ref; may still have i_nlink=1 if shared */
+	ext4_put_ea_inode(inode->i_sb, old_ea_inode);
 	return ret;
 }
 
@@ -2152,7 +2163,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					ext4_warning_inode(ea_inode,
 							   "dec ref error=%d",
 							   error);
-				iput(ea_inode);
+				/* i_nlink stays 1 (inc_ref_all added a ref) */
+				ext4_put_ea_inode(inode->i_sb, ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2206,7 +2218,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		/* success: i_nlink=1; error+dec_ref: may still be 1 if shared */
+		ext4_put_ea_inode(inode->i_sb, ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2288,7 +2301,8 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
-			iput(ea_inode);
+			/* cache-found ea_inode may retain i_nlink=1 */
+			ext4_put_ea_inode(inode->i_sb, ea_inode);
 		}
 		return error;
 	}
@@ -2300,7 +2314,8 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 		header->h_magic = cpu_to_le32(0);
 		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
 	}
-	iput(ea_inode);
+	/* ea_inode has i_nlink=1 (new ref just stored in xattr entry) */
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	return 0;
 }
 
@@ -2989,7 +3004,8 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 					continue;
 				ext4_xattr_inode_free_quota(inode, ea_inode,
 					      le32_to_cpu(entry->e_value_size));
-				iput(ea_inode);
+				/* no dec_ref yet but i_nlink=1; handle is active */
+				ext4_put_ea_inode(inode->i_sb, ea_inode);
 			}
 
 		}
-- 
2.43.0

