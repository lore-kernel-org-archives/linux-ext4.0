Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FCC486437
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 10:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455180; cv=none; b=raioHdGrL+YwoMRY4TnHK8DsenHb4+bAWWqhL85QW0myvoUfH25+cWIUTcbqxyhGPPNkJMOVjDclJIlK3dqpkzpRPyg8Z6V/QB05C6EpQzy6O3kVvO/I8iCZsrWd3S+wWdDTTx0JiZmeal0qVpg79buFYIE+NqeBphMKs1m2nwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455180; c=relaxed/simple;
	bh=HzR9WNnD+ifJl3sRZqNLJRURJgYZXfwYK1/idMmy6xE=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=NPijZ8jeU2DSobJ2lm1UegmaTosK2gXBQemwKtGCOqRfHyqHsSwd7GFX4AiACPPoPhM7XW3wW9f0zfJC7dwbEU4OTimVS4eoGgFboOYgTMIxYxcLjl5pq/2Yvrm7LmaWzn3nZLIZVigWtL9Jh2uE0/cA/c+NQq8hjr03gK6Dx+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jQoNIQBZ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jQoNIQBZ"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261008102616epoutp02555f77b2a50cee0f042995c20cbfcdc5~chv3Izf6q3019530195epoutp02i
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 10:26:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261008102616epoutp02555f77b2a50cee0f042995c20cbfcdc5~chv3Izf6q3019530195epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791455176;
	bh=HzR9WNnD+ifJl3sRZqNLJRURJgYZXfwYK1/idMmy6xE=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=jQoNIQBZG1PoMNBYOrZK4iaS8DB0jBSPUEpw0AeNZrr4YEDFTs2pU1sRlOOz57hT3
	 pMmxnz+hiDTyykXcnZoyghomJzWY9DMVZ9H4o7cYfBRhRggnlsKk0fGo2+TWMT+goM
	 /fvZe6FZrK/unjW6BvVbbs8IwIPsMn5qn3OqlzMc=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261008102615epcas2p275f7269caa86134c5081a53ee069e69a~chv2t-f9J0793507935epcas2p2h;
	Thu,  8 Oct 2026 10:26:15 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.205]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4j0mP33rdYz3hhT9; Thu,  8 Oct
	2026 10:26:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH v2 2/2] ext4: track zeroed out blocks of unwritten
 extents for fast commit
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Jan Kara <jack@suse.cz>
CC: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
	<ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, Harshad
	Shirwadkar <harshadshirwadkar@gmail.com>, Li Chen <me@linux.beauty>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2lgtlg7ydx4qeau2nvv5wkcuc2jkvwdcrav7gbxmxdieptkwl4@emgyfuxuskiu>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261008102615epcms2p2858ca95d96bd2b090f2e406aa1bad63c@epcms2p2>
Date: Thu, 08 Oct 2026 19:26:15 +0900
X-CMS-MailID: 20261008102615epcms2p2858ca95d96bd2b090f2e406aa1bad63c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261008095512epcas2p243a0deff110c0cc75da1ae049b4bbb8b
References: <2lgtlg7ydx4qeau2nvv5wkcuc2jkvwdcrav7gbxmxdieptkwl4@emgyfuxuskiu>
	<20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com>
	<20261008-ext4-fc-zeroout-v2-2-55cab1e24fa3@samsung.com>
	<CGME20261008095512epcas2p243a0deff110c0cc75da1ae049b4bbb8b@epcms2p2>

On Thu, Oct 08, 2026 at 11:55:02 +0200, Jan Kara wrote:
> Just one note: I agree with you ext4_alloc_file_blocks() is actually handled
> correctly. But OTOH tracking a range twice isn't really an issue (only tiny
> performance overhead compared to the extent tree operations and zeroing
> itself). So I just wouldn't special-case ext4_alloc_file_blocks() and
> always pass a proper handle to ext4_issue_zeroout(). That keeps the logic
> slightly simpler: kernel zeroes out blocks => kernel tracks the range. But
> I don't really insist, it's just a suggestion.

Thanks for the review. I wasn't sure I should do that in
ext4_alloc_file_blocks(): f4265b8d32c4 ("ext4: add
FALLOC_FL_WRITE_ZEROES support") issues the zeroout outside of the
running transaction on purpose, and passing a handle there would put it
under the conversion handle, so I left it as it is.
