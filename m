Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B737028C2BF
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 01:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791422676; cv=none; b=nvT86LWB/ya+jz0LQAcIOZrwjmgC0+vjecU0NnsENyVlqprQhPu18nNnBOsyCmbh7ELmdrkrDQktVxcC0JRIS20A5s6/PLICDVwkkBAD2FxFfz8v4hYePv5l0XiI/eKWZymdx6fz+i+L1E8Xf9SoLEeQ0eLSmAhJiDrNeeuhebs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791422676; c=relaxed/simple;
	bh=aOKZGZ5CSaNk8bAYpcBFQuWB0cJkwnqFmR9dJ1mHt5Y=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=Db9KhslUZrjm90YsXn7Y6zykY0YbgogHWpVfTabdhT8Qh6mSTIGCGYHWshkwIFxJ08XQ76SJZGASftdKGch8+rbcKKfJLMr6tW7WVATjBGhkVC4OSFCp0sVHJ3V2DO4hJZLH/MPUSj+Rm/OGdQ/oA6zGEeCngxLrx2qemsv/R88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kmdZHcJv; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kmdZHcJv"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261008012426epoutp0185a2562992db33bfbb4d3ec34c7cf543~caWyTS4iE2603926039epoutp01h
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 01:24:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261008012426epoutp0185a2562992db33bfbb4d3ec34c7cf543~caWyTS4iE2603926039epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791422666;
	bh=aOKZGZ5CSaNk8bAYpcBFQuWB0cJkwnqFmR9dJ1mHt5Y=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=kmdZHcJvX9T8u73FD4mBDxCALiPdKnx9OUJUFP5cG/IJIs98vXJVqbL3g7JxAWZw2
	 M7xozcm3wY+0NUJCi//SuhrSS1mq1ehQ/UNQpSc4l28AlVGudxwYO9KqecfFHg1e8U
	 R8Un7KKrrR9OX3nDh/Mk7UuGbWJDcwP9RYuIUGRY=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261008012426epcas2p48941fe3a08e2fd1e99adf9308f33b7b0~caWxz8zFH3076630766epcas2p4g;
	Thu,  8 Oct 2026 01:24:26 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.201]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j0XMs6pKLz6B9m5; Thu,  8 Oct
	2026 01:24:25 +0000 (GMT)
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
In-Reply-To: <vxase3lkctmatpkj3p4vvhgyrvauqyilkfd5dcz47jjtgfdipx@imb4onyzk3bw>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261008012425epcms2p1c4ddc3f2cc72dd30b0f18ee4f2ec9178@epcms2p1>
Date: Thu, 08 Oct 2026 10:24:25 +0900
X-CMS-MailID: 20261008012425epcms2p1c4ddc3f2cc72dd30b0f18ee4f2ec9178
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261007134122epcas2p261c7ea484933b17c10e745ec844b0aff
References: <vxase3lkctmatpkj3p4vvhgyrvauqyilkfd5dcz47jjtgfdipx@imb4onyzk3bw>
	<20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
	<20261007-ext4-fc-zeroout-v1-2-b86de6439431@samsung.com>
	<CGME20261007134122epcas2p261c7ea484933b17c10e745ec844b0aff@epcms2p1>

Hi Jan,

On Wed, Oct 07, 2026 at 15:41:17 +0200, Jan Kara wrote:
> Also putting this into ext4_split_extent_zeroout() looks a bit too easy to
> miss. In fact I think placing ext4_fc_track_range() into
> ext4_issue_zeroout() would make sense because that is where the writing of
> "data" really happens. This will fix the use in
> ext4_split_extent_zeroout() as well as ext4_ext_convert_to_initialized().
> And it will also fix the same class of problem which I think we have in
> ext4_alloc_file_blocks()...

Thanks, that makes sense. In v2, ext4_issue_zeroout() and
ext4_ext_zeroout() take the handle, and the range is tracked there once
the zeroout has succeeded.

ext4_alloc_file_blocks() zeroes out without a handle, so it passes NULL.
As far as I can tell there is no gap there:
ext4_convert_unwritten_extents() right after it tracks the blocks it
converts through ext4_map_blocks(), and blocks that were already written
keep their mapping. I also tried FALLOC_FL_WRITE_ZEROES on scsi_debug
(lbpws=1 lbprz=1) over an unwritten extent, over one block in the middle
of one, and over a hole, each followed by an in-place write, fsync and
EXT4_IOC_SHUTDOWN. The written block survives replay on the base kernel
as well, and the tracepoint shows the range tracked twice, at allocation
and at conversion. If you had a different path in mind, please let me
know.

I'll send v2 shortly.

Daejun
