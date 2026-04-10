Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900843DA7FB
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834385; cv=none; b=QCcOU74pEWZrUkDPcwXTp2P7ELIBxII2Lu9mW+V4xS1NEoCiVt6gZksN+TpKzs/fSa3dm5Z2GgHZqpJybM6Ffxo9V20qL0Ud94blb+U+F7aIgqpbjZbGSo9M+eZKDUARp2HcN4HDvFt9kN+VObRyLv9lBJsBppi1hO5+4ErazZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834385; c=relaxed/simple;
	bh=//HP5SJdnHw3p6KsSod76rUki4tafeOBN7PynjPtcWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6TLGz0nU2+xZs5B/JVIDhFTN3JiPJYfQX197UYj8lvJJG1zjcvHd/WDUbj7l47NMxMOs1EVG97Nu1/8ad3j/E6KnrLUl4QtP23VIfS1hEvIg1v9+YGetXXnazlJoP0so+E4f8V83PHTSxhDj1Q8ZRtS1VOM7t4MptOb3GBYYhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=fgQfACIM; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="fgQfACIM"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIpV0015865
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834334; bh=KCJyLDlkgxxXOGw52CgIeTXHhpsxVFvdbVlsfGif5ms=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=fgQfACIMFlxD6kigpJ4Htj3sKvMMYuCHzi5stsNZk8O6kM++eZledQT6Pk3pDqZDZ
	 e8zByo2dfvo1DpLs8ocgsK/f460zimIfLxrod59j9qxOK2/jkV2gPMebyE8EIEvCgS
	 tv4732V7qvsz/+O7GnubM303uJOzWB43qYP4elVmBUwG0JRefQB4SHCcMHiysEAre6
	 z1DClUz6S5M/zEXsNcpopRJ1nTe1Smt/V91QlGBih5NEVzeWyCYO0fXxR8zJKmvvpA
	 jlkZeRd+CBU8DXc7hdSRlH+MMmnIEyAYlo5kyPqodJRzqBCnlVHAomR/gqA86q4FRw
	 Tf5eJ8kAXiUPg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1707E2E00E4; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave@stgolabs.net,
        adilger.kernel@dilger.ca, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, libaokun@linux.alibaba.com, yi.zhang@huawei.com,
        yizhang089@gmail.com, yangerkun@huawei.com,
        yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com
Subject: Re: [PATCH v2] jbd2: fix deadlock in jbd2_journal_cancel_revoke()
Date: Fri, 10 Apr 2026 11:18:43 -0400
Message-ID: <177583430882.2758959.611441015890613081.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260409114204.917154-1-yi.zhang@huaweicloud.com>
References: <20260409114204.917154-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 09 Apr 2026 19:42:03 +0800, Zhang Yi wrote:
> Commit f76d4c28a46a ("fs/jbd2: use sleeping version of
> __find_get_block()") changed jbd2_journal_cancel_revoke() to use
> __find_get_block_nonatomic() which holds the folio lock instead of
> i_private_lock. This breaks the lock ordering (folio -> buffer) and
> causes an ABBA deadlock when the filesystem blocksize < pagesize:
> 
>      T1                                T2
> ext4_mkdir()
>  ext4_init_new_dir()
>   ext4_append()
>    ext4_getblk()
>     lock_buffer()    <- A
>                                    sync_blockdev()
>                                     blkdev_writepages()
>                                      writeback_iter()
>                                       writeback_get_folio()
>                                        folio_lock()   <- B
>      ext4_journal_get_create_access()
>       jbd2_journal_cancel_revoke()
>        __find_get_block_nonatomic()
>         folio_lock()  <- B
>                                      block_write_full_folio()
>                                       lock_buffer()   <- A
> 
> [...]

Applied, thanks!

[1/1] jbd2: fix deadlock in jbd2_journal_cancel_revoke()
      commit: 981fcc5674e67158d24d23e841523eccba19d0e7

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
