From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] ext4: use module parameters instead of debugfs for
 mballoc_debug
Date: Tue, 12 Feb 2013 10:14:11 +1100
Message-ID: <20130211231411.GA10731@dastard>
References: <1360460534-818-1-git-send-email-tytso@mit.edu>
 <51191010.50402@redhat.com>
 <511912B1.9070407@redhat.com>
 <20130211155428.GA6001@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31021 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758427Ab3BKXOO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 18:14:14 -0500
Content-Disposition: inline
In-Reply-To: <20130211155428.GA6001@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2013 at 10:54:28AM -0500, Theodore Ts'o wrote:
> On Mon, Feb 11, 2013 at 09:48:01AM -0600, Eric Sandeen wrote:
> > 
> > As another thought, did you consider using dynamic debug for this, or is that
> > too much trickiness?  Might be nice since usually a bug reporter won't have
> > a kernel built with CONFIG_EXT4_DEBUG . . .
> 
> I had assumed that the long term direction was to use tracepoints,
> which also has the advantage of not requiring kernels built with
> CONFIG_EXT4_DEBUG.
> 
> Hmm.... one thing though is if we want bug reporters to use
> tracepoints (as opposed to just developers), we'll need to have some
> pre-made shell scripts to make it easy for non-developers to enable
> tracepoints for various problems.

FYI, we have a quick outline of how to gather a basic event trace
using trace-cmd in the XFS FAQ for this purpose:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

If a more complex/finer grained trace is required to further isolate
the problem, we generally then tell the user exactly what to run as
the events/devices that need to be traced are case-specific.  Seeing
the users are already familiar with the basic tracing technique at
this point it seems to work fine...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
