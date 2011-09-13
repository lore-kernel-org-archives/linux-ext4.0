From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: i_mutex questions
Date: Tue, 13 Sep 2011 11:33:29 -0700
Message-ID: <4E6FA1F9.6080802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41263 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1IMSdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 14:33:36 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Tue, 13 Sep 2011 14:33:35 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8DIXWwC168304
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 14:33:32 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8DIXVVj004005
	for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 14:33:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I have been trying to find a way to synchronize punch hole with read and 
write operations with out the use of i_mutex.  The concern is that after 
punch hole has released the pages inside the hole, another process may 
remap the page to a block before punch has taken i_data_sem.  I think 
putting i_mutex around the punch hole operation would fix this, but 
since we are trying to avoid further improper use of i_mutex, I am 
trying to avoid that solution.

I cannot use i_data_sem to protect the pages because it seems most of 
the code has already established a locking order of pages first, then 
i_data_sem.  So moving i_data_sem up tends to cause a lot of dead locks. 
  I'm thinking that there probably needs to be a another mutex involved 
some where, but I wasnt sure if some one is already working on the idea 
of introducing a replacement for i_mutex.  So I just wanted to know if 
there are any plans already in motion for this, or if any one else could 
suggest some ideas for the punch hole issue.  Thx all!

Allison Henderson

