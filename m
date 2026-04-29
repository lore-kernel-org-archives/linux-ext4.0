Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A271482E8
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2026 04:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777437728; cv=none; b=btcUzG4Kn+6Zve6WhoJJLf8GOJm0wsgFGzwFHO8HOg4Q7Mas/cPuvRzpCRJZA4AAyjTjNQZgsSonI6MhDiBqGHsHFFzsAHWwYi0UHpaP0Llmkt9PwqYmQ2rpH336GAO+VZBdkH7vfHlyWemWp0yUs+T7ERAiwd2wQZOyr/sYF/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777437728; c=relaxed/simple;
	bh=ZWPASXvuefS00LQPEYgReNyA3R2DqRyU66S98hUoA/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C14zr8Sv9FZPUZIKcW4c8O3uX27DMNtaqS08ZWSgvZL7YMPnKnpDGuXrtruyUqq4CiHuiBlZv/y+x+NSP9f1WiBFe6PgvGmLHbOLxCv8HzwfGMKuvgQU/sP3llI1WeKL1PUp0WWNH/tL2a6Or1M4tWVlLBHxR3HWVzweJegq/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=dl/KFO29; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dl/KFO29"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63T4fVZY023988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 00:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1777437694; bh=rmb3Wddw4bl9xAhDaHQ5l1psh+licpYKMv2IsFfPEpM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=dl/KFO29AESIwiotYC1CB5OPQpNpwsjbCtSFAidG9GGTdTAh3OdQaZv+uMjfDW/Cw
	 6hy4ispLqfqhvnIwrUG1qUiRhoDSVUU6TuD4agEex4aTxl3bgIK7xD0EMeE58gqvWW
	 qU0XAUL/TKERCCBPX/iVwO5ugynSx9Biaw9Xb4hsacgcX0iED9dyNoGLHGxsoghhFZ
	 7+l7KIZGGnw5D4nNBpd6PlkmWU44IYc2hbudlDJCgcPrSFf8+o+UdlXBisV7IWouvF
	 aNYEXMVsXRZDn7xTC2qFNHI0gmVPz1J+obkTX4CiYK3pDAa+OGKwUcMBPEzTIy74gE
	 lc/bgln4SW40A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 01C11656AE3A; Wed, 29 Apr 2026 00:40:30 -0400 (EDT)
Date: Wed, 29 Apr 2026 00:40:30 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Zw Tang <shicenci@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, syzkaller-bugs@googlegroups.com
Subject: Re: [BUG] ext4: BUG_ON in ext4_write_inline_data
 (fs/ext4/inline.c:240)
Message-ID: <20260429044030.GB16497@macsyma-wired.lan>
References: <CAPHJ_VJeBAL_fk+P79guYTABZgW1hkcAz8t=c_nVK1mbn3_FYw@mail.gmail.com>
 <20260421122059.GA86221@macsyma.local>
 <4e76eb68-862d-4b9f-8242-e6aced2704ee@gmail.com>
 <20260426032211.GD22489@macsyma-wired.lan>
 <5981069b-8c54-4b5b-a808-5ebdc8cd7265@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5981069b-8c54-4b5b-a808-5ebdc8cd7265@gmail.com>

On Tue, Apr 28, 2026 at 04:50:14PM -0400, Demi Marie Obenour wrote:
> This is an example of a BadUSB attack, which has been known since
> at least 2014.  USB sticks *do* have their own microcontrollers to
> run their firmware.  At least in the past this firmware has been
> programmable and not been digitally signed.  This means that the USB
> stick *can* be reprogrammed to perform a TOCTOU attack on a filesystem,
> or indeed to implement a completely different kind of USB device.

Honestly, if that's what you are worried about, then best solution is
put epoxy in every single USB port.  I've since financial institutions
that have done precisely this, and both Android and Chrome OS supports
enterprise security policies which does the equivalent in software.

> Protecting against replay attacks requires a Merkle tree.  The only
> Linux filesystems that I know have one are ZFS, bcachefs, and BTRFS.
> The first two are out of tree and the third is not shipped in RHEL
> at least.

FYI, there was a patch for btrfs, but it was never landed.  It's
unclear how many people would be willing to pay the performance tax of
using hmac-sha256 for every single data and metadata block write.   

> Of course, you are free to choose which (if any) of these attacks you
> care about.  One can that USB sticks should be mounted in userspace,
> UEFI secure boot with Microsoft keys is irrelevant as long as
> administrator -> kernel isn't a security boundary on Windows, and that
> confidential computing only makes sense for stateless workloads (which
> can use dm-verity) until there is a way to trust storage devices.
> But it's always best to be aware that an attack vector exists,
> whether or not one chooses to address it.

Sure, but a drive-by comment on a patch review advocating that we slow
down ext4 to protect a single instance where the attacker has
read/write access to a mounted block device, when the file system
doesn't have generalized protections against that whole class of
attacks.... isn't particularly helpful.

By the way, I'm not aware of *any* company that has been interested in
funding work to protect against this class of attacks.  Given that
most file system developers prefer food with their meals, and have
enough *other* unfunded mandates from our user community, it doesn't
seem likely that we're going to see much forward progress towards your
desires/interests.

Cheers,

					- Ted
