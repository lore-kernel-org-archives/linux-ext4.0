From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Tue, 11 Jan 2011 16:30:07 -0500
Message-ID: <20110111213007.GF2917@thunk.org>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
 <20101109044242.GH2715@dastard>
 <20101109214147.GK3099@thunk.org>
 <20101109234049.GQ2715@dastard>
 <AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Josef Bacik <josef@redhat.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
	cluster-devel@redhat.com
To: Lawrence Greenfield <leg@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39046 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1AKVaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Jan 2011 16:30:18 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 11, 2011 at 04:13:42PM -0500, Lawrence Greenfield wrote:
> > IOWs, all they want to do is avoid the unwritten extent conversion
> > overhead. Time has shown that a bad security/performance tradeoff
> > decision was made 13 years ago in XFS, so I see little reason to
> > repeat it for ext4 today....

I suspect things may have changed somewhat; both in terms of
requirements and nature of cluter file systems, and the performance of
various storage systems (including PCIe-attached flash devices).  

> I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
> of extent conversion. It's that extent conversion causes more metadata
> operations than what you'd have otherwise, which means systems that
> want to use O_DIRECT and make sure the data doesn't go away either
> have to write O_DIRECT|O_DSYNC or need to call fdatasync().
> 
> cluster file system implementor,

One possibility might be to make it an optional feature which is only
enabled via a mount option.  That way someone would have to explicit
ask for this feature two ways (via a new flag to fallocate) and a
mount option.

It might not make sense for XFS, but for people who are using ext4 as
the local storage file system back-end, and are doing all sorts of
things to get the best performance, including disabling the journal, I
suspect it really would make sense.  So it could always be an
optional-to-implement flag, that not all file systems should feel
obliged to implement.

					- Ted
