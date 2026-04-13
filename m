Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7B03914E7
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2026 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776113012; cv=none; b=ThHKqShUzAX9pp8F51CQnQYhjSOjZcjgmJ+e6JnSYl0tBXv/Y0xU8uTpupjCmLSqOy7EjXgAhZw3raFjXEpcsYX6YMQo70tVrgIhu/0cLTD7WssOFSmuGxnmZxUUPVpqSlS0Oyqpn1+lXqdMVcRmZVlKRicZt0vS3sysVxHm5uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776113012; c=relaxed/simple;
	bh=uZcmzkJFa5zObKfH5LXJV0mjcX+nWGV3DEn2mQoaujY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQdmhUmY4squVslTU1fBddtRqPw6W5msdaIreyszmXeELto/n8Blg9ns4BEPy+83KTyA5LAJewp9peyHebutdcgHmGPfmkx+rfybOtX04OVEJ8oanTixNpUChGRS4h5vYsWaBLNc/c5/aWripwhf6xi5BJCcFt+dUzu2Ja6Wyqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=qL+YC4bt; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="qL+YC4bt"
Received: from macsyma.thunk.org (pool-173-48-113-10.bstnma.fios.verizon.net [173.48.113.10])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63DKhFmh012509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 16:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776112998; bh=kifoyW2lq7RHaGaO4R95aZfysQx3/2dvEk+WJgCCYcQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=qL+YC4btkch8yv1WzIyM+SNrD7urFrM9HBmmx55a8Ok1+f8YMn4Fj8TxQQT7QB9Ee
	 FC66003NdzJ5qlvVSOkDqr7kq/CMpppJv8HoXl4iog/ktaGeNUb8XocEh57wnqjeOL
	 jnIDpwXKAGpjuooeXUhmw52ABY0l9H61it/k/eFeq7cf7cfpkDns7iiF/mozBlkrTh
	 FKA3/5DFYTw2/IX6Q1ltDL2px+fPLk48m0G51KX4mTeuQVR1yoskAOJwDLTjvzTvKo
	 CEHCCrBU2UBJrPVRX9stTqeJ5W4OtnGfWZY4yoUX9MwAU//1H6ylg7HqEJLclig5uY
	 vhaSJg8lEmu4A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 5809762E39D5; Mon, 13 Apr 2026 16:42:15 -0400 (EDT)
Date: Mon, 13 Apr 2026 16:42:15 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
        fstests@vger.kernel.org, fdmanana@suse.com, ritesh.list@gmail.com,
        naohiro.aota@wdc.com, wqu@suse.com, Disha Goel <disgoel@linux.ibm.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 4/6] generic/765: Ignore mkfs warning
Message-ID: <20260413204215.GA5461@macsyma-wired.lan>
References: <cover.1775802601.git.ojaswin@linux.ibm.com>
 <afee4fedcc9b3685df0e05800d82b88d27f977f8.1775802601.git.ojaswin@linux.ibm.com>
 <20260410165435.GU6212@frogsfrogsfrogs>
 <advRgjl1tG4PMc6V@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <adyxi7156VAbL-G1@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <20260413162120.GV6212@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413162120.GV6212@frogsfrogsfrogs>

> > > > > The output can get corrupted with warnings like below because clustersize
> > > > > more than 16xbs is experimental:
> > > > > 
> > > > > + 16 times the block size is considered experimental
> > > > > 
> > > > > Hence pipe these to seqres.full to avoid false negatives.

You could also suppress the warnings using the -q option, for example:

mke2fs -Fq -t ext4 -O bigalloc,quota -b 4096 -C 131072 /tmp/foo.img 4G

> > Futher, mke2fs has multiple instances where we print warnings to stderr,
> > should we go and fix all of them as well?
> 
> "stderr" meaning "standard error", I'd say that errors are anything that
> prohibits the format from completing, and only errors should go there.

Sure, I'll accept those changes.  But adding -q will allow the test to
pass using older versions of e2fsprogs, while still allowing stderr to
go out the expected output.

					- Ted
