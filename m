Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894E224677B
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675898; cv=none; b=R9LXRZw6jln3nha8wjrRbpFnQneMuyKFZa2ITXJaZuaiAYug5ja10EAnZJCIidTl/dEl8cyfMN/Rr5FY5Zfsm0j9bE4jIaPcnJ6c1RBdzSeoHLNMtmeInqMDnDmhrnvUOq6ZFeb68jdcc7JPx1Abu4Nvq9oMTK9Z5obE5De7ZXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675898; c=relaxed/simple;
	bh=TUvzaaku/s17tXFFXYNwVZ8YNkTm5wUVvSlEKs7iR1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SpbWsxeJ5wR62ZHjuR9aa2nROjfAGLsKGTIHPvBt+KpCR2D2Fz9DpO2cpYhDIdKQrot3wrQ2rh3hVVkzBTd9Dm21VcHsme7dO91gt3SvMYH54lLjBOis0LL/RG5PEWTSNyGyyyV3FwYoDO0jxuDcDnVYptsfAE0mhSjuUGSNhFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XpYSHOS1; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XpYSHOS1"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VIAS013566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675879; bh=d050ledkPrI6MI0VPNPLrQj1ff4cKAgQSbb55UDKYtE=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=XpYSHOS1IRcYSX86mT0ScCyjps0hZUKdyXtljvwFRllugH0XjWD9GcQd9hplrsu2q
	 E/FtSdhe7qXAb9KYcuqHa0sgwB+pPJafqhsuqsC9RfKmDLoYkMRrM99YYjYvv7FZKn
	 Oz83meUNqMlajX2X/tLI8132hIzjhE3iIwxdJKeugxXmX7DQZEE+E3w8KBnKP+CDoj
	 UjiKY91fU91pc+arvym6N2BD4c+eLz+b2Na0suLH0sCIHZzOT/agC9cNI4IGgjBGeM
	 kOS7BUAVKhnTDoKr/G+aXk1ZW1bTtJLcDMTcj0ZbV18j/FftTjL+GlYDSXc2qLlZxO
	 WliAhTUbfslTA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0BA832E00DD; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        Zqiang <qiang.zhang@linux.dev>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix the might_sleep() warnings in kvfree()
Date: Sat, 28 Mar 2026 01:31:10 -0400
Message-ID: <177467585135.1335526.17976986565322815598.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260319094545.19291-1-qiang.zhang@linux.dev>
References: <20260319094545.19291-1-qiang.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 19 Mar 2026 17:45:45 +0800, Zqiang wrote:
> Use the kvfree() in the RCU read critical section can trigger
> the following warnings:
> 
> EXT4-fs (vdb): unmounting filesystem cd983e5b-3c83-4f5a-a136-17b00eb9d018.
> 
> WARNING: suspicious RCU usage
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix the might_sleep() warnings in kvfree()
      commit: 496bb99b7e66f48b178126626f47e9ba79e2d0fa

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
