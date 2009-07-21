From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Using O_DIRECT in ext4
Date: Tue, 21 Jul 2009 16:46:16 -0700
Message-ID: <4A665348.7000802@us.ibm.com>
References: <d5ca277e0907201841i18b83bb6uea757e83d177bc9b@mail.gmail.com> <4A6538DB.5050202@redhat.com> <6601abe90907210745k3730f74dq62f1fe6539722b4d@mail.gmail.com> <4A65EEF3.9090507@redhat.com> <1248210485.18500.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Xiang Wang <xiangw@google.com>, linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:57295 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZGUXvb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 19:51:31 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6LNfgiE003347
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 17:41:42 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6LNkIhT111642
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 17:46:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6LNkIQN014758
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2009 17:46:18 -0600
In-Reply-To: <1248210485.18500.2.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Tue, 2009-07-21 at 11:38 -0500, Eric Sandeen wrote:
>   
>> Curt Wohlgemuth wrote:
>>     
>>> On Mon, Jul 20, 2009 at 8:41 PM, Eric Sandeen<sandeen@redhat.com> wrote:
>>>       
>>>> Xiang Wang wrote:
>>>>         
>>>>> For comparison, I did the same experiment on an ext2 partition,
>>>>> resulting in each file having only 1 extent.
>>>>>           
>>>> Interestinng, not sure I would have expected that.
>>>>         
>>> Same with us; we're looking into more variables to understand it.
>>>       
>> To be more clear, I would not have expected ext2 to deal well with it
>> either, is more what I meant ;)  I'm not terribly surprised that ext4
>> gets fragmented.
>>     
>
> Ext2 deals with it via the block reservation code added some time ago.
> It turns out it works pretty well for this case.  Ext4, of course,
> doesn't use the block reservation code.
>   
ext4 mballoc code use per cpu preallocation, so all threads running on 
the same cpu which needs new blocks will be assign blocks next to each 
other. This will makes files created by those threads interleave each 
other as a result, causing fragmentation. Preallocation will help, but 
that a persistant preallocation.

Mingming

