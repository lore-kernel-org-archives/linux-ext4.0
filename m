From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: Simple man page nodiscard option correction
Date: Wed, 16 Feb 2011 11:38:31 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1102161138230.4744@dhcp-27-109.brq.redhat.com>
References: <1296579401-27203-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@MIT.EDU
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab1BPKif (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 05:38:35 -0500
In-Reply-To: <1296579401-27203-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 1 Feb 2011, Lukas Czerner wrote:

> It is not true that 'nodiscard' is set as default, so remove this
> sentence. The default is 'discard' and it is properly documented in man
> page.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  misc/mke2fs.8.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 2eead17..4a3b0c3 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -247,7 +247,7 @@ zeroed. This significantly speeds up filesystem initialization. This is set
>  as default.
>  .TP
>  .BI nodiscard
> -Do not attempt to discard blocks at mkfs time. This is the default.
> +Do not attempt to discard blocks at mkfs time.
>  .RE
>  .TP
>  .BI \-f " fragment-size"
> 

ping
