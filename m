From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: I had to modify some of your patches in the ext4 patch queue
Date: Thu, 13 Nov 2008 20:35:45 +0900
Message-ID: <491C1111.3040602@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59879 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYKMLgK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 06:36:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thank you for comments.

Theodore Tso wrote:
> On Thu, Nov 06, 2008 at 10:19:50AM +0900, Akira Fujita wrote:
>> Thank you for fixing, but there is a problem.
>> ac_excepted_group has not only excepted block group number
>> but also -1 (it means any block groups are accepted).
>> So I think it is necessary for defrag to keep it as "long long",
>> because if maximum number of the ext4_group_t is set excepted_group,
>> defrag can't handle block group number correctly.
>
> It's a really bad idea from a portability perspective to use either
> long, unsigned long, or long long directly.  On some architecture, who
> knows what size long long might be; it might be a 128 bit integer on
> some future system.  The better way to do this is to allocate a
> EXT4_MB_HINT_ flag which indicates whether ac_excepted_group is valid,
> and then let ac_excepted_group have the correct type.

I see.
I will make ac_excepted_group have only block group number.
And create "#define EXT4_MB_ANY_BG 2048" flag which means any block group are
accepted (equivalent to former ac_excepted_group = -1) instead.

> Looking at defrag-08-add-ioc-move-victim-ioctl, I'm still concerned
> that we have far too much policy in the kernel-side code.  The fact
> that there is "phases" for the ioctl seems very wrong.  You don't
> normally find that in normal system calls, since it implies the kernel
> is dictating how various system calls will be used, and in what order.

Do you mean that it is not good EXT4_IOC_DEFRAG ioctl's behavior
is changed by "phases"?
If so, is it OK to create new ioctls equivalent to "phases"
(EXT4_IOC_DEFRAG_FORCE_XXX), for example?


> I'll note that there isn't that much difference between defragging an
> inode where you don't constrain where the blocks go, and defragging an
> inode where you want the blocks to go in a specific range of blocks
> (which I wouldn't necessarily constrain to a single block group; a
> range of blocks would be more general), and defragging an inode where
> you specify the range where you *don't* want the blocks to go, is all
> the same thing, except for the type of constraint you place on the new
> blocks during the inode block migration operation.
>
> So when I approach this from a kernel system call API design
> perspective, I start thinking about a data structure where the user
> program can specify some kind of constraint (or possibly multiple
> constraints, although that adds more complexities) and attach it to a
> file descriptor (perhaps via fcntl), and then *all* allocations,
> regardless of whether it is defrag, or block allocations, would be
> affected by the constraint.
>
> Do you see what I mean?  The kernel should provide general purpose
> primitive building blocks, which can be used in multiple ways by
> different userspace applications.  So by factoring out what needs to
> be done in each of the phases, it's possible to create a relatively
> small/simple system call and/or ioctl extension that modifies or
> extends the existing functions without encoding application specific
> detail into the kernel.
>
> 						- Ted

Regards,
Akira Fujita
