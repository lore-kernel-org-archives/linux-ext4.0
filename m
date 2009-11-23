From: Duane Griffin <duaneg@dghda.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in
	ext4_statfs()
Date: Mon, 23 Nov 2009 11:57:44 +0000
Message-ID: <e9e943910911230357r338bcb45ga6962c92d32fca4a@mail.gmail.com>
References: <4AF4A429.7090507@redhat.com>
	 <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
	 <20091108214804.GC7592@mit.edu>
	 <AB457F38-7E3A-43CE-B334-AE363BAE040C@sun.com>
	 <20091115032941.GB4323@mit.edu>
	 <F64B29C1-A90E-42F5-80CF-5704283D9A1B@sun.com>
	 <20091119190846.GB2099@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <andreas.dilger@lustre.org>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63320 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379AbZKWL5k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 06:57:40 -0500
Received: by fxm5 with SMTP id 5so4520469fxm.28
        for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 03:57:45 -0800 (PST)
In-Reply-To: <20091119190846.GB2099@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/11/19  <tytso@mit.edu>:
> On Mon, Nov 16, 2009 at 03:38:16PM -0800, Andreas Dilger wrote:
>> The other thing that comes to mind is that we don't recover the journal
>> for a read-only e2fsck, but we DO recover it on a read-only mount
>> seems inconsistent.  It wouldn't be hard to have e2fsck -n read the
>> journal and
>> persistently cache the journal blocks in its internal cache (i.e. flag
>> them so they can't be discarded from cache) before it runs the rest
>> of the
>> e2fsck.
>
> Eventually it would be nice if we did the same thing in both kernel
> and userspace when doing a read-only mount/check: build a redirection
> table that maps specific physical blocks to the block in the journal,
> and whenever the system tries to access a specific physical block, we
> look up the proper block to use instead in the redirection block.

Unfortunately you can't just blindly give back the journalled block:
it may have been escaped. So you need to read in the block from the
journal, unescape it if required, then give it back.

> The one tricky bit about doing this in the kernel is that we would
> still have to replay the journal in the case of the read-only root.
> Why?  Because otherwise older e2fsck's would get confused and replay
> the journal, and that would lead to some potentially serious
> confusion.  Even if we fix this in future versions of e2fsck, we still
> need to be careful dealing with remounting a r/o filesystem to be
> read/write, especially in the journal=data mode.

Hmm. The e2fsck confusion is an interesting wrinkle.

> The simple way of handling journaled data blocks is to hack the
> bmap() function to use the redirection block, but the problem with
> doing that is the journal block will be left in the buffer heads in
> the page cache.  If the file system is remounted r/w without first
> flushing these buffer heads, future attempts to modify these pages in
> the page cache could result in a random block in the journalling
> getting corrupted by an update, instead of updating the proper final
> location on disk for that data block.

Yes, they certainly need to be flushed.

> If we have someone who is at least some basic experience in kernel
> coding, but and an entry-level project getting involved with ext4,
> this would be an ideal, self-contained thing to try doing.  I'd
> suggest implementing it in userspace first, using the userspace/kernel
> API framework that allows e2fsck/recovery.c to be roughly kept in sync
> with fs/jbd[2]/recovery.c, and avoiding the hair of r/o roots by
> always replaying the journal in the case of the root file system.
> Anyone interested?  If so, let me know...

I am (still) interested in this. I'll have a look at the userspace
side of things.

>                                                       - Ted

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
