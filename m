From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Tue, 29 Mar 2011 10:26:29 -0500
Message-ID: <4D91FA25.1080402@redhat.com>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com> <4D90CE41.4030209@redhat.com> <4731EEFB-561D-4393-81C9-B550F45964C6@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Oren Elrad <elrad@brandeis.edu>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1C2P0h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2011 11:26:37 -0400
In-Reply-To: <4731EEFB-561D-4393-81C9-B550F45964C6@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/29/11 9:05 AM, Theodore Tso wrote:
> 
> On Mar 28, 2011, at 2:06 PM, Eric Sandeen wrote:
>> 
>> No other fs that I know of enforces this "don't fill the fs to
>> capacity" common sense programatically, though.
> 
> Actually, we (ext2) copied this from the BSD Fast File System (FFS)
> which used a default MINFREE of 10%.   For ext2 we decided to bring
> it down to 5%.   FreeBSD currently uses 8% as their default free
> ratio.

Clearly I don't know enough filesystems, I guess ;)

Should have said "linux filesystem" perhaps.

> The decrease does seem to be relative to the percentage of free
> space, from empirical experience, although no one I know of has done
> a formal analysis of the slowdown.   A lot depends on your workload,
> how much memory pressure you place on your system, etc.  I've
> actually started seeing slowdowns starting as early as 80% full when
> you're trying to allocate large chunks (1M to 8M) at a time, although
> this isn't something where I've gathered hard data; just what I've
> noticed from looking at different systems and their performance
> characteristics.
> 
> Fortunately disks are cheap, and lots of people end up buying far
> more disk space than they need, and so they naturally keep their file
> systems well under 75-80% full.
> 
> If someone wants to add some tuning parameters to mke2fs.conf, so
> they can set their own personal default free ratios, or even
> min_reserved_blocks and max_reserved_blocks settings, that's probably
> a reasonable patch to e2fsprogs that I'd be willing to accept. 

Hm I thought I had sent that, but it was only for the other two
semi-controversial behaviors.  :)

I agree, it seems like at least a decent first step to make it
more site/admin-configurable. 

-Eric

