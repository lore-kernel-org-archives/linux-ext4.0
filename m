From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH] ext4: FLEX_BG Kernel support v2.
Date: Fri, 21 Sep 2007 13:29:27 -0700
Message-ID: <1190406567.13955.1.camel@dyn9047017100.beaverton.ibm.com>
References: <20070921140649.4352.30055.stgit@toolssf2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:41938 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbXIUU0d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 16:26:33 -0400
In-Reply-To: <20070921140649.4352.30055.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-09-21 at 09:06 -0500, Jose R. Santos wrote:
> From: Jose R. Santos <jrs@us.ibm.com>
> 
> ext4: FLEX_BG Kernel support v2.
> 

> @@ -702,13 +702,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
>  #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
>  #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
>  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
> +#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200

Any reason why 0x100 is skipped ?

Thanks,
Badari
