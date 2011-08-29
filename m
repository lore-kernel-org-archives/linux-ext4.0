From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: don't print "do not support" warnings unless
 verbose is specified
Date: Mon, 29 Aug 2011 15:36:21 +1000
Message-ID: <20110829053621.GH32358@dastard>
References: <1314467002-20297-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24488 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738Ab1H2Fv6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Aug 2011 01:51:58 -0400
Content-Disposition: inline
In-Reply-To: <1314467002-20297-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 27, 2011 at 01:43:22PM -0400, Theodore Ts'o wrote:
> Commit 630421f6d449 attempts to avoid printing the "fallocate not
> supported" warning if the -q (quiet) option is specified on the
> command-line.  Unfortunately tests 75 and 112 don't set the -q flag.
> This causes test failures for file systems that don't support
> fallocate or the punch hole functionality.
> 
> I considered changing tests 75 and 112 to pass -q to fsx, but that
> would suppress other warning messages that could be legitimate test
> failures, so I decided to add a new -v (vebose) flag.

Oh, so now we can have verbose quietness? Or is it quiet verbosity?
That quickly leads to insanity.... :/

The quiet flag only suppresses output that is otherwise logged and
output when a failure occurs. Hence setting the quiet won't cause
any loss of functionality or error detection for these tests so you
should just add the quiet flag to the tests.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
