Return-Path: <SRS0=YR0o=WP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF1F0C3A59B
	for <linux-ext4@archiver.kernel.org>; Mon, 19 Aug 2019 04:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F542087E
	for <linux-ext4@archiver.kernel.org>; Mon, 19 Aug 2019 04:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbfHSEje (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:39:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56464 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725308AbfHSEje (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Aug 2019 00:39:34 -0400
Received: from callcc.thunk.org ([12.235.16.3])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x7J4dP5K019002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Aug 2019 00:39:27 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 20FC6420843; Mon, 19 Aug 2019 00:39:25 -0400 (EDT)
Date:   Mon, 19 Aug 2019 00:39:25 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Dongyang Li <dongyangli@ddn.com>
Cc:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger@dilger.ca" <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] libext2fs: optimize
 ext2fs_convert_subcluster_bitmap()
Message-ID: <20190819043925.GC10349@mit.edu>
References: <20190816034834.29439-1-dongyangli@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816034834.29439-1-dongyangli@ddn.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 16, 2019 at 03:49:12AM +0000, Dongyang Li wrote:
> @@ -28,6 +28,7 @@
>  #ifdef HAVE_SYS_TIME_H
>  #include <sys/time.h>
>  #endif
> +#include <sys/param.h>
>  
>  #include "ext2_fs.h"
>  #include "ext2fsP.h"

Please don't don't depend on <sys/param.h> for definitions of macros
like roundup().  It's not going to be present on all OS's, and
e2fsprogs needs to be portable to more systems than just Linux.

Furthermore, if you look in ext2fs.h, we already have the macros:

#define EXT2FS_B2C(fs, blk) 	      ((blk) >> (fs)->cluster_ratio_bits)
#define EXT2FS_C2B(fs, cluster)	   ((cluster) << (fs)->cluster_ratio_bits)

... which translates a block to a cluster number and vice versa.
(Note that the cluster:block ratio is always a power of two.)

So instead of this:

> +		i = bmap->start + roundup(next - bmap->start + 1, ratio);

you can do this:

		i = EXT2FS_C2B(fs, EXT2FS_B2C(fs, next) + 1);

cheers,

					- Ted
