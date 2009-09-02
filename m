From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 17:37:30 -0400
Message-ID: <13808.1251927450@alphaville.usa.hp.com>
References: <4A9D9574.3010606@redhat.com> <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com> <sandeen@redhat.com> <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com>  <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:11817 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZIBVh1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 17:37:27 -0400
In-Reply-To: Message from Justin Maggard <jmaggard10@gmail.com>
   of "Wed, 02 Sep 2009 14:28:23 PDT." <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard <jmaggard10@gmail.com> wrote:

> On Wed, Sep 2, 2009 at 2:02 PM, Nick Dokos<nicholas.dokos@hp.com> wrote:
> > The following patch fixes a problem I think, but I'm not sure whether it
> > resolves Justin's problem. I'm running a test, but I thought I'd send it
> > out for people to try and/or comment on. Let me know of any problems.
> 
> Just finished trying with that patch, but it looks like it doesn't
> resolve my issue either.
> 

Yup, it didn't pass my test either.

Thanks,
Nick
