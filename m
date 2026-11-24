Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.243.244.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493081;
	b=42ErDdGDXovzQtWZNYyKxNN0hptIsudSx5PHUUuLUNWIDAnY2jGX0dyxjr0wCnBETXG5
	 QXf59Nkh6l4Cd5P7axAqCnNQdZyJlyBlKnyc1jHLcFY13o8HYYiHF3Mu7Jb3cqduI9iog
	 DC6vw8toW4LubDOD1PyVATqh94kunEMCzAcIgiWDzKQxp1L4BHH6Folm9Z43NOVhit6ks
	 ban1UCRLbDWZByGwlBgsA7cThLfBta7JIH48gVjP85sF8dQwI0fY6qiVCzCVI0En8e/fl
	 c4DOdV8+E4BTDo4/mBHLwKjfkKEcu8NEFkYtk+cJChfWgQI65h9DQ88rN1oEacjTPvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493081;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-QQ-SENDSIZE:Feedback-ID:X-QQ-XMAILINFO:
	 X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=jX2XngRIkXlF5vp7EuDcYstvDbHSirKjb2NpNSEI9Ao=;
	b=02CsDe+tDA36s0twT5syyi+HsA3JI9rc4YInkdSRRdD+BaYcfmGPsgI+7254ZbDpukIw
	 SXyISiChM5OoYfcjhMsE5gR/sqzgL2TYYwkX22oJGEIG2Pyi9p6Bsb8qTsxnVjWxXd8Cp
	 H+bsZ+qSyk7CMrk+tySE0hOl89utHAU96/GdGpEAto/iy8r1NxeFM6bUIkPNz4SifEZXm
	 MZlrJZBETtI5PumabYv0S6KkLV92p8+VWwuYGKwqhfvC0iA99zztIumyOKikxrN18ypCU
	 1HC/h4ZZCrxYVwMf/QHpaA6CI86zwexWgpJj7HK7PFXNi1atUqszWKXB1IFro/UyvUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=H2EVkWhQ;
	arc=none smtp.remote-ip=54.243.244.52
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA94606A321;
	Tue, 24 Nov 2026 04:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EA94606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=H2EVkWhQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1795493031;
	bh=jX2XngRIkXlF5vp7EuDcYstvDbHSirKjb2NpNSEI9Ao=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=H2EVkWhQvcvjlkGnhNpFrF6o4ZsQeIjpx2op2xjNrYTgGQsOb3ZJkN/3uHNIhiM+f
	 ASePsgpSEYALJ4Q0qcT2xQ1rAkg8siv7GE/LmJogRX3Bby4zgohQ/mrL+QIRU+mIzO
	 J6N4j3h0QUTgBWG4XzatwSL9xrIg/iBMWiw9y1zA=
X-QQ-mid: esmtpgz16t1795493020t3e3d7aad
X-QQ-Originating-IP: Z5MsD92pn60Yw6FxfYn/+lyIOCgKYxuMMwloj6g97ck=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Nov 2026 12:03:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9077606647773718848
EX-QQ-RecipientCnt: 13
From: Yichong Chen <chenyichong@uniontech.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca,
	chenyichong@uniontech.com,
	guanwentao@uniontech.com,
	jack@suse.cz,
	libaokun@linux.alibaba.com,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	zhangdandan@uniontech.com
Subject: Re: [PATCH] ext4: keep ordered data and i_disksize consistent on size changes
Date: Tue, 24 Nov 2026 12:03:38 +0800
Message-Id: <20261124040338.1627891-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <awBwutTXygOERsY-@mit.edu>
References: <awBwutTXygOERsY-@mit.edu>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MXeHgLEcWKNKCQiI3Q4cPIzK6Lv6UUqiT1HlV0gtUQvo4Of5IO7Rokku
	AW2Qp2YmgnLuwOYcuVTxLlhKPa702Z/YaiCPrdBt1T9qqjB0S3efu0JCMNN2eZ44lAFLe4x
	YCQZQm0Ru1zvZFW6aIgjW32gee0366zyVlzr2tzjxlrI9toFcsNR7c69hcRBRn81QD03oti
	/kfy2fJTkn2f2nDee83OjhOE7Vaq/wUuTGGu9z0fPErYV9uQM0a1euPvBXysXhpATELcnaB
	3AYjGABXjosYyJebOcs+6jYv82T++FLA0QMfBCiH6G8fNW3Pe7g8TNQH0C9RGRr5Q4afBRP
	TobSV27zoaB60UopMwh+r/xb4x/KVEUZFG3lA5vkrloKx+dI/VyQ54y955LKKjOu1z0U4Ih
	m6OPr+6AFixKkhrW5v2KnT7LvifDDXs83QaT0NWccf0Lu1T7TVHNGyZP35kPvLlx2KSgM8k
	tL+/C2CBin7kshb5PEK+ywgYDCLFktKcWe5i60rSJGmOQtcpaONjvxP7N3gvlNXzeXVdLsl
	78cF2vXbfCgK4zrKKOr3AVidG1PHFbFIf+L05Y9CUHiHvDQsV0xCbS+L18iZkxpY6IZwt8H
	QLobyjEKxQ/pyeuG0pe5vxTRobo4C2CeZnCzP4dlPU35DKnIxjbuCsNBZKUYMXakTYOHRR/
	WgjdFyBiw6Wuhaf6QZEXHVdC+EN7ySiioslHeXPMPjkQWfe5T/GdUu5TlHn8ymTmfW30SwB
	39ltDHNYHQmSWDEJaoWqNPspeGeMXf2BuH0rA95ME6H8kyaKpsCBCx/+3ojAhflyvovq4Xu
	pO9Z612H9kkU60szDCgdgpOBV+tNriU7o3MWSKzbZhLARC0UF811L5C0cMIBm7CdakNE/BU
	yEnxSnkGuQV1UtWPAfaLCeJSH7/p95Xu/R5gpF7qyMUyZ61eCvQNdJDUoEI/G5SHo5hUTID
	DHkQPLNqZxU913xvZifrMCIc8+KB7yeP6o1d2sU6Q5J1vGEoCwrNqg7Mp9DE+qGTEeQdbQ2
	hkTI9wTxEpO4PF7FBf4c3c3PnsT425kACYQKE0+BqJxEGyTxAT
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

Hi Ted, Honza,

Apologies first: when I set up the test configuration here I missed the
ext4 expunge rule for these three tests, and reported them as new
failures. That was my mistake - the rule has been in xfstests-bld since
2017.

On Fri, Nov 20, 2026 at 01:02:24PM -0500, Jan Kara wrote:
> Yes, and as the LLM probably told you these checks are failing on ext4 for
> ages and no real user complained. Ted may have a different opinion but I
> don't think we care about fixing them, in particular given the costs in
> complexity of i_size updates and also performance of appending writes /
> truncate.

Honza - on the cost concern. My benchmarks confirmed your point. What
the series touches is only ftruncate() with delalloc data, and the
overhead is mostly negligible. For example, shrink after fsync only adds
+2.8us (172.72us -> 175.53us). The worst case is an immediate shrink
after a dirty write (+30us), which confirms the complexity/performance
trade-off you raised.

On Sat, Nov 21, 2026 00:18 AM -0500, Theodore Ts'o wrote:
> Yes.  In addition, there was never any data integrity guarantees of
> data=ordered.  The main reason why this exists is to avoid any stale
> data belonging a deleted file...
> The only reason why we have data=ordered is because we use the order
> of operations from ext2... Once we change things so that we write the
> data block to the newly allocated block, and *then* we make the
> metadata change, we can unify data=ordered and data=writeback...

Ted - thanks for the detailed explanation on the ordered-mode history
and the long-term unification plan.

For context on why I was digging into this: I have been following Zhang
Yi's iomap buffered I/O series targeting ext4 dev. While running
xfstests to validate those interactions, I triggered the NULL file
scenarios. I initially suspected an inconsistency between the 2015 and
2021 commits, but I realize now they are dependent, and this is expected
data=writeback semantics (zeros instead of data), not a metadata
consistency break.

Given your explanation, the acceptable writeback semantics, and the fact
that this code is being rewritten by the iomap series
(EXT4_STATE_DISKSIZE_GROW_PENDING), I will drop my patch series without
pushback.

Thanks for the guidance, and I look forward to the iomap unification.

Best,
Morduan
