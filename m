Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAB43CF962;
	Tue, 23 Jun 2026 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204814; cv=none; b=ZIzQ5e7jvj+2kB1cELsv1J9biIjjjtv7GDU/PtcAoeha0VTWK+VlfaqiQoI3D3xxO2wPIFyYstDNiBkd8e5Q8RRSAULN4lzhF910y2j3W/o6s8pYt7wZEDoPq8h3PHLqKbEoFXI8SytU11JADA8yM9+ucPMRx8LM+Gp0/1t1MUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204814; c=relaxed/simple;
	bh=aRp+Ev0KuBcwdnAJLrtrviPsMucvpppmXB0/eMPyGWc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/C2enNGPc/8k1D8oPFk38w6li0Gaox00GUip/OW0yqG71MH1YeWbOQBFFA3k38lnfXypu4rQPfm5k6PMO1GY5wRgPmx+JB7nvS6YUmAT0XQLFaci20xJxdVAD4XzdxAx+W7rLGqMogeCNfXDnz90MCWS5LQaByFaNlW7l2kQPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=LASjWyu9; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="LASjWyu9"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N6kT2w3332746;
	Tue, 23 Jun 2026 08:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=5M5AS05P0dYmh7YdwmMjtOm1mR7zo9FFzxzRD/pzeLs=; b=
	LASjWyu91Iq4pdM4IGZipefCJvhntBokwcOjN0KHL5uz/jQ+s4V2rwEy/fVwcJ9E
	YzNxDhNjfWlj8IS43TzEoeOFcWpzf6t9D4b/dQf2tkXvbJBALI8hBEShvI8+AIXD
	VGK4rH9Qfho9igvEf3maJHjvdnGJrko55i4r8xzdohgoH1PRSbZ3UmXJ9QU+j5cl
	kkj6sj/uM7vBq6if9b2kkAKBRrHMIXPM3Y0WCEMWlcR7xz62kkqKvfW93csR5M2N
	e/u9+e0tvfbre8+L1jqjd1lO4FzdVJT1SqwQBmoWeOnDbLluiXU30ODvlwpyAZkn
	V6XOyqTtVBiOBup1S52Dtw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wu867-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 23 Jun 2026 08:52:48 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Tue, 23 Jun 2026 01:52:46 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Tue, 23 Jun 2026 01:52:43 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yun.zhou@windriver.com>
Subject: [PATCH v9 0/4] ext4: deferred iput framework for EA inodes
Date: Tue, 23 Jun 2026 16:52:39 +0800
Message-ID: <20260623085243.2816425-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623083540.2744885-5-yun.zhou@windriver.com>
References: <20260623083540.2744885-5-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jpOnpqDlLEEaxO9ihxGyqFeOPzME9wQc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX4j67N8K/aJiN
 K3ScyTDKnNVopr3QUw8TAZEpMix1k/rgx6qa7kpTWrNWl/OFco1aQVUB7hc6jXVuBxUgYNHpR1K
 o3mykosTzvlPDfthVPM1vsmdMAHeAsexpV26zGu/YJud6NbEewxO
X-Proofpoint-GUID: jpOnpqDlLEEaxO9ihxGyqFeOPzME9wQc
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a3a4960 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=klDOsUkWDRETUCZYPvoE:22 a=edf1wS77AAAA:8 a=81yUN2V3KuxMimm0HBwA:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDA3MCBTYWx0ZWRfX5Oa9PAPTmSD6
 q6sVf82hPJ6vew6RdpS22g+HiEFZwUsQoOHu0Dr17zxbRBW0TI0mPgjSHoUoEs4zaf8jgSmU6A4
 n4cSbGp8X1R7yM6VqQFBqUcSdV7lput5qx1Ln2SkPzf/wZ4Vz32vCuonAhxKKeg098E6BrTdgIK
 yydigBm2+3KZCKoi7FDlXwWYhmS4Uie1mKnKSsqZDnht0n2sCR/IrnaOs2KKqQAb3HK8oNoUD6A
 XP3JLhs7fYJm2apk4Lls5CKPt4VwzWup5CKB1St/S1MMk+9/imcI3nZun4LUhJB4T5yzUR3Xw5w
 AEIr1drJRvjIX7TcgXq6jzQ6Z4GCMxsbL/dNsZBIL9OJI8jcxT56MSAqpSC59p0pFXEkMvDTYJG
 04rROF25P4rPugcawANg+JXztsn0WX8kCP0j8xHLOumoKCf509jHIu9SUN0juCukNgrKEV6a2l1
 sr88nGmmdbebWQlsllg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1011 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230070

This series introduces a deferred-iput framework for EA inodes to
eliminate a class of lock ordering issues in ext4 xattr code.

The problem: iput() on EA inodes while holding xattr_sem or a jbd2
handle can trigger eviction, which may acquire those same locks or
s_writepages_rwsem, creating circular dependencies.  The immediate
deadlock (during mount-time orphan cleanup) is fixed by two separate
patches already reviewed and posted:

  ext4: skip extra isize expansion during mount to prevent deadlock
  ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode

This series provides the structural fix that makes the code safe
regardless of calling context:

Patch 1 adds a VFS helper iput_if_not_last() which drops an inode
reference only if it is not the last one, using atomic_add_unless().
This provides a proper VFS abstraction for filesystems that need to
conditionally defer final iput.

Patch 2 introduces ext4_put_ea_inode() using iput_if_not_last() as
a fast path (single atomic, zero overhead for the common case).  If
this is the last reference, the inode is linked onto a per-sb llist
(via i_ea_iput_node embedded in ext4_inode_info, union with xattr_sem
which is unused for EA inodes) and a delayed worker (1 jiffie) performs
the final iput() in a clean context.  No per-iput allocation needed.
Also moves init_rwsem(xattr_sem) from init_once to ext4_alloc_inode
to handle slab reuse after the union field has been overwritten.

Patch 3 converts all EA inode iput() calls in xattr code to use
ext4_put_ea_inode() uniformly -- no exceptions to reason about.

Patch 4 removes the now-redundant ea_inode_array mechanism (parameter
threading, struct, expand/free functions), replaced entirely by direct
ext4_put_ea_inode() calls.  This is a net code reduction.

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

v9:
 - Add iput_if_not_last() as proper VFS helper (per reviewer: don't
   let filesystems manipulate inode refcount without VFS abstraction).
 - Use iput_if_not_last() + llist_node embedded in ext4_inode_info
   (union with xattr_sem) to avoid per-iput allocation entirely.
 - Convert ALL EA inode iput() calls uniformly -- no exceptions.
 - Remove entire ea_inode_array mechanism.
 - Add WARN_ON_ONCE in ext4_put_ea_inode() to catch misuse on non-EA
   inodes (protects the xattr_sem union safety).
 - Fix worker re-arm: ext4_drain_ea_inode_work() loops to handle
   nested EA inode evictions re-scheduling work.
 - Move INIT_DELAYED_WORK before journal loading (fast commit replay
   may trigger evictions).
 - Drain before ext4_quotas_off() for correct quota accounting.
 - Add flush in failed_mount_wq and failed_mount3a error paths for
   journal replay case.
 - Move init_rwsem(xattr_sem) from init_once to ext4_alloc_inode to
   handle slab object reuse after union overwrite.
 - Encapsulate worker init into ext4_init_ea_inode_work(), making
   ext4_ea_inode_work() static to xattr.c.

(Resending with VFS maintainers Cc'd -- no code changes from initial posting)

Yun Zhou (4):
  fs: add iput_if_not_last() helper
  ext4: introduce ext4_put_ea_inode() for safe deferred iput
  ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
  ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()

 fs/ext4/ext4.h     |  13 ++++-
 fs/ext4/inode.c    |   6 +-
 fs/ext4/super.c    |  18 +++++-
 fs/ext4/xattr.c    | 150 ++++++++++++++++++++-------------------------
 fs/ext4/xattr.h    |  21 ++++---
 include/linux/fs.h |  13 ++++
 6 files changed, 125 insertions(+), 96 deletions(-)

-- 
2.43.0

