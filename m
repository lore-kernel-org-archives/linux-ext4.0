Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E0F3BBA00
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138512; cv=none; b=nziKTvJj9FLXGogG3vSwG16LK9aLn/0N9ZeUt6a7KZuCH3zhPOJPRjsiP0jf+sysyOS+Lnz5Gyk6hOk8rS6OYMQTSE1CfZK/wOtSVeP2XtqBtU6Kcva9bRMcRh8LkKlOas9a0lUeoPZa3kiejUaJLSrnB2NjH6ezjdLRYGKO/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138512; c=relaxed/simple;
	bh=VLbzfCTa6bHHAeBkSLEJ50uXzA2O3JUZNevX69X5K3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f53y8O1efOes60H5Hy+LM1qwKPljul48Dy2UqU5WRTalYgQNo2UkmrJ1LRQNf9gtsvt6vr2GR2Cef/2/OrHi9pL+Men0uXVXuYh4c+4WcipBAlsS6ZyOK8rkPurhadQSmunxkUvQVP6GQq0rQjXaVc1o0nUotckRqlGzF8hKFNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=a6siuPLs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="a6siuPLs"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 632E1hbO011719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Apr 2026 10:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775138505; bh=P6mPL6+C5MT8JVx8YYTUS1yF56UpZMD3GAxTbb5blok=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=a6siuPLsOi8X/6R23Jvc2g+zfZtV7Q1n9dniPzZbA9cdZX75+yfwxzKM5oVR8OWtZ
	 LDdxbzF2O9QM/xW4FYZ+kI/dYmowQcUsvX+Qow31jQ+a/lJ8UH9b6stJPDnw5BAeYh
	 o8LVINK6rTbYvQ1m5Nf1ydPNM4nwm6mGwUcvk9gV00cucRPOopXnnXzw7ST1LBM5hG
	 k0WIgYWynMQ4utNiUuo1oKt2sUqZepkcBpt6Pgx4AUNcs20MNWX7v0aGSWyHmGLPYA
	 HG+AcmgWPOGC2SARALSoogGUeDAY+KLOXAI6vNMaB2Sqp7SWP6vQFusbjXqbKpUyLv
	 TApDojvL3CRoQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id B08FE60D9DEA; Thu,  2 Apr 2026 10:00:43 -0400 (EDT)
Date: Thu, 2 Apr 2026 10:00:43 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 7/9] fuse2fs: better tracking of writable state
Message-ID: <20260402140043.GF15407@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916629.3254574.9721669086227705727.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916629.3254574.9721669086227705727.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 02:01:13PM -0700, Darrick J. Wong wrote:
> Hi Ted,
> 
> Please pull this branch with changes for ext4.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit fe8281316fd37133eb78474040affabb3f060e24:
> 
> fuse2fs: record thread id in debug trace data (2026-03-08 19:14:06 -0700)

Thanks, merged into the next branch.

						- Ted
