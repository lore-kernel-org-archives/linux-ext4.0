From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] xfstests: don't print "do not support" warnings unless
 verbose is specified
Date: Mon, 29 Aug 2011 09:37:18 -0400
Message-ID: <20110829133718.GD12187@thunk.org>
References: <1314467002-20297-1-git-send-email-tytso@mit.edu>
 <20110829053621.GH32358@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51101 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1H2NhW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Aug 2011 09:37:22 -0400
Content-Disposition: inline
In-Reply-To: <20110829053621.GH32358@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 29, 2011 at 03:36:21PM +1000, Dave Chinner wrote:
> On Sat, Aug 27, 2011 at 01:43:22PM -0400, Theodore Ts'o wrote:
> > Commit 630421f6d449 attempts to avoid printing the "fallocate not
> > supported" warning if the -q (quiet) option is specified on the
> > command-line.  Unfortunately tests 75 and 112 don't set the -q flag.
> > This causes test failures for file systems that don't support
> > fallocate or the punch hole functionality.
> > 
> > I considered changing tests 75 and 112 to pass -q to fsx, but that
> > would suppress other warning messages that could be legitimate test
> > failures, so I decided to add a new -v (vebose) flag.
> 
> Oh, so now we can have verbose quietness? Or is it quiet verbosity?
> That quickly leads to insanity.... :/
> 
> The quiet flag only suppresses output that is otherwise logged and
> output when a failure occurs. Hence setting the quiet won't cause
> any loss of functionality or error detection for these tests so you
> should just add the quiet flag to the tests.

OK, I'll resubmit a patch which changes the tests (i.e., 75 and 112)
to pass the -q flag to fsx.  I had thought _not_ passing -q was
deliberate, but reviewing the output, it does seem that none of the
!quiet messages are all that important.

					- Ted


