From: Nix <nix@esperi.org.uk>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
Date: Fri, 26 Oct 2012 21:47:26 +0100
Message-ID: <87sj91x8o1.fsf@spindle.srvr.nix>
References: <jXsTo-5lW-13@gated-at.bofh.it> <jXBDk-7vn-13@gated-at.bofh.it>
	<jXNl8-5m5-13@gated-at.bofh.it> <jXNOa-5MR-23@gated-at.bofh.it>
	<jXPGh-87s-5@gated-at.bofh.it> <jXTJW-4CH-55@gated-at.bofh.it>
	<jXUZj-6mo-13@gated-at.bofh.it> <jXVLH-7kO-5@gated-at.bofh.it>
	<jXW53-7CC-5@gated-at.bofh.it> <jXWeJ-7Lk-1@gated-at.bofh.it>
	<50882787.3030504@onlinehome.de> <508AEEF7.8060301@onlinehome.de>
	<871uglyoap.fsf@spindle.srvr.nix> <508AF639.30603@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, stable@vger.kernel.org,
	gregkh@linuxfoundation.org
To: Martin <marogge@onlinehome.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:43135 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2JZUra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 16:47:30 -0400
In-Reply-To: <508AF639.30603@onlinehome.de> (Martin's message of "Fri, 26 Oct
	2012 22:44:41 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 26 Oct 2012, Martin said:

> On 10/26/2012 10:24 PM, Nix wrote:
>> On 26 Oct 2012, Martin spake thusly:
>>> Computer is booted again in order to copy a few files to memory stick. Unbeknownst to me, the following entries are logged in the
>>> system log:
>>>
>>> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5): add_dirent_to_buf:1587: inode #655361: block 2629945: comm mount: bad
>>> entry in directory: rec_len % 4 != 0 - offset=360(360), inode=655682, rec_len=18, name_len=5
>>> Oct 15 20:00:16 harold kernel: Aborting journal on device sda5-8.
>>> Oct 15 20:00:16 harold kernel: EXT4-fs (sda5): Remounting filesystem read-only
>>> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in ext4_evict_inode:238: Journal has aborted
>>> Oct 15 20:00:16 harold kernel: EXT4-fs error (device sda5) in ext4_create:2120: IO failure
>>
>> That's an interesting failure, but looks slightly different to what I
>> saw. No bad directory entries, no aborted journals: a replayed journal
>> and subsequent corruption. Still damaged though, and after a journal
>> abort I'm not surprised you had problems!
>
> So my corrupt journal is simply the result of a user turning off the machine at a bad point in time? That's scary. In that scenario
> even the option data=journal wouldn't save me from harm, would it?

No, I think that's probably a bug -- but I don't know if it's the same
bug: the symptoms are slightly different.

(Note that some hard drives in the distant past had been known to write
rubbish if powered down during a write. I don't think this has been true
for a good decade or so, though.)

>> It's hard to reason about a kernel that's had *that* massive lump of
>> binary junk applied to it, alas. This may or may not be the same
>> problem: it has some common features with what I see, but not all.
>
> true, i normally re-create problems with vanilla kernels before
> reporting them. In this case I was cleanly sniped with no chance of
> re-play so far.

True. I'm stuck with a problem that I can only currently reproduce on
physical hardware myself :( In addition to seeing if Ted's proposed
patch reduces the frequency of corruption, I'll be doing some tests this
weekend with LVM block device suspension and subsequent reboots to see
if that causes similar symptoms even in virtualization.

-- 
NULL && (void)
