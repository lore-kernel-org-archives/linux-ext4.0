Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CDF479899
	for <linux-ext4@vger.kernel.org>; Thu,  6 Aug 2026 15:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028479; cv=none; b=Pcps+JzsHv85U6RvBVfp9TobThvWbG1GTq6iZf+WPS3Dtk0CWFZdtF47chjdcPc0ox8BOuhwXRMjqWCqb5w6zhELXeHKA0FYmetY/dsZAdqQbahpofC/VHok8xdds0lzbSm2XRr06iwx4JMZT2jzhzwlXRkVMmNFcZ1SsKA6Bjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028479; c=relaxed/simple;
	bh=bhEnTqkonl70m1Tjh1uc8OH3Oxk4AOFbXFrXuWkIpKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kT3iqFp1NSyJZG+KVWFLKAyshPS6OGppUXOHVanlapg8z1if6V14kZgI6B2jTxZDwh2LZnjSCakg6PSyY3WWb322SBif9Vwv9V7WDOBjMARcH6wx+KIqIhdq3F1+qxxsSxFoytVe/rc4+CW0lRZR/Y+upNGuBfaHT/U6glEajJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=OuxtbgG/; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="OuxtbgG/"
Received: from trampoline.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 676F16Gm011298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 6 Aug 2026 11:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786028468; bh=W/l7LPjohIDVFOITqyordOCbdjDb/QKuqpLhvHLMKu4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=OuxtbgG/fZmz4qJGFTKaRQm/nI+Mv2PSTf34RDPZ0UZ4NpNypdUaTC80wmsrn+tKg
	 Io0XkjCbGQIP1QCuQWk/fhy0SF4Pcp5hAghwaKcM8GFcXre/YYrG1n0Stect9Rwz04
	 Eom04EgpkhvhzUZ0jEgYWorlmEaQ8chQd3C/xowibzV2ftU7bhWMP0GaqY0sGaZITo
	 9/7UzLGKjbb7eqSHYh2szKMIRVZ48SRDvr4XbsmPfpoeykCeWOdicQ8O8sDGm7Y/D/
	 ZdZ34dDwQc31xV4axTOYaEGSwzLELjOFaU/0FBS9XJXJdcf0dJ4oNJ102RbuE/FOrO
	 Qz4dWv5zH+3xw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0E9892E3F16; Thu, 06 Aug 2026 11:01:06 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiazi Liu <jiazi.liu1984@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jiazi Liu <liujiazi@amazon.com>
Subject: Re: [PATCH 1/1] ext4: fix incorrect function call when initializing s_resgid
Date: Thu,  6 Aug 2026 11:00:58 -0400
Message-ID: <178602814508.965683.2220822685991573635.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727104103.28916-1-liujiazi@amazon.com>
References: <20260727104103.28916-1-liujiazi@amazon.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 27 Jul 2026 18:41:03 +0800, Jiazi Liu wrote:
> In __ext4_fill_super(), s_resgid is initialized by calling
> ext4_get_resuid() instead of ext4_get_resgid(), resulting in the
> reserved GID being set to the same value as the reserved UID rather
> than the value stored in the superblock.

Applied, thanks!

[1/1] ext4: fix incorrect function call when initializing s_resgid
      commit: c87abbab6147dcc5aa1fd8f2a61734d58d8b99ec

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
