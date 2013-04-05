From: Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH] ext4: fixup 64-bit divides in linux-3.0 stable backport
 of upstream fix
Date: Fri, 5 Apr 2013 16:18:15 -0700
Message-ID: <CAAW3YpbM7Vk_=qXv2NCgRsCkashsTpYC_6osA_udm2oDsiz5qA@mail.gmail.com>
References: <1365202463-25872-1-git-send-email-toddpoynor@google.com>
	<20130405230107.GA8412@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: stable@vger.kernel.org, Lingzhu Xiang <lxiang@redhat.com>,
	linux-ext4@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:55098 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759737Ab3DEXSR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Apr 2013 19:18:17 -0400
Received: by mail-la0-f44.google.com with SMTP id fr10so823922lab.3
        for <linux-ext4@vger.kernel.org>; Fri, 05 Apr 2013 16:18:16 -0700 (PDT)
In-Reply-To: <20130405230107.GA8412@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 5, 2013 at 4:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Apr 05, 2013 at 03:54:23PM -0700, Todd Poynor wrote:
> > Replace C division operators with div64_u64 for divides introduced in:
> > commit 503f4bdcc078e7abee273a85ce322de81b18a224
> > ext4: use atomic64_t for the per-flexbg free_clusters count
> >
> > Specific to the linux-3.0 backport of the upstream patch.
>
> Why is this specific?  Why is this working differently in 3.0 from 3.4
> and newer?

Looks like 3.1 doesn't have this patch.  The 3.2-stable backport of
this patch, for example, does not make some additional changes made in
the 3.0-stable backport, in addition to the upstream patch being
backported.  These additional changes include converting
blocks_per_flex and flexbg_free_blocks from int to ext4_fsblk_t (a
64-bit type), probably as a part of these additional changes mentioned
in the commit message:

   [Backported for 3.0-stable. Renamed free_clusters back to free_blocks;
    fixed a few more atomic_read's of free_blocks left in 3.0.]

Perhaps the better fix is to revert those additional changes and let
the ext4 folks figure out what to do about the remaining atomic_reads.

> And care to cc: the ext4 developers/maintainers when sending ext4
> patches?

cc'ed now, apologies.

>
> thanks,
>
> greg k-h
