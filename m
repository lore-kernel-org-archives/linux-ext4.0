Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79763358B9
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016454; cv=none; b=nwqPA0cJI9iTC0KYzrct6OM/wREPcWiCxUDVCbgXbhGvqljFiTN9VKKNq+CPT14jRb3Pe5LBvBMSo5ANWQlXHJF7KelU3qjF+CnlYzg+8Ztgjg3DjoDCk0pE41kCC2PTrgXFfUYAGgtr6bgp5ZSSewhDZlGIWxHYh1p9NDOpu9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016454; c=relaxed/simple;
	bh=kAcZEahDHRfGumFkykTwEcuw4vLnvOKJYhsdf7ZjS5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9TVVpO69Erwis/cGBSg0zgfD371Oeh6rAUGYT/omciRhFrhPHybQU1dpBRThh5dZJEYuh6vj9kqNMfio3nXLlhhGwSrzCerpC1U9UlRBxv02S7uRDeJJyINdaGoQZ1M7DhX80bOq5BaYd55OwDZmM2uMYL6VYweY2w536c/cJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org (syn-072-043-125-131.biz.spectrum.com [72.43.125.131])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 662IKEkV009051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 2 Jul 2026 14:20:15 -0400
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id E6C0A865EA7; Thu,  2 Jul 2026 14:20:13 -0400 (EDT)
Date: Thu, 2 Jul 2026 14:20:13 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Greg KH <gregkh@linuxfoundation.org>, Wang Jun <1742789905@qq.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        libaokun1@huawei.com, 25125332@bjtu.edu.cn, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
Message-ID: <akaoai2pRVxE3t-2@mit.edu>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
 <2026070210-catty-grape-2568@gregkh>
 <8b1d5b5d-61f5-40b1-95d4-35f98a280db8@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b1d5b5d-61f5-40b1-95d4-35f98a280db8@linux.dev>

> 
> This patch is trying to fix the regression which Introduced by this series:
> 
>     [PATCH 6.6 046/567] ext4: get rid of ppath in ext4_ext_insert_extent()
>

The subject line in the patch did not make it clear that this was
fixing a breakage caused by a backport from upstream kernel into 6.6.
So I was quite confused, and given that no one pays me to work on LTS
kernels, and I wasted several days debugging the 6.1 backport before
figuring out what the guilty commit that needed reverting, and life
has gotten super busy at $WORK, I decided to say, oh well, the failure
was only triggered (as far as I know) by tests exercising the shutdown
path, and life was too short to figure out how to untangle 6.6 LTS.

Instead, I've just been telling people that they **really** should
just use far more recent LTS kernels, because from a security
perpsective, lots of patches never get backported to older LTS kernels
--- and in a post Mythos world, it's probably not reasonable to be
using 6.1 or 6.6 --- and sometimes the auto-backport results in flaky
LTS kernels --- and while there had been an attempt to organize
companies to contribute SWE effort to test and stablize xfs, (a) in
the past 18 months, all of the companies who had contriburted SWE time
had with drawn that effort, and (b) I've never been able to recruit
people willing to do this for ext4.  And I'm too busy to spend time
after midnight or on weekends doing it for older LTS kernels for free.

> So I'm confused about the next action will we accept Wang Jun's
> patch or we just revert it as 6.1 did ?

The commit description in Wang Jun's patch needs to explain that it's
fixing a but that was introduced in the LTS backport.  As memory
serves, after the several day effort to figure out the guilty commmt
in 6.1 LTS, we determined that the purported bug that the half-dozen
odd commits (including the dependencies), wasn't even **applicable**
for 6.1.  So it was all just a massive waste of my time.

I have not done the analysis to determine whether the patch series in
6.6 that caused the regression is actually fixing a bug in the 6.6 LTS
kernel.  If it doesn't, perhaps reverting the whole mess is the better
approach.  Or if someone wants to take Wang Jun's patch, and run it
through a full set of regression test suites, using something like:

   gce-xfstests ltm -c ext4/all -g auto

or the equivalent, and it passes without triggering crashes and
without causing more regressions, Wang Jun's patch seems to make
sense.  For more instructions on how to run the test, see [1][2].

[1] https://thunk.org/gce-xfstests
[2] https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md

And if you are interested in helping out with ext4 stable kernel
maintenace, I'd love the volunteer help.  After the mess with the 6.1
and 6.6 LTS backports, I've been tempted to just tell the stable
kernel maintainers to stop backporting fixes to 6.1 and 6.6.  (The XFS
community has standing instructions not to back *any* backports to LTS
kernels,b ecause of this instability problem.  The fix of having
developers actually do QA before sending out backports works, and is
certainly much better than the "it builds, ship it!" approach --- but
the downside is that most companies aren't willing to devote the time
to do that backports, especially now in the post Mythos world, your
internal security teams are probably requiring you to use much newer
LTS kernels anyway.)

Cheers,

						- Ted
