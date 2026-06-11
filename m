Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFC02C21C7
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2026 12:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781181569; cv=none; b=cOaUTKdWPKR0ph4qAddXrzFUj2AyX2d5E6ZqBa9npyxLYoMC6y9FHp2VlT/5MGsWxaSsHtUct5ts5Yh6lL+QucIiHEBx+dXn1rJDMNHuKZLQNrDAZNUZQ50WA3saXWlOKrAKArWgGFX6z6T002Kxw358EHwPBBnJ4oztpkMiZGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781181569; c=relaxed/simple;
	bh=9Bvyv1ltMJ5S0Ndc0oYA2A+jel8KZquHmPNdg0Xy0WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjIWDlfGLt3PhNLJj5+HJK1ixmSUzhqSpv4r3y64GPQuqxDSZvKpAW/ycmReURYDiL0tJB+3LowtvltwL/oVfMkkOnq4GjEaXiCy1gJXcyd5aIoUhs6phhetL7j2Ufrc4bwkMYwEkH660+tmoAxXEJU53ce3g7M97JTtI6vuJsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Kr8Hp5ae; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Kr8Hp5ae"
Received: from trampoline.thunk.org (pool-173-48-113-189.bstnma.fios.verizon.net [173.48.113.189])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65BCZTQH008239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 08:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1781181336; bh=9hkUyOfRdSfcH30kDgjMrwr7olQzjuzlkhGQZPvbL3Y=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Kr8Hp5aeOvNSQRcNuyyhloXulCAKCYPZCsL+OCNYLCU5BCAHv8H0Drb6qvh8GB6hE
	 yXQ4teg3wE/KW6mL8gimaXxLoBLmmCCUhyOppizDHyLm7rV+Xt0vk//pCrN8Hz/yxf
	 RRpi4BWZb1om1OJdQ3C9ICAPTdUpWcfCMjrIAOyyMuk21vtcZHjIBmkGJ0n12roZPh
	 dp2zJd4FLLKtqzPQZufW1h31HMnmAPQc4xE33hYWx6u+n0I8YFkgfRYs5EV6UZ8c07
	 QzQYLxgQj9SPY4b51lzudOwtbWeGGVA3Jhx1GW03PHKytBnhB06yeX8ASKVjY8yXt0
	 skscEMBWH7s5A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 11B592E00D1; Thu, 11 Jun 2026 08:35:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Remove mention of PageWriteback
Date: Thu, 11 Jun 2026 08:35:19 -0400
Message-ID: <178118128401.522716.18185971333745653001.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260526190805.341676-1-willy@infradead.org>
References: <20260526190805.341676-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 26 May 2026 20:08:02 +0100, Matthew Wilcox (Oracle) wrote:
> Update a comment to refer to the concept of writeback instead of the
> (now obsolete) detail of how it's implemented.

Applied, thanks!

[1/1] ext4: Remove mention of PageWriteback
      commit: 4e3a55f44b42c2aabd4c1cc3bdb6a01a7107121d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
