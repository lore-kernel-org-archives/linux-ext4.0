Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770249;
	b=P+v54ALEHNGR5whK3tnzW5NXnA3zjuW5QtLSJ5nLmy/hgcSbRXwrhXtst4FJNbeZOvg/
	 VyjoSSPSkeMhJ2nASAPH3G/cTS/4hNXW9SB0xcFEPDHicdfbBC5bMoe4TUbUQbSiAvSAO
	 SN0gxafSGu/jPQT7xqEUMgWgo40VRdIKAvKbWrigsk5csIO8Sp/ySy+cJysmiH0f5M68n
	 znJYDOo2HroRBXyiVbxSRwqhQfCxco9216lv39/6ga5zvGhfNcHXsmwV0k9HcZTBzt1LJ
	 mVldkZjEBOXBZsTNbB3LeLSBHgDIqIsvpyKqlAP4lQBiHiC6mBeoqyxgDw7eUa7mwog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770249;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=CKQYmYdLzPGW4NIZtjZ0yL03aQP6pahDoX1PWP7h3UQ=;
	b=ngKnnfYL51U1b1zK2y36lmtvpQ6sKKx5IrDAdMSWSQEe5aCzIH651fW0m/ci4f/s6i3a
	 lvrAy2LYiPn0S/fK33wOPJdOIoIuywlnxBagXTtieRib7WFg3JkhG0h4qQAVuBBwmRfbk
	 Net98tY2fEhkrjRI7pgZ3qMcwWxPpXV4W7fa/qclrA7BJ31dtyBjfV/rnyvlZnITQHZn8
	 NTvbpYInU/jsERrpE47QiWGEoXxiuIxzyAHOqRVAZqCFOjELgso3y2rUDKkOoCdKHWadZ
	 a3hUjFARY2vVSdVqHP0GIsAX3dBrCEIdFoDwXHLbTqs1iVKxjxjak/Yh/D/10eCdpLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=gIF9Q5+e;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=rniDJ3Tg;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D4606A338;
	Fri, 27 Nov 2026 09:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B17D4606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=gIF9Q5+e;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=rniDJ3Tg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770243;
	bh=qe+fYdFmjTXOSHvIUmF7GbFC2uXBH5esHQ+bDkFMz+8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=gIF9Q5+eUt4nXeKucKBmuJqL20/NOP8FeccpVQmdAjw434fX/3R4tvhb6BAIkbxsi
	 /MOwGGlSmO4JSUpT4AFjmx7nXnkjCIQc7mQZBRR5M9tOONMUdvPkYjjBWQMZpTDGq1
	 php2KSc9aQcvvowb2AenuaQl4E9wq3CL4Nr3SoCg/3fk1JZ0jajprk+UCvWsJzknAS
	 JQIwQ9/070oUTcfwxnHHfa9CvNronRQ3un7oX9hsuza71SrdHmBUCqr+TGctiqiPAw
	 2ZZihYkxnph3izTFJdaRKSFpgERMOsFeLyGukFJWsOsY5MjMtzipG/ZgG7RwOwiTVf
	 drAZvKjdOvmd+iCUztFCiP2Q9LU6jju7Fcc6GZxwOqq2OzguEAv5LLh+Quzr9OxyPv
	 9ZrmSOZ60tkBGnrAbnC3+WXBTT5eBf2w/bNQbCXIkiJHIixtoHjSXNVP4xS0BFphBv
	 4FLhHdegwFnqee9yxTn0OKxGyH7YKvqlJUi6kh+SVSv1n8xmF1LCV3Talvg6wcY5t6
	 qkkfJQal28V6/Z5JYJiA4fnU430NkPpI187QXQuT0CRy6JOb3OwpOpAVgLJDcC5Rel
	 id1+6TS371tevyuWVpJcZ7SufRESLiahyT6hqLU3dYDwJLHQqWAo637dwCxRkaFv5C
	 LKcTV0g/ZojcCjYds+Mw6mw0=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 78506200200; Fri, 27 Nov 2026 17:04:03 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770238;
	bh=qe+fYdFmjTXOSHvIUmF7GbFC2uXBH5esHQ+bDkFMz+8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=rniDJ3TgcHPqvDJl5CDWlunExUwbUZvdVBE87q7P4hgdkJMpKcShK4SOG1HbdH7LH
	 geyZe9ks8z9oUIl8cMtfJODuC2ZimT9hfyqYWULP5jFgXZosMybRLVe0y9nkiGMZfg
	 0PMNqVd6BBnzPjc6hDjULBDyenOlHulxOKsDRK10h0w0Bd9FpE7NNulqhjBSUIT7xX
	 Yi4xD2PsLReeLF15Oq29TlsF+iNebaWKB93iiyto2gG/FvOzdK3OZFCG+C0LR8vMsi
	 fULPDgd/e/eff68uyCViiv9h9kIxDzip9NyGzqIrbAnZBBzrYfJzYDsVlPuj3DkQCZ
	 wObMPwEkPv00TUShaXr8qxc3sECn9ovkHDktGF0hcT3+iq40OBaVsF4KoSeb3u1RS2
	 GZCwbz6P9HfJsLpZd6Pa9YVQvbQ6oP+5KVZUOxMMaFq0KBPl19Dx1pqWQAcIEqULZo
	 8r5BELlqbNJQRMffwG9N08G7SwEBp7/gi/R1pTAIEyg4BGlqFjjm5nx+MAMOokqwsT
	 4OPIUmpZy6a8zbjLDIYEQDDvXzMbaVeZtsJutZ51eYtgTiQrOFNsV7DoqxkKVRA2bU
	 nLPxJuU2/H7EfDta5KzZR5ebZQVQKn5QCnZW54kDK8G5rSXCVQiwthTOIVJeNd0Yij
	 v2QRmgr6cr7Kk/bwUffS+BCE=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 2DDA82001E1;
	Fri, 27 Nov 2026 17:03:58 +0800 (AWST)
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
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/9] firmware: cs_dsp: Run the wmfw payload error
 tests with invalid block types
From: David Gow <david@davidgow.net>
To: Mark Brown <broonie@kernel.org>
Cc: Simon Trimmer <simont@opensource.cirrus.com>, 
 Charles Keepax <ckeepax@opensource.cirrus.com>, 
 Richard Fitzgerald <rf@opensource.cirrus.com>, 
 Brendan Higgins <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, 
 Rae Moar <raemoar63@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Zhang Yi <yi.zhang@huawei.com>, David Rhodes <david.rhodes@cirrus.com>, 
 Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, 
 Takashi Iwai <tiwai@suse.com>, patches@opensource.cirrus.com, 
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-sound@vger.kernel.org
In-Reply-To: <20261105-kunit-param-names-v2-1-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-1-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021427.2515039.1567105103102888614.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=647; i=david@davidgow.net;
 h=from:subject:message-id; bh=qe+fYdFmjTXOSHvIUmF7GbFC2uXBH5esHQ+bDkFMz+8=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUdyk0WUhfaSsyZX7oxg9FXGhepFL4v8J7N4/
 DfQ10bYoFeJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHchsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20LeHw//YHgYZk2awJKU8g5rSMycrvizLB3Gpzk
 k4E1+XTiF402HPEL7skLkmDaSqLugGZ1LqsVb45+ZwRcOaOtoEmomPGpAgHSYgO8u31Z1mmWWo0
 n/MYmlNnA9CiFXjTpN361D2PsCkH0Wpa904Hx5NVCnPhHD0aTNc9kx/F8Zb1v0249wK8WAb8K2R
 UxAu6CI/+xSqc34bHRYPRk22JSKKMivh9D87NmmE4UWu9KRw3/aoRzeNmCRL46JtxwmPVzUtmol
 5erDZTyAM2ZVL2AjAc8DeUn38sqopiSLqmxc3gOYFTUUWUvkID79EYJ1OiVcD++Rpfc7xuXzb/f
 QqN6KhwTtvvNjGeIqSZeZbfDJ4LFSiSkwKdp1yJHZ1iaPXJrZJ7bwt1xCvwQtk1AmakoLQE2w8n
 Qjc0sn1Wh4RYErPn16RP8MaZtHDGS5GoReJf+BUqJmgNVAQeGeQyYz16UTKlniDn7iiY7LI8HPv
 +uFS/gp4j+pCQVCQzOnz1VwCMJSX9MTl/FK33C/7bHK9YAD8POX0G4Gq+2TO9PVqQnbA2/QFpcg
 OTS5/rokVNeBX1uwQFcf2k2//nRKl4r7BHox0i1cZSUxjz2cyPr6EpIGeYMhIFjSMwaoCZN+tbU
 WmYPu91GeXGyxHvR13k7iznTVFKTofV2CBDR+ERZ0LINUjpYXhdE=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:28 +0000, Mark Brown <broonie@kernel.org> wrote:
> Each of the wmfw error suites lists the truncated block header, truncated
> block payload and garbage payload length tests twice, once with valid
> block types and once with invalid block types. For the payload and
> garbage length tests the second entry names wmfw_too_short_for_block_header
> rather than the test on the preceding line, so the block header test is
> run four times with invalid block types while the other two are only ever
> run with valid ones.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
