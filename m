Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.242.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770266;
	b=xb4gpczVDzLLsM0aVZCkj+LSJILIMkwTnkaWrxIh2RTo07kRe8a5XtFeCssXPYxdbx4Q
	 +1D3S0kIvXUrnvvzsSXgaKYARezgLUiQxkEN8xT1RZSyS5MdcodTL9d6x63jYnqLHw1tU
	 0JUKazzOH6ZWgfMtVNBBkG8RAF8sS247HLJ2k4Olx7xFYCG8onnu9E4pNnB7QPRiRhGPC
	 Z3lbQy9R/2hqzGDqnUyY8X/d9nETAriWKNVZqfo+vlX94lbuIYFR6t4LFXZLWhSn7Puno
	 6Bxyjz8yxb331624yRJ/6dhmKgngiYf29qshZXhZrKP1uDliH+q8qNnNT+v/Tgix8FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770266;
	h=DMARC-Filter:DKIM-Signature:Received:X-Spam-Checker-Version:
	 X-Spam-Level:X-Spam-Status:DKIM-Signature:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=CU9q9sQNgFFgP6YQMK70BgdbEipcXIIKSZY5dCJHndM=;
	b=0MXS6v5kUk5WQeQEeRn1LG7BPA2TtfW5RPUhE3jNRf6MdmzFC8uZUXbHE6fnP5oqyXHB
	 huoN03217bo6ed5nm462eSArcs37MHhAMt+FJxxeFtOiiPeXJkculVhFI1WNP2Mrgi2sj
	 q683jQdVFuGzs8SM8EX66m39fjn7tKDwttgyotC45zwCvLkMew3IyLEPbAOOO5VEM2Ebi
	 JKaLBs1YmQeB9iBTQfRyA12hpFm5aikcFCrqLvij3UNQQB2jdHVZjKToQmW8mZTNBuu2x
	 iADvfYBqmPpQ7Nu/VpnJ3CK0gTjVMJmVq4h3WQk8VrHbCPifaZoJKcHOGpcH3OTHFRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=davidgow.net;
	spf=pass smtp.mailfrom=davidgow.net;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=fNlY4zoN;
	dkim=pass header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=Gz0qMGIw;
	arc=none smtp.remote-ip=203.29.242.92
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD1606A692;
	Fri, 27 Nov 2026 09:04:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BCD1606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=fNlY4zoN;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.a=rsa-sha256 header.s=201606 header.b=Gz0qMGIw
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770263;
	bh=adtqiuprlwq8VSON8xmtvCVPO/QTeq9ihW9PpmaeWmU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=fNlY4zoNZqSBV0vj62fXIR3H/Gl9mxn6rtp6G/O/EXFr4AUda7/NtzpJrJtuUdN2l
	 c3Kf3u0M0Qmvup9Ln5j7EFHC3V97CgAYP1K8jh1ZGs8cmbcgM5AzRsH3tnzpx7LPBV
	 ptgiCNNxfQECOu0+RtxeIbuv/XHKwD9CV3RuCaf8+arMpeu5oB/0/dh88zGTrwNp2Q
	 B5HB08SE7msffY0ui5D7qDk6TLuH1M1qbiLjZ5L7idZ2uHd3o8v8cEbRcTfeXuAhyp
	 TW4b9WdlBFPzaCmZEcKbfeD5jRX/OJJofELJa60WTgJ8W3SND0d2ASOgtR7jwXvTYu
	 Ba6decmNYmk7pRdlaJjmXB1FEiAcgysvmNoILN487gvpmOqy8sEgdAjLDm52zgRAjR
	 bOIofnD0rKBatYwe2DzQsSynDE6a6CbMf/6EjSpOqgEayCFLTo7yR9Ni4AvVfSBj2w
	 pMAGulz5izVqmwENGXgUeJ8OcanND1mH04emno04fR3ZGuI9r6fOQT4lUwNgIiiiT+
	 t6Mfvhs6ew918y/bAXzLbwu3eAGhl56HLPTA0GbtK9K/JH9tMoQ/fR+BdUKHwKGEs7
	 W6L23sSGlH4GIkur9NCtKDphr6+MjGMwgu4JU2RJWh/GfjecqNdAdyp9mNcQBAs7JI
	 Vrn5oqYc/TX9JwRO1lX28RoY=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id 8FE5A200216; Fri, 27 Nov 2026 17:04:23 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1795770239;
	bh=adtqiuprlwq8VSON8xmtvCVPO/QTeq9ihW9PpmaeWmU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=Gz0qMGIwsNBSx5UK4IsPoFpKnHujYUWUslr3pjL37aymptIB4qzXnv0dl3II5w6Od
	 6j4BWZOW/B2LpjGZdtcSFAXkN7vz//unOraxJvDJ04C3GachsxO3qTNmU2LI8XcLYn
	 4UeIdtoRSoRmwSeUdYJN1T+hEobeLNmcj6mAalDLTp+jyNDQ6xLl4xuBI82GUVBM7Y
	 HVoPgv58+0i53k7aZB4HwhJ/CjkmLVkXn/wSA0gV6ejDeZ+D6lZBcII3OvpHvsL3zT
	 fEqAAIFmwTRFtREXQXz6gxyzynUoqMOWPbHYltlh8ahE0bIdvIQfJVg4avTksse1CN
	 iv6oWeUaw0O+2A5JK7Emz40PP6iKqW2vlOr6jgSBzirjei6g7SfPjCnd+W5/axhg+m
	 kieCj9+EuuoTa/heztT/DGYiNpJiwM+m9MowTr/qNb7G/3YtXEhmAC6Y/x87HZSc7Y
	 TB2DEgXRSK5Sqi9kbJEtgdF+YZLxRX8BKKDykLDILyij6MMCteW9OKolGCvN4Xqk39
	 2jmHspXA4kUXA6fl0r6b/ZeUhHt1KvD2UuKDkSXL1oQ959su8Ma8NAobhuWRyYe2ng
	 B7Nn7Io7FAAsvUApV5LFTKClzhsfISNlkoK+exioc6OM6eMtyW3gtu9zcs5uvvi6dY
	 7U10ZoY6jK45DY/soJ2391F8=
Received: from shelley.lan (unknown [IPv6:2001:8003:8802:7000::41b])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id 5A0FD2001E7;
	Fri, 27 Nov 2026 17:03:59 +0800 (AWST)
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
Subject: Re: [PATCH v2 7/9] firmware: cs_dsp: Give the bin file KUnit cases
 distinct names
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
In-Reply-To: <20261105-kunit-param-names-v2-7-765b3d5275d2@kernel.org>
References: <20261105-kunit-param-names-v2-0-765b3d5275d2@kernel.org>
 <20261105-kunit-param-names-v2-7-765b3d5275d2@kernel.org>
Date: Fri, 27 Nov 2026 17:03:34 +0800
Message-Id: <179577021433.2515039.4752533169416309277.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=596; i=david@davidgow.net;
 h=from:subject:message-id; bh=adtqiuprlwq8VSON8xmtvCVPO/QTeq9ihW9PpmaeWmU=;
 b=owEBiQJ2/ZANAwAIAcYipzoZDNtCAcsmYgBrCUd6IhU7n/NUfpSiZs760NvK6L3Ww9Cav+QNA
 h3IhA2dQUWJAk8EAAEIADkWIQSmmTCaqhqZOsxDGC7GIqc6GQzbQgUCawlHehsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQxiKnOhkM20JVaQ//ZgFqnat2TlBnZAiC2FzFGYD+SS2TFhK
 Jk+meG2VetjTVk6eSqjNdQ/uxm3L+1nODJoRrqITu/7h/KG4Uns9qFuDPZwersD2ur/i9SR2FJi
 C+aU3mK5qAhG6orGK8KUHF11LRB3nvQDFKgQFRxzedICdTIzYkKI8vNJ/zlQWBqZPpleaRU2rwN
 1tsk/PpwywiAFd7uaMu6LGkFZAob4Y6uLCne38c3cmB1J5Ab08ETQB9+TwNWVctMRhjxtGpTCnS
 gIvK1yv+/MWhDGZgu9bxX8zSYND0ge1FQKO/VNPvRNzbDbVfn1KAz/Jbu/saxTmnnxaiqZNHwx4
 gxxUWX9xyYf+DWqld/ZOjUPpwVTadK8nVnpqfhTs+ynBT9mk3wb16DnAIlj70PsSAwOJ6McLfZ8
 qGJMHVFXg2FQ9Bza6RxpYzL3j0bzS/Pr0LLbiqHT7mTstrnyVxyCJzclxhCgOURiLcHGq50RATc
 F0BDwaNZqbDASHnXeoaRgA+QPjdqPH+0PzJXYKlGYiDdTYZMUkZgpKWcPdJvkv+AK+DdaAhr4xw
 Eyj7Hdb/0CVNEdCos4AS8SIPYpD6uvI60fhL2S+BlVGvdvkw0DmG7fSqXeDjwXoaF0KeUCQQrwC
 1/Q2afHiizu7f5NONB/xItK2N4WOm59/XqrRa1l2eii/ejLwdOhY=
X-Developer-Key: i=david@davidgow.net; a=openpgp;
 fpr=3B0A53B1D9DF6AAC59C230322A821C5AD66AB03F

On Thu, 05 Nov 2026 16:00:34 +0000, Mark Brown <broonie@kernel.org> wrote:
> The cs_dsp_bin suites run many of their test functions against more
> than one set of parameters, listing the function once per set with
> KUNIT_CASE_PARAM(), which names the case after the function:
> 
>  - the ADSP2 suites run the XM/YM tests again for ZM,
>  - the WMDR v3 suite runs the whole set again with long offset blocks,
>  - the multiple memory tests are run varying the offset and the
>    algorithm.
> 
> [...]

Acked-by: David Gow <david@davidgow.net>

-- 
David Gow <david@davidgow.net>
