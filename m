From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix type-punning warnings
Date: Thu, 16 Dec 2010 17:15:07 -0500
Message-ID: <20101216221507.GD4455@thunk.org>
References: <4D07BEB1.8030406@redhat.com>
 <20101215230926.GC4455@thunk.org>
 <4D0A790A.1080703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48799 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0LPWPL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Dec 2010 17:15:11 -0500
Content-Disposition: inline
In-Reply-To: <4D0A790A.1080703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 16, 2010 at 02:39:38PM -0600, Eric Sandeen wrote:
> Hm this may need an include of the e2p.h header as well, if built in
> a pristine buildroot...

Actually we only need it if we are building tst_csum (i.e., if #DEBUG
is defined).  So I'll apply it under #ifdef DEBUG, and then add a
dependency for tst_csum in the Makefile.

Thanks for pointing this out.

						- Ted
