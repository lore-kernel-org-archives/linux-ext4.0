From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: inconsistent file placement
Date: Tue, 6 Jul 2010 08:52:48 +0200
Message-ID: <AANLkTilxmM6mxH23pAjTeVIaM3mjilY8H3oJLfAhw0cp@mail.gmail.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0GFGwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2010 02:52:50 -0400
Received: by bwz1 with SMTP id 1so3246560bwz.19
        for <linux-ext4@vger.kernel.org>; Mon, 05 Jul 2010 23:52:49 -0700 (PDT)
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AED8@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 6, 2010 at 3:49 AM, Daniel Taylor <Daniel.Taylor@wdc.com> w=
rote:
> I realize that it is enerally not a good idea to tune
> an operating system, or subsystem, for benchmarking, but
> there's something that I don't understand about ext[234]
> that is badly affecting our product. =A0File placement on
> newly-created file systems is inconsistent. =A0I can't,
> yet, call it a bug, but I really need to understand what
> is happening, and I cannot find, in the source code, the
> source of the randomization (related to "goal"???).
>
> Disk drive performance for writing/reading large files
> is rather sensitive to outer-/inner-diameter cylinder
> placement. =A0When I create the same file multiple times
> on newly-created ext[234] file systems on the same disk
> partition, I find that it does not consistently occupy
> the same blocks. =A0In fact, there is enough difference in
> location to cause real differences in performance from
> test to test, which I cannot justify to management.
>

The ext[23] (and I suppose 4 as well) uses the process pid % 16 to
define a 'color' for the process.
New files first block goal depends on that 'color' - the goal is one
of 16 different offsets in the block group
where the new file's inode was allocated (usually the block group of
its parent directory).

The logic behind this allocator is that multiple files created
concurrently in the same directory would
have less chance of stepping over each other's allocations.

I am not sure what you are trying to test or how this behavior badly
affects your product.
If you specify your needs maybe someone can help you solve your problem=
=2E
I think that ext4 has some advanced features, like pre-allocation,
that may be able to help you.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
