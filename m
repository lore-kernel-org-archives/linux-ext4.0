From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: use ext2fs_blocks_count() in ext2fs_open2()
Date: Wed, 2 Sep 2009 18:28:04 -0400
Message-ID: <20090902222804.GB5270@mit.edu>
References: <4A9D9574.3010606@redhat.com> <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com> <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42742 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZIBW2I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 18:28:08 -0400
Content-Disposition: inline
In-Reply-To: <13135.1251925342@alphaville.usa.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 05:02:22PM -0400, Nick Dokos wrote:
> The following patch fixes a problem I think, but I'm not sure whether it
> resolves Justin's problem. I'm running a test, but I thought I'd send it
> out for people to try and/or comment on. Let me know of any problems.

Ouch.  Thanks for sending this; I'm surprised people hadn't run into
massive problems due to this patch earlier.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
