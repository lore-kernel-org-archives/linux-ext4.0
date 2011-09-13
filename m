From: Joel Becker <jlbec@evilplan.org>
Subject: Re: i_mutex questions
Date: Tue, 13 Sep 2011 12:02:09 -0700
Message-ID: <20110913190208.GD4635@noexit.corp.google.com>
References: <4E6FA1F9.6080802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Ted Ts'o <tytso@mit.edu>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49008 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1IMTCR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Sep 2011 15:02:17 -0400
Content-Disposition: inline
In-Reply-To: <4E6FA1F9.6080802@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 13, 2011 at 11:33:29AM -0700, Allison Henderson wrote:
> Hi All,
> 
> I have been trying to find a way to synchronize punch hole with read
> and write operations with out the use of i_mutex.  The concern is
> that after punch hole has released the pages inside the hole,
> another process may remap the page to a block before punch has taken
> i_data_sem.  I think putting i_mutex around the punch hole operation
> would fix this, but since we are trying to avoid further improper
> use of i_mutex, I am trying to avoid that solution.

Hey Allison,
	Actually, i_mutex is the normal way to handle this.  ocfs2 takes
i_mutex down under its ->fallocate().  Truncate is in the same boat,
which is why do_truncate() takes i_mutex before calling notify_change().
	The read-write paths grab i_mutex for buffered operation.  They
don't for O_DIRECT, which doesn't map to the pagecache.  This is where
i_data_sem should speed things up.  

Joel


-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

			http://www.jlbec.org/
			jlbec@evilplan.org
