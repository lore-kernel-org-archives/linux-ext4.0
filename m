From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 Secure Delete 7/7v4] ext4/jbd2: Secure Delete: Secure delete
 journal blocks
Date: Mon, 10 Oct 2011 16:36:25 -0700
Message-ID: <4E938179.6000200@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-8-git-send-email-achender@linux.vnet.ibm.com> <20111010140046.546e3c67@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:42278 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1JJXgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Oct 2011 19:36:32 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Mon, 10 Oct 2011 17:36:31 -0600
In-Reply-To: <20111010140046.546e3c67@bike.lwn.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/2011 01:00 PM, Jonathan Corbet wrote:
> On Fri,  7 Oct 2011 00:11:05 -0700
> Allison Henderson<achender@linux.vnet.ibm.com>  wrote:
>
>> +	/*
>> +	 * If the journal block was not found in the list,
>> +	 * add a new pair to the list
>> +	 */
>> +	if (!b_pair) {
>> +		b_pair = kzalloc(sizeof(struct jbd2_blk_pair), GFP_NOFS);
>> +		if (!b_pair) {
>> +			spin_unlock(&journal->j_pair_lock);
>> +			return -ENOMEM;
>> +		}
>
> Here too...  that really needs to be GFP_ATOMIC.
>
> I'm wondering, though...it looks like, over a short period of time, you
> will create an unordered linked list containing one entry for every
> physical block in the journal.  You'll take a lock and search the whole
> list for every block that is committed.  Wouldn't it be better just to
> have an array indexed by the journal logical block offset?  Less memory,
> faster access...?  Or am I missing something fundamental here?
>
> Thanks,
>
> jon

Hi Jon,

I think that's a good suggestion. Initially I had made it a linked
list since most of the journals existing lists were implemented as
linked lists, but since this list ends up being a fixed size, an
array is a good optimization here. Thx!

Allison

