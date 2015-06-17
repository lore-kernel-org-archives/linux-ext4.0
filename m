From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC] keyctl {clear,revoke} serialization with key-users
Date: Wed, 17 Jun 2015 17:18:42 +0100
Message-ID: <29565.1434557922@warthog.procyon.org.uk>
References: <87ioapt1fj.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075AbbFQQSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2015 12:18:46 -0400
In-Reply-To: <87ioapt1fj.fsf@openvz.org>
Content-ID: <29564.1434557922.1@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> But currently there is not synchronization between 'keyctl clear' and dirty
> page buffers write-back, which result in data loss(because key no longer
> available).

The way fs/afs/ deals with this is to attach the key to the pending writeback
record.  However, this would also benefit from writeback being triggered at
key invalidation.

> But currently there is not synchronization between 'keyctl clear' and dirty
> page buffers write-back, which result in data loss(because key no longer
> available).
>
> There are several ways to synchronize key-management with key-usage
> 1) ext4 specific way via userspace
>    add 'del_key' command to e4crypto which will do:
>        ioctl(ext4_del_key)          # sync and invalidate all inodes which referees given key
>        keyctl(KEYCTL_INVALIDATE,..) # wipe key from kernel

I'm not keen on this because it's too easy to bypass half the process and miss
the ioctl.

> 2) Generic keyring way:
>    Add kernel API to register event listeners for a key so any subsystem
>    may listen for such events and performs necessary actions once it happen.
>    For example:
>    key = request_key(....)
>    notify_changes_key(key, event_mask, my_callback)
> 
> 
>    keyring_clear() {
>    for_each_listener{
>         notify_key(callback, KEY_CLEAR)
>    }
>    
> First one is easy and clean also it preserves original keyring management
> assumptions, but second one is more generic (since other fs will likely to
> implement encryption in near future), the only visible changes of second
> option is that callbacks must be synchronous so 'keyctl clear @s' may takes
> long time. IMHO such implicit synchronization is good for 99% use-cases, the
> only exception is 'emergency key clear' case where we do not care about data
> consistency but do care about key to be wiped ASAP.
> 
> I would like to implement second option. Please rise your objections if any.

I agree that the second is the best option.  It's something I thought about
originally for keys that are tied to some sort of removable hardware but I
never actually implemented.

I would suggest that you consider driving the notification from the gc.  It
might not be entirely practical though and might be better off done from a
separate work item.

David
