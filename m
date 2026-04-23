Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656813BFE31;
	Thu, 23 Apr 2026 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934961; cv=none; b=rPn5TDUagMdb32d53zEz2GKMOnoYKU0raoyAu7DbS2kbhg+T1e/sb1xuyrWN/YSzFtvL3rqT29ep2WvLZL4/lXM0gbvIpWHBw2E5bTlH3jEcDLpibaCwntLUffavd8QB522yNNCCLqtX4uOiZHrEGMj+wzQ939aOtYQoQS5dv0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934961; c=relaxed/simple;
	bh=6GSlu3UgBB53vXrj1/gJ0uCZY3lpDKcWWuwiBmflzt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkImPQBVZ+x2JghGb5XXbFA3vJTNATUiYJ/rHBEuYdiQepH4nNxZDhNGZ8Vsf6gPadh69hWbAl/85UxHv8dDE6CHzU4zLft3Kflfbl8LCRbh5ApQeGozRjBq9CV+y1GGhJoK6528+egOfGhnz0b/VjP3eKFAK/h/4kqojPWDzbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jf6yTwb4; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jf6yTwb4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776934959; x=1808470959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6GSlu3UgBB53vXrj1/gJ0uCZY3lpDKcWWuwiBmflzt4=;
  b=Jf6yTwb44Y3D6Uovpo97MGB1iOAhqDFZKK5FEjg+ae30Hz24s3oEdA8m
   H0wERf4BV3QQQbxoxLhfbvlZniqxgMSU6XaPi9K72mW0pafej7RRQM/WQ
   26dRTgfMG5O3ULxd0DG/dmx5FzzxGJJexaWLd8h4R1O4mlrqbGDZJ7OKt
   /voI6YtkDnvIYkjaj2IvCuyu/KMf7Vjp56yIDidcEJzXFj0CvfaN1n95n
   LZJpP+5AWHyZ5TsrLpsjJNNbyKOOvN1JMHbY41i83Gq8tmcAnElmvvQGa
   4Eze9109KC5mNfM2TcH+8wLAnB39aXWtvH8XuXaprn2nboc4oaHVt4rz0
   g==;
X-CSE-ConnectionGUID: J6V9i/iDS4WIijKDGumOoQ==
X-CSE-MsgGUID: xVWmEeJwTBGCu4WKeS7zOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="100551975"
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="100551975"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 02:02:37 -0700
X-CSE-ConnectionGUID: vc6K8icbS1KWk7AsXIjmJg==
X-CSE-MsgGUID: WIedBRoUSGOpSFkjBpdp8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="232913041"
Received: from junjie-optiplex-micro-plus-7010.bj.intel.com ([10.238.152.98])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 02:02:33 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+26c4a8cab92d0cda3e3b@syzkaller.appspotmail.com,
	junjie.cao@intel.com
Subject: Re: [PATCH] ext4: prevent out-of-bounds read in ext4_read_inline_data()
Date: Fri, 24 Apr 2026 01:05:26 +0800
Message-ID: <20260423170527.129423-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ulfo7ut5ziqvrjy24besb4jtobijunycglvmqki7cwfzsancwi@5ycrwypubh56>
References: <20260421093138.906266-1-junjie.cao@intel.com> <ulfo7ut5ziqvrjy24besb4jtobijunycglvmqki7cwfzsancwi@5ycrwypubh56>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit

Thanks for the review, Jan.

You're right that v1 failed to identify why the buffer changes.  I dug
into the syzbot reproducer — the corruption path is:

  1. Mount a crafted ext4 image on a loop device
  2. Bind-mount the loop device, open + mmap it MAP_SHARED|PROT_WRITE
  3. Write through the mapping — this overwrites the inline xattr
     entry directly in the bdev page cache

The inode buffer_head stays uptodate throughout, so no re-validation
ever triggers — xattr_check_inode() at iget time is thorough but only
runs once, leaving subsequent in-place corruption of the page cache
undetected.

However, ext4_xattr_ibody_get() already guards against this with a
bounds check before its memcpy (xattr.c:674).  ext4_read_inline_data()
lacks the same check because it indexes via the cached i_inline_off,
bypassing xattr_find_entry() entirely.  I think aligning the two paths
is worthwhile, and it would also clear this syzbot report.

Would a v2 with this framing be acceptable to you?

Many thanks，
Junjie
