Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95D82EB87F
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775241344; cv=none; b=flpT4q/fN3P/2b1Qj3Z5K1Y0p+mpWQmgGyfSmyIUW0I/XUeGEUR85Jx1KNFI04Y17gO8L3mjVStwXyq3Z4kemh5IcFwIb1BZ9maTgkoi8Ry3AGa/fMg+5Rx6+DpGDqdhJKv2wXdk1+9uhopqhLwUjEVF37WTlC6sGf1hV45kWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775241344; c=relaxed/simple;
	bh=mA7n4/gM/3rmt6RYYMWwttUjU1VTXMM6uf83vdJXUic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epU/OvNUD2lP+MF42BW83ih7iOUnD1x+MA6Kkl3AdcvQx2zKUWGrd7qWImwJ+ABwY7p4xqMc4huYI561rkR94obWfEIbWislFiFt/YxR8+TmfJ+hr4317HqKj3efDt5l7QbxvCjap/UiGjJ48Gt4MvgKV7V5CJWxaCcIYB5HzJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=RM/jCU6i; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="RM/jCU6i"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633IZSOa022582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 14:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775241330; bh=hkAyVNMKWJCYCNPdK+9TH4rbhYJEWDZcnLgJolW8zVU=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=RM/jCU6iYcjry1to8AX+gloakCy1jAXbT0DuFWiIK43XR6M+skqht+poS/L6OqDvL
	 MLGjNJu9Q1yMtKVKfczKn9jmmvHZz74/t2Pet+ccnVf8lPLxctG3CjA+GkuedmFzAT
	 44mLG0Qx+8qbuwoSDkx/a8xBpLR1pdLUBrLbNATBJpA30G/7WHS1o1pQX1WCGOCxp0
	 +P5SDh+O6vv/eKDVW2KUNBUSvM13yKRV039OmCKnPPMkws1gVW7giAwvh4Mgjd1toc
	 oJhq7YSHCG4xB5JU+PLNghT45AjUxJeBUx5+PhTJqmV8/sE+nHeOhcvPDuQc7VpU+g
	 BxY+/1mUKHiBQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CB8B561096CF; Fri,  3 Apr 2026 14:34:27 -0400 (EDT)
Date: Fri, 3 Apr 2026 14:34:27 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: 4fqr <4fqr@proton.me>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [SECURITY] e2fsprogs =?utf-8?Q?v1=2E47?=
 =?utf-8?Q?=2E4_Vulnerabilities_=E2=80=94?= Orphan File & Extent Handling
Message-ID: <20260403183427.GB16311@macsyma-wired.lan>
References: <DJq7WqGAG9HBnpd-DVD5sVNGDUoSoP2sJ5RAXlucoYhtbqxJXFNUUfhFETwaDeDr6Q8a5xp0hVJb0yIt8EucI-F-PQ28zg8i0Y9HmF8qk5Q=@proton.me>
 <0778B5AC-16ED-4736-AE64-849541629466@dilger.ca>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0778B5AC-16ED-4736-AE64-849541629466@dilger.ca>

On Fri, Apr 03, 2026 at 10:17:38AM -0600, Andreas Dilger wrote:
> 
> I don't see how this exposes any kind of security vulnerability if it
> requires that the image be specially modified in the first place?
> At that point the "attacker" can directly modify the image in any way
> they want, regardless of how e2fsprogs behaves.

We can debate whther or not it is a security vulnerability, and if so,
whether it deserves a CVSS corresponding to a low, medium, or high
severity since that's what people who are worrying about FEDRAMP
compliance need to worry about in terms of time to mitigation.

The reason why it's of interest is because we tell people that if they
have a potentially untrustwothy file system image (say, they if they
pick up a USB stick that was thoughtfully dropped off in the parking
lot by the Chinese MSS or Russian KGB agent), they should run e2fsck
on said file system image before they try mounting it.  Asking them to
run e2fsck on the image is only a little bit more likely to work than
telling them to just not pick up the USB stick, or DESTROY IT BY FIRE,
and so the reality is that 99% of all uesrs will just mount the file
system without running fsck --- at which point, when their system is
compromised, we call it a "problem exists between chair and keyboard"
situation.


I don't really care whether we call it a security bug, or a quality of
implementation bug, but that's because I'm not the person responsible
for FEDRAMP compliance at $WORK, and I'm not someone who hands out bug
bounties, or who is trying to keep score of how many security
vulnerabilities that I found in order to demonstrate real world impact
as part of an academic tenure-track evaluation.  :-)

As far as I'm concerned, if e2fsck doesn't (a) detect a file system
corruption, or (b) doesn't fix it after a single e2fsck -y run, or
(c) crashes or results in running a malicious payload as a result of a
specially crafted payload, it's a bug, and bugs should get fixed.

Cheers,

					- Ted
