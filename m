From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Add INCLUDES to BUILD_CFLAGS when
 cross-compiling
Date: Sat, 5 Jul 2014 19:55:42 -0400
Message-ID: <20140705235542.GA19036@thunk.org>
References: <1401832319-2247-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47078 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaGEXzr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 19:55:47 -0400
Content-Disposition: inline
In-Reply-To: <1401832319-2247-1-git-send-email-gustavo@zacarias.com.ar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 03, 2014 at 06:51:59PM -0300, Gustavo Zacarias wrote:
> We need $INCLUDES in BUILD_CFLAGS otherwise cross-compilation is broken
> now that util/subst.c uses config.h (from commit 2873927d15).
> 
> Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
> ---
>  configure.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.in b/configure.in
> index 448a292..8bac870 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -1382,7 +1382,7 @@ if test $cross_compiling = no; then
>     BUILD_CFLAGS="$CFLAGS $CPPFLAGS $INCLUDES -DHAVE_CONFIG_H"
>     BUILD_LDFLAGS="$LDFLAGS"
>  else
> -   BUILD_CFLAGS=
> +   BUILD_CFLAGS="$INCLUDES -DHAVE_CONFIG_H"

I would think that

BUILD_CFLAGS="-I$(top_builddir)/lib -DHAVE_CONFIG_H"

... would be safer, since $INCLUDES could potentially include some
$CPPFLAGS that could be specific to the target architecture.

Yes?

						- Ted
