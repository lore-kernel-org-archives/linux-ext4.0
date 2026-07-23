Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF464C901B
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812169; cv=none; b=IcTt9ur8sc94SUvkiS7XXtDh8oTTj9y2AqWdgvThZwN14FXn3/1fzwzj7+iVbBKZaMjQf9b6pPDwEERtjioNn1vgi4R0kvAmoSFI9Z6dpXKCAqUnl4z794tLtJBG6CUt86PTEfrWSCJez/JP4zq9BWs7WVpRPFC2toNcCqKci2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812169; c=relaxed/simple;
	bh=yluS32GH5xPPow2zwp3HcN52s074iyknLbDBJa5Gh1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LF57KSZWf2/wOdhhQgCfzhuiGV+YKzR3TGop993tWR9KsQXpGh1y/YkgDgGQvB1AytjglMmkT4LqJMlCLQc2PxJi+yJ6cBlQS1opK8D+AUL5JbBQbSJAoWJ2Y2caNrhH0j0TbQiLtKbLgj4yQMYmRU/+zRPi/Ut6l5iORGN/Usw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=V5ubLKfz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="V5ubLKfz"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND93wg017941
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812145; bh=WsVK5vaGW0yC/q1BBuZ0kCNtv72BMn9B7uUgw8psi2M=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=V5ubLKfzm/Qlf/1b9yRcrBfP5eQZ8KXIpvSPpG7Hpso9M3wPKhQujINNE9TUrQYd7
	 8pJUUr8DMjX8CDyjvISbXWnunYDULSF5Yt87Qturdf9qF3TE/38aQb3n/vu28m6WwL
	 etRCnU0JzAHLW+qm0v/wrQEDi+M0SJhLco87I1mkC43X1j07LGn2pzJ92TSUuT/Eyq
	 qyw3p8/nuYarkfFa8hXMBizYB+8l6fGjcsNTthat/Q9Xh9rmWXRspU+VCwuIkkesg8
	 p8r5+pno3hII6tEvMDOv8YymIe/1uKnQx7Qg8Iq7R73OUjNk3BSaQkkqHiAlsZaJMa
	 qmfhOy0Tx+Wzg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id CFC482E3F20; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Xiang Mei <xmei5@asu.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH] ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()
Date: Thu, 23 Jul 2026 09:08:48 -0400
Message-ID: <178481171749.796182.4958325647124265197.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260709184101.441348-1-xmei5@asu.edu>
References: <20260709184101.441348-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 09 Jul 2026 11:41:01 -0700, Xiang Mei wrote:
> For casefolded encrypted directories ext4 stores an 8-byte hash trailer
> after the name (EXT4_DIRENT_HASHES()), at an offset derived from
> de->name_len.  On the sb_no_casefold_compat_fallback() path ext4_match()
> reads that trailer, but ext4_search_dir()'s by-hand pre-check only tests
> de->name + de->name_len <= dlimit, which proves the name fits, not the
> rounded trailer.  A crafted entry whose name ends at the block boundary
> passes the check while EXT4_DIRENT_HASHES(de) lands past the block end,
> so ext4_match() reads out of bounds on an ordinary lookup.  KASAN reports
> it as a use-after-free when the page after the directory block holds a
> freed object:
> 
> [...]

Applied, thanks!

[1/1] ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()
      commit: c7e6b863d298f56522d0d08554bbea7f142e6588

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
