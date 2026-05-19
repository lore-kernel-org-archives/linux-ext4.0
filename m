Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0083DB30C;
	Tue, 19 May 2026 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779229351; cv=none; b=WPnUgcQvlVTybTz7jeC5hWFupvpGcZJApbpsqtQuIb5XMo9k/u09Q9/0FebDeQLRtOljMULFcpFwW7kiW4xlFsSczIhZ94x3vFvo7KWKI0vPewK46U9oFCt+t2AW5r6zqNbx/UVGLV+6MM94ySPZ3J5+EsyIPQWZSi6Rst+kzqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779229351; c=relaxed/simple;
	bh=xYcDZk1WsDwMNBEI0IkX1AhTrdDgiZk9faTLWLXULhk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hOJK7wbFWLsf/GtNc6q2MVz84NAFofFceG4qM+g3HM1y03QYtnpo1QP3ayFNBECpyLMEbBx+InUth81qqzKDrAgnXJygM7zxZfHHgreHwvuyE0DtsnFduD6n0DjohIoN3e9Z7xCMAgtXIijiZHdv1gpjEJL+2r80lhhBG+BR4nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOnHRXmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOnHRXmd"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A2BF61F00893;
	Tue, 19 May 2026 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779229349;
	bh=UUjnk+fAt2LpePPYpdYfCvrYStDZPTXBjWLuLoxFuI4=;
	h=Date:From:To:Cc:Subject;
	b=nOnHRXmdIe3aZ6XL7qTbDwUZLn+5kITC3Bi1xf46SdPvIQCEbT64vCMtiDwTv8aaG
	 eScQCjVrmRdF0ttV/jasauS1B70qC5mqiRfJuWJnLu2J/YpHNXAnhUIS9an4ZDCe8k
	 G/La6orrEurvSKgDhBmZ6pg7V6X2oz54Sr5XZreRYisI3JWVXeEifYBie9zJa7w3Bu
	 0MBWGm7TDruRUKol1wevoiPpPeLBEDo8OcU1h03xIUZIYqj8mOX+Pz5wcESX5hek2/
	 Fk+giWsjXKwDgSlpMTrWUz28nU4YqRxWkCCHleBo0FFXVbshC1nVlzFNwr7ecqHgiT
	 qDExjUXBIEkfA==
Date: Tue, 19 May 2026 15:22:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>, Neal Gompa <neal@gompa.dev>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>, john@groves.net
Subject: [PATCHBOMB v9] fuse/libfuse/e2fsprogs: faster file IO for
 containerized ext4 servers
Message-ID: <20260519222229.GB9544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

This is the ninth public draft of a prototype to connect the Linux
fuse driver to fs-iomap for regular file IO operations to and from files
whose contents persist to locally attached storage devices.  With this
release, I show that it's possible to build a fuse server for a real
filesystem (ext4) that runs entirely in userspace yet maintains most of
its performance.

This effort is now separate from the one to run fuse servers in a
constrained environment via systemd.  Putting fuse servers in a
container gets you all the blast radii reduction advantages and provides
a pathway to removing less popular filesystem drivers to reduce
maintenance work in the kernel; now we want trade relaxation of that
isolation for better performance.

The fuse command plumbing is very simple -- the ->iomap_begin,
->iomap_end, and iomap ->ioend calls within iomap are turned into
upcalls to the fuse server via a trio of new fuse commands.  Pagecache
writeback is now a directio write.  The fuse server can upsert mappings
into the kernel for cached access (== zero upcalls for rereads and pure
overwrites!) and the iomap cache revalidation code works.

At this stage I still get about 95% of the kernel ext4 driver's
streaming directio performance on streaming IO, and 110% of its
streaming buffered IO performance.  Random buffered IO is about 85% as
fast as the kernel.  Random direct IO is about 80% as fast as the
kernel; see the cover letter for the fuse2fs iomap changes for more
details.  Unwritten extent conversions on random direct writes are
especially painful for fuse+iomap (~90% more overhead) due to upcall
overhead.  And that's with (now dynamic) debugging turned on!

This series has been rebased to 7.1-rc4 since the eighth RFC, with
the following kernel changes:

1. The BPF stuff has been replaced with a filesystem striping mechanism.
   This is my first attempt ever to implement raid0.

2. Much tightening of the validation code based on Codex reviews so that
   we don't expose more "ABI" than we feel like getting yelled at for
   in 2031.

3. Refactored iomap writeback mapping so that you can use the standard
   iomap_begin functions for that.

4. Better userspace helpers so that fuse server authors don't have to
   know quite so much detail of the innards.

5. The libfuse changes are based off the WIP fuse-service-container
   branch.

There are some questions remaining:

a. fuse2fs doesn't support the ext4 journal.  Urk.

b. I've dropped everything but the kernel patches for basic plumbing and
   file IO paths because frankly they weren't getting looked at.

c. How on earth am I going to separate out the file_operations?
   Will it actually work to say that fuse-iomap only supports local
   filesystems initially?  How many of the "is_iomap?" predicates are
   actually for local filesystems and not the IO path???

I would like to any part of this submission reviewed for 7.2 now that
this has been collecting comments and tweaks in non-rfc status for 6
months.

Kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-iomap-striping

libfuse:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/libfuse.git/log/?h=fuse-iomap-striping

e2fsprogs:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/e2fsprogs.git/log/?h=fuse4fs-memory-reclaim

fstests:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuse2fs

--Darrick
