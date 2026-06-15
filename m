Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAF140BCDF;
	Mon, 15 Jun 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541376; cv=none; b=LPSkAuqPjHLc1E0VjNaCw2fJwEAF+h/aQ74seVvIJHqh1bEs9BXTJlvHJ1UxwubytOK/d1Z4jXIM6WZrtE/on1q7yhw48UINu7X1pQuE0mcppVbmi549VkUjz/jcFCDE7gHEoWIbeLqRKs0k7AJeB6RKzMopGG1L/A+8zFIgd5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541376; c=relaxed/simple;
	bh=htmzChsKiDO3g3Rv3FAnFIf+qorcxHdiAEH3Rwk7OFk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H4Vh1yVa+daKYJgh8wGVtLq+yfDLgo7g5t1t1xhXXfn2aOqNoegnl+E6o7xBzWJyt/FQUkjuBYBhHZJE4hMAg/fBPtrURHxYqnQSHkYxt4tG69+tnVbDs7/jDgas6lTVFFbYXWuKZ1kdHtMpbxR0I/0LFo7Zjzpw1++USXCIhYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=jTKCF50X; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="jTKCF50X"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFfOTS769080;
	Mon, 15 Jun 2026 16:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=SUgkeRFD4
	CMqo5KAvvY6B/aaZe8CJR6mVMvy5ySSZZI=; b=jTKCF50XPObCLx40NMv9f7zJG
	HNkTMIca/7Ug+035BpnTbYw1DH+PDuI5F1t4rzF6p42ZASJS/oY/kw5UO47z2gAg
	6noNwDfZbXAcSYawQJ9KQShgrX3DMor6oPHLCYVoRN9I8UcYoe0LK+alsT56nm/R
	cpVh1+L7qwJ7MCIUO0GrLJw5tWRqc/+ATo4++sqDc0XPNrM8TdjJyV+UNbJk3xEj
	W2C1FrbX2JFgjaLwIDNUFjH8+25liM9ors3bf9eqpefI0ImXL2d9DtGQNVkulDgG
	ubfaBFNvFEPpDmIVAwzLZ50S/6YBBTDNhCxV31/tObFGvYUpnZDNIJpYzH2uQ==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4erx63u17h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 15 Jun 2026 16:30:43 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 15 Jun 2026 09:30:42 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 15 Jun 2026 09:30:39 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
        <jack@suse.cz>, <ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
        <yi.zhang@huawei.com>, <ebiggers@google.com>, <yun.zhou@windriver.com>
CC: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 0/3] ext4: fix xattr iput deadlock with s_writepages_rwsem
Date: Tue, 16 Jun 2026 00:30:35 +0800
Message-ID: <20260615163038.1223293-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=SvmgLvO0 c=1 sm=1 tr=0 ts=6a3028b3 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=fTW__CHxibyLmBMfj2wP:22 a=edf1wS77AAAA:8 a=qKkoInzyUaplSM5oE94A:9
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-GUID: ufjFMlCofeNmis0hhFz87kz4QApT4Aki
X-Proofpoint-ORIG-GUID: ufjFMlCofeNmis0hhFz87kz4QApT4Aki
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE3NCBTYWx0ZWRfX51N3R7wvgH7S
 Hoj4XdnV/qQXX9CyhKmzoWjlw1+sV2S+VTcx3eYmG3Tj56Am/l27mF0x3YjZAzj7k6hVyyV184Z
 LUTxlsjYMb8xMBvEhBbA38VV47gT3sQTOLG+w1yXju+DCsmv8QP5XfGgqZ5Zc2WDWZ8BAlg/UG9
 pKNU/aJV+/Z4bU50b+kBEyz0gr04UCJmogD0ng2jb9zWC4/pG1pnxCJfk909bREPidxHkQZ+L1i
 p2glkiVld4vgT2BY4ZGrx3Y7C1INplNrCbfe0sPQplATLm2EvpeNwWrW5PIp+GGCo/OcHlJYwfi
 PXiVHMUuZXLBV4aVNTPZLiLTtKk1/xNhTjqHXd8l+uX3MYVKHRYYW0JKWIaiD2itqkHbHjhc6x0
 eMpw+CXXHMsbbxmByRm3Vpt+aAIvVebnlHNlfnbusCOChCPNK5SKvkHTDUXlRRy8UX4oBs+K8eb
 uXqmwNBEMqEB1lOvDUA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE3NCBTYWx0ZWRfX/1qOic6X2lN2
 Qku0du6OG8FblVoU6XLJ7L377sBz7Vzjx64D6qWBUhyuNYDbkvMtnzaYt55pdmi63zNxQNc5YkD
 Gwsqc0dJabh20xu7TrVIzxGDNP5El91CpKNKQFyE64fpFbXEDSLI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606150174

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

v6:
 - ext4_inline_data_truncate(): use local ea_inode_array instead of
   passing NULL, freed after ext4_journal_stop().  Fixes a deadlock
   reachable via crafted filesystem where inline data xattr entry has
   e_value_inum set: orphan cleanup -> ext4_truncate ->
   ext4_inline_data_truncate -> iput under !SB_ACTIVE.

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
 fs/ext4/inline.c         | 10 +++--
 fs/ext4/inode.c          | 27 ++++++++++--
 fs/ext4/xattr.c          | 93 ++++++++++++++++++++++++----------------
 fs/ext4/xattr.h          | 10 +++--
 fs/ext4/xattr_security.c |  3 +-
 7 files changed, 98 insertions(+), 51 deletions(-)

-- 
2.43.0
