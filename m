From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] tune2fs: remove dire warning about check intervals
Date: Wed, 19 Jul 2017 09:25:40 +0200
Message-ID: <20170719072540.7yzdlvfbfua4vwqg@localhost.localdomain>
References: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751822AbdGSHZq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 03:25:46 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E827961D11
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 07:25:45 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <ce6bff3e-49f4-2bed-67ce-a7be604ce1cf@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 18, 2017 at 04:10:49PM -0500, Eric Sandeen wrote:
> Time & mount-count based checks have been off by default for quite some
> time now, but the dire warning about disabling them remains in the
> tune2fs manpage, which is confusing.  We did "strongly consider
> the consequences" and disabled it by default, no need to scare the
> user about it now.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
> index 5c885f9..a8cacc7 100644
> --- a/misc/tune2fs.8.in
> +++ b/misc/tune2fs.8.in
> @@ -134,17 +134,6 @@ Staggering the mount-counts at which filesystems are forcibly
>  checked will avoid all filesystems being checked at one time
>  when using journaled filesystems.
>  .sp
> -You should strongly consider the consequences of disabling
> -mount-count-dependent checking entirely.  Bad disk drives, cables,
> -memory, and kernel bugs could all corrupt a filesystem without
> -marking the filesystem dirty or in error.  If you are using
> -journaling on your filesystem, your filesystem will
> -.B never
> -be marked dirty, so it will not normally be checked.  A
> -filesystem error detected by the kernel will still force
> -an fsck on the next reboot, but it may already be too late
> -to prevent data loss at that point.
> -.sp
>  See also the
>  .B \-i
>  option for time-dependent checking.
> 

There is one more paragraph about this in the section about -i option.
Also I'd not remove it entirely, but adding a note of possible benefits
of this setting as well as disadvantages.

-Lukas
