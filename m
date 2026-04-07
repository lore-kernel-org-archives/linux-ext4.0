Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4942140DFDD
	for <linux-ext4@vger.kernel.org>; Tue,  7 Apr 2026 07:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775548010; cv=none; b=X/j3JGlSbcEjS9c9sXBDhrv/f/B7dLJBbsjA5rLz34I1BNV3IzgIBuXSWDtOx8oHz+LB3AEzns+yGiJ/Fw5BPI7T3aJraY/l6u5v1dtqPJE+A2Kk/IfpMzL8gl/ocSvgSq/D0RrNXitLW26bcMVPO4yGSdgu7ujayx1vDcpSfIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775548010; c=relaxed/simple;
	bh=KFgVBXnry845PIfnPOlMc2sOdr2esbGzBoYCdYbITQk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TTySzBaoprnfAcl69mm5QAuXysGtvhn3DNluX1N6Frc2Mx2GlII7IQAM0DzbwFdnHm+iws4c05GRKdlC46Lht2l7ZZXGWUywqLgSfKhQc8yI57gQIWDM/k4zsJ9Wfd35w0wePJbIek7pOkXGF677lg3VypgLmOgE1MJCZoP4zWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=hCWeZn1l; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="hCWeZn1l"
Received: from monopod.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTPSA id BA1E2413A4DB;
	Tue,  7 Apr 2026 07:46:38 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru BA1E2413A4DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1775547998;
	bh=bQZPCYlOfJcFjumDRLe69FbwpFNDOhE7/hkelOkN/mU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=hCWeZn1lkGbqpo7I/8+l59QmoD0gVtWG/BNQfkdmHO4LFU7H4lEjBvNMadRQ0OYqq
	 GYxzDDP2qEZZkkjWmv0G1eWKHMjP5iOectskPUgqOefNX5C1mpxg7m6tKVs2dpGS/W
	 b5IQRzLitt6QkWu2SiuS35iZWerDc3ZLmhAn1808=
Date: Tue, 7 Apr 2026 10:46:35 +0300 (MSK)
From: Alexander Monakov <amonakov@ispras.ru>
To: linux-ext4@vger.kernel.org
cc: Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [BUG] lseek in sparse files broken on ext3 mounted as ext4
In-Reply-To: <594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru>
Message-ID: <77ea1a0c-6924-a9a5-4851-9d7ad9a52e32@ispras.ru>
References: <594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sat, 28 Mar 2026, Alexander Monakov wrote:

> Hi!
> 
> Mounting ext3 with '-o delalloc' is explicitly rejected by the kernel
> ("EXT4-fs: Mount option(s) incompatible with ext3" in dmesg).
> 
> At the same time, mounting ext3 with '-t ext4' is accepted, and enables
> delayed allocation. In this case, lseek with SEEK_DATA/SEEK_HOLE requests
> does not work correctly and breaks userspace programs such as install(1)
> from coreutils.
> 
> To reproduce, it is sufficient to prepare an ext3 image as usual and mount it
> as ext4:
> 
> truncate -s 1G img-ext3
> mkfs.ext3 img-ext3
> mkdir mnt-ext3
> mount -t ext4 img-ext3 mnt-ext3
> 
> and run the following repro script:
> 
> #!/bin/sh
> echo | dd of=src bs=1 count=1 seek=64K
> strace -v -o install.strace install src dst
> cmp src dst
> 
> the output should be
> 
> src dst differ: char 65537, line 1
> 
> with
> 
> lseek(3, 0, SEEK_DATA)                  = -1 ENXIO
> 
> in install.strace on the first lseek call, meaning that it reports
> "no more data until EOF" (and hence install does not copy anything).
> 
> Either mounting with '-o nodelalloc' or fdatasync'ing the file before install
> (conv=fdatasync in dd or 'sync -d src' after dd) avoids the problem.
> 
> The old ext4 wiki [1], the KernelNewbies wiki [2], and the Arch wiki [3]
> all claim that mounting ext3 as ext4 is expected to work correctly.
> 
> [1] https://archive.kernel.org/oldwiki/ext4.wiki.kernel.org/index.php/UpgradeToExt4.html
> [2] https://kernelnewbies.org/Ext4
> [3] https://wiki.archlinux.org/title/Ext4

I would like to ping this, and take this chance to cc Zhang Yi: it seems you
have experience in this area, do you have some ideas what is happening here?
How does delayed allocation interact with lseek like that?

I think it would be nice to solve this problem, because it is just silent
data corruption (no sign in dmesg of anything going wrong) in a setup that
was claimed to be safe by ext4 wiki (and propagated elsewhere).

Downstream this was discovered in Gentoo bug 970253 (I'm not the affected user,
I assisted with root-causing the bug): https://bugs.gentoo.org/970253

Thanks.
Alexander
