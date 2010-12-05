From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4_alloc_context occupies 150 GiB of memory and makes the
 system unusable
Date: Sat, 4 Dec 2010 22:11:30 -0500
Message-ID: <20101205031130.GA4273@thunk.org>
References: <201011221323.25342.bartoschek@or.uni-bonn.de>
 <4CEA8B4A.3030608@redhat.com>
 <201011221637.58275.bartoschek@or.uni-bonn.de>
 <4CEA902F.9040706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Bartoschek <bartoschek@or.uni-bonn.de>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36797 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab0LEDLg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Dec 2010 22:11:36 -0500
Content-Disposition: inline
In-Reply-To: <4CEA902F.9040706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christoph,

Have you been able to replicate this problem since rebooting your
machine.  I've never seen anything quite like your report before.

If you do, a couple of questions.  Which slab allocator are you using?
Are you using SLAB or SLUB?  (grep for CONFIG_SLAB or CONFIG_SLUB in
your .config file).

If you are using SLUB, it would be useful to compile slubinfo.c (found
in /usr/src/linux/Documentation/vm/slabinfo.c) and send us the output
"slabinfo -a ext4_allocation_context" and "slabinfo -r
ext4_allocation_context".   

Also, you might try "slabinfo -s" and see if that shrinks the slabs
for you.  If this works, why it wasn't doing this automatically is
beyond me.

					- Ted

