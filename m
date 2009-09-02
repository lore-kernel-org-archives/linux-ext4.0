From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 2 Sep 2009 14:28:23 -0700
Message-ID: <150c16850909021428v5e001691r8a5e28b5c1be9326@mail.gmail.com>
References: <4A9D9574.3010606@redhat.com>
	 <20090902055953.GF4197@webber.adilger.int>
	 <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com>
	 <sandeen@redhat.com> <4A9EA09E.10509@redhat.com>
	 <13135.1251925342@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:64035 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZIBV2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 17:28:21 -0400
Received: by pzk42 with SMTP id 42so1034874pzk.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 14:28:24 -0700 (PDT)
In-Reply-To: <13135.1251925342@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 2, 2009 at 2:02 PM, Nick Dokos<nicholas.dokos@hp.com> wrote:
> The following patch fixes a problem I think, but I'm not sure whether it
> resolves Justin's problem. I'm running a test, but I thought I'd send it
> out for people to try and/or comment on. Let me know of any problems.

Just finished trying with that patch, but it looks like it doesn't
resolve my issue either.

-Justin
