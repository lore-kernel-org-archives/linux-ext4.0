From: mike <mike503@gmail.com>
Subject: Re: [zfs-discuss] ZFS, XFS, and EXT4 compared
Date: Wed, 29 Aug 2007 23:27:58 -0700
Message-ID: <bd9320b30708292327u26f30c75j8e34b9fa1584371f@mail.gmail.com>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:35922 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXH3G2A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 02:28:00 -0400
Received: by nz-out-0506.google.com with SMTP id s18so343124nze
        for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 23:27:59 -0700 (PDT)
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 8/29/07, Jeffrey W. Baker <jwbaker@acm.org> wrote:
> I have a lot of people whispering "zfs" in my virtual ear these days,
> and at the same time I have an irrational attachment to xfs based
> entirely on its lack of the 32000 subdirectory limit.  I'm not afraid of
> ext4's newness, since really a lot of that stuff has been in Lustre for
> years.  So a-benchmarking I went.  Results at the bottom:
>
> http://tastic.brillig.org/~jwb/zfs-xfs-ext4.html
>
> Short version: ext4 is awesome.  zfs has absurdly fast metadata
> operations but falls apart on sequential transfer.  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel.
>
> It would be nice if mke2fs would copy xfs's code for optimal layout on a
> software raid.  The mkfs defaults and the mdadm defaults interact badly.

this is cool to see. however, performance wouldn't be my reason for
moving to zfs. the inline checksumming and all that is what i want. if
someone could get nearly incorruptable filesystems (or just a linux
version of zfs... btrfs looks promising) this would be even better.

sadly ext4+swraid isn't as good, i might have tried that since waiting
the right hardware support for zfs for me seems to be unknown at this
point.
