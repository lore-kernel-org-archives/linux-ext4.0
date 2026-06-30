Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E93EC2CB;
	Tue, 30 Jun 2026 10:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814163; cv=none; b=r9TEB42s3NLAF8Rx3MbS/TgmCPXPn4e5FoUsjPt9GypEmCQ2EHIXfQsd0WfcJgirtewYXSMFfnUkMKK7DPqJ6KJVShi9nFf73aN9sVRZU9dpzl3LDVkY7PDjftIWZPAxYeQ6kylCzvOXkZrJe9wGp6TuWyBhe9VP2zMTGCiR13M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814163; c=relaxed/simple;
	bh=jQIKINSzk9Y2T21NmTC3f3QYFbiOQbaIKvTXdgpO8u0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/ij4z2ATMZv2tSrnuAwofHPEnYoGzLNqbXR3DIYuv6SjZMBOMTM5yAitdgoyLYHSibu7pk5B10fvu7QmYqOvW8BiloQeOYnfGQ39VRBOAmDUFxHs/Tm2RQVF6ClklhElf976HpeHryJsiSk5wgRDaKyXG0gnmMEJIWO+t0D2hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=He9oF8oH; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="He9oF8oH"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U9oacN755771;
	Tue, 30 Jun 2026 10:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=W3Cc5ozYmAkjhyRVzpLa8art99yxwG3VN7yO3jCcXrU=; b=
	He9oF8oHiZFiD8nbAhYoyhCPVRMeSd2zolMDh4Z4pGd9qqNwnwmbBOU5z+Uc8BIq
	YQD5gFkHp2SC9HdVcyvWolJ7rirzZyO+Z61RB+0cmY3AcqKRkVVUC2oEeByVI3DI
	++cKK0CmBTEsDONhP8eKUNdZDF/P6u+ZuQEzjFwPsx3OpELGc/RXYniisZ8LlSYN
	3n9YWUEQyIEg0FDh3hGURYGQLNTvRdlwN4huAEjZ7ydRN/fdl1HRWpVEUszA806x
	U/jiBc95FSg61uYpd5Oo6T71+JD4JwOYx7jSwugb6QM714vG9qdiCgMvxxYZLIZ5
	HChfOoFZNYizQug0aqJZ+Q==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0bqbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 30 Jun 2026 10:08:44 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 30 Jun 2026 03:08:43 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 30 Jun 2026 03:08:40 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v12 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
Date: Tue, 30 Jun 2026 18:08:28 +0800
Message-ID: <20260630100829.1257618-4-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630100829.1257618-1-yun.zhou@windriver.com>
References: <20260630100829.1257618-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a4395ac cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=t7CeM3EgAAAA:8 a=o_jFod6Xf73EBe-g21MA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: JAaApcI-B5HjQ-PczGqY42lcz3zbUvnp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA5MSBTYWx0ZWRfX68UXpkEf/GOo
 wZm6uVOztulDBRDm5dikLrFWJgT8GFPR6dVMK2qOzOis3F6ZW5WdtCxGnZBRK86BfAjupE35fQF
 8pDF6TCe8zSpbDURxqRcISUco6s02RKT7okPAude6yS+zSgucF53baG/zXOF/1FY1EBASjqUHI1
 TezvO3zE35eVc0QOQ5DevedZLrv5CiSHaWveptlGXa9TVEoyVYbGeFCp3MKQOM8etUyCr8eiJCb
 +qWHtJJSOH7ZzGzaxAVw0RHmyZ5T9JxT9PltGevqxplCvXI0mtBQwajTXFamnUL8nBeELbx0sor
 VlI8639zQCWCd8QZXxpbH+UrFtGRVFRcPMvmNUvcZiEa9qrCZ4OnZBpjuofykrWe1xTUD29FxKV
 eVFcSuod9hChassq2RpmlB2A0gYilvPWa/mVV3b5rcEJQa1WC/RZHsYtb8NJ+bX2usEw35kjJfA
 eGXYSM3cgTpIl2LlQFQ==
X-Proofpoint-GUID: JAaApcI-B5HjQ-PczGqY42lcz3zbUvnp
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA5MSBTYWx0ZWRfXxVMFHw7sZavW
 EQy52lcq8M0hReVURra2T+E8Ao557cuLcaWQ4zRuZ5c21DplUUZ7/p4Zgi/YTNBdBmL+dv1PA6J
 4nFra40ocAzLE9l59mM5ld4y/hT7aD0BAmTCD7lU9jI6LME5je5i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300091

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

