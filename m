Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B6336215D
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773932461; cv=none; b=IJ2/GnRS+Ev7wGuFBoSHm+kgrf4vXnRS2AoSyawD+98wAcj/uiGeQRhFULTyDlUDxt+Dfmt/Htmbhfo2i9d1wmMmUmmeiKzbF5PK+/WSLfgKx/PAsyuNzxR28rBxtJSiJEwf7ftxv6ypTUJ0t6jxmMwUZbL5P+rua1W4lw/+LRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773932461; c=relaxed/simple;
	bh=a5KOYxvuj2Sl0Surm0DbaNkg7qyCkjrJDX+eHrH+LZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NUP7R42+JncKKI77yoKGjPv1P868wMMUd5yh7ItI6z3ISieL3jykj7yUhXOKu8X0LKdY/zF0bDhsXkjCzYfM9urN7bfoah10RKzhKiUBgoPG+7ByCPrYAG75t/fTI0tIUGKR8gku151uRZanty2DD3+upMVy7nABhIVlnIGk8tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RdocTgwi; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RdocTgwi"
Received: from macsyma.thunk.org (pool-173-48-82-102.bstnma.fios.verizon.net [173.48.82.102])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62JF0kaj003845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Mar 2026 11:00:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773932448; bh=AEeKJnp/+pyFJ91e5zUrWQ/FZSXm/+N4JRcE8IjHU8A=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=RdocTgwisZgvjPtjvIbhirkWKo/vtsclfSHykDvxZlKnY5lXBAXtiYRuaMmg/E8Pp
	 7dklmygs4crWQ7ZlchJzKMHz0dDF9kDD2/Lt0Res6ztoVz78miPsiF+zb0x8TwK0MF
	 19d1zmjGMFaAA0+VdEiGdHuvXA/chvjHi8MLGxciGQlQZQWKJH67FwUR76PLPpso74
	 //qlFxGCXLHBjEtRjALHa83nd+IsAdbwJ3knlRIUJTDF+Ufr70eW+vyoD7uSdi9YP5
	 HgNw/vLw4zaT8yB3yY1VlditZkyzBcbspBvCleqw9TZz60NZNktgu/IkwFcxeGLggc
	 Pzrb10qEGYabA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 26AF95E4D7C3; Thu, 19 Mar 2026 10:59:46 -0400 (EDT)
Date: Thu, 19 Mar 2026 10:59:46 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 2/9] fuse2fs: add some easy new features
Message-ID: <20260319145946.GB14752@macsyma-wired.lan>
References: <20260312205728.GA6004@frogsfrogsfrogs>
 <177334916488.3254574.394222234133985617.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177334916488.3254574.394222234133985617.stg-ugh@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 01:59:55PM -0700, Darrick J. Wong wrote:
> Please pull this branch with changes for ext4.

When reviewing this patch series, I noticed that the
debian/libext2fs2t64.symbols file used the version number of 1.47.4
for the new symbols.  I'll fix it up after doing the pull, but in the
future, it's probably simpler if you don't try to adjust the debian
symbol files.  I generally will take care of that before I do a Debian
release.

Thanks,

					- Ted
