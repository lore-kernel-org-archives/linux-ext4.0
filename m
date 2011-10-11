From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure delete
 journal blocks
Date: Mon, 10 Oct 2011 17:54:30 -0700
Message-ID: <4E9393C6.8030907@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com> <20111010134736.5b721a22@bike.lwn.net>	<4E93813C.1020708@linux.vnet.ibm.com> <20111010174115.054c3f1f@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47151 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1JKAyf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Oct 2011 20:54:35 -0400
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 10 Oct 2011 20:54:34 -0400
In-Reply-To: <20111010174115.054c3f1f@bike.lwn.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/2011 04:41 PM, Jonathan Corbet wrote:
> On Mon, 10 Oct 2011 16:35:24 -0700
> Allison Henderson<achender@linux.vnet.ibm.com>  wrote:
>
>> On 10/10/2011 12:47 PM, Jonathan Corbet wrote:
>>> One quick question:
>>>
>>> On Fri,  7 Oct 2011 00:11:05 -0700
>>> Allison Henderson<achender@linux.vnet.ibm.com>   wrote:
>>>
>>>> +	/* Secure delete any blocks still in our range */
>>>> +	if (jbd2_pblk_count>   0)
>>>> +		err = ext4_secure_delete_pblks(journal->j_inode,
>>>> +			jbd2_pblk_start, jbd2_pblk_count);
>>>> +
>>>> +out:
>>>> +	spin_unlock(&journal->j_pair_lock);
>>>
>>> ext4_secure_delete_pblks() appears to do its job synchronously - it has
>>> calls to things like sync_dirty_buffer() and such.  How can you do that
>>> while holding ->j_pair_lock?
>>>
>>> Thanks,
>>>
>>> jon
>>>
>>
>> Hi Jon,
>>
>> Well j_pair_lock is a lock I added to protect the new list of vfs
>> ->  jbd2 block pairs. It is locked by the journal commit thread to
>> update the list when ever a journal block is modified. The above
>> code here is called by the same thread that performs a punch hole or
>> truncate operation, not the journal commit thread. So I'm not
>> immediately seeing why there would be any lock problems. Is there
>> another case I'm missing?
>
> The problem is that ext4_secure_delete_pblks() can sleep, unless I've
> misunderstood things very badly.  That's not something you want to do
> while holding a spinlock...
>
> jon
>

Oh I see the concern now.  Ok, I can put in a semaphore instead.  Thx 
for catching that.  :)

Allison

