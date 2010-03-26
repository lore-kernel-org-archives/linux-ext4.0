From: tytso@mit.edu
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 09:38:56 -0400
Message-ID: <20100326133856.GE21658@thunk.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <20100326033824.GC21658@thunk.org>
 <20100326104205.GA3055@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39299 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0CZNjo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 09:39:44 -0400
Content-Disposition: inline
In-Reply-To: <20100326104205.GA3055@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 26, 2010 at 11:42:05AM +0100, Jan Kara wrote:
> > There may also be other programs that depend on the existence of
> > aquota.user, and may be reading and writing them in various random
> > ways, and there is the question of how do we provide compatibility
> > with these other programs, some of which may not be within quotatools,
> > but in various magic virtualization or container or cluster management
> > systems....
>   Yeah, this is possible, although I'm not aware of any such program -

Actually, Google's cluster management system is accessing/modifying
aquota.group file directly before and after quota is enabled.  This
may change in the future, but it's one more point of compatibility.

>   Yeah, I believe that support for the oldest quota format can be phased
> out - the new format is around for something like 10 years and it had
> it's problems at that time already. I guess I'll add a warning to the
> next release of quota-tools to the people still using it.

And if we transition to using quotactl calls to access and read the
information in the quota files, then the actual format of the quota
file won't matter any more, right?

Stupid question --- how does repquota work on OCFS2?  I don't see any
quotactl subcommands that would appear to return the functionality
needed by repquota --- unless you just assume that the only uid/gid's
in use are in /etc/passwd and /etc/group, and just call quotactl for
each uid/gid in the system passwd and group files.

     	     	    	   	      	    - Ted
