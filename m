Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099688;
	b=jrH34FhjAcZUeo8OXB09w1FS3hr8ieBd5856MEN0vZk1H31f2NuypKttCkcaYEbyVvhf
	 sRClowS+oW1DuzIOkjEwBll8MNWMhKd3LCfHGgos9Yu8xox+FmhA4+WNFTLOLR2TvEg9m
	 mzrIwzB6q62/kqo9b5RGvC3SMJ3xn9pmviOH2TrQxZk5DAgc2EG5kxvKSY1RC+xlx794y
	 IEtjbq4/6mYyWka260lC666Pm0M6zb/EmyWUqBmP+z56STowPZfj2Px7Na22A13+QjDmo
	 OMFu/5sQoJ+XrIeMxT7CFW0MI8b8RpnLPzt4mWcPLxIFHB0nkhd3FPxEWJarZPHDZNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099688;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=S3eBXROsZ1V1tzGlkc+mH+KX+1OZ5lIfl+yHoKm58Zw=;
	b=MQUVa5lLfUQef5JRh2ywCsrDLmu6TTQbKAWrBUOAitXll9kGLnsb75K5fFg/Ur+36Xy6
	 JgcVWd3PBNtSS7Zqf2l+Ntdx7qVPMflHddOeVWBov/OEXweOPTakfVvZxrA0AvfjCJz0u
	 cilF2ncYWOaGPL0Mov8qayPGfO8JV/pNWknGK+hqgB4C4YtVSyNFJfR54WWmouYgcnD78
	 /yV0MoBIlIRdsnGcB8JD9gIhYl969vPPjthkV5iBiG88tta/SVNC5yqgxsQOawf3t6bzB
	 dsHoJMQfwx67nZQdMbQ/WUZq3AOW7wkMjuG5wHSlDbLCQf8MH0yR4omGXN2Z/f3/KeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=bbCUj83N;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B8160A6F5A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1B8160A6F5A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=bbCUj83N
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElaYO017882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099658; bh=S3eBXROsZ1V1tzGlkc+mH+KX+1OZ5lIfl+yHoKm58Zw=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bbCUj83NB8F/XoON+gJkEJK4G8eFvZZZ89jYrM59F0efFy5oSHZv0Fhif+6741S+G
	 onRhjT/taC6YKNk7FOu/7+9x8KcX2PjgQ37f2E3Q5VMty/quNDtAM8I3RZLaBB/pFi
	 lh1hIiHH4s+ZKH1DcBeTPdSVSp5nd4Csu2525hRUdzHpnC7mdAZPnHkMnrUrXl5DgN
	 85E0jmg7PdpMqOrAw37JxxcPVb51mfphTEfqlzbRFMgrVejDkccedTgFzWv1DxXnDj
	 y/DFKl4NRlkgkuqvPSPzX4Pt0/Q9DCvMTNO3SA10E+QPs2QqSvBd92Q5VJitd2vwM9
	 zSozP3cCxxWKA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id CFC552E014F; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Yichong Chen <chenyichong@uniontech.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH] ext4: don't clobber the migration error in ext4_ext_migrate()
Date: Thu, 19 Nov 2026 09:46:40 -0500
Message-ID: <179509948668.1938961.5133534820495481165.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910052927.3161092-1-chenyichong@uniontech.com>
References: <20260910052927.3161092-1-chenyichong@uniontech.com>
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


On Thu, 10 Sep 2026 13:29:27 +0800, Yichong Chen wrote:
> ext4_ext_migrate() records the failure of the migration in retval, but
> ext4_journal_ensure_credits() overwrites it: it returns 0 when the handle
> has enough credits or the transaction could be extended, and 1 when the
> transaction had to be restarted.  A failed migration is therefore
> reported as success, and a restart leaks the internal value 1 to
> userspace through EXT4_IOC_MIGRATE and FS_IOC_SETFLAGS.
> 
> [...]

Applied, thanks!

[1/1] ext4: don't clobber the migration error in ext4_ext_migrate()
      commit: 82e2a5743b6ada7c77e072ca67c9ec55e9e18923

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
