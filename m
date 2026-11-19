Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099695;
	b=CVKjAOOeSQP23E6RQOb8RgWR6lKD5+JUkrhVUQP91HdAz5VN6qCxsHfnxD8oVxM8DOiR
	 yl/SSsbZm73Y8dcrWV1+bFRMDutKVZob5o9nws/fBJ0pI+P4llSNMWVeCOBxbyEKI5CVv
	 L65xLoa64YRzRMqSZfwiELZtKEmrHPebD03+tgQ4FrLSsocC+hwBXmkQ5O/evKlVlQMht
	 T/ZM4RU/JBHDe4XEYdYVeg2z9bl2p3gl8+V7KzsZxQATeAy86oFCjrOjFs72LgCZHSTsX
	 ocIe+ja/Cp4sdOcGLhfsP9c18x1aA3YFa6Dm7+7oiGpnR8Ml3mbcwrhpxGsCfsacyUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099695;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=G+tHk0pxR9GNS7pwuQbOnrBX1cCshVIGoTCYC4i8zAQ=;
	b=LfQDFjT6KEhL1b4zWlhf+s2YN4qTPZxDsmGdlEurDzqEAScsQUoCuORy8K8TE6ZxOOO3
	 5tgoK+jp4cD8PVpjy82j0II1ZGHO1Yj/Swsyk6ypjBOa+nSUXgQhQkbKeiw1qUWoPanvv
	 fCAzDZP1j1OedgZ8cMgV5YDxh0TLPA88YoGhegxAGNp4bvc/NCb4PNzwKGos/vHG1MWAY
	 IpqMSWGVWY7AAYBq2oX0lwZqWbF+SX88SgO44yOgAB/VYBY80bsMXILYKBgtufmBE5893
	 tq7AEMj9gkGXy0v8IzoccK3RE6c9mW6a/UdD3+IL+GD4PZgbtwwZ8zyjm0SoHg7pgiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=bjr+3mdW;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F28606C311
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1F28606C311
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=bjr+3mdW
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfT5018199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=G+tHk0pxR9GNS7pwuQbOnrBX1cCshVIGoTCYC4i8zAQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bjr+3mdWAxEBaBRsIj81x41r++SNafjIBGmwxyk08ic+QRVXUInzTU0GPyFWn8Zl3
	 yp1g5SmJI8NkTYXoJqksU90yz1ePzAEtKWZazyVQbbDeVSKP1OiVwGIyHsY3k0wvAh
	 0TgoNNCYGOTFMbpe2EXfRWBL7aPvs2gQw4cSIctIxnDD+F+qfRPuviKs6VcjTHgh55
	 6ienHY1esOk9cAKKli/YGUT/41au0WUNUrqr1bBvCZS1fV53S1SAxaM9K3eoABXkrS
	 MxxREUtINc7/LVXG0MoXJtxnsp7yn2YASTjuHfo6NjcDlQmUHbGSURdkLhSeHtvsgK
	 B2o6zpjx6qWcw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5F1B92E0195; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ritesh Harjani <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ye Bin <yebin10@huawei.com>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] ext4: Fix sparse warning in extents kunit test when EXT4_KUNIT_TESTS=m
Date: Thu, 19 Nov 2026 09:47:18 -0500
Message-ID: <179509948686.1938961.3591960804929374794.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
References: <20260924073929.2594339-1-ojaswin@linux.ibm.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 24 Sep 2026 13:09:28 +0530, Ojaswin Mujoo wrote:
> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:
> 
> >> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>    declared. Should it be static?
> 
> Fix this by declaring it as static.
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix sparse warning in extents kunit test when EXT4_KUNIT_TESTS=m
      commit: 7d2ac21f7cc66c45fe7bc69d00aceb4fd1404629

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
