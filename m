From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] filefrag: fix GCC7.x compiler warning
Date: Wed, 28 Jun 2017 13:28:02 -0400
Message-ID: <20170628172802.uxfxoqxkko6a7wko@thunk.org>
References: <856ed7be-9cb4-eb8d-1ce5-3f07adf600b6@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55354 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdF1Uj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Jun 2017 16:39:27 -0400
Content-Disposition: inline
In-Reply-To: <856ed7be-9cb4-eb8d-1ce5-3f07adf600b6@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 26, 2017 at 04:39:47PM +0100, Marc Thomas wrote:
> ../../misc/filefrag.c:591:33: warning: comparison between pointer and
> zero character constant [-Wpointer-compare]
>   for (cpp = argv + optind; *cpp != '\0'; cpp++) {
> 
> Signed-off-by: Marc Thomas <marc@dragonfly.plus.com>

The patch was corrutped somehow, but I applied the fix.

Thanks,

					- Ted
