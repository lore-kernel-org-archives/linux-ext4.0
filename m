Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD751C7EE25
	for <linux-ext4@archiver.kernel.org>; Fri,  9 Jun 2023 13:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbjFINUr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 9 Jun 2023 09:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241476AbjFINUh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jun 2023 09:20:37 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 06:20:22 PDT
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BF4E3C16;
        Fri,  9 Jun 2023 06:20:22 -0700 (PDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 62C8672C90B;
        Fri,  9 Jun 2023 16:03:52 +0300 (MSK)
Received: from glebfm.altlinux.org (flight.tilaa.cloud [84.22.108.118])
        by imap.altlinux.org (Postfix) with ESMTPSA id 020EB36D070B;
        Fri,  9 Jun 2023 16:03:51 +0300 (MSK)
Date:   Fri, 9 Jun 2023 13:03:39 +0000
From:   Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v3] ext4: Add a uapi header for ext4 userspace APIs
Message-ID: <ZIMjGKQdalBAeyQJ@glebfm.altlinux.org>
References: <680175260970d977d16b5cc7e7606483ec99eb63.1680402881.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <680175260970d977d16b5cc7e7606483ec99eb63.1680402881.git.josh@joshtriplett.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

On Sun, Apr 02, 2023 at 11:37:42AM +0900, Josh Triplett wrote:
> Create a uapi header include/uapi/linux/ext4.h, move the ioctls and
> associated data structures to the uapi header, and include it from
> fs/ext4/ext4.h.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> Sorry for the churn; I didn't encounter these errors in local
> test builds.
> 
> v2:
> - Add UAPI header to MAINTAINERS
> - Fix include paths in UAPI header
> - Formatting fix for EXT4_IOC_SHUTDOWN
> 
> v3:
> - Leave compat ioctls in the private ext4.h header. It appears that some other
>   UAPI headers already follow this pattern, with compat defined privately. For
>   instance, quota and ethtool both follow that pattern.

Do you intend to keep the compat ioctl definitions in the private header?

[...]
> --- /dev/null
> +++ b/include/uapi/linux/ext4.h
[...]
> +/*
> + * ioctl commands in 32 bit emulation
> + */
> +#define EXT4_IOC32_GETVERSION		_IOR('f', 3, int)
> +#define EXT4_IOC32_SETVERSION		_IOW('f', 4, int)
> +#define EXT4_IOC32_GETRSVSZ		_IOR('f', 5, int)
> +#define EXT4_IOC32_SETRSVSZ		_IOW('f', 6, int)
> +#define EXT4_IOC32_GROUP_EXTEND		_IOW('f', 7, unsigned int)
> +#define EXT4_IOC32_GROUP_ADD		_IOW('f', 8, struct compat_ext4_new_group_input)

It appears that the ioctl definition for EXT4_IOC32_GROUP_ADD is provided,
but there is no corresponding definition for the
compat_ext4_new_group_input structure nowhere in the uapi headers.

-- 
glebfm
