Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2D237DE90;
	Mon, 15 Jun 2026 11:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524722; cv=none; b=j1hn5VImT2rNOwFuGaLwCtTsijX9aslNQwYsGsCpxnz6l34uLbG3KqlusR24oHZO3KxgEfNQs02+Bpyqf+9Q+kTFz2qA+pUwiFiEPTQVn9pI5LGHpoDzy+zx81VFXRxK6k5D2YBOy2Unaa/m6flpDA6vupPBdKmvU7/BNQdFe3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524722; c=relaxed/simple;
	bh=84jRwwVDp7h7Xc43j7IXCGcgg1AfFKEh/RzqOx6kALA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MjBHatGkUdlueA1sCzRMlYhSBatf9LkKk8WegUk4adzXPACtfL8iiav1iYd3u5AHp7J6hPte/qg6KXQ5LfjvLE4qLV4weR8R0dEE1O303t7ULvVhNYbXaH9ZhA/iZzC/gEBbvuUoxnohfW+gtq1CmEHcQ8gyX8ZvFCC/eLx0iJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Gnz+7fF7; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Gnz+7fF7"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FApTUI1060872;
	Mon, 15 Jun 2026 04:53:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=bcGA5SdK2
	vYbK/cFcaKzLvvSiZeg6bHzORpobUv0lHY=; b=Gnz+7fF7/gD1WwS0SW13KXG6+
	+XJrUR+mO7RsPM9k0I5n3MVEGG8pxrWJUcZ/tjJMoz01HrK58xxtLPvpv7QoVYH1
	HjHPf0URvBxs/w6J7oUxp7xRl6VFMTWO6X0q61iGIg0gsp/SuJjTcjSs6/OF+ksh
	cGOjeP9eVL7F8swiYemwN8dvPlkS0SXIZ2T+NFJu3Q0jq7B8uw3Ynxdx0Cj8A/eI
	9nUB5yrWxVrbqrTXpnIYFlzp3wj+hW0TFDIa6S6O2XnsXtw1wov9EayGViI8t3wn
	1Nwc2FXsib4n/UFwrWlVL9Ye+1NslNuryEj7AmVp55zFFSUBPdGvxtpbKL66w==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es6qdt4hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 04:53:21 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 04:53:20 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 04:53:18 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 0/3] ext4: fix xattr iput deadlock with s_writepages_rwsem
Date: Mon, 15 Jun 2026 19:53:14 +0800
Message-ID: <20260615115317.3549469-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=DLq/JSNb c=1 sm=1 tr=0 ts=6a2fe7b1 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=qKkoInzyUaplSM5oE94A:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-GUID: jqmZ7NSxSfVbDSIdRatvc7qYOgYpcPIe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfX5T5lh+DPCxgv
 TZGZNn98eOMfiOauSdN6jtbSAKwLRpw4LbTdZUuukciJJ6ghTqf2PX6cdl9ULLMa8amgeOCJa9m
 3sL/1zQ267/WnRjSQKf1pliQWB4J02omfaxnDvQHA+a3FkpNRgxn+udBOJMG1yLdIRI3eLtA3b8
 1862VSX02eCGiDGZJeqk4POnTgzbIQh6qzKnUTTgX692+7FtwwnlBsi9+K9WlLdpewo+EDt10PL
 Ovp6lChdkeUzt9LBAn4fsUhVgl/Zu01i4KkSQn4RRnm8Jmo5+ZoxWMHqEhPbStrsHMnEuor9mpv
 gxJwxZZwVQ4OFLSN2M9iM+Cjl1wQM9USd6BZlo6M3Tjo78SmG1Wvo7y0BJgq921ZKPleP/vr9fS
 7uBkBH8TJKo4KOfVFVSoWtEkIh7p383+24rIZYgnbxFAD7w6ofDrK7hxjZN/1OPwmW44FgLGFBC
 OYGAdAaas2FqonL+iNg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDEyNSBTYWx0ZWRfX7+uNUatIIDSI
 1KWocqaGV3nign+u8nRdIV4WsC5/ENaUORbSXZGYBamdkROpvuS4RwTxt0VJPkGEBJQ7RhMJazv
 aUxUH4KYwi6jRSPG7DC0VAMuyHtIbNh5uFzzvtzes5dL5xQuGhbF
X-Proofpoint-ORIG-GUID: jqmZ7NSxSfVbDSIdRatvc7qYOgYpcPIe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150125

This series fixes a circular lock dependency reported by syzbot:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

The deadlock occurs when iput() on an ea_inode triggers write_inode_now()
while xattr_sem and a jbd2 handle are held.  The triggering path is
during mount-time orphan cleanup (!SB_ACTIVE) where iput_final() calls
write_inode_now() synchronously.

Patch 1 blocks the deadlock by skipping extra isize expansion when
!SB_ACTIVE -- this prevents the xattr manipulation path from being
entered during mount.

Patch 2 is a belt-and-suspenders semantic improvement: an inode under
eviction never needs extra isize expansion.

Patch 3 is a structural improvement: defer all ea_inode iput() calls
until after xattr_sem is released, reducing lock nesting depth and
preventing future code paths from reintroducing the lock ordering issue.

Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5

v5:
 - Split into 3 patches for easier review.
 - Add explicit !SB_ACTIVE early-return in ext4_try_to_expand_extra_isize()
   to block ALL mount-time paths (ext4_process_orphan -> ext4_truncate ->
   ext4_mark_inode_dirty), not just the eviction path. v4 only relied on
   EXT4_STATE_NO_EXPAND which doesn't cover orphan truncation.

v4:
 - Comprehensive rewrite of the deferred iput mechanism.
 - Thread ea_inode_array through ext4_expand_extra_isize_ea() and
   ext4_xattr_move_to_block() so ALL ea_inode iputs in the expand
   path are deferred, not just those in ext4_xattr_block_set().
 - Add NULL safety to ext4_expand_inode_array(): when ea_inode_array
   pointer is NULL, fall back to synchronous iput (for callers like
   ext4_initxattrs that only run with SB_ACTIVE).
 - Use __GFP_NOFAIL to guarantee deferred array growth, eliminating
   fallback to synchronous iput under locks.
 - Update ext4_xattr_ibody_set() and ext4_xattr_set_entry() signatures
   to accept ea_inode_array, converting ALL iput(ea_inode) calls.
 - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() before
   ext4_mark_inode_dirty().

v3:
 - Check ext4_expand_inode_array() return value; fallback to
   direct iput() on ENOMEM to prevent inode leak.
 - Make ext4_xattr_set_handle() take an optional ea_inode_array
   output parameter so callers can free after ext4_journal_stop(),
   avoiding the jbd2_handle vs s_writepages_rwsem AB-BA.
 - Pass ea_inode_array directly to ext4_xattr_release_block()
   instead of using a local array freed under xattr_sem.
 - Move ext4_xattr_inode_array_free() after ext4_journal_stop()

v2:
 - Defer iput() in ext4_xattr_block_set() via ea_inode_array,
   freed after xattr_sem is released. Fixes the root cause.

v1:
 - Set EXT4_STATE_NO_EXPAND in ext4_evict_inode() to skip expand
   on inodes being deleted. Only fixes the syzbot reproducer, not
   the underlying lock ordering violation.

Yun Zhou (3):
  ext4: skip extra isize expansion during mount to prevent deadlock
  ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
  ext4: defer iput() on ea_inodes to reduce lock holding scope

 fs/ext4/acl.c            |  2 +-
 fs/ext4/crypto.c         |  4 +-
 fs/ext4/inline.c         |  8 ++--
 fs/ext4/inode.c          | 26 +++++++++--
 fs/ext4/xattr.c          | 93 ++++++++++++++++++++++++----------------
 fs/ext4/xattr.h          | 10 +++--
 fs/ext4/xattr_security.c |  3 +-
 7 files changed, 95 insertions(+), 51 deletions(-)

-- 
2.43.0

