Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099700;
	b=A9Myz1NoPDHeYT7oh4LmPbEB/nRG00WxkTMqw/fJPO5mm9gB1UhufRYYT+DjTw8vktWx
	 eigx5LAEK+08b68L8KV5ZDjlBw0gTGwHgKrEjvjNlajrHIb52CdUd5bF5FaRyYnxBM+3o
	 v6WOD1uew93Ea2uiLwckvHGkaLR7ksuJEes+0wYAv2q/kfF6Y0GW8pj7+4FL+uaJLjmd5
	 jBPeunektWK/EOQu1xlw4E6ih5/7rTIa3zSPqlEJnEEKLaQM70nl5XdfOdXmMt5INeFnI
	 2wtcZVC2EpR0Oj/ae3v4x0EvJbKtzLvyEMZhCluusimFZ9t3YycrMtVgkCNXNbUoFkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099700;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=74sN9QGG0JCpJW3Ur2HPs7MYvyHfbWdZsr2EkdJA/hk=;
	b=VZs4bvtu6577PIzJRYWFVpLUuTn+WFD0TY2+kvrvolZK34UnbSOaLz3dIiyixr5KPYgr
	 GZMu2TwUsKpTvy248NUJELT6K0fKEX3OywYMiynAbgMt9yEAXFwLAiElX1zlv5T89pydN
	 eGzFJHI19aWq1CL6yD7P7CHLfYeM1oq1IJ8aijU+6dq2w2zrjh/d6YE2sKdXiytZQnLMx
	 24vxaH9RUqkd4rRztn3BkCBAcKq0E9eXIVMp5HJtRjW+XpNID89sQbUnUOotLID91C39R
	 HIVW3p/mI5qWU6M0eRtC+k97omm0aX9XD/eA6nAeJaHikV0mNHRA0jZ3GlCeLB6/GmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=BHvZJbaf;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E418A606E12F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E418A606E12F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=BHvZJbaf
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElhYC018283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099665; bh=74sN9QGG0JCpJW3Ur2HPs7MYvyHfbWdZsr2EkdJA/hk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=BHvZJbafox41nyon3WW+pMptrbgFWTxL5UzD1JQCNntpfkEPKHardJmlRGJWgiomG
	 9UbzSz8QtwESe18HQtbuhvoCNSLm6KoIghNnTCzlPxwECqhOPWDRc45pDUpWHXVY8Y
	 GbWnCV86JdE0iUf1BXriPcRXKtsK1SBqs95kRBYQlt/vUGn0qobcKd2j3noYLNELEm
	 nTAQNmpL3HPIwc8gZe5Z6VZEtBnI2NFIFJYb2LVWiGsZN1aOaCLKlHYYLhziziT38l
	 gUg1JM4RCIjLu6VZ6LH6b68FffXADjhW61If51r+6gYV4VHpzdW6DCt0vUFi6oQkuA
	 TjEMIco3q1qxg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 7E8952E019E; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: fix OOB memmove in ext4_xattr_set_entry
Date: Thu, 19 Nov 2026 09:47:27 -0500
Message-ID: <179509948684.1938961.11594093534091787371.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918101249.43643-1-zhaogongyi@bytedance.com>
References: <20260918101249.43643-1-zhaogongyi@bytedance.com>
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


On Fri, 18 Sep 2026 18:12:49 +0800, Zhao Gongyi wrote:
> A corrupted filesystem can leave an inode marked as having inline data
> while the system.data xattr is missing. ext4_destroy_inline_data_nolock()
> then asks ext4_xattr_set_entry() to remove an entry even though
> ext4_xattr_ibody_find() left the search state at the insertion position.
> 
> In the syzkaller reproducer, the old xattr value offset is smaller than
> min_offs. ext4_xattr_set_entry() then computes val - first_val for
> memmove(), the length wraps to a huge size_t, and memmove() can run out of
> the xattr buffer. This results in an out-of-bounds memmove and a kernel
> page fault.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix OOB memmove in ext4_xattr_set_entry
      commit: 1608d1abdc62d09f9eae9df925d471598bdf6913

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
