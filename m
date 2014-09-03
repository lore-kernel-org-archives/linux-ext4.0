From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: What happened to e4defrag relevant file and free space defrag?
Date: Wed, 3 Sep 2014 15:02:07 -0400
Message-ID: <20140903190207.GJ2504@thunk.org>
References: <53F87552.6050000@terminalmx.com>
 <540760AA.4060900@terminalmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Joakim Ziegler <joakim@terminalmx.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35700 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbaICTCQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 15:02:16 -0400
Content-Disposition: inline
In-Reply-To: <540760AA.4060900@terminalmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 03, 2014 at 01:40:42PM -0500, Joakim Ziegler wrote:
> On 23/08/14, 6:04, Joakim Ziegler wrote:
> >
> >Also, about free space defrag, it says:
> >
> >"Implement free space defragmentation (e4defrag -f). We might implement this
> >feature when the relevant defrag development is completed."

The e4defrag is in e2fsprogs, and the code is still getting maintained
and improved.  Dmitry Monakhov has in particular added a lot of
"torture tests", and found a number of race conditions in the
underlying kernel code.  He recently also sent a code refactor of the
kernel code which significantly improved it and (shrank the size of
ext4 by 550 lines of code).

That being said, there hasn't been any real feature development for
e4defrag in quite some time.  There has been some discussion about
what the kernel API's might be to support this feature, but there has
never been a finalized API proposal, let alone an implementation.

Cheers,

						- Ted
