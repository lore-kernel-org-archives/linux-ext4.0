Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770251;
	b=v1oFaakLFKI3riwYgVKiJJyETbReJlsrOiiYbf/MYcNANZ7ckO2Wqy5a7v/07QVMZKCB
	 jQSfkzdGr9reZyM46+Cv9f4lg8A3l3s6sp0KuKCusRjtDss8Xm90db3M6bc+Hydpa9+BY
	 PRYfXSy1G55vzMe82yW0e0tpkj16H65DDdTWVf8URAu/lldfFnq46j/Yp/wXYsx/r92LF
	 M9mxuWMWYlNeI+FxJLB1k6mus29qcc7vHPEhOvvSkC1ddnp+wWnqwhN+vecixuFy3GStv
	 kVCTJtyjEAOx3cZAeJy9R4rylOOI2Zt6OLkMN0pDLDwOI44O4OyMC40C8tqOdpus3dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770251;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=LcCUZZ2quD+PZzlcirOXMexuueBPCDrUp6fJvIUCbPg=;
	b=zBDhaBI5/rOetK4o0BDomfpgbzacyRZnEyo+ZC2Px0U0sH5zTR82EyPlH51hubXU95Zz
	 /A2e15LHnr1s5zUF6Rrm8o5Amqm1lp3IJcoTj6Q4cX8Y6jBBcQMzEU9NnRMVcB1LhLvKL
	 1UzyIcGbzqAQf4V75A8jHS6pSkU2R3Xyh0VZuaCx69mj6WPz6Yp0i2slf6jBGVU6up76i
	 4+SAaBD5xSJvtS8IhgNNBdHwhoShbL6L8ekpDcFPol0gv7hW/9JnorEGC0h8tAqs0zPUG
	 LRrVrfY2PbOGLoYY3A5blB5WWc2o3nK3H2TDqwMaaIiPR/uQtQxS08SvOw8McZ4wASw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=WnLYqFTc;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=inW9P+pg;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B00E606A33A;
	Fri, 27 Nov 2026 09:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B00E606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=WnLYqFTc;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=inW9P+pg
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770247;
	bh=i/CqDa5BdBRGfiEpFJeHEfKIix2XPR+QtimFlz2bk4I=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=WnLYqFTcrCGSXoX3j484RQQKWLkaqT+nsWPQOcYiTuAwiEuUcYS/E3TtJlcGs2X1y
	 B3TljWNYA7dLiBs/HQclYfLNGLZpuuhBFXTo/umoQ3YmJGhQqNVUZW+nZe2RO18U1Z
	 Y2qlQlAqIkZQ4h71NdxeVl24qIFOk2eS+cE9bEJN1tRG/48j3ifEuqsdVT+3w92rDE
	 Kb9ZXM6aC2zYL9dfGn93EEy4xyXHSZQlNA9BG4wXXP8/LxEue9U6AWttPvAwkCYLTL
	 MzLonFBGdMiWcDup1xuT1ffxvLi1Ov7MXnlkTFEQl6c2w5LHb88FPIx4u+AM/E2Dv2
	 hHamf11TdJjALgJCVtkz9Wl/n+WqCtfprlSFd/S7yWHcRrOUffP0p22VoOUzv+HIM6
	 4EdZfT/StoTSCwLY/FEBlcVxEQFL+odyHLO9eObKtjIcyZG0MfRYD9SMqrTCCYG+vR
	 2zHIFi6NckOwjzofdhGbS1zUW0ohbmmkkYP+TiymqNuXBvBEY0GGVj2KPlgtef0j2I
	 Fluin6ujd6l2xtsiR2/wJlhp6YCCCWqQlFcQ4JU8qgeC9QUAMmK9vMN/jnq3DgzwJQ
	 rDiBRJrr0fkwap5zP3XxNcDgIeDae4zVJs+sn3MisP7JM9F7OMZhYuffgHhVzljyIh
	 yUAxUNdl0iRnkzqRZKL6Dcus=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 64B7F200207; Fri, 27 Nov 2026 17:04:07 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770238;
	bh=i/CqDa5BdBRGfiEpFJeHEfKIix2XPR+QtimFlz2bk4I=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=inW9P+pgOrOW7QJLBOEOQVZD5doEfQZ6LDA7/WzAB0EoEH30lR2KS2L1/VVQ9/+1y
	 7+MY+zkEQ/eASMJygs8tm7aXAd8CK/RuroC4PmYbEe5Y2pKJ8gr3m+Cx7unbQrfZZC
	 wqB7PXOepWlrb49kqa9aPWqYFmk1y6EQBYcT1RYQN3D6T7/F2Q1dyvCPLI83hBbhiT
	 cCqesDO7+csVGBMBoU8HmZENjDwrA8vwmtQ8HeJ4WnOcG0g9uXMIKARsPAfbyGccVz
	 NtF1ze8oU66mw93urq2Kx0jTtfv5qzh6cpHDfcMAF+P8KBOsxybN9fZY7RZGe/qEOs
	 T+uvt6vU+LAMcEndq4z5JtCU1WBuEwfAYUgUkiM6kngPmh2nQQ9iu7oY8ehRcmuNg9
	 NeYackLz4KtqiMBCBpfjnwp2BucAU/9rNmOcG3yT4suwc+TjzkpZUCnKIWRDDWMdTb
	 8nqzwRKN5vfWnh+hXjkEJJVssCx+Ew3B7zR7UsQjJvm4WzArhTJGdR6fkrCG8z0/lE
	 hgB6/qjndtFSXsT8SGSh/PPMAY5xzkISVYq2rIjQe1oI7OBOhnFDHcoXDbLRWXAFI/
	 QeY2aNzaD74PQv2BDzHkCChWExku8JqbtMRJXHTuY9Cqy/k5n/8PMGtcYsb6OtSOwR
	 ZjW45MvmbhZTNq0dr2itNwsA=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 52E722001E2;
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
Subject: Re: [PATCH v2 2/9] kunit: Add KUNIT_CASE_PARAM_UNIQUE() and
 KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
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
In-Reply-To: <20261105-kunit-param-names-v2-2-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-2-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021428.2515039.572546302708567368.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1762; i=david@davidgow.net;
 h=from:subject:message-id; bh=i/CqDa5BdBRGfiEpFJeHEfKIix2XPR+QtimFlz2bk4I=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd0CebrAgqUjWkDQ+sKrIs23bu1K5z8MwOyq
 LEYDHhAhb6JAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHdBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20JnRQ//RWD5KA0bq8VfeuvZ8IQEAuHqftyivGF
 v8KSOjQrGQf6P6110IyJ8qAPM89PVxEqydkFylL1Xg/C1DIlbF6qnTfCYVUDMYzlO4TmXafXR4R
 AlKGpMUCFzwqZRqlR+xmp3Lfcln/GN7x5ZAQeroBDloQkx/VmLNgB+6y4qTOBlAtG1217dONJW1
 2thkwar2iW/cQUePqW6I+yJR9MLA/f3rVzuSSVEK0eP3URWhUDbxWkdf77sVmRbxFGHdZ/8wgBD
 qrgNFemu27n350w5SjLqPg5mdUm3cqBDtLNB86Fnj3JcuMCcB6Zr6OuUiStHSUAGNlFv+2c7pNv
 TtG+iE3HOJpZDI2dSgqlt/HyCfhw9v4LqH1sZcyy5NtgbjPCzRy+axxQ44kUiXA30BEW5OauB1g
 XEXmjgfYk+k3iMTKJGRxYZnN3LIUVQdKi9wrHWtoEhtpxBCMmerWlqEfyu95VSioqWxp01FiR2x
 z8S3SquIegcDVaehDoOo9QeXyFaSAApvys/tAxva8jGmdjLbzH5ua4Vwvat3Y7NRkcbBKYSvVGD
 QAcvidZ4WzRe2SK/WQ5liuVJ3/amI4+mOaJckGSzteOFjxaCHwpsG5BpmGYzPBo08ZE16zN+XAH
 UqRvwrtq6t7n/QyjlQGkVHIJYDIuYwHyB08ATy4+dGHHdRTzo/aM=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

> KUNIT_CASE_PARAM() and KUNIT_CASE_PARAM_WITH_INIT() name the test case
> after the test function. Several suites reuse one test function with
> more than one parameter generator or param_init() function, listing it
> once per set of parameters, which leads to multiple tests being created
> with the same name. Same-named cases cannot be told apart in the results
> and cannot be selected individually with kunit.filter_glob=, so kunit.py
> --run_isolated=test boots a kernel for every entry and each kernel runs
> all of the same-named cases.
> 
> We could fix this by having the KUNIT_CASE_PARAM() macros always include
> the parameter name but this would not only rename all existing users but
> also result in some awkwardly named tests. Instead introduce some new
> macros for use in cases where we need to disambiguate.
> 
> Add KUNIT_CASE_PARAM_UNIQUE() and KUNIT_CASE_PARAM_WITH_INIT_UNIQUE()
> which behave identically to the existing macros but include the name of
> the parameter generator or the param_init() function in the name of
> the case, giving names such as sha1_test-sha1_gen_params. The
> param_init() function is used for the WITH_INIT variant since currently
> all the tests which register parameter arrays from param_init() all
> share the generic kunit_array_gen_params() generator.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
>

Thanks very much: I hadn't tried this with --run-isolated=test, so missed
that part of it.

This is definitely long overdue (and while I'm not completely sure
'UNIQUE' is the best possible name for it, I couldn't think of a better
one, so let's go with it)!

Reviewed-by: David Gow <david@davidgow.net>

Cheers,
-- David

-- 
David Gow <david@davidgow.net>
