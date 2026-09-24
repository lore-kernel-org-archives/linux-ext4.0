Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD6047ECCB;
	Thu, 24 Sep 2026 12:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790252506; cv=none; b=YVBWSlYpV7wJ8vHW8qMLy+wG7yyJ/b34Au74ju5MU0p3l1CEwK3MvFJF6FU007wweF0+4fA3TBfB6RQJBRyB6BgWxROT0xY7sqhWhVhHSbhxOphslrZT+KoZ0kAPuQROZrEWobEmCWcTotmL9zKIV0Nd9MpnAEk46LCUdngta4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790252506; c=relaxed/simple;
	bh=Zpd+j/mUx9C7TrN/L31jgjvx5dJBC8fLkMNiUI0+nMM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=djZcevZ5hA7nfNrQtF3hQjIwLBkyKxCndMYaJk5kYr6xIjIbKcimcWzHGW7lrFWJpPn+BtxKp/sPzKvBaTQOaWps1M15iN++oNr7piN4mjKMp0JCP/dK8YRcmEh156jwTew98sTCJzGPWySZA0LRXHXi0e8JAwg/c1FCI5Sf+Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PHX86KUV; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PHX86KUV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=Zpd+j/mUx9C7TrN/L31jgjvx5dJBC8fLkMNiUI0+nMM=; b=P
	HX86KUVSFYJ+onbEn1E3UI18by81/qVQJmtiZ0R8Ejl63Gus3wfT05rHJaDql+Hk
	CkRJwxrcaFK51V2rqR/8mUXimKTXQ2RM+4r2luBOH3cS3WucmxJqIwnVFw4P3xnu
	+5ZYuQ//9K60QV07khAlnWStJlhR+ZsQWfp85Bu3/o=
Date: Thu, 24 Sep 2026 20:20:47 +0800 (CST)
From: "jiale yao" <19888972804@163.com>
To: liubaolin <liubaolin12138@163.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>,
	"Sungjong Seo" <sj1557.seo@samsung.com>,
	"Yuezhang Mo" <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.com>,
	"Hyunchul Lee" <hyc.lee@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, exfat@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ntfs@lists.linux.dev
Subject: Re:Re: [PATCH 2/3] ntfs: drain in-flight DIO before buffered write
 fallback
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <b51a2ffa-5778-4075-a679-84cd3acf419a@163.com>
References: <20260924110544.601390-1-yaojiale02@163.com>
 <20260924110544.601390-3-yaojiale02@163.com>
 <b51a2ffa-5778-4075-a679-84cd3acf419a@163.com>
X-NTES-SC: AL_Qu2SAv6evUwv4SSZZukcn08ShO49XMOyvfoi2YFTc+wEnhnL8yUYRG1aAVbZ0M2NIDyrmSO1VSZU0dZdb4B+FqGYtFDMTsnu5maxz/wyRw==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <7e97a16e.9bac.1a0d35c76c2.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:ZygvCgD3f1mfFbVqMqtOAA--.47461W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8B90rmq1FZ-9nQAA3A
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGkgQmFvbGluLAoKWW91J3JlIHJpZ2h0LiBOVEZTIGFkdmVydGlzZXMgRk1PREVfTk9XQUlULCBh
bmQgY2xlYXJpbmcgSU9DQl9ESVJFQ1QKZG9lcyBub3QgbWFrZSBpdCB2YWxpZCB0byBibG9jayBp
biBpbm9kZV9kaW9fd2FpdCgpLgoKSSB3aWxsIGNoZWNrIElPQ0JfTk9XQUlUIGJlZm9yZSBlbnRl
cmluZyB0aGUgYnVmZmVyZWQgZmFsbGJhY2suIElmCmlvbWFwX2Rpb19ydygpIGhhcyBub3Qgd3Jp
dHRlbiBhbnkgZGF0YSwgdGhlIHBhdGggd2lsbCByZXR1cm4gLUVBR0FJTi4KSWYgaXQgY29tcGxl
dGVkIGEgcGFydGlhbCB3cml0ZSwgaXQgd2lsbCByZXR1cm4gdGhlIHBvc2l0aXZlIHNob3J0LXdy
aXRlCnJlc3VsdCB3aXRob3V0IGVudGVyaW5nIHRoZSBwb3RlbnRpYWxseSBibG9ja2luZyBmYWxs
YmFjay4KCkkgd2lsbCBhZGRyZXNzIHRoaXMgaW4gdjIsIGFmdGVyIDI0aC4KClRoYW5rcywKSmlh
bGU=
