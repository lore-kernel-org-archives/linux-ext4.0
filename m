Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288001F131A
	for <linux-ext4@vger.kernel.org>; Sun, 26 Apr 2026 03:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777173834; cv=none; b=EdogDy0J+MeQuz+reCEGtumynEZ8Z7GejBdnPigov5gB4SDFK73+H+6q+idy0guZpic9JFx9ILUiMTEevVIBj/IJx8r8isk7jdg3zvD8huhZTZg1oOZYpsMP7zb7pHweTjJPoYH8YMd4pIpsrqEmK4foRt8ue5wDom9J10Yjkq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777173834; c=relaxed/simple;
	bh=NRFid82dWokUSPLZ8KSVrjNlQbWo7C/PGljHTP1hiyQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmOxA/lMoe9sjduFIxkwE0/hEjP35hGd7UFtEGll8Mtfz7nsu7t2n8SW+rHzRQDNMPQKcLPB4U6qDQBwkh+P8aE8/pXk6cZokC5jEwXPJqQDsKSuksGp7cHcyKbuY159bzAVFnM9RMEnqbGBNbcAIpgy24TeIevVhwURzd0MJlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=guv8muH4; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="guv8muH4"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63Q3NBEx008166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 25 Apr 2026 23:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777173797; bh=fc0JrjbtsDTG8b4nKaSZjvS3aKP0at0JO5qol57LFIE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=guv8muH4bMR5Wn4mqK8e/2DvvSH6xfPRnFhSJZE1Rv+tSAB51tgKYC/rLkNE5EQ4Z
	 mir6AAbNEaSuWTgMClFWc9Z+Nx9c64Q2vLouVEhhi4dbr9d7XsUpfpPhtqW8PLxKxo
	 CkTGnB9Tdc9mJ4nPH3/no2IHJrR8mnCVir+DGh+hUbiMocLHXknVXOVbA/+ntzVtdY
	 cKTBcALJtcg7051rF/MjvGGo2vlC5s9SIuRwAFz0+sSZgLHQk9++J8MGTr0bP20iIn
	 Bt8M6agpQdi3yyqgQaK0LL+GZrdZ7FbdCTg2ksgLMRn+XQ4IZDaBxQMq+mvqG7pEHe
	 Px+laUoRXJgSQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 70FC4651AA86; Sat, 25 Apr 2026 23:22:11 -0400 (EDT)
Date: Sat, 25 Apr 2026 23:22:11 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Zw Tang <shicenci@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] ext4: BUG_ON in ext4_write_inline_data
 (fs/ext4/inline.c:240)
Message-ID: <20260426032211.GD22489@macsyma-wired.lan>
References: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
 <20260421122059.GA86221@macsyma.local>
 <4e76eb68-862d-4b9f-8242-e6aced2704ee@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e76eb68-862d-4b9f-8242-e6aced2704ee@gmail.com>

On Sat, Apr 25, 2026 at 02:00:23PM -0400, Demi Marie Obenour wrote:
> 
> Changing block devices that are mounted is also reachable via USB.
> Yes, some distros may disable automount, but users who have stuff to
> get done will mount USB devices anyway.  Telling users "don't do this"
> very rarely works in practice.

How can an unprivileged user change the contents of a USB device while
it is mounted?

Are you positing evil USB devices that can return block contents A at
time t, and block contents B at time t+1?

The threat model that we are using is that if the USB device is set to
a particular state *before* the file system is mounted, and then the
KGB scatters the USB device in the parking lot, and then someone picks
up the USB device in the Raytheon parking lot, and says, "hey, free
hardware", takes it into the classified machinem room, inserts it into
the server, and mounts it.  This might be considered likely or not
likely, but speaking as someone who has been in a top secret machine
room at a defense contractor, they were *way* less protected than what
I've seen at a financial services company, or at a data center at a
hyperscaler.

But be that as it may, even *then* you're not modifying the block
device while it is mounted.

> 2. Harden the kernel filesystem drivers against malicious devices,
>    including TOCTOU.

Malicious devices that have their own microcomputer and can change the
block contents under the control of the attacker is *just* not
something I care about.  I also don't think it's a particularly
realistic threat model.

Cheers,

						- Ted
