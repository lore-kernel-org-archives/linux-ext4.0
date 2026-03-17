Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1623E1227
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756061; cv=none; b=RKmR4OYbM/7ngJytuJYx5313mDfzJkfpwUtUKYSFXU0fReZEeBuy+WmNCpNl1Qs2dMNSihD+O6AY0KDdNYNCxD/X86MuuU27BT/NRp8dibYTzVfNM4sFT4n0+54doYfjCQ2B9toFxX/LGtQxiR8mx5E21uQWtiy0zX0OeYsw29s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756061; c=relaxed/simple;
	bh=yhVL8QDOI/FFbAizMBorJLYfRMwc296FoGjhH73QP+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlCJ4KnELPpUVC/iKAHrew3V0v2Jwt/v7hhWofifLRE4wW4dkdsv8tMJYa49s3d+2EtMSvT/NcSSSDLASJhbh0OQO2vTf1zksA7YAPQtdiLLRozjINGFX52pMyq6ea8v+azLhzpVwcp75ghK9VK5zr0OVkE/bCLjhsCytedOHxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=O34gw2CD; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="O34gw2CD"
Received: from macsyma.thunk.org (pool-173-48-82-106.bstnma.fios.verizon.net [173.48.82.106])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62HE0LqH014273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Mar 2026 10:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773756024; bh=jPZ0GRsGQixJN9OLjYc4HU0xw7QwN6o0ICegT4jM4tY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=O34gw2CDG6Aq8qdbIztYiRALOaD9uCRKP5dsXsPYHK4XVrGQmgHOlfWyZtSbu47ey
	 KrLGXP90Qn08vmXLIMMxXbM53lJfDNvNVj235c+VO01+AhkUiA/jSFRI1pNoVHjjlF
	 Y298YkZoli+zUKeYawj6ipHekqbspsPx1DITHDS69eG4M3g8NlG65Nnq2BnMKBTb3R
	 sphgeUtuXI5AZ8tCys+Bw7YLAJkK4e+si4utiqTMEzliRvacuYZCNk+GhZzaC0sWed
	 abLMeBD32p2JBl+s2PcPA5Z553v+YaG+NPOHw86M2e3vPY2MHpzIm07Js3YwSP864j
	 KqhYo0Y4dIE1Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 1A7CC5DF7D85; Tue, 17 Mar 2026 09:59:21 -0400 (EDT)
Date: Tue, 17 Mar 2026 09:59:21 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
        Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, John@groves.net
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
Message-ID: <20260317135921.GB53921@macsyma-wired.lan>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
 <20260316234137.GJ1742010@frogsfrogsfrogs>
 <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>

On Mon, Mar 16, 2026 at 08:20:29PM -0400, Demi Marie Obenour wrote:
> 
> It's worth noting that on ChromeOS and Android, the only trusted
> disk images are those that are read-only and protected by dm-verity.
> *Every* writable image is considered untrusted.

So I can't speak for ChromeOS or Android, but given discussions that
I've had with folks in those teams when we were developing fscrypt and
fsverity, the writeable images which are soldered onto the mainboard,
where user data is stored, is protected by fscrypt, which provide
confidentiality but not integrity for user data.

However, from a trust perspective, if there is an "evil maid attack"
(where someone leaves their device unattended in a hotel room, and the
housecleaning staff removes the device, and the flash is removed from
the mainboard and modified) is something which is considered an attack
which is realistically only going to be carried out by a nation state,
and the primary priority was protecting the privileged APK's (the
moral equivalent of setuid binaries), and that's where fsverity is
used to protect against that threat.

Yes, the nation state attacker could potentially corrupt the metadata
of the writeable file system image, and but there are enough zero day
attacks that involve sending corrupted image files that trigger buffer
overflows, etc., that while it would be nice to protect against this
sort of thing, given that it requires a physical attack (and that
point, the nation state attacker could also enhance the device with
remotely denotated explosives, something which spies on the
touchscreen or microphone and ships the output over the network,
etc.), I don't believe this is considered a high priority threat that
is worth spending $$$ to mitigate.

The only other extrenal image, which is where something like using
fuse would be interesting, is a USB thumb drive being connected to the
ChromeOS or Android device.  In that case, performance is really not
an issue, so running fsck before mounting would probably be considered
acceptable.  The main issue here is that fsck for NTFS, FAT, etc.,
probably isn't as good as the fsck for a file systems such as xfs or
ext4.  So the primary protection that we have is that enterprise
managed devices can simply prohibit mounting external USB thumb drives
if the enterprise administrators elects to do so.  This doesn't help
personal devices, but users have to take affirmative action to mount a
device (simply inserting a device isn't enough, at least on Android),
so people who are paranoid can simply not pick up a USB thumb drive
they find in a parking lot and insert it into their phone.

Cheers,

						- Ted
					
