From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 21:41:14 -0500
Message-ID: <4A9F2CCA.8000307@redhat.com>
References: <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com> <sandeen@redhat.com> <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com> <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com> <13808.1251927450@alphaville.usa.hp.com> <4A9EE6FF.4000901@redhat.com> <150c16850909021445se2ebc6ahc896dc6c5aa56f8b@mail.gmail.com> <4A9EF2AB.3090602@redhat.com> <20090902225531.GD4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Justin Maggard <jmaggard10@gmail.com>, nicholas.dokos@hp.com,
	ext4 development <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:12357 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbZICClM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 22:41:12 -0400
In-Reply-To: <20090902225531.GD4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 02, 2009  17:33 -0500, Eric Sandeen wrote:
>> Justin Maggard wrote:
>>> On Wed, Sep 2, 2009 at 2:43 PM, Eric Sandeen<sandeen@redhat.com> wrote:
>>>> You guys are still getting bad checksums?
>>> Yeah, I am.
>> Oh, sorry, all the other bugs gave me a head-fake, and I forgot the
>> original problem of -fsck- corrupting the checksums.  :)  I had a simple
>> mkdir giving me the corruptions.  Ok, on to that.
> 
> I found the source of the checksum error last night - the reserved bytes
> in the 64-bit group descriptor are not zero after the e2fsck is run.
> It should be pretty easy to run e2fsck under gdb and put a hardware watch
> on those bytes to see who twiddles them.

Thanks, I saw that email a bit late today, will take a look.

-Eric

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

