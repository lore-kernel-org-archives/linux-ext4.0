Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099684;
	b=zSQPYk3a8QYqalr6Gl5qE73999qVLMbGbB4TlAFZEfYUF1xbcHyDcxv9o/Zp910n+7CB
	 5VytTu//rdOK2OE+EIBXElPa/R1xHb62PKzBaiXTBOc4xmZuKF4BHSo0ucERcsmKxZchl
	 DwDiJeVIK7DBiyopJ2hdsFXAEGckvyK9PUtIKp5dG0ptAtZdOIXqfATOwRk3QFkzHjDAN
	 Q/sIdzNWxEFI+VvYUXCmcSob3rZtARK04NI1F+nanFYJLKYfwLYfRNgzvM3Y8y6RFSGsm
	 VTr7sPz6VJNshmjnWy+pXGrpG2O4kAaTSDKgAxBEnUdYM/e3VxoWmmGoGX7w5iau2AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099684;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=5W9eBeMpCUNFjPULyIc9SZUHcLXnHYrkNCxqJKL/soA=;
	b=a9PTpeyXEtUWgeZKDy+BzvD8pW+9YVsT3moD6kfJoozp6esh8AVGaVqRTYYsWZXtUC7M
	 pFzkttxi0HJKj3USHO9gg4Wd0o/ucKzwlCEjpuA3WySlmiRlsTGWthaloySjZ0EzlEWm/
	 02pabA4DuT7SNmKbzOrdM1z6XvC/7ifPFwWxB8G+B2uVprCSGtLAMGbSXUzUnmSxhsGUB
	 vUHN7sy6VHpgBBMbNnWxjCJGS37HrsH3UMmLK9wR7HpUxHdPGPiixvA823SaFriavYvKU
	 bf3yQ0GAyx1uEWghBaDYa3gad3yHJhS2pGDn2ZTzZy6B+Vz7sSHXbZM8n4rCCQoIuWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=VRPf+UoO;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B63606A33B
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1B63606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=VRPf+UoO
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJEldtq018057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=5W9eBeMpCUNFjPULyIc9SZUHcLXnHYrkNCxqJKL/soA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=VRPf+UoOVJijCt1gQN4Om7IGkWDAqRi2xCA7UNNeVugii/ZMHc3Fj7k2hXFTHiG1R
	 zvA9gUZ/WECY8f1opWSS2Rwhv+JQIwYOoHX7duY3BFef7y0gm6UyCLFJO5UbnNGDQj
	 ll0Jdox7OTzp5b1nayuzc2XEcnyFqUXV3McepOnK75y9oBeTWbXo+aVafbKlEKnk4W
	 ToX+tuKVy19GImfYDqY65Mcp/WDHW3RexmgIo0deiENF2Rn04PVoK5S8MWqXPI7LgK
	 C3GAfEKNHZs2KuDtV3CUQScYdh8leP1XavbeEH5qKzA4B2QAoyR7WlB2T/5k7fF4iL
	 pI46Zlb/vB+qw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 2805E2E0185; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Mikulas Patocka <mpatocka@redhat.com>,
        Baokun Li <libaokun1@huawei.com>, Zhang Yi <yi.zhang@huawei.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix maximum orphan file size check
Date: Thu, 19 Nov 2026 09:47:02 -0500
Message-ID: <179509948692.1938961.12652922188361013635.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002115040.2783654-2-jack@suse.cz>
References: <20261002115040.2783654-2-jack@suse.cz>
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


On Fri, 02 Oct 2026 13:50:41 +0200, Jan Kara wrote:
> Mikulas reported that e2fsprogs 1.47.4 with 1k fs blocksize by default
> creates orphan file of the size the kernel rejects. This is because that
> version of e2fsprogs creates 2MB file by default regardless of the block
> size and with 1k blocks that's more than the limit of 512 fs blocks.
> Fix the check to make kernel accept any file upto those 2MB regardless
> of the number of blocks.
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix maximum orphan file size check
      commit: fce77179ac1007f88850f86f72b4ca58d566b113

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
