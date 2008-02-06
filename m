From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Replace iget with iget_locked in
	defrag-free-space-fragementation
Date: Tue, 5 Feb 2008 22:28:05 -0500
Message-ID: <20080206032805.GG27119@mit.edu>
References: <E1JLLPj-0006dq-9C@closure.thunk.org> <1202259352.3935.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64942 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbYBFD2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 22:28:21 -0500
Content-Disposition: inline
In-Reply-To: <1202259352.3935.16.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 05, 2008 at 04:55:52PM -0800, Mingming Cao wrote:
> On Sat, 2008-02-02 at 11:40 -0500, Theodore Ts'o wrote:
> > We also have an issue where the read-only bind patches from Dave Hansen
> > are making changes which conflict with the ext4 patch tree, which is
> > making akpm very grumpy.  I'll try to take a look at this later in the
> > weekend...
> > 
> > 						- Ted
> 
> BTW, Ted, could you clarify about this one? I am able to build the patch
> queue on akpm's 2.6.24-mm1 tree with Dave Hansen's read-only bind
> changes. Maybe I missed something.

That's because I've already removed the BKL patches that conflict.

       	       	    	    	    	    - Ted
