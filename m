From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 16:33:20 -0800
Message-ID: <20110226003319.GD28214@noexit>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
 <20110225215924.GA28214@noexit>
 <20110225234002.GA2924@thunk.org>
 <20110226000304.GC28214@noexit>
 <20110226003140.GB2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:50575 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab1BZAdY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 19:33:24 -0500
Content-Disposition: inline
In-Reply-To: <20110226003140.GB2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 07:31:40PM -0500, Ted Ts'o wrote:
> On Fri, Feb 25, 2011 at 04:03:04PM -0800, Joel Becker wrote:
> > > We could add complexity to do suballocations for directories, but KISS
> > > seems to be a much better idea for now.
> > 
> > 	Oh dear God no.
> 
> What are you saying no to?  KISS or suballocations?  :-)

	You know the answer to that ;-)  Though if you ever do smoke
some crack and design suballocations, ocfs2 will happily steal them.

Jool

-- 

"Only a life lived for others is a life worth while."
							-Albert Einstein  

			http://www.jlbec.org/
			jlbec@evilplan.org
