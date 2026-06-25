Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C082652AF;
	Thu, 25 Jun 2026 15:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782401433; cv=none; b=aiqvWCTuTlNEGNMCOJKFGoRcpf9YGvID7jfEIqd4Uy1traAm5EUJbY0332b7vEqSBmtvZcWfhIA0gDFYMDMEp5nnXqN4nxmhbKO5yQR+Cqz29wUl5M41XRarw4jr9uYR2R9hX/MaLN8TYkzD/aGAc9Szswk1opKhHnQtwPa8mUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782401433; c=relaxed/simple;
	bh=GiEHYyXSv4KPbI6KvBl2B8FXPEEOC/UmbWu7TWVjas4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Od7xR2JG7yTL0wn5/yeo7xyjgnZm8nMRJGmmpZhHz07k2p4EP6/SD8qknHOLDElDfnXWKaBn4pQD3pGCE9nb/BVB1lpBIaZ/FAhIWkfIdouubm+3Fb6MW1jSurYw2dUU2aVciYNi3Xx99Viap3Wr3RiMym3N4sZgGLZgALrlz5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=eIerOoKU; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="eIerOoKU"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65PBBAee1122550;
	Thu, 25 Jun 2026 08:29:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=x35jGbhQ/BfDQx9ToRkqBMLd0DWy+HVaRK2+3ygZOTY=; b=
	eIerOoKUnhIHpdC88BE1QfAr7yEDeDQ1ZYNorgUYTTYmVIa3hMf2FD5lumPwveOl
	M4NADHDxXjYFpfpDkx1uvWQtXUSf682RZr9gDB6/9TaN5b4tu1jucs6HSEPLYAMe
	TXIqM//XsnRYJc1XBMQNKwuhH0Mv9Tku85mIAqxUyzUQvJbqnNT/0NM1UQYbqPmL
	JpDp1NIUD/lgePoifJqfwxqeh5t7EqqcExIfAcBJnEf9XL5NnP5iZVx41uU86G61
	FjzSXGUagb97udrV8NC+/L2HKtCLOOAYV4nuWE6zBNnix0kECEIYuRU6wMfLxbg7
	ufslJCnO7zdhYU6B9YAzNA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0t06gw5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 25 Jun 2026 08:29:57 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 25 Jun 2026 08:29:56 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 25 Jun 2026 08:29:53 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v10 3/5] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
Date: Thu, 25 Jun 2026 23:29:39 +0800
Message-ID: <20260625152941.24788-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625152941.24788-1-yun.zhou@windriver.com>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEzMiBTYWx0ZWRfX7xJnqTWlI8Bu
 Ok/TlWwA6X0e4MC4GBzW9LGOrhDMpUwQXKc+RMwkelcaJgUebDZEq/oYoT4xwY7tPobH+s3d8fk
 6HGlunqjO09klByQYtA0OoVNVMRsbFZtzDrTOHK55Spkf37ePowo
X-Proofpoint-ORIG-GUID: oZv00NYNmfOwisRQCkxDPctEluhyhPeu
X-Authority-Analysis: v=2.4 cv=M6t97Sws c=1 sm=1 tr=0 ts=6a3d4975 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=t7CeM3EgAAAA:8 a=4Hxdw77LFoERu1OnU-oA:9
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: oZv00NYNmfOwisRQCkxDPctEluhyhPeu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEzMiBTYWx0ZWRfXwcAD4IgR4t0j
 R/nAyk1nc71e3AuXUIYrOPRFc2PscK89BxePmfYCax5Dkm4AE4fvavTotMLrqlbeD4W19thAsSs
 NhI8rD9wBTcLFvs0FrSxRGG9Z9yY6P9yYTI5NOV6PLl8JNCIjjJzOXFZ68am/bFAzQdeMxgXsx6
 eFR0Swe83Rl0p1r09v6kMPj1SiT1XUmBVStU6Ah1rYBFAMyy4pp77M2a/ZTsl94cYig2VcdbMVP
 /f1lAOK63nwHQ/y2NpsFlwEuUMShxLqUQkmIhiDfzmwDlboHKFzJVV+s8gnE+MTK9wPeetsZM4b
 Lcs4etGdnG6YjackANe/zm4Pn4iE9+7KnyH6yBtTxpw3P85TxNkaaMKJEdfyn3/zVyLhpjrKSZt
 6mKfAKCSI6BciIhkFk4KLdT5tgbWgiXFrih+OOtCB0syDSmvHtOsOVrkPU2JrEjRSOgyRhESadT
 djSM3CQihOr/6BEU/HQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250132

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
index ecdad5920b14..90b693b78a45 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -569,7 +569,7 @@ ext4_xattr_inode_get(struct inode *inode, struct ext4_xattr_entry *entry,
 					ea_inode->i_ino, true /* reusable */);
 	}
 out:
-	iput(ea_inode);
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	return err;
 }
 
@@ -1106,10 +1106,10 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
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
 
@@ -1135,7 +1135,7 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 		if (err)
 			ext4_warning_inode(ea_inode, "cleanup dec ref error %d",
 					   err);
-		iput(ea_inode);
+		ext4_put_ea_inode(parent->i_sb, ea_inode);
 	}
 	return saved_err;
 }
@@ -1203,7 +1203,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 		if (err) {
 			ext4_warning_inode(ea_inode,
 					   "Expand inode array err=%d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(parent->i_sb, ea_inode);
 			continue;
 		}
 
@@ -1507,7 +1507,7 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
 				ext4_warning_inode(ea_inode,
 					"cleanup dec ref error %d", err);
-			iput(ea_inode);
+			ext4_put_ea_inode(inode->i_sb, ea_inode);
 			return ERR_PTR(err);
 		}
 
@@ -1566,7 +1566,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 			kvfree(ea_data);
 			return ea_inode;
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(inode->i_sb, ea_inode);
 	next_entry:
 		ce = mb_cache_entry_find_next(ea_inode_cache, ce);
 	}
@@ -1617,7 +1617,7 @@ static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
 				      ea_inode->i_ino, true /* reusable */);
 	return ea_inode;
 out_err:
-	iput(ea_inode);
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	ext4_xattr_inode_free_quota(inode, NULL, value_len);
 	return ERR_PTR(err);
 }
@@ -1850,7 +1850,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 
 	ret = 0;
 out:
-	iput(old_ea_inode);
+	ext4_put_ea_inode(inode->i_sb, old_ea_inode);
 	return ret;
 }
 
@@ -2012,7 +2012,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				old_ea_inode_quota = le32_to_cpu(
 						s->here->e_value_size);
 			}
-			iput(tmp_inode);
+			ext4_put_ea_inode(inode->i_sb, tmp_inode);
 
 			s->here->e_value_inum = 0;
 			s->here->e_value_size = 0;
@@ -2152,7 +2152,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 					ext4_warning_inode(ea_inode,
 							   "dec ref error=%d",
 							   error);
-				iput(ea_inode);
+				ext4_put_ea_inode(inode->i_sb, ea_inode);
 				ea_inode = NULL;
 			}
 
@@ -2206,7 +2206,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
 		}
-		iput(ea_inode);
+		ext4_put_ea_inode(inode->i_sb, ea_inode);
 	}
 	if (ce)
 		mb_cache_entry_put(ea_block_cache, ce);
@@ -2288,7 +2288,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
-			iput(ea_inode);
+			ext4_put_ea_inode(inode->i_sb, ea_inode);
 		}
 		return error;
 	}
@@ -2300,7 +2300,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 		header->h_magic = cpu_to_le32(0);
 		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
 	}
-	iput(ea_inode);
+	ext4_put_ea_inode(inode->i_sb, ea_inode);
 	return 0;
 }
 
@@ -2989,7 +2989,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 					continue;
 				ext4_xattr_inode_free_quota(inode, ea_inode,
 					      le32_to_cpu(entry->e_value_size));
-				iput(ea_inode);
+				ext4_put_ea_inode(inode->i_sb, ea_inode);
 			}
 
 		}
-- 
2.43.0

