From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [RFC PATCH 1/1] ext4: Try to better reuse recently freed space
Date: Tue, 01 Apr 2014 20:35:39 +0400
Message-ID: <87fvlxuhwk.fsf@openvz.org>
References: <alpine.LFD.2.00.1312021727150.2284@localhost.localdomain> <20140401053018.GP4911@thunk.org> <87ioqtuvd6.fsf@openvz.org> <20140401144708.GT4911@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:51286 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaDAQfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2014 12:35:44 -0400
Received: by mail-lb0-f169.google.com with SMTP id q8so7367230lbi.28
        for <linux-ext4@vger.kernel.org>; Tue, 01 Apr 2014 09:35:42 -0700 (PDT)
In-Reply-To: <20140401144708.GT4911@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 1 Apr 2014 10:47:08 -0400, "Theodore Ts'o" <tytso@mit.edu> wrote:
> On Tue, Apr 01, 2014 at 03:44:53PM +0400, Dmitry Monakhov wrote:
> > BTW where this can I find this discussion? I would like to cooperate
> > this that activity. Please CC me next time you will disscuss allocation
> > performance mesurments. At Parallels we run https://oss.oracle.com/~mason/compilebench/
> > as load simulator.
> 
> The discussion happened at the Ext4 developer's get together in Napa,
> California, colocated with the LSF/MM and the Collaboration Summit.
> You should go next year; it was a huge amount of fun, and there were a
> bunch of other Parallels people there who can tell you about the
> reception at the Jacuzzi Family Winery, etc.  :-)
Hm... the truth is that I was there. I am the man which asked your
opinion about mfsync(multy-file-fsync) remember :)
But probably I've simply missed an allocation topic.
> 
> I suspect there will be some future conversations at our weekly
> conference calls.  Typically design stuff will happen there, but
> technical low-level details about things like patches will happen on
> the mailing list, so you'll be alerted when we start having specific
> patches to evaluate and as we start putting together a set of
> allocation benchmarks.
> 
> If you are interested in participating on the conference calls,
> contact me off-line.  If the current time (8AM US/Pacific ; 11 AM
> US/Eastern) isn't good for you, we can try to see if another time
> works for everyone.
Yes. it would be nice. Please invite be to the next call.
> 
> One of the discussion points that came up last week is that it would
> be good if we can come up with allocation tests that are fast to run.
> That might mean (for example) taking a workload such as compilebench,
> and changing it to use fallocate() or having a mount option which
> causes the actual data path writes to be skipped for files.  We would
> then need to have some kind of metric to evaluate how "good" a
> particular file system layout ends up being at the end of the
> workload.  Not just for a specific file, but for all of the files in
> some kind of holistic measurement of "goodness", as well as looking at
> how fragmented the free space ended up being.  Exactly how we do this
> is still something that we need to figure out; if you have any
> suggestions, they would be most welcome!
> 
> Cheers,
> 
> 					- Ted
