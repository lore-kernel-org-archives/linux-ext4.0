From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Potential bug in mballoc --- reusing data blocks before txn commit
Date: Mon, 29 Sep 2008 17:04:04 -0400
Message-ID: <48E142C4.7090809@redhat.com>
References: <E1KjlCM-0002L7-SO@closure.thunk.org> <48E138B2.8080707@sun.com> <20080929205712.GH10831@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51868 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYI2VE2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Sep 2008 17:04:28 -0400
In-Reply-To: <20080929205712.GH10831@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Sep 30, 2008 at 12:21:06AM +0400, Alex Tomas wrote:
>   
>> Theodore Ts'o wrote:
>>     
>>> I'll also note that a linked list of extents that should be freed would
>>> also be useful for implementing the trim command for SSD's --- and that
>>> this would be much more cleanly implemented via a callback from the jbd2
>>> layer when a commit is finished, rather than the current
>>> ext4_mb_poll_new_transaction() mechanism.
>>>       
>> yes, polling is a hack as we lost commit callback long ago.
>>     
>
> Yeah, I know Andrian Bunk strikes again....  but the right answer is
> to ressurect that code and add it back.
>
>   
>>> In any case, is there a reason why the mballoc.c is using its current
>>> scheme, and not using kj->b_commited_data as in the original balloc.c
>>> code?  And was there a reason why you decided that it wasn't necessary
>>> to protect freed data blocks from being reused until the transaction was
>>> committed?
>>>       
>> I think we don't really care about data consistency much. so I tried to save
>> some memory (given amount of metadata is smaller usually).
>>     
>
> Well, we need to keep this information for the SSD Trim command
> anyway; so probably the right approach is to keep a red/black tree of
> extents that need to be freed, and then when the commit callback is
> called, we can update the appropriate mballoc data structures and call
> the SSD trim command if necessary.
>
> That restores the data consistency that we have with ext3, and it also
> gives us the SSD trim functionality, which we need for both ext3 and
> ext4.  In fact, the information we need in both cases is 100% identical.
>
> The other thing which I should check is that if we are using this
> scheme, I think we shouldn't need to keep the shadow copy of the block
> bitmap buffers any more.  I would imagine we still need them for the
> inode bitmaps, for the same reason, though.
>
>      	      	  		     	 - Ted
>
>   

I don't disagree with any of the above, just want to point out that TRIM 
has a  SCSI T10 cousin that is very similar (used to implement thinly 
provisioned luns). We should make sure as much as possible to make our 
file system level support work for both...

ric

