Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D42B471CF5
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812156; cv=none; b=TMdT9uzu6bS75373t+O9a2tBXN/vsIq4k2MvydCwHGg5q08iHVYPNy8nFOQilCZdF4x4dxw2SQMa8DBSd7/8y/AmQRTXEGK+qsIAlYUL4gZnF/hGw5SySkVDyqm+qvPbSB36Rp7PdC9d3C23bqLzwLARsoTLJL6d5CD50lb2e/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812156; c=relaxed/simple;
	bh=ARcfl9ugI5baxTjp6CydOVfLa/qqc137GPBQxHmWQ5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmYUK/FM0j8H/Hi3FelSly1m0XWZ1dGd4WsC8srYt6W3tOcuuIwEXBT8hXR+bQ8kEr31K8AS3dTjRZvfGan62ENsLjEawozaofOHJk9odHmNMfzQEo/v6iVqLZzjwDHLHQdAETTu8mOWXE8cS5W+Sx3suFDH11BMlRGdprAkRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=P8u/jEhC; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="P8u/jEhC"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND92so017900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812144; bh=6pV9ibJdJnVSe8Nv4iWxWQ7KtzfJji2JMZT4X3eEAkQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=P8u/jEhCMUW3FCZXAQLaQuFRjmhZfoUIJ+2JCUeyUVjiD7YnVQKK0ekoWR5kCQb+t
	 D/NtkrD3wCThQIkCSMeyvEcpayqVBZicX2PyfNrU9CWvYK3Ts9iwqZAcBziPJKqQAT
	 bde+i+OPI7BV4hv49k6Teh05xvZbQCcszEMgNqpS7bQe8bi+Qa18D7saQ9n3Oh3XIh
	 YGjI1tKlabnA7zOb2C/A7oOte/KzjvBLBDxJD+Pt4LSZIUZpA4R6upBKRmgx5ANnhd
	 iMhVwbdSbvAanms/YqdIfjl1q2UBFRFmCz0s/pbqIU+ioAFky73c265gUJx3TycJbR
	 r0/wHns2iqPgw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id BB1B62E3F1A; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.cz, Gerald Yang <gerald.yang@canonical.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        gerald.yang.tw@gmail.com
Subject: Re: [PATCH v2] ext4: clear stale xarray tags on folios skipped during writeback
Date: Thu, 23 Jul 2026 09:08:42 -0400
Message-ID: <178481171740.796182.14497370066206720502.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625160127.162272-1-gerald.yang@canonical.com>
References: <20260625160127.162272-1-gerald.yang@canonical.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 26 Jun 2026 00:01:23 +0800, Gerald Yang wrote:
> In data=journal mode, the writeback thread can hit the
> WARN_ON_ONCE(sb_rdonly(sb)) in ext4_journal_check_start() while the
> superblock is being remounted read-only during reboot:
> 
> Workqueue: writeback wb_workfn (flush-253:0)
> RIP: 0010:ext4_journal_check_start+0x8b/0xd0
> Call Trace:
>   __ext4_journal_start_sb+0x3c/0x1e0
>   mpage_prepare_extent_to_map+0x4af/0x580
>   ext4_do_writepages+0x3c0/0x1080
>   ext4_writepages+0xc8/0x1a0
>   do_writepages+0xc4/0x180
>   __writeback_single_inode+0x45/0x2f0
>   writeback_sb_inodes+0x26b/0x5d0
>   __writeback_inodes_wb+0x54/0x100
>   wb_writeback+0x1ac/0x320
>   wb_workfn+0x394/0x470
> 
> [...]

Applied, thanks!

[1/1] ext4: clear stale xarray tags on folios skipped during writeback
      commit: ec524aae479b4b2078c47492b90ec21200bce434

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
