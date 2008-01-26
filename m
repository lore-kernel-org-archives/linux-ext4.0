From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Sat, 26 Jan 2008 08:21:24 -0500
Message-ID: <20080126132124.GA8348@mit.edu>
References: <alpine.LSU.0.999.0801252338460.26260@be1.lrz> <OF9B297CB7.4B613CFE-ON882573DC.00092EE4-882573DC.000A9B77@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bodo Eggert <7eggert@gmx.de>, Andreas Dilger <adilger@sun.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Adrian Bunk <bunk@kernel.org>, David Chinner <dgc@sgi.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ric Wheeler <ric@emc.com>,
	Valerie Henson <val@vahconsulting.com>, Valdis.Kletnieks@vt.edu
To: Bryan Henderson <hbryan@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52761 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752792AbYAZNW4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jan 2008 08:22:56 -0500
Content-Disposition: inline
In-Reply-To: <OF9B297CB7.4B613CFE-ON882573DC.00092EE4-882573DC.000A9B77@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2008 at 05:55:51PM -0800, Bryan Henderson wrote:
> I was surprised to see AIX do late allocation by default, because IBM's 
> traditional style is bulletproof systems.  A system where a process can be 
> killed at unpredictable times because of resource demands of unrelated 
> processes doesn't really fit that style.
> 
> It's really a fairly unusual application that benefits from late 
> allocation: one that creates a lot more virtual memory than it ever 
> touches.  For example, a sparse array.  Or am I missing something?

I guess it depends on how far you try to do "bulletproof".  OSF/1 used
to use "bulletproof" as its default --- and I had to turn it off on
tsx-11.mit.edu (the first North American ftp server for Linux :-),
because the difference was something like 50 ftp daemons versus over
500 on the same server.  It reserved VM space for the text segement of
every single process, since at least in theory, it's possible for
every single text page to get modified using ptrace if (for example) a
debugger were to set a break point on every single page of every
single text segement of every single ftp daemon.

You can also see potential problems for Java programs.  Suppose you
had some gigantic Java Application (say, Lotus Notes, or Websphere
Application Server) which is taking up many, many, MANY gigabytes of
VM space.  Now suppose the Java application needs to fork and exec
some trivial helper program.  For that tiny instant, between the fork
and exec, the VM requirements in "bulletproof" mode would double,
since while 99.9999% of the time programs will immediately discard the
VM upon the exec, there is always the possibility that the child
process will touch every single data page, forcing a copy on write,
and never do the exec.

There are of course different levels of "bulletproof" between the
extremes of "totally bulletproof" and "late binding" from an
algorithmic standpoint.  For example, you could ignore the needed
pages caused by ptrace(); more challenging would be to how to handle
the fork/exec semantics, although there could be kludges such as
strongly encouraging applications to use an old-fashed BSD-style
vfork() to guarantee that the child couldn't double VM requirements
between the vfork() and exec().  I certainly can't say for sure what
the AIX designers had in mind, and why they didn't choose one of the
more intermediate design choices.  

However, it is fair to say that "100% bulletproof" can require
reserving far more VM resources than you might first expect.  Even a
company which is highly incented to sell large amounts of hardware,
such as Digital, might not have wanted their OS to be only able to
support an embarassingly small number of simultaneous ftpd
connections.  I know this for sure because the OSF/1 documentation,
when discussing their VM tuning knobs, specifically talked about the
scenario that I ran into with tsx-11.mit.edu.

Regards,

						- Ted
