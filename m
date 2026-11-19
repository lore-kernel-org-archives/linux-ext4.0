Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099719;
	b=KfOmYg6hI/2t/rEkFYisoKMbayj87fddKX1fPRgs6MCvobvKH+uUf7G3hAyVaNftJjX7
	 w8gWJH1xBeJglVMlr78DmVuQxMElM0MS0dvNcUI4R8hPy2yu+VeNeE10eHCeEW5JsBbxg
	 r8/AWJuNrrc5i6GUu9MeISYAdduOP0x/oeLlUzZt6sUp9iqbWEKnHY3zir4v3g87Xii/D
	 DS2gyFZPcnZdAWZ2maU6kLdUeIht0824bc8jaEuHTcPJt7MzaV/Im5KY/TQxDktt2fk5K
	 lYZOyfrUEXw2dg3lhALs+spLB0EjGhWw/icBwQbtcuLbsvgklDzKkBwE6SLPqbfkOIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099719;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=2k/qvIve+FteLtzWmf2yAnEDMnA+Pf3BrE8ettOewK0=;
	b=d/5qzY5dbAiZG5cQKYUOYsj4Hby844sm5Qc2lRwe+rgczguZzeRZPsRv9O38Sp0vHGGP
	 uKT6FUuwowO77whfxlNDyw4WqbVz4l+jZYQdwaOagme9WntFToS36WBKd2DgGvT0QgoqP
	 q4loc2L01C5tx+GwK8ABvfiQPzq4Xuqa08G/2ODMSdDZaFCJJXMqXxuPvxfvKkrlh+gJb
	 Q9jZ6+yujsz4Du7eIQzrZZcHWWR3mMKaMGvIZsYWjnzT8l95dmgb5imTY7aMjqjf7aq7M
	 K7kJ4J5x9ulb3m4Gk7+xdeNMEDg5ac+L966O2sRrPuhtk+EvnN1S5Y25IczSOfoI3eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=F7HtwBYt;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BBA60A2628
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50BBA60A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=F7HtwBYt
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfls018157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099666; bh=2k/qvIve+FteLtzWmf2yAnEDMnA+Pf3BrE8ettOewK0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=F7HtwBYtmrjpifyBLs5Tezf1l/Jlm21uQE1reVTQZI/NaX/ShIyRpNU+JPNu7m33b
	 7vwgeYuXrojda5DZ3kHMsoBQW+AEtiTWEi26oYogECMk4yzRWwPOXe19dgU0Ocowfk
	 U1Et/jnB0RcTglzVcVxRSHIURB4uNhIIvWUpuo6UMPoa8jtj5thcvA0FPVMryU0tTE
	 FWG84ErGZZ2LE+ZowEPezgxcZUpT7w/Fx91r5pMdgVAOQf2FW2lwAmYBLjGRAx0XTY
	 P+U0ww3SfyMZyAs+IH/kueK6TdWRgL/8X58eYh2b3vJCPEsKd3OP9hEozOaVyYmGD6
	 0fkbj+U9YNIbg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4B1E32E018F; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Manuel Ebner <manuelebnerli@mailbox.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4, doc: remove unnecessary bracket
Date: Thu, 19 Nov 2026 09:47:12 -0500
Message-ID: <179509948679.1938961.4968007170853654691.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916104251.296148-3-manuelebnerli@mailbox.org>
References: <20260916104251.296148-3-manuelebnerli@mailbox.org>
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


On Wed, 16 Sep 2026 12:42:52 +0200, Manuel Ebner wrote:
> Fix sentence structure to improve readability

Applied, thanks!

[1/1] ext4, doc: remove unnecessary bracket
      commit: 735ee61d4c17c57934fa279131232764abd70c15

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
