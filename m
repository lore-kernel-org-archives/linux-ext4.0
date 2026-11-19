Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099689;
	b=MoQla+/ManEuri/U1UyjcXMFVkZve448uA+MF6i0Zpzc1zH/or0xYAOAFIC5Ocy4UEca
	 //52s+tQZeY6ZDU2wmDi6g6eSIcICUGNX/h1VEdf5UMsm3b+9CxcQ0gdTH8KkmDUf4Vp2
	 /cI3WTNYJ+6v0dk/gItapiYkgAdrX+P+uuiDlcGzMVnlOkhWbC8Kb0nGj65GxWKfqoPfh
	 W4Z6d+3q5Rst7iD6bK0+9PwHSgKTN7jrL5d+VBb2UOCyylLcBiWlIes7d5S4nP8fb9UYE
	 pDk05Bpk4OkLejKMAmoDNVE++M4esfoZ0mjCIpP6hYonvpuBlWJcMAwNAAHpvWsK8vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099689;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Qe3qhA69nS8sGjHwgn1KToe9wAEJ9OgehotFm9MKvrU=;
	b=czA4NsAUjJs6fNs0RZ8LFUmvQR+YuiCjzRXiX6DlVuZW+S7Mg6VvPYgS2+QNx05xhxs6
	 cRQyK3LgeJ4MEk+aTbDBJ1GpgRhznJ4P1DUFRc6dut30LOY7zq7hzZg4C/0Ws8zJa/IOD
	 im671BfRPQnDg2Cvly62HsE2l2Y5P2A35IJcVcxb56cbUStfGjTii5lVD8LYoCzEiyuz6
	 sZNmnjDgy93q64+LhzXuMMd+1OK2Z/woB8uHnOz5mIdQ7J+LxsLhiMWeTvozOCdkvqzSs
	 UZ5HhU9qwDmeTCWyEVY5xcmObknfbk3k13aRsWCBo9MKgccAik4Hk1arFuudRINxCZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HbSHsnuf;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7A560A262B
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D7A560A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HbSHsnuf
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElaIO017892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099658; bh=Qe3qhA69nS8sGjHwgn1KToe9wAEJ9OgehotFm9MKvrU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=HbSHsnufWAwbjqF8QkuXJjdSNsYOHfnadqfMxdpty9cGy4EkyzV41PMEtJ1Ly0Pzq
	 F9YBKdkANp3unbJK8IDiBf2RhOurJYQoiqaz/CchzI8xhqOWzKj1UwGwMJF2ZRNCIZ
	 OmhZCo7aiy3WjaSRePZ+uJwR/k6dPh8Ky+FPBDiMD+dmfReqDFbDoUlke5wkQjazmm
	 BaG9SRVpcqs9S2S+WiTEQJVbto7mp4v1PaQ227LyO5dVd2PAcmM4beYrQZxFRHxXs/
	 RYuDsLmMLbtmo7BqmrYRr/Lgj3lxMGpMbq2NFpqF0bsP+QOj5kg2opoi1OfS+AdnS0
	 TcpovNvJvz+JQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id D9FF42E0152; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Yichong Chen <chenyichong@uniontech.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] ext4: fix the logical block counter overflow in indirect migration
Date: Thu, 19 Nov 2026 09:46:43 -0500
Message-ID: <179509948672.1938961.18102367817472578267.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914082516.3442815-1-chenyichong@uniontech.com>
References: <20260914082516.3442815-1-chenyichong@uniontech.com>
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


On Mon, 14 Sep 2026 16:25:16 +0800, Yichong Chen wrote:
> update_tind_extent_range() advances lb->curr_block, an ext4_lblk_t, by
> max_entries * max_entries for every empty triple-indirect slot.  One
> triple-indirect block spans max_entries^3 logical blocks, which exceeds
> 2^32 as soon as the block size is 8K or larger (16384^3 = 2^42 with 64K
> blocks), so the counter wraps while that block is walked.
> 
> A wrapped counter makes the migration store a block number that is 2^32
> blocks away from the one the pointer block describes.  Two ranges can then
> end up with the same ee_block, which trips
> BUG_ON(newext->ee_block == nearex->ee_block) in ext4_ext_insert_extent(),
> and without that collision the data is still moved to the wrong logical
> block while the migration reports success.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix the logical block counter overflow in indirect migration
      commit: 42be4bd54735ec52b2c8aef62cc068ac5f918f52

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
