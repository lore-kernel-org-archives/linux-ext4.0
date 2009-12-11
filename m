From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] replaced BUG() with return -EIO	from	ext4_ext_get_blocks
Date: Fri, 11 Dec 2009 14:31:50 -0600
Message-ID: <4B22AC36.5020106@redhat.com>
References: <1260540418-11844-1-git-send-email-surbhi.palande@canonical.com>	 <1260554859.21896.8.camel@bobble.smo.corp.google.com>	 <4B22A572.5010201@redhat.com> <1260562923.21896.11.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Surbhi Palande <surbhi.palande@canonical.com>,
	linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbZLKUbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Dec 2009 15:31:51 -0500
In-Reply-To: <1260562923.21896.11.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Fri, 2009-12-11 at 14:02 -0600, Eric Sandeen wrote:
>> My first thought was that this was a bandaid too, but I guess it can
>> come about due to on-disk corruption for any reason, so it should
>> be handled gracefully, and I suppose this approach seems fine.
> 
> That's why we've been running with it, yes.

now if this is coming about as the result of a programming error, we'd
better sort that out ;)  Do you have any reason to believe that the
corruption a hardware or admin issue, vs. an actual bug somewhere?

>> Since this is catching on-disk corruption, though, it'd be better to call
>> ext4_error() and let the mount-time error-handling policy decide what to do.
>>
>> I like having more info but below seems awfully wordy ;)  Maybe the first
>> printk would suffice, and switching it to an ext4_error() would be best,
>> I think.
> 
> Okay, I'll rework the patch a bit and resubmit it.


Thanks!

The amount of info printed is probably just a judgement call; for a developer,
printing out the inode & iblock is enough 'cause we can then just go use
debugfs & look at it.  For a bug report, perhaps more info would be useful
because that one set of printks may be all we'll get ... up to you.

Maybe we should think about a generic "print corrupted inode information"
infrastructure that could be reused ...

Thanks,
-Eric
