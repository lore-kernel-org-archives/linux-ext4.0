From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 16:55:31 -0600
Message-ID: <20090902225531.GD4197@webber.adilger.int>
References: <20090902055953.GF4197@webber.adilger.int>
 <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>
 <sandeen@redhat.com> <4A9EA09E.10509@redhat.com>
 <13135.1251925342@alphaville.usa.hp.com>
 <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com>
 <13808.1251927450@alphaville.usa.hp.com> <4A9EE6FF.4000901@redhat.com>
 <150c16850909021445se2ebc6ahc896dc6c5aa56f8b@mail.gmail.com>
 <4A9EF2AB.3090602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Justin Maggard <jmaggard10@gmail.com>, nicholas.dokos@hp.com,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58646 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbZIBWzU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 18:55:20 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n82MtMa5028169
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 15:55:22 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPD00M008XXS400@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 15:55:22 -0700 (PDT)
In-reply-to: <4A9EF2AB.3090602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 02, 2009  17:33 -0500, Eric Sandeen wrote:
> Justin Maggard wrote:
> > On Wed, Sep 2, 2009 at 2:43 PM, Eric Sandeen<sandeen@redhat.com> wrote:
> >> You guys are still getting bad checksums?
> > 
> > Yeah, I am.
> 
> Oh, sorry, all the other bugs gave me a head-fake, and I forgot the
> original problem of -fsck- corrupting the checksums.  :)  I had a simple
> mkdir giving me the corruptions.  Ok, on to that.

I found the source of the checksum error last night - the reserved bytes
in the 64-bit group descriptor are not zero after the e2fsck is run.
It should be pretty easy to run e2fsck under gdb and put a hardware watch
on those bytes to see who twiddles them.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

