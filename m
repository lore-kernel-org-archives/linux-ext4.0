Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66993C1A
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 01:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335351; cv=none; b=Sc9rbBWba/azeoOjShUuBY4uK9KiXrg6sCIquZ7jdvZHE+JOMiQWqikvUh/wDd6aS4x/vXF5polyW4z6OnscO38OY4SKzk3ZNHSMsmIolPsK6azOvy1/+6S/SscRLPV9v7vALm69MH8cSCPaitD+w2f70UxF0F9n0zv9NyM7A5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335351; c=relaxed/simple;
	bh=lZ1xbaoJxl7g2bXHCuYLctZ0kdEBBGSEco5/kK4gTLA=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=r5L1Rfs5AIyji8dc/qG1R9bHvf8VhqgxX9UL6mbKBSTEO4Ln0waErD1BymtgzVh7E5WbDkKwxFF6RQIYzBJlsz9EnWl5zlhOly+sJh9gsWCQSMZpk6b/TTVZn3TRaQoqB5cHOVHx+4GeN1+JalprZh/H1LFuL2YIYTWqZxWpHhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qpE4JPBk; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qpE4JPBk"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261007010901epoutp01b91371269db9f2b5c18affcf472ab4d2~cGgCtOtxu0611106111epoutp01x
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 01:09:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261007010901epoutp01b91371269db9f2b5c18affcf472ab4d2~cGgCtOtxu0611106111epoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791335342;
	bh=lZ1xbaoJxl7g2bXHCuYLctZ0kdEBBGSEco5/kK4gTLA=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=qpE4JPBk4y4ZFNxJu2qiUDUyOXJPxETVVtG498kYHXiCKPEJgyD6YzorxEYWrFn4u
	 e2saNB+YoVIeKlt4HyxRv5aLyHUDymsFmHEw4JMoRJosx/b2SulAmyis09mrxo27rr
	 5Yd7xypN7vtHIzVKlwTlR+fqI8OkS6/R1fHxmbH4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261007010901epcas2p205378bb3b6bdd3060b4fa834a41ec355~cGgCTm3CE1562815628epcas2p2N;
	Wed,  7 Oct 2026 01:09:01 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.209]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hzw4Y2NQBz2SSKZ; Wed,  7 Oct
	2026 01:09:01 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 2/2] ext4: track zeroed out blocks of unwritten
 extents for fast commit
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "tytso@mit.edu" <tytso@mit.edu>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <sashiko-outbox-162556@kernel.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261007010900epcms2p66e3f6b8e14468cf399e14cea7d107c9e@epcms2p6>
Date: Wed, 07 Oct 2026 10:09:00 +0900
X-CMS-MailID: 20261007010900epcms2p66e3f6b8e14468cf399e14cea7d107c9e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261007005529epcas2p241745ac48b13e8e684666ae6b0e46f53
References: <sashiko-outbox-162556@kernel.org>
	<20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
	<20261007-ext4-fc-zeroout-v1-2-b86de6439431@samsung.com>
	<CGME20261007005529epcas2p241745ac48b13e8e684666ae6b0e46f53@epcms2p6>

On Wed, Oct 07, 2026 at 00:55:24 +0000, sashiko-bot@kernel.org wrote:
> Unlike ext4_zeroout_es(), ext4_split_extent_zeroout() does not update the ES
> tree, so the outer zeroed blocks remain EXTENT_STATUS_UNWRITTEN in the cache.

Mostly a false positive. The failed split drops the extent from the ES
tree, and it is then re-inserted as written, or left uncached so that
the fast commit falls back to a full commit. A stale unwritten entry can
remain only for blocks that were just zeroed out, so replay gives the
same contents.

Daejun
