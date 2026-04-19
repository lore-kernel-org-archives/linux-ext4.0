Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F5F158535
	for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776559704; cv=none; b=hsmwNyel+xjVFWJajAYSXU21FRjMbMZw7OIZ4k1iK3aIXiBqQAqGODAjxohpzjmuQ8soVkXOmrRa1wa1+KwRpyqaJw/Zvezl5RNQK08X9dWJjyp6DJxDLYPG+fveai+acdwhelmWsvbQpCnaY2NKJDv0V7aydA53euUXOms7n9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776559704; c=relaxed/simple;
	bh=T8THIneoKjR7BIt70w8aMh+X7N7iv4nInsjiuIgCX14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zi1+hJ5Gv+fu4jZlO1gALwgqCxUqSKXocjKjv2z01fKXCtfSu8y/EeOvTxaRnXBG3r2ArVxqDz/4KNn8lkX9EJA7t4GfuapcZIkWmgGlDaoaQdVSu+hsvPiit/JX/1u29tKHWGFOk92HlcNaMBYuTFiD2GA1jz259EL1vgQR/hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Uuheqv3O; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Uuheqv3O"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63J0mGiu010940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 20:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776559698; bh=5MgujdT91YTjTbmvBUAMw0XqirNxkfSso789cDYpHVY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Uuheqv3ONoCxlRGB92pewwGlxET/keWrxqQcM25V3itHFKWw50RInmYcviRJhcwCC
	 0HXdfYNrRQY7kpvvSHIrRifc+m5J5KoUgSDMIblyOUGJEQ66/KUBfqMPnffw2/4rqT
	 U/rSHpbIb52Ldt3xAPl8TCrPjKkUYPTOd9VzqHbycNA+e/Tg+k9GnxbZ/xIic26eKJ
	 BS9cRKFd1abmvjLPtXhCjLE6Qd6NUwh6h2IrJKGuT3RopmURwYgEuMwyNQcFoKEzzk
	 anJq/2+0YvPhXKaQ526/vShM0w2LtrDHPk6wsd5sAyFHiyZqD+NSr2TuMfeV0NGoYQ
	 9KRQTA7BzpSuA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 55B0F63BD4C3; Sat, 18 Apr 2026 20:47:16 -0400 (EDT)
Date: Sat, 18 Apr 2026 20:47:16 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH 0/3] Data in direntry (dirdata) feature
Message-ID: <20260419004716.GB58909@macsyma-wired.lan>
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
 <20260418214359.GA58909@macsyma-wired.lan>
 <CA+rD4x8uk7h7dv_Mg1tMXXiVZZD1YAj5WAw+6GNuMKQAAMueuQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rD4x8uk7h7dv_Mg1tMXXiVZZD1YAj5WAw+6GNuMKQAAMueuQ@mail.gmail.com>

On Sat, Apr 18, 2026 at 11:24:32PM +0100, Artem Blagodarenko wrote:
> There is now a way to set dirdata. Following the decisions from [1]
> the patches provided change how the encryption + casefold
> hash is stored. If the dirdata feature is enabled,
> the hash is stored as dirdata. Therefore, to test dirdata, it is
> sufficient to test the combination of encryption + casefold + dirdata.

I'm not seeing that in the patches that was sent out to the list last
week.  Where is that?

I traced all of the places where ext4_insert_dentry_data() and
ext4_dirdata_set() and I don't see *anything* where dirdata was
stored, including the fscrypt + casefold hash.   What am I missing?

It *really* would be a good idea if the e2fsprogs patches included a
way to list and set the dirdata using debugfs.  That way we could
easily verify that dirdata field was getting set when you expected it
to be.

> ext4/064: encryption + casefold (WITHOUT dirdata)
> 
> This test verifies that files created in directories with both
> encryption and case-insensitive (casefold) attributes work correctly.

Yes, but that doesn't actually verify that the dirdata field was set
when you expected it to be.  Just that it works correctly....

> LUFID is an optimization that allows Lustre to store file identifiers
> efficiently directly in directory entries, avoiding additional I/O
> operations to look them up separately.

Oh, I see.  So this is for readdir(), right?

> I am open to adding mechanisms to access LUFID outside the Lustre
> filesystem. However, since: 1) dirdata is tested using the encryption +
> casefold features, and LUFID is primarily useful within the Lustre filesystem
> and is already tested there, I would prefer to rely on testing LUFID
> within Lustre FS.

Well, the one advantage of having a way to set and get LUFID would be
if you ever wanted to ressurrect the userspace Lustre server[1].  :-)

[1]  https://wiki.lustre.org/images/5/56/LUG08-Lustre-uOSS.pdf

And I *do* think it would be useful to have a way to set and get the
LUFID using debugfs.

Cheers,

						- Ted
