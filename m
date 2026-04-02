Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3013D3DF008
	for <linux-ext4@vger.kernel.org>; Thu,  2 Apr 2026 13:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775137778; cv=none; b=SFxMJdydLjr82JbSa42S5xJuJ5GFHz2UvKPj2tRbJDlaBiRtL/5oUfkPbbO/87PI/N4QOf2CGXqoHzdBIlt5BGUv+opM7GYwvph4PxmKI9kf9V5Kr/D//RT0kMSDLKLY/PkIKUuW/klBtH79x6K8ljW+Tvd2fUc/4dWkNaGzer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775137778; c=relaxed/simple;
	bh=ZKaLgI/GXGxdScdhPM43X/72a0hDedyjAnXxqJ1vGoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n83dS7X6+NEleKgVWjxTOV+B9iYmrE9agEu4/Q5Gr/ciUh9dGbhPUt/Kz+BxECuLVbODlqM6fuHi+gSrcG00LUGvBMOSdfPfO1yxIk2Yr2R/+Qj/WVL+nG2CXO+lTLUd81Hq76Y6s6LOC7I+Hl3yn5t9W95wN8WLEbKIPJ9pdGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Mk9TQfmh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Mk9TQfmh"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 632DnSwV004953
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Apr 2026 09:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775137770; bh=hudNQZMnqf0t9Ux7pIOBg3Z8Z4FbyJqxC9ujCz7aJ9w=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Mk9TQfmh8yqvkwDskW3/+YIb6KBHMOV7WsUDgPGzJ1DoaJr4jJdJ9mmkg8XBuGrKk
	 C5PS4nJbM0np2RquoMZljy2piN3aNE6w6UbZAzBvZdjIuFhEdbPl32cB7O/OcUO0CW
	 x6JvwU1Iq2QVjgCL62zUV/uM9oDcNdmwBGpGx+KzXA9wVxyUUnD0qEKHO+dqfZcXfb
	 NORZ2fC7b+jGG/Wfd52MXMnFXgYlR6WN9GINQ8dqXBnwh6QHytZPNmwXKcSW+PqRKf
	 Y3kteSOWx80Gh7nsECSqRQrn2M6WPwDDZYWBs4ponwtCLvQnRRqVXWV8ctIOySAVsr
	 ioQLbn0BuhUVg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 29F9D60D95E7; Thu,  2 Apr 2026 09:48:28 -0400 (EDT)
Date: Thu, 2 Apr 2026 09:48:28 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 3/9] fuse2fs: clean up operation startup
Message-ID: <20260402134828.GB15407@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916519.3254574.10658825847200071665.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916519.3254574.10658825847200071665.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 02:00:11PM -0700, Darrick J. Wong wrote:
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit a4fc4817e3072cb19f481da24d4520671a174fff:
>
> fuse2fs: implement MMP updates (2026-03-08 19:14:04 -0700)

Thanks, merged.  (BTW, I noticed that the previous pull request
resulted in a large number of regression test failures triggered by
improving libext2fs's dir_index support.  I should have noticed it
earlier, but I had skipped running "make -j24 check" after merging the
previous pull request, which is my bad.)

					- Ted
