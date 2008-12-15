From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Mon, 15 Dec 2008 02:22:01 +0100
Message-ID: <87fxkqdyh2.fsf@frosties.localdomain>
References: <20081214223001.9E693108047@picon.linux-foundation.org>
	<4945925C.8010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:38060 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYLOBWI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Dec 2008 20:22:08 -0500
In-Reply-To: <4945925C.8010606@redhat.com> (Eric Sandeen's message of "Sun, 14
	Dec 2008 17:10:20 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> maj,min cpu  seq  time           pid   act rwbs off+len
> 8,0      0    1   0.000000000    1109   A   WS 14375 + 8 <- (8,1) 14312
>
> ... etc
>
> I'm not sure it gives us enough info; all we see is that there was an IO
> on sdb (from sdb1)
>
> I might suggest
>
> # sysctl -w vm.block_dump=1
>
> to see if you get any info about inodes on sda1 being dirtied.

Like atime/diratime updates?

> (Also, I didn't see any info about sda1 in the posted fstab...)
>
> -Eric

MfG
        Goswin
