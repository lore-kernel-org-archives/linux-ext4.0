From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] mke2fs: check that auto-detected blocksize <= sys_page_size
Date: Wed, 8 Jun 2011 15:50:10 +0300
Message-ID: <BANLkTikGv=OZgV0iwZroDDnPi+TiyxDzVg@mail.gmail.com>
References: <1307524998.2467.41.camel@newpride>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Yury V. Zaytsev" <yury@shurup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65157 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1FHMuL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 08:50:11 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so326931wya.19
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jun 2011 05:50:11 -0700 (PDT)
In-Reply-To: <1307524998.2467.41.camel@newpride>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 12:23 PM, Yury V. Zaytsev <yury@shurup.com> wrote:
> Hi!
>
> I have recently stumbled upon a RHEL6.1 installation problem on an SSD
> drive that was working fine with older kernels, where created file
> systems could not be mounted and the installation was aborting.
>
> It turned out that the drive had a firmware bug and was exposing a
> minimum_io_size of 8912, whereas my x86_64 system had a page size of
> 4096 bytes.
>
> mkfs in turn was silently creating file systems with 8912 bytes block
> size, because it was auto-detected as opposed to specified via the -b
> option from the command line.
>
> This made the problem hard to debug, hence I attach a tentative patch to
> fix this issue. I'd like to acknowledge Mike Snitzer for directing me to
> this list.
>
> I'm not subscribed, so please CC: me upon replies and be mindful that
> it's my first contribution of this kind, so even though I did my best to
> do it the right way, I might have screwed something up.

The only thing you screwed up is sending the patch as an attachment.
People here expect it to be as plain text in the email, so that they can
reply and comment inline.
Other than that, the fix looks good (and well explained) to me.

Cheers,
Amir.

>
> Thanks!
>
> --
> Sincerely yours,
> Yury V. Zaytsev
>
>
