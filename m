Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54B22E889C
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775224218; cv=none; b=Uw+8YvxYOGRwdt/+XWG1/KO1TScpPAIGIfsN5FInDjqyrytU2s2xJBU3yLEP0LNALFUM2uAz1IxbY499q4RTcMlj7x5STKYq+P6Z+BfIpze4BS9te9gfugogelGwGNqQ/CS2hOdiy31mBZ6Oko2FGCM0M99d5uaZ1UvgUUjEUG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775224218; c=relaxed/simple;
	bh=KM82XPyhwQSvWzfe3ry+IsLm3lctzv9eE9LE6M/XEUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X461zG5Reb1nAJMXWONhYzsgi+2M1uROsqVWexwbChByEjqt24CdmJsJwk0IvQyYgh4EPk2bMigi6s3tOwEQKkAlNgLZ9RPN21lmoCCDk6K17U6PfGYG4tckbwJXDCIGJMi1XUWO7RhtIx8jA9gT93H0kzoLH65rU2ac5VMNd9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=T3LPeyfN; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="T3LPeyfN"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633DnqaB019633
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 09:49:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775224194; bh=ACY9Dd7YGqHjTQ+3FVbAepJcXW43VjGz7Vp/66VzHLk=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=T3LPeyfN2rZoFYJ3T4tEq+gnpxJJ2evbIe8+hD/AHosc7MbvR2zxA0/Es+FLnCobG
	 uAEseqiHqaTlfZOY4V7R6wnDAl2cdcZHmbmvmYrNs2JwIS8nee0yPwW80bEou9Yuba
	 lFkBylOf3xxnYHfw7gb4oLA9cfJh8KZMEyswMBO0/VSmsd6TZ3np1ozHj/CsgskijW
	 lOqYYbCq0cMDn7xwzAGDm0rzx2oEf8ZRpCrzFBZfWLuA15vVjIxm07fd8EHGp4gtm+
	 AZY88g2alBC/U5S8frZRuvZGoPUi7tZBuUc1Mmt5flgb4cjvCW1HGtsYULs0CaAEeo
	 GdM/r1fN5aRjA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 57BCE6103EC9; Fri,  3 Apr 2026 09:48:52 -0400 (EDT)
Date: Fri, 3 Apr 2026 09:48:52 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: 4fqr <4fqr@proton.me>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [SECURITY] e2fsprogs =?utf-8?Q?v1=2E47?=
 =?utf-8?Q?=2E4_Vulnerabilities_=E2=80=94?= Orphan File & Extent Handling
Message-ID: <20260403134852.GE12260@macsyma-wired.lan>
References: <DJq7WqGAG9HBnpd-DVD5sVNGDUoSoP2sJ5RAXlucoYhtbqxJXFNUUfhFETwaDeDr6Q8a5xp0hVJb0yIt8EucI-F-PQ28zg8i0Y9HmF8qk5Q=@proton.me>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJq7WqGAG9HBnpd-DVD5sVNGDUoSoP2sJ5RAXlucoYhtbqxJXFNUUfhFETwaDeDr6Q8a5xp0hVJb0yIt8EucI-F-PQ28zg8i0Y9HmF8qk5Q=@proton.me>

On Fri, Apr 03, 2026 at 11:29:55AM +0000, 4fqr wrote:
> 
> I'm disclosing three security vulnerabilities in e2fsprogs v1.47.4
> affecting orphan file inode processing and extent tree
> validation. This follows responsible disclosure notification to the
> maintainer (Theodore Ts'o).

You notified me 45 seconds before sending this e-mail to linux-ext4,
which is a public mailing list.  (For future reference, essentially
all lists @vger.kernel.org are public, with the contents available at
https://lore.kernel.org.)

> Patches and coordination discussion will follow once the maintainer
> has reviewed.

Coordination discussion is moot at this point, because you've already
made your findings public.  I'll review them in detail in the next few
days, but it does appear that we are missing some checks in the
orphan_file handling, which whether or not they are exploitable by a
malicious attacker, are real bugs that should be fixed.

Cheers,

					- Ted
