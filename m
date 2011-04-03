From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] x86, defconfig: replace ext3 with ext4
Date: Sun, 3 Apr 2011 15:22:08 +0200
Message-ID: <20110403132208.GC5141@quack.suse.cz>
References: <20110401074548.17629.77638.stgit@localhost6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab1DDAhg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 20:37:36 -0400
Content-Disposition: inline
In-Reply-To: <20110401074548.17629.77638.stgit@localhost6>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 01-04-11 11:45:48, Konstantin Khlebnikov wrote:
> Replace ext3 with ext4, because now it is a de facto standard file system.
> And set CONFIG_EXT4_USE_FOR_EXT23=y to use it also for mounting ext2/ext3.
  I'm sorry but I think it's too early for CONFIG_EXT4_USE_FOR_EXT23 part.
Although ext4 can handle ext3 and is stable, I believe there hasn't been
enough testing of ext4 code used as ext3 replacement. Some of the code
paths used for handling of ext3 are different from those used for ext4 and
there could be bugs lurking. Also ext4 has some slight differences in
performance and behavior in corner cases to ext3 which can potentially
screw users. I'm not saying these differences are showstoppers but we
should at least (try to) identify them before exposing users to them.

Actually, I want to speak to some people about this this week at LSF to get
some concensus on what exactly needs to be done so that we can replace
ext[23] with ext4.

									Honza

> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  arch/x86/configs/i386_defconfig   |    9 +++++----
>  arch/x86/configs/x86_64_defconfig |    9 +++++----
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> index 6f98726..cb8268c 100644
> --- a/arch/x86/configs/i386_defconfig
> +++ b/arch/x86/configs/i386_defconfig
> @@ -269,10 +269,11 @@ CONFIG_RTC_CLASS=y
>  CONFIG_DMADEVICES=y
>  CONFIG_EEEPC_LAPTOP=y
>  CONFIG_EFI_VARS=y
> -CONFIG_EXT3_FS=y
> -# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> -CONFIG_EXT3_FS_POSIX_ACL=y
> -CONFIG_EXT3_FS_SECURITY=y
> +CONFIG_EXT4_FS=y
> +CONFIG_EXT4_USE_FOR_EXT23=y
> +CONFIG_EXT4_FS_XATTR=y
> +CONFIG_EXT4_FS_POSIX_ACL=y
> +CONFIG_EXT4_FS_SECURITY=y
>  CONFIG_QUOTA=y
>  CONFIG_QUOTA_NETLINK_INTERFACE=y
>  # CONFIG_PRINT_QUOTA_WARNING is not set
> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> index ee01a9d..033ec9a 100644
> --- a/arch/x86/configs/x86_64_defconfig
> +++ b/arch/x86/configs/x86_64_defconfig
> @@ -270,10 +270,11 @@ CONFIG_RTC_CLASS=y
>  CONFIG_DMADEVICES=y
>  CONFIG_EEEPC_LAPTOP=y
>  CONFIG_EFI_VARS=y
> -CONFIG_EXT3_FS=y
> -# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> -CONFIG_EXT3_FS_POSIX_ACL=y
> -CONFIG_EXT3_FS_SECURITY=y
> +CONFIG_EXT4_FS=y
> +CONFIG_EXT4_USE_FOR_EXT23=y
> +CONFIG_EXT4_FS_XATTR=y
> +CONFIG_EXT4_FS_POSIX_ACL=y
> +CONFIG_EXT4_FS_SECURITY=y
>  CONFIG_QUOTA=y
>  CONFIG_QUOTA_NETLINK_INTERFACE=y
>  # CONFIG_PRINT_QUOTA_WARNING is not set
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
