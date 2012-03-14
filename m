From: Ted Ts'o <tytso@mit.edu>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Wed, 14 Mar 2012 12:54:01 -0400
Message-ID: <20120314165401.GB28042@thunk.org>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com>
 <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com>
 <20120310044804.GB5652@thunk.org>
 <4F5F9A97.5060404@ubuntu.com>
 <20120313195339.GA24124@thunk.org>
 <4F5FAC9C.9070607@gmail.com>
 <20120313213304.GB11969@thunk.org>
 <4F60AB04.1000706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Phillip Susi <phillsusi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39388 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab2CNQyF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Mar 2012 12:54:05 -0400
Content-Disposition: inline
In-Reply-To: <4F60AB04.1000706@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 14, 2012 at 10:28:20AM -0400, Phillip Susi wrote:
> 
> Do you really think it is that much easier?  Even if it is easier,
> it is still an ugly kludge.  It would be much better to fix the
> underlying problem rather than try to paper over it.

I don't think the choice is obvious.  A solution which solves the
problem 90% plus of the time for real-life workloads, without
requiring any file system format changes, is very appealing to me and
to I think many customers.

That being said, for someone who is looking for perfection, I can see
how it would grate on someone's nerves.

> The same argument could have been made against the current htree
> implementation when it was added.  I think it carries just as little
> weight now as it did then.  People who care about the added
> performance the new feature provides can use it, those who don't,
> won't.  Eventually it will become ubiquitous.

The original htree implementation tried very hard to be fully
backwards compatible for reading and writing.  At the time that was
considered very important, and for some folks it was a major killer
feature.  The original ext3 journalling support was designed in a way
where you could back out and mount such a file system on an ext2 file
system, and that was considered important back then, too.

The fact that we've been so successful with ext4's upgrade to features
that require RO_COMPAT or INCOMPAT features does make me more willing
to consider those features, but the reality is that the deployment
time for such a new feature is measured in 2-3 years, minimum.  So I
won't rule out making such a change, but I wouldn't let the fact that
someone wants to sign up to implement a long-term feature, to be
mutually exclusive with a short-term solution which solves most of the
problem that could be rolled out much more quickly.

	     	      	     	      	   - Ted
