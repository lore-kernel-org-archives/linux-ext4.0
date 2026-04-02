Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C31B4224
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138173; cv=none; b=ZN2h1PDt6sf984vh/h668wjBYIonc8Px1l/5pNFnVxsLa0dXjRZwHZsU9LrHzssxeKo9aT6TH9Yzer2JUhrv5FCSi5tmGUSQKGEARNQpQlegbi2bshYJZKJanpgUgw402UpZ4VGwGR+zpl6n6rw92gDsOiEDHIJTzLyWqrqdmcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138173; c=relaxed/simple;
	bh=NEaKcu4vVXbfgYE0yuCy6CExuc+RGWwW+/dIpGzO43s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVxDLjpDC2wBbcB31Nq+kCLcKzna8WjZKpx8DFaxZndhmUMPJMXi5FyoBXRvJP5mT35qlzVL7pEpgCn7YBEdT+oAvAxohgqb4DHTEBeajXmNwaidcLf9n0o01GrAmvuBAB3PladvfW3XWq5NkFhnKXg9kielgYiMzBC6G9vMIZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=PEnAwhPJ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="PEnAwhPJ"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 632Du4SJ008704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Apr 2026 09:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775138165; bh=R2XxLv/A6D2O6q/prXtW29kQfIw5x7ZC0GJBU5LFc6k=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=PEnAwhPJChqm2N9iCSpgBRrw4i2l/AgCL/IB1+hplmMS7otMFstP4M0iCpwjguSUL
	 TtBMCkDX9scpNCgpf/drw4+/SL4n1apm7aODTl3sqe9KXHt9hGFQmlrUoHeLjBJhOJ
	 J1XXXmoUuMZ6AS0Yh/28twiHTrnJQOp2Y70ZqP4+ibvDjLNIVERclRxw14BqFdMtR9
	 VFiUhnDL1O1x4+muyIY3axSTzV3jywKn70uWcRFyFvl0VNwTJRM40uORNENpvnq2Sh
	 xxv1F7luJDxRkaEYwzYmtFfoGDIqiEfVuvDOk144w8VQsWTckatSWowE51G51edaYF
	 6X80ggsWkQUrA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id F1C2860D9CAB; Thu,  2 Apr 2026 09:55:03 -0400 (EDT)
Date: Thu, 2 Apr 2026 09:55:03 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 5/9] fuse2fs: refactor mount code
Message-ID: <20260402135503.GD15407@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916576.3254574.12995451033800002505.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916576.3254574.12995451033800002505.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 02:00:42PM -0700, Darrick J. Wong wrote:
> Hi Ted,
> 
> Please pull this branch with changes for ext4.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 5d3394ff8d6f2e120be1343c1504831d9602a3b4:
> 
> fuse2fs: hoist unmount code from main (2026-03-08 19:14:05 -0700)

Thanks, merged into the next branch.

						- Ted
