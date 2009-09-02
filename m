From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 02 Sep 2009 16:31:29 -0500
Message-ID: <4A9EE431.3050702@redhat.com>
References: <4A9D9574.3010606@redhat.com>	 <20090902055953.GF4197@webber.adilger.int>	 <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>	 <sandeen@redhat.com> <4A9EA09E.10509@redhat.com>	 <13135.1251925342@alphaville.usa.hp.com> <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: nicholas.dokos@hp.com, Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZIBVbd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 17:31:33 -0400
In-Reply-To: <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Maggard wrote:
> On Wed, Sep 2, 2009 at 2:02 PM, Nick Dokos<nicholas.dokos@hp.com> wrote:
>> The following patch fixes a problem I think, but I'm not sure whether it
>> resolves Justin's problem. I'm running a test, but I thought I'd send it
>> out for people to try and/or comment on. Let me know of any problems.
> 
> Just finished trying with that patch, but it looks like it doesn't
> resolve my issue either.
> 
> -Justin

Ok, I had a thinko in there, steered astray by a weird function
arguments; V2 coming in a moment :)

-Eric
