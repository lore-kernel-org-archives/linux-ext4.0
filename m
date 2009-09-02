From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 19:12:22 -0400
Message-ID: <15413.1251933142@alphaville.usa.hp.com>
References: <4A9D9574.3010606@redhat.com> <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com> <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com>  <20090902222804.GB5270@mit.edu>
Reply-To: nicholas.dokos@hp.com
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45167 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZIBXMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 19:12:19 -0400
In-Reply-To: Message from Theodore Tso <tytso@mit.edu>
   of "Wed, 02 Sep 2009 18:28:04 EDT." <20090902222804.GB5270@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, Sep 02, 2009 at 05:02:22PM -0400, Nick Dokos wrote:
> > The following patch fixes a problem I think, but I'm not sure whether it
> > resolves Justin's problem. I'm running a test, but I thought I'd send it
> > out for people to try and/or comment on. Let me know of any problems.
> 
> Ouch.  Thanks for sending this; I'm surprised people hadn't run into
> massive problems due to this patch earlier.
> 

Most of the time those counts fit in 16 bits (they are per block group,
is that right?) - at least with default values: you'd have to make a
file system with larger block groups to see the problem, I think.  So
it's not as painful as it first sounds.

Nick
