From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND][PATCH 0/3 BUG,RFC] release block-device-mapping
 buffer_heads which have the filesystem private data for avoiding oom-killer
Date: Mon, 24 Nov 2008 22:29:32 -0800
Message-ID: <20081124222932.511c3cb7.akpm@linux-foundation.org>
References: <20081120092711.231c69bf.toshi.okajima@jp.fujitsu.com>
	<20081124131352.f5485398.akpm@linux-foundation.org>
	<492B9791.30007@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, viro@zeniv.linux.org.uk, sct@redhat.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbYKYGaz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2008 01:30:55 -0500
In-Reply-To: <492B9791.30007@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 25 Nov 2008 15:13:37 +0900 Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:

> Hi Andrew,
> Thanks for your comments.
> 
>  > On Thu, 20 Nov 2008 09:27:11 +0900
>  > Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> <SNIP>
>  >
>  > I'm scratching my head trying to work out why we never encountered and
>  > fixed this before.
> 
>  > Is it possible that you have a very large number of filesystems
>  > mounted, and/or that they have large journals?
> 
> Yes, I think it happen more easily under those conditions.
> 
> Actually, I encountered this situation if conditions were:
> - on the x86 architecture (The size of Normal zone is only 800MB
>     even if the huge memory (more than 4GB) install.)
> - reserving the big memory (more than 100MB) for the kdump kernel.
>    (The memory obtains from Normal Zone.)
> - mounting the large number of ext3 filesystems (more than 50).
> 
> And the following operations were done:
> - many I/Os were issued to many filesystems sequentially and continuously.
> (They made many journal_heads (and buffer_heads).
>   => they were metadata.)
> - issuing the I/Os to many filesystems were stopped.
> (This caused many metadata to remain.)
> 
> By their operations, the number of remaining the journal_heads was
> more than 100000 (They occupied 400MB (The same number of buffer_heads remained
> and the block size was 4096B)). We cannot release those journal_heads because
> checkpointing the transactions are not executed till some I/Os are issued to
> the filesystems or the filesystems were unmounting.
> And many other slab caches which couldn't be released occupied about 300MB.
> Therefore about 800MB memory couldn't be released.
> As a result, there was no room in the Normal zone.
> 
> I think you could not encounter it because you haven't done such the following:
> - You reserve the big memory for the kdump kernel.
> - You issue many I/Os to each ext3 filesystem sequentially and continuously,
>   and then you never issue some I/Os to the filesystems at all afterwards.
>   (Especially, you do the operations which causes many metadata to remain.
>    Example: Delete many files which are huge.)

yup.

>  > Would it not be more logical if the ->client_releasepage function
>  > pointer were a member of the blockdev address_space_operations, rather
>  > than some random field in the blockdev inode?  That arrangement might
>  > well be reused in the future, when some other address_space needs to
>  > talk to a different address_space to make a page reclaimable.
> 
> I think it logical to replace a default ->releasepage with a function pointer
> which a client (FS) passed, but I don't think it logical to add a new member
> function in address space in order to release a client page. Because new
> function is called from ->releasepage, so I think this function pointer should
> not be put in the same level as the releasepage of address space.
> 
> Though, it is difficult to replace ->releasepage member with a client function
> because there is no exclusive operation while this function is calling.
> 
> So, I made this patch (without replacing ->releasepage).
> 
> How about my thought?

yeah, I don't have particularly strong opinions either way.  If it
needs changing later, we can change it.
