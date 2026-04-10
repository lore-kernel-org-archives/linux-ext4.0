Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8853DA7FB
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834387; cv=none; b=TmZtpJwVYdJrYAs0S6qUIoRKJvTxxWp0VxRVYpsNQ+1LkdT5STzTWp2Cm1AEheRNM0yJ/P55FgaIZgtO0qW+4MmA29UT6PdMvMY5Il/UqHumQZklzNm8p5F+Q5VFKgzXVq32wWUq9ofHyL/eyj3OZ7+S+GCUqkz5ujhgdzZC0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834387; c=relaxed/simple;
	bh=ej52qOll+qP1nq1Lzts7EpjFnxlDvd/IWXAz9CzCUN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AqYfp2nsWi9rGkcXQ7DtmZP8TrGh96DiyKbWV2oeSm8zQTRRvTPd8MqXdRHJfqXddkt/q3k9JxxeIVvmq1ls6ykJ8xPkG2/8vCsVmysRseykNaXmrrXdMNG4vgCDU5pUNuGKbbWn6FZiWqpG88VzolRzWD5jwFjN7DrxUp+MI04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XD9qPbDl; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XD9qPbDl"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIpGB015883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834334; bh=L0nxbUJJO6oAX21VQ1PlpaBLALii/R8BCFUwcXuupR8=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=XD9qPbDlEhsuF/92m3t3LqoJ/DwNN6JWD7K50SkgMHsGPrprMYs1jzEmyT0OZ6rZq
	 yMoZvPwnhCfhmExYnknDv38xZCSvKI+HIaCwkkrdYu2U+wWx96kvDsHRVVsKUE20xn
	 kBoUwOVaIsGfl0SbVUBw3k/fPk7gal9PskoHMNET6thmXQ1HRu65/41wM00vbDmr6r
	 CJMs3L9So4FYTOldTr/M6EQX81H4CD+sR0uX2nqDG8puBtihHR3I1FSvIWIRyaI0F4
	 r0tiO4L3v5Dcl0UOO55JB7dSegwetz7mjRDI1JmTn3jTUhwFQyO6/PUK/3LysS2V1q
	 BhWtdc746UilA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1A07F2E00E5; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        libaokun@linux.alibaba.com, yi.zhang@huawei.com, yizhang089@gmail.com,
        yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v4 00/13] ext4: refactor partial block zero-out for iomap conversion
Date: Fri, 10 Apr 2026 11:18:44 -0400
Message-ID: <177583430877.2758959.1117298774574539840.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 27 Mar 2026 18:29:26 +0800, Zhang Yi wrote:
> Changes since v3:
>  - In patch 04, fix the comments of ext4_block_zero_range().
>  - Add patch 09, ensure zeroed partial blocks are persisted in SYNC mode
>    for ext4_punch_hole() and ext4_zero_range(), This can resolve the
>    breaks in the guarantee of data-ordered mode caused by patch 05, as
>    pointed out by Sashiko.
>  - Add patch 10, unify the inconsistent SYNC mode checks in all
>    fallocate paths.
>  - In patch 12, fix two issues related to updating the file size in
>    error paths, as pointed out by Sashiko.
> 
> [...]

Applied, thanks!

[01/13] ext4: add did_zero output parameter to ext4_block_zero_page_range()
        commit: 5447c8b9de7581ca7254d712652678cc460a18c2
[02/13] ext4: rename and extend ext4_block_truncate_page()
        commit: bd099a0565fce5c771e1d0bfcefec26fb5b1c1b7
[03/13] ext4: factor out journalled block zeroing range
        commit: 3b312a6f510ca217607ffacf5cbca2f08c402ec0
[04/13] ext4: rename ext4_block_zero_page_range() to ext4_block_zero_range()
        commit: ad11526d1504641b632918e202e23c9c80923fff
[05/13] ext4: move ordered data handling out of ext4_block_do_zero_range()
        commit: 69e2d5c1f544982389327ff90b491a0f7d1afe48
[06/13] ext4: remove handle parameters from zero partial block functions
        commit: d3609a71b777d073ea6ead2e6eed93e97841fa21
[07/13] ext4: pass allocate range as loff_t to ext4_alloc_file_blocks()
        commit: ad1876bc4c4cae59f747b4225007cdc31f834597
[08/13] ext4: move zero partial block range functions out of active handle
        commit: c4602a1d09ec7c6dd6f53e5faf3f04e9c02d71eb
[09/13] ext4: ensure zeroed partial blocks are persisted in SYNC mode
        commit: 7d81ec0246ff74b10d92a4617fea84eaf06162c0
[10/13] ext4: unify SYNC mode checks in fallocate paths
        commit: c3688d212fc6306bbb7136fbc1d0be0f175a5270
[11/13] ext4: remove ctime/mtime update from ext4_alloc_file_blocks()
        commit: 116c0bdac2ec059d91045ba3f57cc90cb1e3b71d
[12/13] ext4: move pagecache_isize_extended() out of active handle
        commit: 1ad0f42823291bcac371dafd37533f5e8d92acc3
[13/13] ext4: zero post-EOF partial block before appending write
        commit: 3f60efd65412dfe4ff33b376a983220ef74056b1

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
