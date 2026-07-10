Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE20362133;
	Fri, 10 Jul 2026 03:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783652977; cv=none; b=X14NlCzRVBa4eUJLKpYrNiJQsPtvIIXRYO4PWswSh9lq/R0TKyXspELc4ngimP4PXt6HETWuxYxoTq1UaMuGy1SXnjStrXis2nR2oyr52Xa7ZquDBCH0dzHPzMl6ge6qAcJ+rknVx3YTOQtkOz9yYyKkn0X7njHjzuPtPeNAkcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783652977; c=relaxed/simple;
	bh=jQIKINSzk9Y2T21NmTC3f3QYFbiOQbaIKvTXdgpO8u0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HBhtjiYQiH8WiQGuYTZ1s40aUJ6pMgEJIfGp5Eiq8Ovc58eiaDSgeEvvEFO2lJYQ3vXoGwmxrACypyx9z9jnq6iIwH1fc0PiKH8RWBnd0N5qirBGtXFJSMVAOmg9lGdlUqFEEDlCcCEWP8+8ytsjGKOPHa+LSRLct0JBjSGsqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=OdEmVgrK; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="OdEmVgrK"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66A2baY53827148;
	Fri, 10 Jul 2026 03:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=W3Cc5ozYmAkjhyRVzpLa8art99yxwG3VN7yO3jCcXrU=; b=
	OdEmVgrKVQQzstJQsyFefarFTe+ZhuLOOvORUx6H8iWPD6SxLQUyk2DMo02hP+h7
	y2YurKVsrG8WL0KaYiYp9UyURPEDER41/u+eFzLK7JdobvmTT+UiTx2CRZC1OiWg
	msMxKu89O0KezTJh6sYIaYZi4NiF+gxYdIJeGkwI6982IjQ0NpRMEr4KAbqN8sDr
	yZJcYV2Nqil263XagaOupzsqmE65dEfrb10bJy+I3Aim6uNhUzp3KVfAIQVrNd0U
	4jiwstQacwu+rgh9agqCXxGtgcwjSJkYfbRrz96+eeKO8Y6ksiaaKY4A+yQDL7CJ
	OzKCWboHqmFtZpdMX1+BAA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fa1aqa18n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 10 Jul 2026 03:09:07 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 9 Jul 2026 20:09:06 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 9 Jul 2026 20:09:02 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v14 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
Date: Fri, 10 Jul 2026 11:08:50 +0800
Message-ID: <20260710030851.2791589-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710030851.2791589-1-yun.zhou@windriver.com>
References: <20260710030851.2791589-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Z9-jB4qOddmhJuitRbtQYZ5No7EriTn-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDAyNiBTYWx0ZWRfX3Y2TGKME/Tph
 q5TQDbCiJmSJ7yR8JI5ZYRHOfqarte+GUN/hLBEEWahfvGrAH9m5UF2VoygyPZM6o3/fTBjO+57
 tnL4S6NmKRzd+5ItGvVPTZ/v6T35ZYRU+gWIX2EFJADXOlzP0QuA
X-Authority-Analysis: v=2.4 cv=XIkAjwhE c=1 sm=1 tr=0 ts=6a506253 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=o_jFod6Xf73EBe-g21MA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: Z9-jB4qOddmhJuitRbtQYZ5No7EriTn-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDAyNiBTYWx0ZWRfXzZHD5T3mcB1V
 eNuWG16/AgWKUPYhS4rZdj0ixs1Tx9/8pSSz+FMfku9TdW5vY5/2rI7hb5P/F1MKd6mCo5eiblg
 7NJ2y3xNNsjSYz6Ke0PL+8y+r0kSYT/eKonA3JxAbVHrBapmGnv2eQ6uKllSZvT3wkxjp7NYbIV
 cxo53DosaVu3j3aQY2Hwe7XSpkNO9rIWcqHut+cLjFpKM3FXdsbnHYUNXUdz65WS0OtMAkj5Wjt
 hV/STe1Gcmeo6v3xAnRRGXrWzaXyP++7qVNNKHc+Q0AdaMNC/aEIwmuusJH/1a36Crl2B29vNcx
 JT/dRR5l2jhrA7lTavR6IFA914ENsAbqWVrVX2zpdppjup6HSG+nvkk+nQAvOO3/DhAFHUJoeEU
 L4zz0qayxmYQaaPn3MCzubUvd36Gt3fKgjDyB28RWTs9j/nDdn40p9KcY2wRkpfT0wFnaolYwWU
 4e8F4M12nB/PKKHl3gQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_04,2026-07-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607100026

Convert all iput() calls on EA inodes in xattr code paths to use
ext4_put_ea_inode().  This establishes a uniform rule: every EA inode
reference release in ext4 xattr code goes through ext4_put_ea_inode(),
eliminating the need to analyze each call site individually for lock
safety.

Converted sites:

- ext4_xattr_inode_get() read path
- ext4_xattr_inode_inc_ref_all() main loop and cleanup path
- ext4_xattr_inode_dec_ref_all() error paths
- ext4_xattr_inode_create() error path
- ext4_xattr_inode_cache_find() mismatch path
- ext4_xattr_inode_lookup_create() out_err
- ext4_xattr_set_entry() old_ea_inode
- ext4_xattr_block_set() new block path, cleanup, and tmp_inode
- ext4_xattr_ibody_set() error and success paths
- ext4_xattr_delete_inode() quota loop

For most of these, iput_if_not_last() will succeed (the EA inode has
other references) making the overhead a single atomic operation.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d5bccc64b032..6a1f2bdb6ff8 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -567,7 +567,7 @@ ext4_xattr_inode_get(struct inode *inode, struct ext4_xattr_entry *entry,
 					ea_inode->i_ino, true /* reusable */);
 	}
 out:
-	iput(ea_inode);
+	ext4_put_ea_inode(ea_inode);
 	return err;
 }
 
@@ -1104,10 +1104,10 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 		err = ext4_xattr_inode_inc_ref(handle, ea_inode);
 		if (err) {
 			ext4_warning_inode(ea_inode, "inc ref error %d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(ea_inode);
 			goto cleanup;
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(ea_inode);
 	}
 	return 0;
 
@@ -1133,7 +1133,7 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 		if (err)
 			ext4_warning_inode(ea_inode, "cleanup dec ref error %d",
 					   err);
-		iput(ea_inode);
+		ext4_put_ea_inode(ea_inode);
 	}
 	return saved_err;
 }
@@ -1201,7 +1201,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode,
 					   "Expand inode array err=%d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(ea_inode);
 			continue;
 		}
 
@@ -1505,7 +1505,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
 				ext4_warning_inode(ea_inode,
 					"cleanup dec ref error %d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(ea_inode);
 			return ERR_PTR(err);
 		}
 
@@ -1564,7 +1564,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 			kvfree(ea_data);
 			return ea_inode;
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(ea_inode);
 	next_entry:
 		ce = mb_cache_entry_find_next(ea_inode_cache, ce);
 	}
@@ -1615,7 +1615,7 @@ static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
 				      ea_inode->i_ino, true /* reusable */);
 	return ea_inode;
 out_err:
-	iput(ea_inode);
+	ext4_put_ea_inode(ea_inode);
 	ext4_xattr_inode_free_quota(inode, NULL, value_len);
 	return ERR_PTR(err);
 }
@@ -1848,7 +1848,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 
 	ret = 0;
 out:
-	iput(old_ea_inode);
+	ext4_put_ea_inode(old_ea_inode);
 	return ret;
 }
 
@@ -2010,7 +2010,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				old_ea_inode_quota = le32_to_cpu(
 						s->here->e_value_size);
 			}
-			iput(tmp_inode);
+			ext4_put_ea_inode(tmp_inode);
 
 			s->here->e_value_inum = 0;
 			s->here->e_value_size = 0;
@@ -2150,7 +2150,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					ext4_warning_inode(ea_inode,
 							   "dec ref error=%d",
 							   error);
-				iput(ea_inode);
+				ext4_put_ea_inode(ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2203,7 +2203,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2285,7 +2285,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
-			iput(ea_inode);
+			ext4_put_ea_inode(ea_inode);
 		}
 		return error;
 	}
@@ -2297,7 +2297,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 		header->h_magic = cpu_to_le32(0);
 		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
 	}
-	iput(ea_inode);
+	ext4_put_ea_inode(ea_inode);
 	return 0;
 }
 
@@ -2986,7 +2986,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 					continue;
 				ext4_xattr_inode_free_quota(inode, ea_inode,
 					      le32_to_cpu(entry->e_value_size));
-				iput(ea_inode);
+				ext4_put_ea_inode(ea_inode);
 			}
 
 		}
-- 
2.43.0

