From: Joel Becker <jlbec@evilplan.org>
Subject: Re: i_mutex questions
Date: Tue, 13 Sep 2011 17:05:53 -0700
Message-ID: <20110914000553.GA8761@noexit.corp.google.com>
References: <4E6FA1F9.6080802@linux.vnet.ibm.com>
 <20110913190208.GD4635@noexit.corp.google.com>
 <4E6FD4F0.4000901@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:53816 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1INAGK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Sep 2011 20:06:10 -0400
Content-Disposition: inline
In-Reply-To: <4E6FD4F0.4000901@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 13, 2011 at 03:10:56PM -0700, Allison Henderson wrote:
> Well, I actually already had a patch that was trying to use i_mutex
> to solve this ([PATCH 4/6 v7] ext4: Lock i_mutex for punch hole).
> But we decided not to apply it because of plans to reduce the usage
> of i_mutex in the ext4 code.  So I've been trying to figure out a
> different way to solve this, but so far I haven't had a whole lot of
> luck finding a solution that doesn't involve introducing a new
> locking mechanism.  So I wanted to check back here for more details
> on what the plan for i_mutex is so I dont conflict with anything
> that might already be going on.  :)

	Sure ;-)  If you find another mechanism that reduces contention
but still plays well with read/write et al, please let us all know.
Getting i_mutex out of read/write would be interesting.

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

			http://www.jlbec.org/
			jlbec@evilplan.org
