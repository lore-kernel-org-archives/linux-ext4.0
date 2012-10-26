From: Martin <marogge@onlinehome.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Fri, 26 Oct 2012 22:44:41 +0200
Message-ID: <508AF639.30603@onlinehome.de>
References: <jXsTo-5lW-13@gated-at.bofh.it> <jXBDk-7vn-13@gated-at.bofh.it> <jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it> <jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it> <jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it> <jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it> <50882787.3030504@onlinehome.de> <508AEEF7.8060301@onlinehome.de> <871uglyoap.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org,
	gregkh@linuxfoundation.org
To: Nix <nix@esperi.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2JZUou (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 16:44:50 -0400
In-Reply-To: <871uglyoap.fsf@spindle.srvr.nix>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/2012 10:24 PM, Nix wrote:
> On 26 Oct 2012, Martin spake thusly:
[...]
>> I have studied my corruption problem more closely and can give you a
>> description of what happened below. Would you say this may be the same
>> bug?
>
> No. You want to keep up with the thread. Ted's first educated guess is
> not always guaranteed to be correct (though this is rare).

OK

>
>> Oct 15 19:56:12
>>
>> Computer is booted again in order to copy a few files to memory stick. Unbeknownst to me, the following entries are logged in the
>> system log:
>>
>> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5): add_dirent_to_buf:1587: inode #655361: block 2629945: comm mount: bad
>> entry in directory: rec_len % 4 != 0 - offset=360(360), inode=655682, rec_len=18, name_len=5
>> Oct 15 20:00:16 harold kernel: Aborting journal on device sda5-8.
>> Oct 15 20:00:16 harold kernel: EXT4-fs (sda5): Remounting filesystem read-only
>> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in ext4_evict_inode:238: Journal has aborted
>> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in ext4_create:2120: IO failure
>
> That's an interesting failure, but looks slightly different to what I
> saw. No bad directory entries, no aborted journals: a replayed journal
> and subsequent corruption. Still damaged though, and after a journal
> abort I'm not surprised you had problems!

So my corrupt journal is simply the result of a user turning off the 
machine at a bad point in time? That's scary. In that scenario even the 
option data=journal wouldn't save me from harm, would it?

Funny this happens to someone who has always said that robustness is the 
most important quality of a filesystem (and who thinks data=writeback is 
madness).

>
>>                            I will try to rename them to their
>> proper name on another machine, and restore them on the target
>> machine. However, due to the sheer number this might take forever.
>
> I relearned this week that backups are good.

Backups are good, and always too old.

>
>> Also I am worried the problem might re-surface, as it has neither been
>> identified nor fixed.
>
> I'm seeing it on almost every reboot.

Indeed the symptoms look different.

>
>> NB: kernel was v3.5.5
>
> Hm, this provides possible evidence that the problem does indeed extend
> into 3.5.x.
>
>> with CK1 and BFQ patches, tainted by nvidia module.
>
> It's hard to reason about a kernel that's had *that* massive lump of
> binary junk applied to it, alas. This may or may not be the same
> problem: it has some common features with what I see, but not all.
>

true, i normally re-create problems with vanilla kernels before 
reporting them. In this case I was cleanly sniped with no chance of 
re-play so far.

