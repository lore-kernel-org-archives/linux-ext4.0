Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D5535E925
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 03:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780977137; cv=none; b=G2auFML+5hm4Vbe6WdXuYdf9OGVBaCkUOm+0gryU3usVft0mgqoD2bgeogzRmIV0mPISsG8J5doNtPNVHWE/zUlEbroEVhRncaG0emeF2BAzAUqcck0PEgse4n4a/SLQA5IMuVVs+r7I4Ot60GiZJCvwdnaC2gvrAo4T82XGHXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780977137; c=relaxed/simple;
	bh=hdSVW6bl8+h5i6KnjDI3UWtf5kZ5kcQDkOrWk0z4KKs=;
	h=From:Subject:To:Mime-Version:Date:Content-Type:Cc:Message-Id; b=ju/wkNUgY+nAUGmf6vHwSGjyMKmh4g4ukyzUEEt4GJzNkLyuKne0DQMYAB1EyyyrVvZTNA7/xr3QEblXC+1OW92y7TiKXtRaYZ5RFxh4hqRbaVusNDl7o5CHn457SfC9RykTNgkLiWIVKvWavoVvZNVoFht24AGcR+C1qPLAhos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=b8or/2rz; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="b8or/2rz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780977129; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=3OgIEj2yUui+EzX4hPJghiUVKL6AAFLi2lczr6j1EMo=;
 b=b8or/2rzrG0eV6jeyCVrs2+RSpr8UPuWjTe6rUTfRwkGaY4LPznbQ9rl4ESK9uUj5ruPcy
 0nJosWBPP+YLaXqJ3rWn90rRs18L8DVX/MtzbK2kt7GLAn0hd7W1GSIKYSuWPkP0+H0Bq3
 PxGvapGe9kpXWxJVpuDZFOtSzGQCUuarc7++8UlhTzsB+RyLle++rpkr15j+1sR2Aboxzg
 t47mwMrE2Swr4MK+rGP/Xw6EfjMKygGiivm0x7dV0YLAOzvysyznz+cDhaPBLfHfHFLGxE
 Q59OsOT/tqt6GwLwCXmYAzB889u0TTzMmN+FfUN+PzvPuLi9StZW2ZiMP8Lc1w==
From: "Jia Zhu" <zhujia.zj@bytedance.com>
Subject: [PATCH v3 0/2] ext4: avoid tail walks for cached large-folio writes
To: "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue,  9 Jun 2026 11:52:00 +0800
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a278de7+cb8082+vger.kernel.org+zhujia.zj@bytedance.com>
Cc: "Matthew Wilcox" <willy@infradead.org>, 
	"Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Jia Zhu" <zhujia.zj@bytedance.com>
Message-Id: <20260609035202.90669-1-zhujia.zj@bytedance.com>
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>

Hi,

This series addresses a buffered-write regression we found during our
v6.12 -> v6.18 LTS upgrade testing on ext4.

The regression is in the remaining buffer_head path.  A small overwrite
of an already cached, uptodate large folio still walks every buffer_head
attached to the folio in both write_begin and write_end.  With order-0
folios this was bounded by the page size.  After ext4 enabled large
folios for regular files, the same loops became proportional to the
folio size.

I agree that converting ext4 buffered I/O to iomap is the right long-term
direction, and that would avoid this problem.  This series is meant as a
small fix for current and LTS kernels that still use the buffer_head path.

Patch 1 follows Willy's suggestion for block_commit_write(): if the folio
was already uptodate on entry, stop the commit walk once the copied range
has been processed.

Patch 2 applies the same conservative shape to ext4_block_write_begin().
It keeps walking from the first buffer, so prefix buffer state handling is
unchanged, and only skips the suffix for folios that were already
uptodate on entry.

The workload is from libMicro, which we use in kernel release testing:

  https://github.com/rzezeski/libMicro

The table below includes the v6.12 baseline from the same release
benchmark.  The v6.12 and v6.18 columns were run with THP=always.  The
last column is v6.18 with this series applied.  Results are usecs/call,
lower is better, and the improvement is relative to unpatched v6.18.

case           v6.12    v6.18   v6.18 + series   improvement
write_u1k      0.609    4.659       0.528           88.7%
write_u10k     1.408    4.869       0.809           83.4%
pwrite_u1k     0.609    4.659       0.538           88.5%
pwrite_u10k    1.399    4.889       0.819           83.2%
writev_u1k     2.238    5.277       1.179           77.7%
writev_u10k   11.057    8.029       4.219           47.5%

For the cases that regressed from v6.12 to v6.18 in this test, this
series brings the v6.18 numbers back below the v6.12 cost.

Previous versions:
v2:
  https://lore.kernel.org/r/20260608120131.45146-1-zhujia.zj@bytedance.com
v1:
  https://lore.kernel.org/r/20260603134800.25155-1-zhujia.zj@bytedance.com

Changes since v2:
- simplify the ext4 loop condition as suggested by Jan;
- add Reviewed-by tags from Jan;
- add stable Cc tags.

Changes since v1:
- replace the ext4 seek-to-@from optimization with a conservative tail
  break that preserves prefix buffer handling;
- add the block_commit_write() tail break suggested by Willy;
- add v6.12 and v6.18 benchmark results for the full series.

Jia Zhu (2):
  fs/buffer: avoid tail commit walk for uptodate folios
  ext4: avoid tail write_begin walk for uptodate folios

 fs/buffer.c     |  3 +++
 fs/ext4/inode.c | 11 ++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

-- 
2.20.1
