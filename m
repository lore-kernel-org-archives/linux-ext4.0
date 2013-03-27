From: Zach Brown <zab@zabbo.net>
Subject: Re: Announce re-factor all current xfstests patches request
Date: Wed, 27 Mar 2013 13:42:17 -0700
Message-ID: <20130327204217.GC16651@lenny.home.zabbo.net>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <5153217B.5070909@sgi.com>
 <20130327190512.GA22889@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
	linux-ext4@vger.kernel.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:40758 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab3C0UmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 16:42:18 -0400
Content-Disposition: inline
In-Reply-To: <20130327190512.GA22889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> What do you think about renaming the existing tests from NNN to
> NNN-descriptive-name?  That way it will be easier for people who are
> trying to track regressions, since they can easily map from the new
> more descriptive name to the old test number for comparison purposes
> (i.e., to see whether a failure is a regression or not, etc.)

It does seem like a good idea to help people map from descriptive names
to their previous numeric file names.

But do we want to bake it in to the file names forevermore?  Would it be
good enough to start the old tests with something like

_was_test_nr 45

that spits out the old test number in the log?

Just thinking out loud over here.

- z
