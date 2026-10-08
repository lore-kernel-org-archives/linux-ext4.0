Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96B73D6494
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791445647; cv=none; b=LNy+bnRSpJ/KwUstRaPyBOwWBIacCvi1YFUiXRNmIkouna0humMN97LEGVYlMk8C7Sy+gKRvPENDy12jHdm7gKFT3PZ77vp6ZI5S3B93Uy9hFijGbas9rtP9a8wVOiwkRQd8Zs1+MYL8kHE2iAMlLCmai8kJlN1KozaXknCh/qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791445647; c=relaxed/simple;
	bh=WmDgLymXivLEP/4zC8uAdcdGK0ICXX4CozZw27Upafc=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=VLhmNkWhL4zz9NPW3Nu8tbliR2y7koEDU0eEUoJraKDBNzsH/GWQGYq22ZjAHII5/NotrzRcKKayTo4aJxhHfo6+3AgfTaF1p5RbUQcKX5hA8X0YMNHO8v93YvOEBhPyma2/YRky3nCxfAyQFTxPtR8f5nH6JpLmfMlQcNRQ97M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PKY6VrT/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PKY6VrT/"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261008074716epoutp02f44dd8a06a2dba367bc63a329a533a96~cflCAmd8E3225532255epoutp02b
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 07:47:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261008074716epoutp02f44dd8a06a2dba367bc63a329a533a96~cflCAmd8E3225532255epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791445636;
	bh=WmDgLymXivLEP/4zC8uAdcdGK0ICXX4CozZw27Upafc=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=PKY6VrT/MUoXRK6jh91qXN5bKGPkWL4lGPjrsvwHx/bJ9Ng9Kxpu2dIk2tuVdYHmf
	 W2pSp4Cgl+kn5a5dbWsfH5in/622zTNM2ikiqUi7eP4qOqhnrEI8WIccljMpoL6QFp
	 TjZeDWqZzeZ26hArRe9egnQ/ITgqcmX+jQcV0c00=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261008074715epcas2p35351906e2bfbdb90b8a41e9d7328c806~cflBjax9Z1103111031epcas2p3_;
	Thu,  8 Oct 2026 07:47:15 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.211]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j0hsb0911z6B9mQ; Thu,  8 Oct
	2026 07:47:15 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH 1/2] ext4: don't cache unzeroed blocks as written
 after a failed zeroout
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
CC: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>, Andreas Dilger
	<adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, "Ritesh
 Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, Harshad Shirwadkar
	<harshadshirwadkar@gmail.com>, Li Chen <me@linux.beauty>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <asc2BOOFgO8Nupw7@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261008074714epcms2p27e156e29471fdc7a8f50cc8a422989a1@epcms2p2>
Date: Thu, 08 Oct 2026 16:47:14 +0900
X-CMS-MailID: 20261008074714epcms2p27e156e29471fdc7a8f50cc8a422989a1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261008062023epcas2p17ab2f934eeb6ba157103b01c9cb59f5b
References: <asc2BOOFgO8Nupw7@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
	<20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
	<20261007-ext4-fc-zeroout-v1-1-b86de6439431@samsung.com>
	<CGME20261008062023epcas2p17ab2f934eeb6ba157103b01c9cb59f5b@epcms2p2>

Hi Ojaswin,

On Thu, Oct 08, 2026 at 11:49:48 +0530, Ojaswin Mujoo wrote:
> Feel free to add:
>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>
> btw, did you catch this with some fstests? If not I think it would be
> good to add a test for this.

Thanks for the review.

No, it wasn't fstests. I ran into it while working on 2/2: when adding
the fast commit tracking next to ext4_zeroout_es(), I checked what it
caches when the zeroout fails, and saw that zero_ex1/zero_ex2 keep their
length on that path. To confirm it, I put dm-error under the file system
and failed only the zeroout.

I turned that into an fstests case [2]. The existing dm-error tests
don't reach this path: they write with direct I/O, which leaves the
extent unwritten until the I/O completes, and so does a buffered write
with the default dioread_nolock.

v2 [1] keeps this patch unchanged, so I'll carry your tag if there is a
v3.

[1] https://lore.kernel.org/r/20261008-ext4-fc-zeroout-v2-0-55cab1e24fa3@samsung.com
[2] https://lore.kernel.org/r/20261008-ext4-zeroout-eio-test-v1-1-9bb66deaf646@samsung.com

Daejun
