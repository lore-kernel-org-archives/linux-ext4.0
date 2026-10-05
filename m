Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA164252D6
	for <linux-ext4@vger.kernel.org>; Mon,  5 Oct 2026 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190900; cv=none; b=EsLHUQqX/w2Ar006+K7zvRK7tLVfNpaC8soB24HBNqAjaAg/Vw8Jy+tqhaC6k3xQX2YPTji6Br9fCUdMVqkH4r6LcGn2ypRVmGhUppw4SGFL8c53tyq42we1lTPE2aBNQwMwwv9sZcm7/kTGjf7G4qGsa7fxV7eyPgGe2vtB5gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190900; c=relaxed/simple;
	bh=cfCbdeoyqs9lFp93hAiJIAW/RThs3pxulD6iVGAR9M0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNnqMZLnlSU1xS+kzhMjUw+r1Q4WFBTpAaTKW9KkIVtUSiv9HmeN+dHFjuyScK2gjNgaMjgv8AHGFqWTVY+mdUhD75DZyeaoQo3tUSP6xM5M6pRhnlkRzgn7Qk2rGuWNVe3OfdK6SMKiJQooPssvIWnAPb4BBcUFpVQOyRnKo1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CNKKps5/; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CNKKps5/"
Received: from macsyma.thunk.org ([151.240.45.26])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 69591OKc003468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 05:01:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791190887; bh=diWfgc7wncaVIN9MrFj674Vinu8ZWgWgukXMXOMgSGs=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=CNKKps5/Y2qSquS78Usdz8mTa/FBMoOaN8hDm9fEebSNZkHFidPGh1Xc+HkbCGnQ2
	 ImK2U501+ovz/iYEt+QwA6ijR/sWXsFd9E9YOrak3QawV0HyII1mBuz+D1z10hzFAH
	 3QKBJCoeorJpzM/vAi2d9HFSDEWtJQZfoutG9c/c4TbvQKk8Xn11UWIatCV95Kzg69
	 n8HZPxGFpWTwodN+23aDGIPU1WaB/a0gFq5MMaJE9LVoQad1uEMaaMhoW07hoF0qLa
	 bC+rUk8G8E1I9+fyTCEjmoupfIAfWXvJf0CLayMls31O6V8zwC5CpdCb2wZM3QpAuY
	 9iBySOmdIQP3A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id DBC7A1F0F77B; Mon,  5 Oct 2026 05:01:23 -0400 (EDT)
Date: Mon, 5 Oct 2026 05:01:23 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Nexory <St4yl3r30@hotmail.de>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 0/2] debugfs: fix rdump path-traversal on
 untrusted images
Message-ID: <asNnNLWyiZ74Ofas@mit.edu>
References: <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>

On Fri, Aug 07, 2026 at 12:03:02PM -0500, Nexory wrote:
> debugfs "rdump" extracts a directory tree from a filesystem image to a
> destination directory. It copies each raw on-disk directory entry name into
> the output path without checking it, so an entry whose name contains a '/'
> (for example "../escaped") in a crafted or corrupted image is written outside
> the destination directory. A valid ext2/3/4 filesystem never contains such a
> name, and e2fsck already flags it as corruption (PR_2_BAD_NAME), so only
> untrusted or damaged images are affected, which is exactly what debugfs is
> pointed at.

Sorry, I forgot to send an acknowledgement of this when I pushed the
change out earlier, but thanks, I've applied your changes.

       	   	    		     	     - Ted
