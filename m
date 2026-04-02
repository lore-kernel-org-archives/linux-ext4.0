Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C793019DC
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137955; cv=none; b=EsW3z+HADRPM9FDA8p9P8JsXD5DZM5B56RVBHgGglj+8Xq3a1wNCTaHxlFaUrqITy9KjB/J6dD9Wx33RFcftAQISazJ5myM2zM6OSB1rHGC0Z9RxTwMMGBUaUfHHpnO7Mp6oST1HCyZ5GZY4MlRExTrpnEFEBbjRqGEye+Oo4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137955; c=relaxed/simple;
	bh=R6P4KVp9tSs0mf5atxMxwlsTPmgRsUn09daYPFGHxTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoU/cRRE62mp6ouDtrcFy4ZbEAG8jEwpUUKrEd54MUpN383Y2NJVBA+3YkMl2DjR32VzPPbe4c5JgQy5g8UHJmNAIv52ui5XqohdMHvNPsUN2TR5tD2oTY9x7fQgAf6VHMG4QiuJDVOgBV1Kw63PRJ9xBZ+KoYKJj6keEXS4jas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=PopzYlwM; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="PopzYlwM"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 632DqROm006855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Apr 2026 09:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775137949; bh=zJoFRNj8ECdcskwgGdCXinOjyEtMbAI5Gq8L1Nli6r0=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=PopzYlwM+7UHAQCYcLHi0Hps4rOrYV785rVCiR0kkAok7QmVV6hd3vAskKM5NdFad
	 aOU/Xt5xbZ/HT3wapnL/wVIGxaXTlAzxirJ58128D4RpiQEqlH7pZBCRJNAqCW7QFG
	 ebZm2vN9tr6oxp0yQ4ZRA+iSpV9zN8I5+rynsN3Ueb9tJIAreBYy9GQcV1J94iy6Iu
	 AtxJ2zkQJAkkSGf8EAi8agBy1qFB+3fLJFk//1hMMHR9dQad8ZX4/cgLJRDKVQqlNA
	 LyujhK8JA/it6xP6zxCyNHi9a2bWaqiaWkML1aJCbwSHztrYearItxMdkd3zeK6ijO
	 IRSbreeNpMEpw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9F9B660D9872; Thu,  2 Apr 2026 09:51:27 -0400 (EDT)
Date: Thu, 2 Apr 2026 09:51:27 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 4/9] fuse2fs: refactor unmount code
Message-ID: <20260402135127.GC15407@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916548.3254574.4332031441968487356.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916548.3254574.4332031441968487356.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 02:00:26PM -0700, Darrick J. Wong wrote:
> Hi Ted,
> 
> Please pull this branch with changes for ext4.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit f5c46155c79cccd46e047d732063c7f21db35c8e:
> 
> fuse2fs: collect runtime of various operations (2026-03-08 19:14:05 -0700)

Thanks, merged.

						- Ted
