Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A01D3C9456;
	Mon, 29 Jun 2026 11:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731382; cv=none; b=SS3CgKCZm+lAmp6KiOIvsmWCCsyXj7b2jFQZa/310IxHhcGFFU3BVC+peN92HSGs509nSw03yiXMLBzLClmcK9aDK0rrZUwfSv9hTmhHTv4WmHSn7CI80nGrYQKxQXoHsYQRBCe+CJvngi/5apFxSzsf0yfCEz0RwtLe60dv9T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731382; c=relaxed/simple;
	bh=Jy853H0g8V1NEwd2Lz6fvKV/QH1EZflh1gPOC/jpfnE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDd+Cx7B5sZbNBspq8fjNLc1GwZohxdsDQB9cBjFkQanQTli7NPQgeyfbXbsYA+dmrC3ZLqVwEHFhwrICPeeWJS7m8t2hBDobDv2nFiWoge+rSeVXhJGNZewxa73Ky5bq/yrJkBNwmd2IIZg1IUrswWT2D0aif/Ar+DEm9HYCPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=VKi9RVuG; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="VKi9RVuG"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65TAWrgG2536930;
	Mon, 29 Jun 2026 11:09:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=xRBzVTtLBkQ+E1iGlQ4yjnEKAOCGSPCa26cXQIlhNso=; b=
	VKi9RVuGjnrwKZ6ThNgjKo3g/7EKI5+8rwlCVucDLgVQkEf4QjXZO4Iq5sJv+WB8
	TGkvNTf6hG3N72dD8pdkfv1VxsHwgorKIQDeGCAQyb10UQEG9MBqADLrcFq7bIpf
	AsZUDvijfx+syRshvmVmQENgBTnp51lA62qyroN7cYME5w24hJJR5QJqzE6rRhPb
	Vh/hI7Iwqcksiqz9DF63lD181tZzCSMQyijZ+tHLXpopCPucSmfOT8D2ijiO834n
	+aHs7MnkVhfM6sYb7J08zCbVqeqN0wCXlHkO5aACX8plbwU642YFEXg1Dm4BiXXm
	s+m9pqYS/uF0BlX7i7w9Aw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0a3ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 29 Jun 2026 11:09:04 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 29 Jun 2026 04:09:03 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 29 Jun 2026 04:08:59 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>,
        <xiaowu.417@qq.com>
Subject: [PATCH v11 3/5] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
Date: Mon, 29 Jun 2026 19:08:46 +0800
Message-ID: <20260629110848.3085662-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260629110848.3085662-1-yun.zhou@windriver.com>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a425250 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=4Hxdw77LFoERu1OnU-oA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: N-v2j9j9fBjHZ_slgaWJq2IqO0ChGNZf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfX6kzupgOujQ5t
 8a40KaWZtTJQTb0YKnc/EKfHyIRTGpYQWv7kdAI7U19cx99TC42i4bkclpWkxnxhpzSbO8DQto7
 UoqSq7N96LzvgeduH75TqobLPNu70aLbVK8J2gDOQRjfVZQw45+rKrXV3eNFAj2v3icRtMxE7Ne
 EYAS+BsI6GsWj2bz6Oj5PNWyaXLV+bEK9WlfbM++ohdz8fS8A6Rk89k2vNaiMuZidBEEM+AsQEQ
 AO33a+epM8XII7YhYm2I+rV5DptlK/TB+Nnvy4fQrn26TB5ZTnUkKLp7gUkzdIifxtOk7l6/Zpp
 S229MDYqiUZsqpKejX1KyYCOpjExG5PzxYz3pH/q1U7dTe5KjNkNOYkrnZjw7mufb3VaGor6Dup
 SoCLbPCksoItAWiN1yI1Ln3fp8zszx/NOEGcC3wgYzBLKYsJZ5QcVLneLbGmr6uAGZsAT33BJya
 viDpFWt5f9+6h6j9nfQ==
X-Proofpoint-GUID: N-v2j9j9fBjHZ_slgaWJq2IqO0ChGNZf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA5MCBTYWx0ZWRfX/PV6PtI8N4zD
 5FQdqcCw9g4nJyEFI0ZxfhaR7Xzfr7FabMV1mEeagQxQNQKY+1/KGJoxanVf6tnz8Xj6dwhGsHh
 YKLmOFjSRYs18upQP8YcBmRFdQrkvL84Nk+zocXCJV4ApuAjw5L8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290090

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
---
 fs/ext4/xattr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ec66c62fbdaa..d6950b0b8f40 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -567,7 +567,7 @@ ext4_xattr_inode_get(struct inode *inode, struct ext4_xattr_entry *entry,
 					ea_inode->i_ino, true /* reusable */);
 	}
 out:
-	iput(ea_inode);
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	return err;
 }
 
@@ -1104,10 +1104,10 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
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
 
@@ -1133,7 +1133,7 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 		if (err)
 			ext4_warning_inode(ea_inode, "cleanup dec ref error %d",
 					   err);
-		iput(ea_inode);
+		ext4_put_ea_inode(parent->i_sb, ea_inode);
 	}
 	return saved_err;
 }
@@ -1201,7 +1201,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode,
 					   "Expand inode array err=%d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			continue;
 		}
 
@@ -1505,7 +1505,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
 				ext4_warning_inode(ea_inode,
 					"cleanup dec ref error %d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(inode->i_sb, ea_inode);
 			return ERR_PTR(err);
 		}
 
@@ -1564,7 +1564,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 			kvfree(ea_data);
 			return ea_inode;
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(inode->i_sb, ea_inode);
 	next_entry:
 		ce = mb_cache_entry_find_next(ea_inode_cache, ce);
 	}
@@ -1615,7 +1615,7 @@ static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
 				      ea_inode->i_ino, true /* reusable */);
 	return ea_inode;
 out_err:
-	iput(ea_inode);
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	ext4_xattr_inode_free_quota(inode, NULL, value_len);
 	return ERR_PTR(err);
 }
@@ -1848,7 +1848,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 
 	ret = 0;
 out:
-	iput(old_ea_inode);
+	ext4_put_ea_inode(inode->i_sb, old_ea_inode);
 	return ret;
 }
 
@@ -2010,7 +2010,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				old_ea_inode_quota = le32_to_cpu(
 						s->here->e_value_size);
 			}
-			iput(tmp_inode);
+			ext4_put_ea_inode(inode->i_sb, tmp_inode);
 
 			s->here->e_value_inum = 0;
 			s->here->e_value_size = 0;
@@ -2150,7 +2150,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					ext4_warning_inode(ea_inode,
 							   "dec ref error=%d",
 							   error);
-				iput(ea_inode);
+				ext4_put_ea_inode(inode->i_sb, ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2203,7 +2203,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(inode->i_sb, ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2285,7 +2285,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
-			iput(ea_inode);
+			ext4_put_ea_inode(inode->i_sb, ea_inode);
 		}
 		return error;
 	}
@@ -2297,7 +2297,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 		header->h_magic = cpu_to_le32(0);
 		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
 	}
-	iput(ea_inode);
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	return 0;
 }
 
@@ -2986,7 +2986,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 					continue;
 				ext4_xattr_inode_free_quota(inode, ea_inode,
 					      le32_to_cpu(entry->e_value_size));
-				iput(ea_inode);
+				ext4_put_ea_inode(inode->i_sb, ea_inode);
 			}
 
 		}
-- 
2.43.0

