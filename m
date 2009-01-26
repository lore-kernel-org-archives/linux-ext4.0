From: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Mon, 26 Jan 2009 09:12:34 -0800
Message-ID: <497DEF02.90003@us.ibm.com>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com> <20090114044059.GA6222@mit.edu> <20090114191632.GA13114@linux-os.sc.intel.com> <1231961377.14825.51.camel@laptop>  <20090114212038.GJ6222@mit.edu> <1232568618.16682.20.camel@jamoon.sc.intel.com> <1232782595.4859.3.camel@laptop>  <497DE73B.4050602@us.ibm.com> <1232988371.4863.162.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:37879 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZAZRMi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2009 12:12:38 -0500
In-Reply-To: <1232988371.4863.162.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Peter Zijlstra wrote:
> On Mon, 2009-01-26 at 08:39 -0800, Darren Hart wrote:
> 
>>> diff --git a/kernel/futex.c b/kernel/futex.c
>>> index f89d373..f4132ab 100644
>>> --- a/kernel/futex.c
>>> +++ b/kernel/futex.c
>>> @@ -929,7 +929,7 @@ out_unlock:
>>>
>>>  	/* drop_futex_key_refs() must be called outside the spinlocks. */
>>>  	while (--drop_count >= 0)
>>> -		drop_futex_key_refs(&key1);
>>> +		drop_futex_key_refs(&key2);
>> Unfortunately, I realized later that this code was indeed correct and I 
>> asked Ingo to pull my patch implementing the above change.  Quoting my 
>> previous mail on the subject:
>>
>> "I believe what is happening here is that the requeue loop requeues each 
>> waiter from one futex (key1) to another (key2).  It rightly takes a 
>> reference to the futex at key2 and then decrements the references to 
>> key1 by drop_count (since the waiters now reference key2, not key1). 
>> The newly taken key2 references will be dropped in futex_wait() when 
>> each waiter is woken up and takes the futex."
> 
> Argh, that wants a comment..
> 

Agreed.  How about this.


futex: comment requeue key reference symmantics

From: Darren Hart <dvhltc@us.ibm.com>

We've tripped over the futex_requeue drop_count refering to key2
instead of key1.  The code is actually correct, but is non-intuitive.
This patch adds an explicit comment explaining the requeue.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/futex.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index 8af1002..3655cad 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -969,7 +969,12 @@ out_unlock:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 
-	/* drop_futex_key_refs() must be called outside the spinlocks. */
+	/*
+	 * drop_futex_key_refs() must be called outside the spinlocks. During
+	 * the requeue we moved futex_q's from the hash bucket at key1 to the
+	 * one at key2 and updated their key pointer.  We no longer need to
+	 * hold the references to key1.
+	 */
 	while (--drop_count >= 0)
 		drop_futex_key_refs(&key1);
 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
