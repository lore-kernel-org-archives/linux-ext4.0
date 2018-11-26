Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57042 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbeK0EbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 23:31:05 -0500
Date: Mon, 26 Nov 2018 12:36:15 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, ebiggers@kernel.org
Subject: Re: [PATCH 5/7] ext4: use IS_VERITY() to check inode's fsverity
 status
Message-ID: <20181126173615.GB22888@thunk.org>
References: <20181119052324.31456-1-chandan@linux.vnet.ibm.com>
 <20181119052324.31456-6-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119052324.31456-6-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2018 at 10:53:22AM +0530, Chandan Rajendra wrote:
> This commit now uses IS_VERITY() macro to check if fsverity is
> enabled on an inode.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

This patch causes a massive number of fsverity tests.  I suspect it's
due to a mismatch between the ext4's inode flags as opposed to the VFS
inode's flags.  I'll take a closer look in the next day or two.

Cheers,

						- Ted
