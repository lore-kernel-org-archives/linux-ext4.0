From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Wed, 21 Jul 2010 08:55:51 -0500
Message-ID: <4C46FC67.4000900@redhat.com>
References: <20100715105745.GI30737@dastard> <20100719224512.GD32635@dastard> <20100721063222.GW32635@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab0GUN4J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jul 2010 09:56:09 -0400
In-Reply-To: <20100721063222.GW32635@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dave Chinner wrote:

> Ok, so now I know *why* that one filesystem got busted - I built a
> kernel without CONFIG_EXT3_DEFAULTS_TO_ORDERED set and it got a
> forced reboot (echo b > proc/sysrq-trigger). That'll teach me for
> trying to reproduce bugs Andrew is tripping over with his config
> files.
> 
> Quite frankly, data=writeback mode for ext3 is a dangerous,
> dangerous configuration to run by default. IMO, it shouldn't be the
> default. Patch below.

I agree, though I might just remove the config option altogether,
it just obfuscates what's going on, IMHO.

Still, as far as it goes, you can add:

Acked-by: Eric Sandeen <sandeen@redhat.com>

to the patch.

-Eric

> ext3: default to ordered mode
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> data=writeback mode is dangerous and is leads to filesystem
> corruption, data loss and stale data exposure when systems crash. It
> should not be the default, especially when all major distros ensure
> their ext3 filesystems default to ordered mode. Change the default
> mode to the safer data=ordered mode, because we should be caring
> far more about avoiding corruption than performance.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/ext3/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
> index 522b154..e8c6ba0 100644
> --- a/fs/ext3/Kconfig
> +++ b/fs/ext3/Kconfig
> @@ -31,6 +31,7 @@ config EXT3_FS
>  config EXT3_DEFAULTS_TO_ORDERED
>  	bool "Default to 'data=ordered' in ext3"
>  	depends on EXT3_FS
> +	default y
>  	help
>  	  The journal mode options for ext3 have different tradeoffs
>  	  between when data is guaranteed to be on disk and

