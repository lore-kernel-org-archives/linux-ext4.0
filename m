From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: quotacheck on 'tune2fs -O quota'
Date: Mon, 7 Nov 2011 21:38:36 +0100
Message-ID: <20111107203836.GB3191@granier.hd.free.fr>
References: <4EB224A9.8030606@whamcloud.com>
 <CAGr1F2FMvsZ6eLJid4z0RpJcAm5paEfbJwrtFE7iqbr_bA4BTA@mail.gmail.com>
 <20111104090356.GC6205@granier.hd.free.fr>
 <CAGr1F2FQ=MAqd8NiamZ39K9dX8YC_JiaUszFod3tG=CK+W0GGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49016 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1KGUmq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 15:42:46 -0500
Received: by wyh15 with SMTP id 15so4905473wyh.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 12:42:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAGr1F2FQ=MAqd8NiamZ39K9dX8YC_JiaUszFod3tG=CK+W0GGQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 04, 2011 at 09:48:09AM -0700, Aditya Kali wrote:
> On Fri, Nov 4, 2011 at 2:03 AM, Johann Lombardi <johann@whamcloud.com> wrote:
> > The old quota files also contain enforcement information which will thus be lost.
> > To sum up, there is no way to upgrade without losing all quota limits?
> >
> I agree it would be useful to allow upgrades using existing quota
> files. I just didn't have a way of doing this correctly though so I
> had removed it. But this patch fixes it, so I am all for including it.

Great, thanks.

> Niu, could you please rebase your changes on top of the cleanup
> changes that I had sent?  Also, I will prefer if you split this patch
> into two patches-
> 1) to add support for reading existing quota files
> 2) do a quota check at tune2fs time

Niu has resubmitted the patches.

Cheers,
Johann
