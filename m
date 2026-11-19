Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099664;
	b=Ib7yVl2TUCYeZvneSfYy4EFsZ1fdyBSlBT7N6WbNmc+s0yAqIDay7SPis5z5x9VtFH/K
	 WCdgIgFJ0YdQBBgJlyZkd4QesZPCqoZGnaWeL5og+5xtGd+eWisT+X1iQ6gHf3qmTvKGK
	 h57FmJZaEtERQzZrgWp7nDMeHKgRP9wyXNTjX3ZUEhorZBXg+IgF1ZgRBa9u00ZlXKY1d
	 jNgXIfMf/PHMt51vhwgTI+x5rbkZCGYPp1gE6Z+uneqh/oYOZfgD4FbYprrd9j/dKUBkN
	 Z0K3ZsIY52ub3YVzvTeC63IqAE/d0nhiAFaX8wvUruQjAbt1EhnUtDvjhUkMY+9c0+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099664;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=KcbnbdpjX1f16zvMMSuFZ4/9j6NBLAagPJeDDBEAGf0=;
	b=hR41mSqCzsgkSUFd+nVNXzO982Ak+6Z71EeCNvRqpIP1ewW7YrYnbmvx/EATkK0m2/+K
	 /uHu1IObXx2K9Cn01YMOwNKoUNwLLcIE1O+L+WTJZKMPQJxgucDrDmj3HGc67KyZ2wfw0
	 /kJ1ixfGQhjdNl+r72qu+RSR1h8E1MbGtTjBPclTmQx1EzKJx5y/8yuv2UmlQFATK+2pF
	 1k73w/ILJUHyHeb8tJiCZiPkz9IyEtXTC+hevNqQvi/Khvh0twKC/gEdkqDNnNyfB2c0k
	 bAtA0FHEvGy65uWMVbatcku73gTMHXu4Dl7Pg39g+M1nZ1XUkBAfu0hCx7J7Dgpfpvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HI0vcNKH;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE7F606A32F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FE7F606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HI0vcNKH
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJEldRB018042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099660; bh=KcbnbdpjX1f16zvMMSuFZ4/9j6NBLAagPJeDDBEAGf0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=HI0vcNKHrzmAsdz+ZeZARiaUnw3gUTJpvay2xnFERgXIhm0QuheSozm1tnunf3EJQ
	 0wX6Toc/SJjFvh/c6HOwNPr48oBUyq+SPvMQswHUBBcoL2o9bqAmSuqjDYd701s/SP
	 cjLUWneh7sf1SujdVQH4WkuAxmydfFxFyO6WuKsFP1+Ysbgiypm712NuljXZbcJvBl
	 h8c6qBAFCqMDLHJOi44I3VDm+fUIIEUu7OTi0gsLcl0xLtbybZSXrW0Jx+ceJ/cozv
	 yn7Ux3012WwyUsOiWVBxrxfX2oqdqhwpDnWEBzr+TAf0mOZ9C49TlgNJSQGjmtMTdl
	 9eT2Fi88NG5rw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 20FDF2E016A; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Hengyu Liang <hengyul@cs.unc.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-kernel@vger.kernel.org, kartikey406@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: do not report inline conversion allocation failures as fs errors
Date: Thu, 19 Nov 2026 09:47:00 -0500
Message-ID: <179509948722.1938961.403936387322923967.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030025730.3965245-1-hengyul@cs.unc.edu>
References: <20261030025730.3965245-1-hengyul@cs.unc.edu>
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


On Thu, 29 Oct 2026 22:57:30 -0400, Hengyu Liang wrote:
> When truncate grows an inline-data file beyond its inline capacity,
> ext4_setattr() first calls ext4_convert_inline_data(). If the conversion
> fails, it jumps to err_out and passes the error to ext4_std_error().
> 
> Allocating the first block can fail with -ENOSPC or -EDQUOT on a healthy
> filesystem. Reporting these as filesystem errors records an error in the
> superblock and, with errors=remount-ro, aborts the journal and rejects
> subsequent writes with -EROFS.
> 
> [...]

Applied, thanks!

[1/1] ext4: do not report inline conversion allocation failures as fs errors
      commit: 1107d7673f64233881ac0e2e110710d4f9cc671c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
