From: Nanakos Chrysostomos <nanakos@wired-net.gr>
Subject: Re: Ext4 Kernel Crash
Date: Sun, 26 Feb 2012 14:18:02 +0200
Message-ID: <20120226121802.GA8600@dinofilaria.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.eleftheriou.eu ([86.35.2.10]:60136 "EHLO
	enigma.wired-net.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2BZMSP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Feb 2012 07:18:15 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
I tried a newer kernel and for the moment there are no problems.
I am testing our systems this weekend and the new week. I will
let you know the results.

Kind regards,
     Chris


On Mon, Jan 30, 2012 at 12:26:59PM -0500, Ted Ts'o wrote:
> On Sun, Jan 29, 2012 at 07:50:57PM +0200, Nanakos Chrysostomos wrote:
> > Dear Linux Kernel Developers,
> > I am writing to report a kernel or ext4 bug.
>
> Hi Nanakos,
>
> My apologies for not responding to the message that you sent to me
> personally three days ago, but I was on vacation in Hawaii; the best
> place to send queries about ext4 file systems is to use the
> linux-ext4@vger.kernel.org mailing list.
>
> One thing that I would immediately suggest is to see whether you can
> reproduce this bug using a modern kernel.  You are currently using a
> RHEL6-derived kernel (2.6.32-220.4.1.el6.x86_64).  The ext4 file
> system in such a kernel is quite different from what is in upstream,
> and there were a large number of bugs that have been fixed in ext4
> since 2.6.32.  Many of these fixes were backported into the RHEL6
> kernel, but I'm not an expert on which fixes have been backported into
> RHEL6 and which haven't.  (Especially since Red Hat doesn't release
> broken-out patches for their RHEL kernels....)
>
> My understanding is that Gluster doesn't require any kernel-side
> patches, so it should be OK to run Gluster on a v3.2 kernel.
> Alternatively, if you are a paid customer of RHEL6, I'd suggest
> sending a support request to Red Hat.
>
> Best regards,
>
>                                       - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
