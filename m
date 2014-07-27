From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Sat, 26 Jul 2014 20:34:45 -0400
Message-ID: <53D44925.4000903@dobrotescu.ca>
References: <loom.20140727T010632-633@post.gmane.org> <20140727000733.GV6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49237 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaG0Aet (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2014 20:34:49 -0400
Received: by mail-ie0-f175.google.com with SMTP id x19so5210593ier.20
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jul 2014 17:34:48 -0700 (PDT)
In-Reply-To: <20140727000733.GV6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26/07/2014 20:07, Theodore Ts'o wrote:
> On Sat, Jul 26, 2014 at 11:07:59PM +0000, Vlad Dobrotescu wrote:
>> If this isn't the proper place for this question, please point me in
>> the right direction.
>>
>> I couldn't find any description on Ext4's behaviour when mounted
>> with errors=continue and external journal if the journal block device
>> is unavailable at mount time (or becomes unavailable at some point).
>>
>> I would be using CentOS 7 (kernel 3.10.0-123.4.4.el7 x86_64) and
>> (probably) full data journaling on a SSD. Can someone help?
> So there are two different questions.
>
> If you use errors=continue, there is the chance that the file system
> inconsistencies that discovered could cause further file system
> damage, which might lead to the loss or corruption of data files
> written earlier.  So it's not really recommended for most purposes,
> unless you have some scheme where you are monitoring dmesgs and having
> some strategy to deal with detected file system errors, or when the
> system absolutely, positively must continue running, and this is more
> important than potential data loss.
>
> If the journal block device is not present then the file system can't
> be mounted, and if the system was uncleanly shut down you won't be
> able to recover from the unclean shutdown by replaying the journal.
>
> If the journal block device is *gone*, it is possible to remove the
> external journal block device, and then force a file system repair,
> but if this happens after an unclean shutdown, you may very well lose
> data.
>
> Cheers,
>
> 						- Ted

Sorry if this is a duplicate, but the "Followup" didn't seem to work for me

Thanks for the quick and detailed answer. If I understand it correctly,
the errors= option has nothing to do with journaling, but only with FS
consistency issues (which can be caused by a vanished journal, but also
by other events), while the mounting itself fails in the absence of the
device specified for external journaling, with no fall-back alternative.
Right?

Vlad

