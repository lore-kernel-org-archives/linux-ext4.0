Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECB534CFC5;
	Sat, 26 Sep 2026 07:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790407822; cv=none; b=flQNv/AgMNyId5sUOtFjT6xC6K2LZ+4nQEhQUr401XrsjUKDA2HJIKD2LpM30DFCd0yeT5GufOUSOjE3XudXd6R4PUaKo2Dheh6yZofQKEWGt5SLexARfv/iSZFQYAsrEPeTSlo3sr13Xwli3vy2Gp9VuaBHyToA/aaGG52QY1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790407822; c=relaxed/simple;
	bh=hMgD4cND9CJBndYFu6le5SnVC3/bG3HpVvXWc4Crebk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=dGH+3/7IHjwFF+pRaoVhmowXH2beavowFAcsdZogTAviPDgwKgLOqgD9L0usUf7X3ShbvSJsXcpq3nNtFxkWKg/jli8GeAYihhd9le9H6UONP5T+SYVtXV+yKNNiqMbMh1l+0mKrgAGWO5XNuzSHFMmL74XM18eJKI3ChGgVLQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KEXrh/Z7; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KEXrh/Z7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=hMgD4cND9CJBndYFu6le5SnVC3/bG3HpVvXWc4Crebk=; b=K
	EXrh/Z7jbQ5QyV+T+eAGsBVK+0+xwpDcKCqaFk4OKq8Pcg8uDRc5Vo0wSflp/Oee
	HH3SM/Vnts1elGa1ZXlahHezvQittslD1zh0qoo/p/toJzxRcEyK2GfL7f4EgTNf
	wrv9ooc1gx0SVO4gzph3hF8GDI+9qt3ZdPia2gssH8=
Date: Sat, 26 Sep 2026 15:29:45 +0800 (CST)
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
X-NTES-SC: AL_Qu2SAvibuE8j4yacZukdmE8Uges8WcC0svki1YJUc/gEiA305CwnXVJyOEHmy8eeADCmojeSbzhe59xaeahmp2/Ymvt05eKFWO4AJlQkZQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <8700d3f.1059.1a0dc9ebcb3.Coremail.19888972804@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:cCgvCgD3N+5pdLdq9+pOAA--.9765W
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wm-+Wq3dGlpcgAA37
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGkgQmFvbGluLCAKQXQgMjAyNi0wOS0yNCAyMDowNDoxNCwgImxpdWJhb2xpbiIgPGxpdWJhb2xp
bjEyMTM4QDE2My5jb20+IHdyb3RlOgo+SGkgSmlhbGUsCj4gICAgVGhpcyBmYWxsYmFjayBwYXRo
IGNhbiBzdGlsbCBoYXZlIElPQ0JfTk9XQUlUIHNldCwgYnV0IAo+aW5vZGVfZGlvX3dhaXQoKSBi
bG9ja3Mgd2hlbiB0aGVyZSBpcyBvdXRzdGFuZGluZyBESU8uIENsZWFyaW5nIAo+SU9DQl9ESVJF
Q1QgZG9lcyBub3QgY2xlYXIgSU9DQl9OT1dBSVQuCj4KPiAgIEluIGNvbXBhcmlzb24sIGV4dDRf
YnVmZmVyZWRfd3JpdGVfaXRlcigpIHJlamVjdHMgTk9XQUlUIHJlcXVlc3RzIAo+YmVmb3JlIHJl
YWNoaW5nIHRoZSB3YWl0Lgo+Cj4gICBDb3VsZCB3ZSBhbHNvIGhhbmRsZSBJT0NCX05PV0FJVCBi
ZWZvcmUgZW50ZXJpbmcgdGhpcyBwb3RlbnRpYWxseSAKPmJsb2NraW5nIGZhbGxiYWNrPwo+ICAg
SWYgbm8gYnl0ZXMgaGF2ZSBiZWVuIHdyaXR0ZW4sIHdlIGNhbiByZXR1cm4gLUVBR0FJTjsgaWYg
c29tZSBESU8gaGFzIAo+YWxyZWFkeSBjb21wbGV0ZWQsIHdlIHNob3VsZCBwcmVzZXJ2ZSB0aGUg
cG9zaXRpdmUgc2hvcnQtd3JpdGUgcmVzdWx0LgoKVjIgaXMgaGVyZSwgaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjYwOTI2MDcyNjEyLjMwMjI2ODAtMS15YW9qaWFsZTAyQDE2My5jb20K
CkppYWxl
