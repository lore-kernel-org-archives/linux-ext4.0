From: Nick Alcock <nick.alcock@oracle.com>
Subject: Re: v4.7--v4.10+: ext4: repeatable inline-data oops (and fs corruption) caused by msync() of shared writable mmap (with recipe)
Date: Mon, 13 Mar 2017 23:11:35 +0000
Message-ID: <87tw6wg4bc.fsf@esperi.org.uk>
References: <874lzdcj9r.fsf@esperi.org.uk> <20170313005232.GA593@zzz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40252 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753911AbdCMXLv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Mar 2017 19:11:51 -0400
In-Reply-To: <20170313005232.GA593@zzz> (Eric Biggers's message of "Sun, 12
        Mar 2017 17:52:32 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13 Mar 2017, Eric Biggers spake thusly:

> On Wed, Mar 01, 2017 at 11:45:52AM +0000, Nick Alcock wrote:
>> [Resend, after the first attempt, from my home address, failed with
>>  endless greylisting followed by "4.5.0 Interactive router timed out"
>>  from all but the lowest-priority MX for vger, and "Name server:
>>  bl-ckh-le.kernel.org.: host not found" for the apparently-nonexistent
>>  lowest-priority MX. Maybe it'll work better from here.]
>> 
>> I first spotted this -- or it spotted me -- back in the v4.7.x days. It
>> is still present in v4.10.
>> 
>> Here's a replication recipe, given a reasonable rootfs with a compiler
>> on it, and assuming a blank virtio disk on /dev/vdb:
>
> Hi Nick, thanks for reporting this.  I've sent a patch which should fix this,
> and Cc'ed you.  This actually seems to been a bug for a very long time, maybe

I'll test it. Your timing is supernatural: I was just about to mkfs all
the filesystems on my new server (a once-in-a-decade operation for me)
and was bemoaning the fact that I couldn't turn on inline_data at the
same time. Now I can! (I have good backups so can take suicidally crazy
risks).

> even ever since the inline_data feature was introduced.  (I was able to
> reproduce it in a 3.18 kernel, at least.)  I'm not sure why it didn't get
> noticed earlier --- maybe hardly anyone ever writes to small files with mmap...

Yeah, I built my /usr/src with it and ran for weeks without hitting it:
it wasn't until I rebuilt most of a distro and hit dovecot that anything
went wrong.

I note that what I saw then was massive filesystem corruption, so
massive that not even tune2fs recognized it as being an ext4 fs
afterwards. Perhaps the thing wrote badness into the journal (possibly
including inline data scribbled over the next inode?) and replayed it
over the fs on the next boot, following which a cascade of increasing
badness ended up eating the entire fs... ah well, I guess it's hard to
know now, months after the fact (though if it's of interest, I still
have an e2image of the corrupted fs lying around!)

-- 
NULL && (void)
