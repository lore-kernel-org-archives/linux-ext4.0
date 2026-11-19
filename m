Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099674;
	b=lRpYxqHjaaTtAXX98aJbsVaEhwEFqDaPhd6TRpAGQB/NJtqKm8yokJf1XxahJxBEUwYp
	 uNmCn1oUDmy2JInFxj/ssnQT8OxjpJmnaHTJ2PqbPqdH23UOfPyYyEErZ0NUFX/xlqKhm
	 N73IFgvqSWc4eXnsNs6e2grCq0MXhYbxogKh1vwhOYpsfmGth1VUSjFLXD7Poulj4kdQj
	 meKRxeLwOHyK88B39g5sMPGQ7iuqJo/rtMEaAJ43u+m9li93kj4aPaGxuEDnI/BqXb7NU
	 33l5MKOnlYYX8T0dnYPAmw31FWEHJ+pdmgzjh+G6g9IPfag6BP95+J00tvrjmIKIhMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099674;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=n5sjMrno7PS+5/FxCbfK2I0915urQaYpHmFhsEDS1LA=;
	b=CurdfeOMK2LXccnXRhriBAGDoztsp1Bec94Unt5K8jTH8IiE3XmzDTU91A2O3uuQjEkY
	 0nNUNyl3cIAi3PQ0pRT72X2rDG8Xx8ld7rGIda5ixqAi4FluXj5+WryMPxSb/GZCCmJVy
	 K9fmyKbZMnhmOzUIYvqO6Jzlb1cIg8FC7rvs1Qok1lzyIB2yIHu25mnfqI0v40rYiicHI
	 wGteGI6Gs5oZQ0anbQMps1+Cc7wekaSF2tjBQG609s7TddW9o5rf4LoaVRHMA6ma31597
	 0UeQnyAiagXt37te8exD64gjDzgfB2CSENajzApTs4ReopSR2Cs0N8g3fkUEoywgJ+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Nciq9WIT;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E260A2605
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B8E260A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=Nciq9WIT
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfxU018158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099662; bh=n5sjMrno7PS+5/FxCbfK2I0915urQaYpHmFhsEDS1LA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Nciq9WITu+fKPlhE4qdSt4S53PCexLICO9IzV1iw09WiefSw5KIHwVW+3F3ZK8KmL
	 FezRZhVXuijIHawKukR6+VVB/TnkR4kiRZM690uBnWtjrlWhSF1jixT8y3Xgy5AZGw
	 sSvAKxiIa+frPEfSFqEHY2LHvjWykxRMjiPlPBX33nQ+s4+LdD3Q/2Wq1ww4O4zmrW
	 ugW7tbX3zrbHcKdVyruq3TXUrbTa/xx01X9E4gShGI6e8CMQl8d7zXsZZV0xWHasSu
	 s+nBEaQFbekpQ8WjxFxK3z3p1G2Je27k1FINDGSbNPxULucIYyLTGVYyFkS0YV8dN8
	 +L7iYhxEgfurg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 479C22E018E; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Lukas Czerner <lukas@czerner.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: free fast commit replay state on failed mounts
Date: Thu, 19 Nov 2026 09:47:11 -0500
Message-ID: <179509948715.1938961.12444153677794495193.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024104407.1037354-1-lukas@czerner.cz>
References: <20261024104407.1037354-1-lukas@czerner.cz>
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


On Sat, 24 Oct 2026 12:44:07 +0200, Lukas Czerner wrote:
> ext4_fc_replay_cleanup() is only ever called on the success path of
> __ext4_fill_super(). Fast commit replay runs from jbd2_journal_load(),
> so a mount that fails after that point leaks the fc_regions and
> fc_modified_inodes allocated during replay.
> 
> Call ext4_fc_replay_cleanup() from the failed_mount3a error path, which
> every failure after jbd2_journal_load() goes through. Do it after
> draining deferred EA inode iputs, so evictions still run with
> EXT4_FC_REPLAY set. On paths where no replay happened both are NULL so
> this would be a no-op.
> 
> [...]

Applied, thanks!

[1/1] ext4: free fast commit replay state on failed mounts
      commit: 2d36dbdbf5759dffbf245a4777ff6984e12d5d5a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
