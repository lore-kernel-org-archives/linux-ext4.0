From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ext4: fixup 64-bit divides in linux-3.0 stable backport
 of upstream fix
Date: Fri, 5 Apr 2013 16:55:09 -0700
Message-ID: <20130405235509.GA13306@kroah.com>
References: <1365202463-25872-1-git-send-email-toddpoynor@google.com>
 <20130405230107.GA8412@kroah.com>
 <CAAW3YpbM7Vk_=qXv2NCgRsCkashsTpYC_6osA_udm2oDsiz5qA@mail.gmail.com>
 <20130405235018.GC6597@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Todd Poynor <toddpoynor@google.com>, stable@vger.kernel.org,
	Lingzhu Xiang <lxiang@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44871 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3DEXzM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Apr 2013 19:55:12 -0400
Received: by mail-pd0-f174.google.com with SMTP id p12so2245938pdj.5
        for <linux-ext4@vger.kernel.org>; Fri, 05 Apr 2013 16:55:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130405235018.GC6597@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 05, 2013 at 07:50:18PM -0400, Theodore Ts'o wrote:
> Greg,
> 
> The reason why Todd's patch is needed in 3.0 is because the code in
> question was nuked as of 3.2 by commit 4113c4caa4f355:
> 
> commit 4113c4caa4f355b8ff8b7ff0510c29c9d00d30b3
> Author: Lukas Czerner <lczerner@redhat.com>
> Date:   Sat Oct 8 14:34:47 2011 -0400
> 
>     ext4: remove deprecated oldalloc
>     
>     For a long time now orlov is the default block allocator in the
>     ext4. It performs better than the old one and no one seems to claim
>     otherwise so we can safely drop it and make oldalloc and orlov mount
>     option deprecated.
>     
>     This is a part of the effort to reduce number of ext4 options hence the
>     test matrix.
>     
>     Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> So the 64-bit divides aren't in the upstream kernel because the code
> in question is long gone in the mainline ext4 code.  It looks like Cai
> (who did the 3.0 backport) never tested the patch on a 32-bit build.
> 
> Thanks Todd, for providing the patch.  You can add my:
> 
> Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> to it.  Greg, could you apply it to the stable tree?   Thanks!!

Thanks for the review, will apply it for the next release, thanks.

greg k-h
