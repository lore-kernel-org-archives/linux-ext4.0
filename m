From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: refuse O_DIRECT opens for mode where DIO doesn't
 work
Date: Mon, 25 Apr 2016 20:20:38 -0400
Message-ID: <20160426002038.GA28496@thunk.org>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
 <20160425234946.GB26977@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonlist@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39192 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbcDZAUl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2016 20:20:41 -0400
Content-Disposition: inline
In-Reply-To: <20160425234946.GB26977@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2016 at 09:49:46AM +1000, Dave Chinner wrote:
> Why not just transparently fall back to buffered IO if direct IO
> cannot be done? Saves people from wondering why applications fail
> on one ext4 filesystem and not another....

Some file systems return EINVAL if they don't support O_DIRECT.  In
fact, _require_odirect in xfstests relies on this fact.  The question
of whether it's better to silently fall back to buffered I/O and fail
to provide the O_DIRECT functionality requested by the user, or
whether it's better to fail with EINVAL is an interesting one.  It is
possible for applications (or xfstests tests) that expect O_DIRECT
functionality but don't get it can end up fail, sometimes in subtle
ways that might be tricky to debug.

It would be nice if there was some way to answer the question, "does
O_DIRECT work or is it a placebo", perhaps via an extension to
statfs(2), but we don't have that today.

I ran into this because I was investigating an xfstests failure, and
it was because we were claiming to support O_DIRECT when in fact we
weren't, and this was causing a test failure.  OTOH, after I applied
this patch, there were a handful of tests that are using O_DIRECT
without using the _require_odirect assertion, and we were passing
those tests essentially by luck.

So depending how we decide to deal with this case, I can send patches
that add the missing _require_odirect to those tests, and/or send
tests that add more ext4-specific checks to _require_odirect (e.g.,
don't try to use O_DIRECT in data=journal, or if inline_data is
enabled, or if encryption is enabled).

What do folks think?

					- Ted
