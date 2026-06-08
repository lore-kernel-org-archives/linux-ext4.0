Received: from sg-3-111.ptr.tlmpb.com (sg-3-111.ptr.tlmpb.com [101.45.255.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1312F28FC
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780919822; cv=none; b=YSG2PneDjjNaVB4PbD9Yh3Zi7g3/evc1a4rFuW3A740QcGoLn5hVcKldR75cN+OyvIWDb7gBCMV5qtrV3Ybar/antWdFc2ry9O4+FTlxNhA4TUPNfbk86cwgYt9TJPeAWJztsT9cEddFtfya/cJueY0JEhm47BjPpOKui7Hi7AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780919822; c=relaxed/simple;
	bh=W5/Cs7H3zC0sTTBTZDd9Qq/g8ZrRL/hAqYNsxaYz4Pk=;
	h=Subject:Date:To:Mime-Version:Content-Type:Cc:From:Message-Id:
	 In-Reply-To:References; b=IyodwHDu0cn8Map8E6AksEabKP8SaY0aMC3ooUzia3opmv3u0P/C6ao9HD0z9iZ1/+yVPWAxDq46o5Kpp0s4IxEit7Ia4YFE/y98laNvpSRf6HtpbfcryNicCIfuMoYVg7t6o8W9sRDuMO8IAi/52xqoeBTl7Doe2PFGg169CTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GsNzJLPh; arc=none smtp.client-ip=101.45.255.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GsNzJLPh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780919770; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=MejWGC39h2TnYcSmlXVvV4Fiwc9x2eqxuoE2HxnACIs=;
 b=GsNzJLPhqZDW9REk4uxWcIR06AHjDtNiVJ0elB3BtoZRRx2A+nVhcMcV+kCl48tnNoBPGq
 N0W3etYJRvD90NHOHb8Zn7y7LTEDvgCWczdOiqg/cgjGtTgbl8reBHjvWGNEJScDcNz029
 ybmv+iznKzVBH/vpjX8R0irBDxj/8GpU0mlti0pirs06qCqyCfQWygz+Z4kDQwSYOnXCna
 f1sdJzThe2wQWXejPNfd6GfZ1/JrHTAm4+7Su0LiRjdA7g/EsvZ0lc01yLWZND5Gz8yEbr
 pH5lQhJ/67lD/r2ohMLzKwTUh5i4Hw6LmYAuqec+4PTH37AYwFdBwDC1IphdqA==
Subject: Re: [PATCH] ext4: avoid full buffer walks for large folio partial writes
X-Original-From: Jia Zhu <zhujia.zj@bytedance.com>
Date: Mon,  8 Jun 2026 19:56:04 +0800
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Lms-Return-Path: <lba+26a26add8+062d65+vger.kernel.org+zhujia.zj@bytedance.com>
To: "Matthew Wilcox" <willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Cc: "Jia Zhu" <zhujia.zj@bytedance.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Andreas Dilger" <adilger.kernel@dilger.ca>, 
	"Alexander Viro" <viro@zeniv.linux.org.uk>, 
	"Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, 
	"Baokun Li" <libaokun@linux.alibaba.com>, 
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani" <ritesh.list@gmail.com>, 
	"Zhang Yi" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "Jia Zhu" <zhujia.zj@bytedance.com>
Message-Id: <20260608115604.39230-1-zhujia.zj@bytedance.com>
In-Reply-To: <aiLcFP2drmHGjEL2@casper.infradead.org>
References: <20260603134800.25155-1-zhujia.zj@bytedance.com> <aiBuZE5NWMfOGAA6@casper.infradead.org> <20260605090253.32822-1-zhujia.zj@bytedance.com> <aiLcFP2drmHGjEL2@casper.infradead.org>

On Fri, Jun 05, 2026 at 03:24:20PM +0100, Matthew Wilcox wrote:
> > The reason I am still looking at this path is that the regression is
> > visible in our LTS upgrade testing from 6.12 to 6.18.  It was introduced
> > by the ext4 large-folio enablement in v6.16.  For example, in our
> > libMicro release benchmark with THP always enabled, usecs/call, lower is
> > better:
> > 
> > case        v6.12        v6.18        regression
> > write_u1k   0.609        4.659        +665.0%
> > write_u10k  1.408        4.869        +245.8%
> 
> Ouch ;-)  No wonder you want to address this.  Do you recover all the
> regression with this fix?

With the full v2 series applied to v6.18, the small overwrite cases look
like this.  Results are usecs/call, lower is better:

case           v6.12    v6.18   v6.18 + series
write_u1k      0.609    4.659       0.528
write_u10k     1.408    4.869       0.809
pwrite_u1k     0.609    4.659       0.538
pwrite_u10k    1.399    4.889       0.819
writev_u1k     2.238    5.277       1.179
writev_u10k   11.057    8.029       4.219

This matches the regression I was trying to address.

> > The iomap conversion is the long-term fix, but it does not help kernels
> > which still use the buffer-head buffered write path.  I would like to keep
> > this as a small regression fix for that path, and make it minimal enough
> > to be suitable for stable/LTS backport.
> 
> Is it that you're using some ext4 features that aren't supported by
> iomap yet?  Could you say which ones?  That might motivate someone to
> prioritise that support.

No, this benchmark is not using a specific ext4 feature that prevents
iomap.  It is just the default ext4 buffered write path on a regular
file.

I agree that iomap looks like the better long-term direction for ext4
buffered writes.  This small fix is mainly motivated by current/LTS
kernels that still have the buffer-head path (from v6.16 through current
mainline, until ext4 buffered writes are converted to iomap upstream),
where the large-folio enablement made this tail-walk cost visible.
