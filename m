Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227F82F1FC7
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 03:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936399; cv=none; b=NHlfiR7uk3rRcv2/9DAbYjlRt73NzF5VYBqFszwITZo37frJLSdk9mTDOmKs0MQM1YHFoGX8cg1yCBsCkPxRetYyjcaLrqpQDuDgvmhrPH6TKPGHx1iP7uj9Zrlqxh49+SP7L50qnLRNrrRu9Ix7uJM7ZMz9Lujv6zr/qyNEUbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936399; c=relaxed/simple;
	bh=vPgOLuEPl911eD4jjwJgEIh92g6h/nsvF87rp4gsz04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MvkXNkrC4q/mOR5UZSTMHN0P4lscxZ4SBQnLokwyRyvqOjl5ugF5hp2CGy/iQvd2ECrQfCDhx76nmKpPqMlyHlY9T+mJPzttwXyvViorqWPGeFmp1Asb/nH78hluZE83kSo6Iwv/JV2xDzIBonGzFN9dbed0RQaQ1rQqCBoWGhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=AgGEmpaf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="AgGEmpaf"
Received: from macsyma.thunk.org (pool-173-48-113-153.bstnma.fios.verizon.net [173.48.113.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 67H3CXkg024202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Aug 2026 23:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1786936358; bh=9CxpuVTla2ZixjVmEhgzepEgOkxzTAB3CnDjO0WA3Sc=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=AgGEmpafGKEcWFrdSkKUw/CSik/VsRjhINxLmjyc+0JPc5LpWrltuxj+dnXDm3BVE
	 MdgXKoiqfddE3f+oBInUjQNzn7Obp5Y7N8cuT0JSzJR7PASIqanKeP5EafOndKoRah
	 ORWhkojSxMLDxz6Rvgvss71GKMpV3i2+hVPQ1z0t8IF76xoLYt40Vw0LdhDH+CLCGx
	 qhN1+ICT3tu0RI+xNLIFm1wz/lCy/JzNBjIPc1fXGeFTvei7jA/Dk5xe8YgclLJwj6
	 gVkT5Q0gp+gLcyXxlJAMXzd5ZjS3KVrNyf4ZoKbrqXlODvGRH8w4oxVgKpd9TyRp2r
	 s4cy2uOkcPMkQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9777FF48A4A; Sun, 16 Aug 2026 23:12:33 -0400 (EDT)
Date: Sun, 16 Aug 2026 23:12:33 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: shuo chen <1289151713@qq.com>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ack@suse.cz,
        ojaswin@linux.ibm.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Message-ID: <aoJ4bJZNgNAt4pLD@mit.edu>
References: <an5_shcksPF6uIaW@mit.edu>
 <tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com>

Given the issues that were reported by the Sashiko and Syzbot issues,
I commend that you try using the kvm-xfstests[1] test appliance or the
related gce-xfstests[2] test appliance if you have access to Google
Compute Engine

[1] https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md
[2] https://thunk.org/gce-xfstests

Since you are making changes to inline_data feature, you'd use it
soemthing like this:

% cd /usr/src/linux  # replace with your kernel sources
% install-kconfig
% kbuild
% kvm-xfstests -c ext4/inline -g auto

You can also add some options to install-kconfig to enable extra
debugging, of which the most interesting are --kasan and --lockdep.  I
would recommend doing your initial testing using just the plain
install-kconfig, and then once you are getting clean run, do separate
runs with the Kernel Address Sanitizer and the runtime locking
correctness validator.

The way I do my testing using gce-xfstests is to use a command like
this: "gce-xfstests ltm -c ext4/all -g auto" which will launch 12
VM's, for a variety of ext4 test scenarios (e.g., with bigalloc, fast
commit, 1k block sizes, etc.)  You can of course try running
"kvm-xfstests -c ext4/all -g auto" but this will likely take around
24-36 hours depending on how fast your local storage test devices.
(Using gce-xfstest's lightweight test manager takes around 2 hours of
wall clock time, since the test VM's run in parallel.)

Cheers,

					- Ted
