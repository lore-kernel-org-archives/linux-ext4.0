Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38772 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387882AbeKVKKR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Nov 2018 05:10:17 -0500
Date: Wed, 21 Nov 2018 18:33:38 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: alexey.lyashkov@gmail.com
Cc: linux-ext4@vger.kernel.org,
        Alexey Lyashkov <alexey.lyashkov@seagate.com>
Subject: Re: [PATCH 1/3] block number output fix.
Message-ID: <20181121233338.GD10588@thunk.org>
References: <20181119091650.81803-1-alexey.lyashkov@gmail.com>
 <20181119091650.81803-2-alexey.lyashkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119091650.81803-2-alexey.lyashkov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2018 at 12:16:48PM +0300, alexey.lyashkov@gmail.com wrote:
> 
> debugfs lack a support journal tag v3 and block numbers over 2^32
> fix it.

This file is missing a Signed-off-by trailer.

Also please use a subject prefix of "debugfs: " for these patches,
since they are related to debugfs.  I also prefer not having a
trailing period, and use a more descriptive summary so that it's more
understandable what the commit will do when using "git log --oneline".

So, something like:

debugfs: fix logdump to support 64-bit block numbers with v3 journal tags

Thanks,

					- Ted
