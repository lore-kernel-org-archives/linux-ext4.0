From: Dave Chinner <david@fromorbit.com>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Thu, 28 Mar 2013 11:34:35 +1100
Message-ID: <20130328003435.GW6369@dastard>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <5153217B.5070909@sgi.com>
 <20130327190512.GA22889@thunk.org>
 <20130327204217.GC16651@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Rich Johnston <rjohnston@sgi.com>,
	xfs-oss <xfs@oss.sgi.com>, linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14492 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab3C1Aej (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 20:34:39 -0400
Content-Disposition: inline
In-Reply-To: <20130327204217.GC16651@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 01:42:17PM -0700, Zach Brown wrote:
> On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> > What do you think about renaming the existing tests from NNN to
> > NNN-descriptive-name?  That way it will be easier for people who are
> > trying to track regressions, since they can easily map from the new
> > more descriptive name to the old test number for comparison purposes
> > (i.e., to see whether a failure is a regression or not, etc.)
> 
> It does seem like a good idea to help people map from descriptive names
> to their previous numeric file names.
> 
> But do we want to bake it in to the file names forevermore?  Would it be
> good enough to start the old tests with something like
> 
> _was_test_nr 45

$ cd tests/generic
$ ../../lsqa.pl -b 001
Random file copier to produce chains of identical files so the head
and the tail can be diff'd at the end of each iteration.

Exercises creat, write and unlink for a variety of directory sizes,
and
checks for data corruption.

run [config]

config has one line per file with filename and byte size, else use
the default one below.
$ ../../lsqa.pl -b 005
Test symlinks & ELOOP
$

Do we even really need to change them? Fix the lsqa.pl script be
able to take a directory argument, and just use the script to get
the description....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
