From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Reproducible block structure
Date: Tue, 10 Dec 2013 11:32:02 -0200
Message-ID: <20131210133159.GA28136@orion.maiolino.org>
References: <CAO_9QQcOSgUA84ewb=PANikU+MzeTmmeHnPeLd2SHQ_46sUi8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jitesh Shah <jitesh.1337@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3LJNcN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 08:32:13 -0500
Content-Disposition: inline
In-Reply-To: <CAO_9QQcOSgUA84ewb=PANikU+MzeTmmeHnPeLd2SHQ_46sUi8Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 09, 2013 at 09:03:23PM -0800, Jitesh Shah wrote:
> Hello all,
> Assuming I have the latest ext4 system, I have a question ->
> Scenario -> I have 5 HDDs on which I burn the same block image on.
> These HDDs are usually mounted RO when used in production. For
> upgrading, I connect each one to an isolated machine, mount it as RW
> and run a script to update files (basically add, delete, modify
> files).
> 
> Now, if the script is ran in the SAME way for all 5 HDDs, is it
> guaranteed that these HDDs will be same at the block level too? (i.e.
> block allocation/deallocation will follow the same pattern). Assume
> single-core system with only one process modifying the HDD in
> predetermined order.
> 
No, you can't assume it, although ext4 might do the same write patterns, the
caches behind the scenes might change the way you'll be writing the data there.

> If there is no way to provide such a guarantee in a default ext4
> install, is there an ext4 option (ordered?) which can provide this
> guarantee?
>
ordered option for journal will guarantee journal ordering but not what you're
aiming for.

> Why do I ask -> I am tinkering with the idea of block level
> verification of images. If the above guarantees can be provided, I can
> easily hash the raw HDD for verification purposes.
>

I'm not sure if you'll be able to do it, different HDDs, even from the same
vendor might have slightly differences which might change the write patterns.
There are also some performance improvements like delalloc and mballoc that
might not have the same allocation result in all your HDDs.

Maybe (although I'm not the best person to ensure it), you can have success on
that if you disable HDDs write caches and use a filesystem less optimized and
with no journal, like ext2, or maybe use synchronous writes with ext4 but even
with sync writes, I'm not sure if you'll be able to have exactly the same
situation on all hdds, due the journal and the dynamic allocation algorithms

> Thanks,
> Jitesh
> 
> PS: I am not subscribed to the mailing list, so please include my id
> in the response if your email client does not put it there already!

Please, subscribe to maillist. This help to keep the talk in the maillist and
avoid to take a look if somebody already answered you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
