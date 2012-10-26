From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Fri, 26 Oct 2012 21:24:30 +0100
Message-ID: <871uglyoap.fsf@spindle.srvr.nix>
References: <jXsTo-5lW-13@gated-at.bofh.it> <jXBDk-7vn-13@gated-at.bofh.it>
	<jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it>
	<jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it>
	<jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it>
	<jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it>
	<50882787.3030504@onlinehome.de> <508AEEF7.8060301@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org,
	gregkh@linuxfoundation.org
To: Martin <marogge@onlinehome.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:40094 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966400Ab2JZUYg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 16:24:36 -0400
In-Reply-To: <508AEEF7.8060301@onlinehome.de> (Martin's message of "Fri, 26
	Oct 2012 22:13:43 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26 Oct 2012, Martin spake thusly:

> On 10/24/2012 07:38 PM, Martin wrote:
>> On 10/24/2012 01:40 AM, Nix wrote:
>>
>>> It's true that in less than a week
>>> probably not all that many people have rebooted often enough to trip
>>> over this.
>>>
>>> I hope.
>>>
>>
>> [previous bug report]
>
> First off let me apologize for not having the right follow-up headers,
> but I am not subscribed and I read the list behind an NNTP gateway.
>
> I have studied my corruption problem more closely and can give you a
> description of what happened below. Would you say this may be the same
> bug?

No. You want to keep up with the thread. Ted's first educated guess is
not always guaranteed to be correct (though this is rare).

> Oct 15 19:56:12
>
> Computer is booted again in order to copy a few files to memory stick. Unbeknownst to me, the following entries are logged in the
> system log:
>
> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5): add_dirent_to_buf:1587: inode #655361: block 2629945: comm mount: bad
> entry in directory: rec_len % 4 != 0 - offset=360(360), inode=655682, rec_len=18, name_len=5
> Oct 15 20:00:16 harold kernel: Aborting journal on device sda5-8.
> Oct 15 20:00:16 harold kernel: EXT4-fs (sda5): Remounting filesystem read-only
> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in ext4_evict_inode:238: Journal has aborted
> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in ext4_create:2120: IO failure

That's an interesting failure, but looks slightly different to what I
saw. No bad directory entries, no aborted journals: a replayed journal
and subsequent corruption. Still damaged though, and after a journal
abort I'm not surprised you had problems!

>                           I will try to rename them to their
> proper name on another machine, and restore them on the target
> machine. However, due to the sheer number this might take forever.

I relearned this week that backups are good.

> Also I am worried the problem might re-surface, as it has neither been
> identified nor fixed.

I'm seeing it on almost every reboot.

> NB: kernel was v3.5.5

Hm, this provides possible evidence that the problem does indeed extend
into 3.5.x.

> with CK1 and BFQ patches, tainted by nvidia module.

It's hard to reason about a kernel that's had *that* massive lump of
binary junk applied to it, alas. This may or may not be the same
problem: it has some common features with what I see, but not all.

-- 
NULL && (void)
