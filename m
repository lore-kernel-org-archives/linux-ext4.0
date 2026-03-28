Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954521C862F
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774715111; cv=none; b=SuMNo4ye9/7UOs23j9Iu2KwNK4B8Z0JP2he6cPTWysSow/y9ZtCdmWXDJquPkYTictAetRknYgYjaG1FaiGDXpYgUNL1Oe+EaXMefQMta8RJgVUlNF+ayglNLXZVZlisUJKeJ5NQO0RatMHNdoFDC8WECxdaJEZNkyR8bSUhhz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774715111; c=relaxed/simple;
	bh=Cgr4qVPvc1+sB5NVL6ExnzprDjsT58rFwaokxGU1a1E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=oEfb8Bf5pXYaQn1hcrc9BAdo80m8CIIG7h9en/G0MrZ0m+0b9ZhSCyO0ab1i3ehc8XRbYc9mQhnYO6K3IJPLrzF0qlYK4Vu8vWL/Mef7pp/nxYTFgbW5321vtktRDR1G9xNHfyYGivKhyUqozH2Lm8ccVMJqrPA3G9oi0PWKYNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=qmt9vXZ4; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="qmt9vXZ4"
Received: from monopod.intra.ispras.ru (unknown [10.10.3.121])
	by mail.ispras.ru (Postfix) with ESMTPSA id F14C94077955
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 16:24:58 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru F14C94077955
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1774715099;
	bh=yT44FslkrfeYH40bqjisscUDc2r/9qDHQvVKxe5gBNw=;
	h=Date:From:To:Subject:From;
	b=qmt9vXZ448o9ESW0KtsjbJIV15zVCCylkQR1BsdMYETKGuVC6uW9ZPylWItlEz/eI
	 KWdJ1x6xnsGauSLumu3yRW1ptfcFNxc6j5Lzv2PFA2OZQpRMCbAcFp/tIQVrIxH3pf
	 yZvG8wVwe1lulwPvLLeRN9uTVNFKMZyo8bqgXKus=
Date: Sat, 28 Mar 2026 19:24:56 +0300 (MSK)
From: Alexander Monakov <amonakov@ispras.ru>
To: linux-ext4@vger.kernel.org
Subject: [BUG] lseek in sparse files broken on ext3 mounted as ext4
Message-ID: <594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi!

Mounting ext3 with '-o delalloc' is explicitly rejected by the kernel
("EXT4-fs: Mount option(s) incompatible with ext3" in dmesg).

At the same time, mounting ext3 with '-t ext4' is accepted, and enables
delayed allocation. In this case, lseek with SEEK_DATA/SEEK_HOLE requests
does not work correctly and breaks userspace programs such as install(1)
from coreutils.

To reproduce, it is sufficient to prepare an ext3 image as usual and mount it
as ext4:

truncate -s 1G img-ext3
mkfs.ext3 img-ext3
mkdir mnt-ext3
mount -t ext4 img-ext3 mnt-ext3

and run the following repro script:

#!/bin/sh
echo | dd of=src bs=1 count=1 seek=64K
strace -v -o install.strace install src dst
cmp src dst

the output should be

src dst differ: char 65537, line 1

with

lseek(3, 0, SEEK_DATA)                  = -1 ENXIO

in install.strace on the first lseek call, meaning that it reports
"no more data until EOF" (and hence install does not copy anything).

Either mounting with '-o nodelalloc' or fdatasync'ing the file before install
(conv=fdatasync in dd or 'sync -d src' after dd) avoids the problem.

The old ext4 wiki [1], the KernelNewbies wiki [2], and the Arch wiki [3]
all claim that mounting ext3 as ext4 is expected to work correctly.

[1] https://archive.kernel.org/oldwiki/ext4.wiki.kernel.org/index.php/UpgradeToExt4.html
[2] https://kernelnewbies.org/Ext4
[3] https://wiki.archlinux.org/title/Ext4

Thanks.
Alexander
