Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53146 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbeKZOeW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 09:34:22 -0500
Date: Sun, 25 Nov 2018 22:41:32 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, ebiggers@kernel.org
Subject: Re: [f2fs-dev] [PATCH 2/7] f2fs: use IS_ENCRYPTED() to check
 encryption status
Message-ID: <20181126034132.GC7904@thunk.org>
References: <20181119052324.31456-1-chandan@linux.vnet.ibm.com>
 <20181119052324.31456-3-chandan@linux.vnet.ibm.com>
 <20181119212332.GB33805@jaegeuk-macbookpro.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119212332.GB33805@jaegeuk-macbookpro.roam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2018 at 01:23:32PM -0800, Jaegeuk Kim wrote:
> Hi Chandan,
> 
> Let me try to queue and test this patch separately from the patch-set in order
> to avoid merge conflicts. So, I think IS_ENCRYPTED should be merged in f2fs/ext4
> branches, and the others can be applied to fscrypt and fsverity into each trees.

Hi Jaeguk,

What conflicts are you anticipating?  I can't apply the rest of
Chandan's patches without unless we apply them in order, and I'd
prefer to avoid cross-merging, or spreading out this series across two
kernel releases.

						- Ted
