From: Alex Tomas <bzzz@sun.com>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn commit
Date: Tue, 30 Sep 2008 00:21:06 +0400
Message-ID: <48E138B2.8080707@sun.com>
References: <E1KjlCM-0002L7-SO@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:53145 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYI2UVt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2008 16:21:49 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8TKLdQg020734
	for <linux-ext4@vger.kernel.org>; Mon, 29 Sep 2008 20:21:47 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7Z00J014EMFZ00@fe-emea-10.sun.com> (original mail from bzzz@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 29 Sep 2008 21:21:39 +0100 (BST)
In-reply-to: <E1KjlCM-0002L7-SO@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> I'll also note that a linked list of extents that should be freed would
> also be useful for implementing the trim command for SSD's --- and that
> this would be much more cleanly implemented via a callback from the jbd2
> layer when a commit is finished, rather than the current
> ext4_mb_poll_new_transaction() mechanism.

yes, polling is a hack as we lost commit callback long ago.

> In any case, is there a reason why the mballoc.c is using its current
> scheme, and not using kj->b_commited_data as in the original balloc.c
> code?  And was there a reason why you decided that it wasn't necessary
> to protect freed data blocks from being reused until the transaction was
> committed?

I think we don't really care about data consistency much. so I tried to save
some memory (given amount of metadata is smaller usually).


thanks, Alex

