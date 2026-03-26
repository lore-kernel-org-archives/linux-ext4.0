Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBB3391820
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526286; cv=none; b=HKiLEpocXdoWdrVu93mmsEEWNEPogKQBl3BgEGmw87ypRNlQPmV9t31nRI2PraxCNQN5opU6+UZWOi0e1c80uvP6E21xLFDEnfM70x9RL4up/i0+HdR4HS4XdV6BFCL5W4ZexmVNA9znoIx+HtYprx9SSrd0Qeq13VWu4bE/B1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526286; c=relaxed/simple;
	bh=OoU9UIjcTb6qcIB8TwLFkBy5siqsu/GwPhLF2tJYZWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTtymT5S5Q8aZcJUAJl1JQ8WO1rxrPRsVz57rmEuK4vpqh4yolK07wdkDm95KEO4z+LdIuE/Iv7oYsyw6w4w+KjttsZqL0hO+0dF4HhgsAtfMjFTJmF0/5o7AsYi+d/DNszKymd9ggTv/jttKJlewnXAwmeykc6qkOvK393V55g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=nsqebLL6; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="nsqebLL6"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvvqb020390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526279; bh=YU1W/+2Pptw4tIS22rYMG6W3zbGwCdoDGEE2nFy07h0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=nsqebLL6Xy/FH5zZ+8XJxDMl1Phvm/uwf5cB8snYJ+foleDvKfGl59W5sEZOQKbX0
	 dPRZc49D6vzvpSucH5XeNqZjDHTHVbu4ErXBQKT4WzlGhcSuIzQRiojkWR3aN8BHpj
	 kHPNaMRvwT2Acur8BGFLLxfTAIhUYSdlZOH5hKIVRIpLUwzZcmwo3zfoCPPCi4H04S
	 8w/g18zBc266ZmgKazT76LFVe6zSR7b3DNxvlih6Sv6S4J4CqhTakrPJ6RzDBBNK4S
	 4RXpFViBqRwQDgemAc1memw5puEskxn30vgp95WKxzla6wLZrp5EYS/cJGGp7S5Jj5
	 Z1ur7apI60peQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id EB8AF2E00D9; Thu, 26 Mar 2026 07:57:56 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7de5fe447862fc37576f@syzkaller.appspotmail.com,
        Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: Re: [PATCH] ext4: convert inline data to extents when truncate exceeds inline size
Date: Thu, 26 Mar 2026 07:57:45 -0400
Message-ID: <177452625024.1205486.11166725369591880699.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260207043607.1175976-1-kartikey406@gmail.com>
References: <20260207043607.1175976-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sat, 07 Feb 2026 10:06:07 +0530, Deepanshu Kartikey wrote:
> Add a check in ext4_setattr() to convert files from inline data storage
> to extent-based storage when truncate() grows the file size beyond the
> inline capacity. This prevents the filesystem from entering an
> inconsistent state where the inline data flag is set but the file size
> exceeds what can be stored inline.
> 
> Without this fix, the following sequence causes a kernel BUG_ON():
> 
> [...]

Applied, thanks!

[1/1] ext4: convert inline data to extents when truncate exceeds inline size
      commit: ea3ec364b624093c46426269a34cf7568af6d6cf

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
