Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848486329;
	Sat, 20 Jun 2026 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781919623; cv=none; b=GWGFG1V6r5qXBr1hxs4+CjxRrPT5IJS2mBGvoX4zZkHuJZ8GY6n5mjCyxJIeI68RqI3SAXfTqmWeuOWYjNlrOwnLXh2IJfcy0nKs26V9KN0zcXTe9bPN2sgpe8xSrnRYsA5G77KnFuoRGaf0YV5mUmHm39X5TP/Xzv8M5B6Khts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781919623; c=relaxed/simple;
	bh=Fl3080UN2FrDDT5RMFbrmSdk1WUL9y5O8Ywo0g0ukfk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5duFZBNV4LUoGuOU7J7l9CB9HzHBFuYfUhutNbaFGCZ2aWwnfbNZkiUMaYNJonrJDhIYkKq0h5RlQOZBqQuoVuyh0Ohqv9oYxeUfP8OES6Y0LWdNzxpRvZi8Zq9M7qV9BMZdFxToRIILFCTdJiShoRGVKCqAFEp5NVx81Wkwtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=HBjfwoKC; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="HBjfwoKC"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65K1cl6k3836978;
	Sat, 20 Jun 2026 01:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=nUNZ4qAEetG0R3hAsncnkiIEmhLUX95tOhrXCRrMkto=; b=
	HBjfwoKCTHwz97vi7uGyi3U0Ep65cnjuhvZJ6O3hDPp4B1++C3PO6yusce11J3kU
	oWx95NDSzTYH6EHTY2Zbs8+8AZSVa+qVn5NwywWS4rsl94ROG8FLKUAziHIdMUpD
	BFF/67F+ywRggVYrUqVhWrw/bZZlmE4AtD/o0vTfRxExdQ4fyQr7YNlvmkTjatJE
	7IuHGxoq1109Lz1/SuwoBfO0YXY3az0/GdFjFe6rKT8tKRuzXHuRZBGYldBJIPVd
	dhaltwWfhA8mM6JdIpTC+8YsRZtL8yFn/6Bts3nEDfOP4Ykh4Wh0OXIgc3DIl0Ce
	WjuDp5TVLq/QwzuEh+6L+g==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wr1sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 20 Jun 2026 01:39:53 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Fri, 19 Jun 2026 18:39:51 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Fri, 19 Jun 2026 18:39:49 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH v8 4/4] ext4: convert remaining EA inode iput() calls to ext4_put_ea_inode()
Date: Sat, 20 Jun 2026 09:39:37 +0800
Message-ID: <20260620013937.2564269-5-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260620013937.2564269-1-yun.zhou@windriver.com>
References: <20260620013937.2564269-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2EXJFzJfaL4cP4HeN6pmD9r85yNQf4rF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfX0ry7dn2DfAFC
 ccJzPC05qiqGtbc9/MLkcrYrPsfRqc72kuGnK5xOyNoOfJPqUWmGek7Z+4oPP1kFH04s97Br/Dl
 QstWkbX3JxxtqqxiDjFjgUDMnDxMmtvIZv2qQ855fnHZFyJeq3Ps
X-Proofpoint-GUID: 2EXJFzJfaL4cP4HeN6pmD9r85yNQf4rF
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a35ef69 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=KbrKpI8UcdLxBOtU3akA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIwMDAxNCBTYWx0ZWRfXz9miINQXwQcK
 ST77HKTGLFEA6kxmOUkPO+pNGgOAAi59Qw2B8O+hXwHEmkxSC7qHN8lMFoYYM5Jrs2KuE5qvhR4
 neDQsHrjaTgxITgoFJL+aD/5Do+FIoN9WQT8Pd3TzlcVj3lz3C9LYAVpryfEEM8AUN//brr17ZW
 Tfc17pqgHDEUjlEuERHAQMThqoC0TsCg0GIJQ1IKCL1rcnZdsYZJqym6DfhsXllsUzwrUV3RHPz
 ySCNoun/XDViaHUx9cq6WRmWzbkU4cAwKNolpcRMhqHh7YxoOyu30otlDYgzzTYsv0yYVPA820+
 mAjvxpcIFUMi7GSZwNUnhETDHlnPVMriDpLjU00qUCF2ioC/0/nk8flGpNvZo/L0iqCB/+A/AmP
 Z2Croz5m5Z3U4AMR0vbB+Xk3xr4QItXRFaaAHKzfuUZZhtHeOO5VVeT1O9e5GMYFo5oL1o42PKE
 uuHgwZN4eQBV0A7bpZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_05,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606200014

Convert all remaining iput() calls on EA inodes that execute under
xattr_sem or a jbd2 handle to use ext4_put_ea_inode().  With i_nlink>=1
and !SB_ACTIVE, a direct iput() would trigger write_inode_now() ->
s_writepages_rwsem, creating a lock ordering violation with the caller's
active jbd2 handle.

Converted sites and why defer is necessary:

- ext4_xattr_inode_inc_ref_all() cleanup: dec_ref undoes the failed
  inc_ref, but the EA inode may be shared so i_nlink remains 1.

- ext4_xattr_inode_dec_ref_all() ENOMEM fallback: ext4_expand_inode_array()
  failed before dec_ref is called, i_nlink=1, jbd2 handle active.

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

Direct iput() calls in pure lookup paths (ext4_xattr_inode_get,
ext4_xattr_inode_cache_find, tmp_inode in ext4_xattr_block_set) are
left unchanged -- these do not hold a jbd2 handle or xattr_sem.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/ext4/xattr.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 79de182e22e6..08c1bdd5133d 100644
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
@@ -1106,10 +1113,10 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 		err = ext4_xattr_inode_inc_ref(handle, ea_inode);
 		if (err) {
 			ext4_warning_inode(ea_inode, "inc ref error %d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			goto cleanup;
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(parent->i_sb, ea_inode);
 	}
 	return 0;
 
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
@@ -1203,7 +1211,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode,
 					   "Expand inode array err=%d", err);
-			iput(ea_inode);
+			/* i_nlink=1 (dec_ref not yet called); handle active */
+			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			continue;
 		}
 
@@ -1507,7 +1516,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
 				ext4_warning_inode(ea_inode,
 					"cleanup dec ref error %d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(inode->i_sb, ea_inode);
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

