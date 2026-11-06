Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793956593;
	b=3ua+uPTNw03F59EQICDPUL1KqOxpN8CQkid5ygWulBt7s9DASKVuPycKFQmY3SSm9d3F
	 s4K96LYdCq/sA7HmHF0MPzdCZEzEKWR2Kp6xOm59WF+91QLhfGjaELaBdvr0IN9qoWMPM
	 iLNkZGuiXQ1OlTY8ab1w9DMp4M0CDdM42vgNL7HR3wfcwrpIFDIjxpueBMGEkBSSNLp6P
	 AepGqNl17SF1Yg8QHpFCO1PTn3eK79nf9098IwNLrTl2iB5tg5mHORZYtvO8PitsbBH7g
	 iFtZIKdOb0HJ+5+qxAf35iUSF2M0dv0f2md43fJlJCkf4ZYvz7kztPd2rwDjmO/4xyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793956593;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vcL1NhYQpFcHWrVsIZpIrMZtOSmgli6Y91V/Xvy4p8E=;
	b=fu0w86wtzebdYukYhGzTi5HV5YgGLIk3o8ngkNjeOCtMADj2mdge6ngZLQf9c2x/kWC+
	 XESd4LxEbaeRdIBlF+2Run1COx+NrEPPmo9PUaqgMJ+VthjwgrP99Vxjdzeg7umAS7CE6
	 HKwPBeuXVsMtqIWMPLtxitOrcY+p9yWMr5cmBO4sbq2S9lBOo0mhjr6VT/Sp5xXT38PDP
	 OLRBgQNHFjOW/2qDHcszKbRNM4Q6Xux+n9i/qfM7taTXzWOaiy8JTRN60WrmBT5ZdyR0/
	 H+dvNP9Bm/30Q4tiw2304xcyX0ehv1uPXuwPlq8WGISGkZyZ/sFM2Agb1fKdVGx+xlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=lBo+ULpn;
	arc=none smtp.remote-ip=162.62.57.137
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65252606A326
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 09:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65252606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=lBo+ULpn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793956588; bh=vcL1NhYQpFcHWrVsIZpIrMZtOSmgli6Y91V/Xvy4p8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBo+ULpn6XyHlDf7BECNGZZJM62FAnjsE0oO5cURVhwTPgPBgN1FQuM6OQnoM66zh
	 NYyfFT8wZm8HDFyx3801TSQMdER7V8ZLEVFDkuddW1/oY3DMb/5452w0CIM/OiWOL0
	 Vu/AKCZ+qgz65vChGGHrlrj92QcBxveJIlUIth+4=
Received: from shuai-VMware-Virtual-Platform.. ([218.28.192.28])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 4192A03A; Fri, 06 Nov 2026 17:16:25 +0800
X-QQ-mid: xmsmtpt1793956585tk93hi8a4
Message-ID: <tencent_F81D5DFA8A2551DEADE91577474C68C2C705@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoex5frKWRRy3d9y5cbZtT8RsCG+Yb3O57bGmK8/Zjcl9RKzPYwnK
	 4uu0PfebxcBvHvL0deZnBgk/H05tzr8HW7XhVho5tcsEwIrrmAcsRLmz07MOWShBIIZYrZ8l5PP8
	 B+Lq7tm28dAVlAhG+IZaGWd/x1Zsh1pgwLjBiD2isTCuNG7riQzHVpZ/JjhOlvQFekc345UgMTx3
	 iClTh+XtN0ESjG6siWI/xLl/kEX/abBfksT9n2UB+wJNUEwYJBx8gkklTbnjeAUaXq5XOxdkwnHp
	 d7HmPRT8PNXTgZcmlylhTEsgLZ+sCZJvLQV4olLE1K8Jkw380MFMEyuIlBwOOa6eod94fEwF7aSs
	 Lb3Sqhjnq6kmy3dvsyT3loM1ngLODDoeGPf+snK7524mWUWDzBMBxEX5nNlt2wPB3aP5DCeC5oh0
	 UFJiljebEtIBZkG3MgjzQoXTb1OjceQ6MZerW5l1TUAkO5xLfsNyjv0/2y0AZFl6I9DSIjXmLoFu
	 DxH0qfECrb3mRnBG8Cc5unQVBGAcAIs9NqWHsRzh4Z7UGRovEXl8faGwbGeTQa0PAR9aWjxtlntb
	 fejxrMWs0H3nLhYTwNgdU8ukj0La5akfUdwPhZ02o5csn3EgDGOLZn4WEcA8VoCmt895gdIjX0ta
	 JGmO46o7XYLX4xWCg/ssZXEbcytUH04I/OEPYaMgh6TK0jRhewDOE3gNGL6exoTsJsVFZLSRPAnE
	 CyuPF3H7q/TUcsjOYtMCpPNYQV48RNuyN3/LsVH1EfL5kozjNuC33VwDUIEDsqZKacNCSFEW/ZyK
	 UPIbHSoIn4Wbot+9RNkU9xFGKrzft7gemH1HXrLU7sjdSv5p6PpZLVMvAUvmDp2wWnUj2hvpzXn6
	 z+S8I6CuW/nO4CgSId5q0ZPCrj8Qv44Z2ELKQXyeYplq9U/Cz4BQ9G3GIROZwRFzEbQqI3hidw4/
	 3YRr3CjByNTwIjji63umsAG7QlMDLpbRkz+oX0+qNFw9VMuQiZAqSKVkdEXD974F8/FqvBAWL93w
	 7kWp4+xQMpOzJwHJNfszan3vgk8Q2AeRGNENa6ZbGFQzkjAf8qOpz7eCl1y3llZOs8uOgZDRce/f
	 umMwnpu74qST/ryugeoSyFq52LSw==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Shuai Liu <847807867@qq.com>
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	libaokun@linux.alibaba.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	yi.zhang@huawei.com,
	sashiko-bot@kernel.org,
	syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com,
	linux-kernel@vger.kernel.org,
	Shuai Liu <847807867@qq.com>
Subject: Re: [PATCH v8] ext4: fix slab-use-after-free in do_split()
Date: Fri,  6 Nov 2026 17:16:25 +0800
X-OQ-MSGID: <20261106091625.707374-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <zlob4iplebmd7bqzh6iniyz3vrgzifrhg4cqy22uljraftrjxc@hr5rvleofcrx>
References: <zlob4iplebmd7bqzh6iniyz3vrgzifrhg4cqy22uljraftrjxc@hr5rvleofcrx>
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

Hi Honza,

Thank you for the detailed review and the honest feedback.

You are right - I was iterating against the AI review bot's findings
without pausing to seek human feedback, and that was the wrong
prioritization. I also agree with your point on maintainability: disk
metadata can be corrupted in unbounded ways, ext4 has always treated
graceful handling as best effort, and adding per-alias checks at every
call site is expensive protection for a niche case.

Given that, how would you like to proceed? The syzbot crash itself is
real (KASAN slab-use-after-free from aliased buffer heads), so I could
downscale this to a minimal fix for the actual reported crash (just the
do_split() *bh/bh2 alias check) if you think that single check is
worthwhile. Alternatively I can drop the series entirely, and I would
be interested in helping explore the buffer_head metadata tag approach
you outlined, if that is something you would welcome.

Thanks again,
Shuai Liu

