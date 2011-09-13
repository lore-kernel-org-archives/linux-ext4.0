From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: i_mutex questions
Date: Tue, 13 Sep 2011 15:10:56 -0700
Message-ID: <4E6FD4F0.4000901@linux.vnet.ibm.com>
References: <4E6FA1F9.6080802@linux.vnet.ibm.com> <20110913190208.GD4635@noexit.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, jlbec@evilplan.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46440 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab1IMWLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 18:11:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8DLm07G008896
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 17:48:00 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8DMBeDp268506
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 18:11:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8DMBewj001882
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 18:11:40 -0400
In-Reply-To: <20110913190208.GD4635@noexit.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/13/2011 12:02 PM, Joel Becker wrote:
> On Tue, Sep 13, 2011 at 11:33:29AM -0700, Allison Henderson wrote:
>> Hi All,
>>
>> I have been trying to find a way to synchronize punch hole with read
>> and write operations with out the use of i_mutex.  The concern is
>> that after punch hole has released the pages inside the hole,
>> another process may remap the page to a block before punch has taken
>> i_data_sem.  I think putting i_mutex around the punch hole operation
>> would fix this, but since we are trying to avoid further improper
>> use of i_mutex, I am trying to avoid that solution.
>
> Hey Allison,
> 	Actually, i_mutex is the normal way to handle this.  ocfs2 takes
> i_mutex down under its ->fallocate().  Truncate is in the same boat,
> which is why do_truncate() takes i_mutex before calling notify_change().
> 	The read-write paths grab i_mutex for buffered operation.  They
> don't for O_DIRECT, which doesn't map to the pagecache.  This is where
> i_data_sem should speed things up.
>
> Joel
>
Hi Joel,

Well, I actually already had a patch that was trying to use i_mutex to 
solve this ([PATCH 4/6 v7] ext4: Lock i_mutex for punch hole).  But we 
decided not to apply it because of plans to reduce the usage of i_mutex 
in the ext4 code.  So I've been trying to figure out a different way to 
solve this, but so far I haven't had a whole lot of luck finding a 
solution that doesn't involve introducing a new locking mechanism.  So I 
wanted to check back here for more details on what the plan for i_mutex 
is so I dont conflict with anything that might already be going on.  :)

Ted, would you be able to give us some more details on this topic?  Thx!

Allison Henderson
