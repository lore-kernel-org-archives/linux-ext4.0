Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFC62D23A6
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2026 00:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790124479; cv=none; b=rffTwrTNPfLVwanAiTgk7nNKY0vtd3kzMqNpzkhE8R+6HGNYhWyndOu3eiU3IEMcYlGSUd+txBo+1po6C6YcEXZ+vOke/QwW8/gQY53WfPYGJaRmxiswLV6/v/m0kEtn6qEO0QebAtyYqDv6dgApP6fGfoDQlbhAmr82F5WbM1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790124479; c=relaxed/simple;
	bh=BzSWCKBjbZYdJXg7nx2wi8oi9VVl1Aeyy2vxP0gRcqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rs7LzUHCorCGA0LnAeKXcQYZS1Ov5YftB3zV1ieTiBRrEOAXqiqU8YNT0ACELtXgyMYN6bb6NYaUxuICxCYxW0dilWSuNB9RHC6MK9cM3xDSlLVVWDYyXJxQvfFuomprxuu7quWI1NKm2yo9ly/LGe7cAP+L3DCbcoUcHr5Td24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=NkANFFcK; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="NkANFFcK"
Received: from macsyma.thunk.org (pool-108-26-156-67.bstnma.fios.verizon.net [108.26.156.67])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 68N0loNt022625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Sep 2026 20:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1790124472; bh=1YDPyZZBqmiNYzHoL1DVcVHnOART80rV2GL+wbjf/qE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=NkANFFcKJLW5R1Psf81d+3l+egWdEgmD5B819friItIjF2RDVq+Mx+c8JiD7knIV/
	 geUUXGR1iv3k/a13Q2C4pw4mpOJkPDMLb0H3c1mvALg9CI/DgsFo69E6chKrTq41zW
	 jkgyp2/N4GU+eMXdfeGM18hvlBqfXwCuQzN6SVE7R9gvOqKI7PfglsI6Mqar4IvfLV
	 92KTtvX/ZrSNn5pgI5iXhU4IpMLHs03PPnoz/SAe99TS6Z+FmVrPa5tVBtXrS87xls
	 HBWrAXdCbtQFRqzMT0PFzI+7QJlpiqVjCP0Lvl7ZVFiG/5chsuaDtx94bbVOOZk7rm
	 639DbTSDbhzXg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 892261CA7F6C; Tue, 22 Sep 2026 20:46:50 -0400 (EDT)
Date: Tue, 22 Sep 2026 20:46:50 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [GIT PULL 2/4] fuse4fs: run servers as a contained service
Message-ID: <arL6faQ3Nq8MJHvg@mit.edu>
References: <178919524467.1033422.11195342952336631864.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178919524467.1033422.11195342952336631864.stg-ugh@frogsfrogsfrogs>

On Fri, Sep 11, 2026 at 11:41:59PM -0500, Darrick J. Wong wrote:
> libext2fs: fix MMP code to work with unixfd IO manager

So a quick comment about this:

       * It's also broken if the unixfd IO manager was passed a string with a
       * file descriptor number instead of a /dev/fd/XX path, but the
       * internet thinks there are no users of the manager outside of Google.

Specifically, it's not Google, it's "Android", and it's used for a
similar reason as unprivileged containerized use case --- namely
security.  In the case of Android, a volume server daemon passes the
file descriptor over a unix domain socket so that the fsck can be run
on the file system without giving it wider access to the system.  The
difference is that Android didn't care about MMP, so they never tested
or cared about that particular corner case.

Honestly, MMP only really makes sense when you have specialized
hardware where the storage device can be simultaneously connected to
two host servers, and you want to do block device level failover
between devices.  This doesn't really make sense for Android or for
the containerized fuse service, so _not_ supporting it for FUSE (or
Android) is a perfectly valid choice.

Even in the software defined block device world for Cloud VM's, you
generally don't need it because this can be handled at the control
plane level.  For example, Google Cloud's Persistent Disk has an I/O
fencing feature where if one of the VM loses network connectivity, you
can do a forced failover where the backup VM can "take over" the cloud
disk, and the previous VM that had exclusive writer access will have
its access cut off before the secondary VM gains exclusive write
access to the disk.  If you have this, you don't need MMP.

Cheers,

						- Ted
						

