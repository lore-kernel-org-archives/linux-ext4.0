Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35106 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbeKPE0F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 23:26:05 -0500
Date: Thu, 15 Nov 2018 13:17:08 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Li Dongyang <dongyangli@ddn.com>
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca
Subject: Re: [v2] e2fsck: check xattr 'system.data' before setting
 inline_data feature
Message-ID: <20181115181708.GA19411@thunk.org>
References: <20181113044603.1089-1-dongyangli@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113044603.1089-1-dongyangli@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 13, 2018 at 03:46:03PM +1100, Li Dongyang wrote:
> ext2fs_inline_data_size will happy return 0 and set size to
> EXT4_MIN_INLINE_DATA_SIZE even when inode doesn't have
> xattr 'system.data', a corrupted i_flags could make e2fsck
> enable the inline_data on the superblock.
> 
> We should only offer to enable inline_data when i_flags is set
> and xattr 'system.data' can be found.
> 
> Also use correct prompt for PR_1_INLINE_DATA_FEATURE.
> 
> Signed-off-by: Li Dongyang <dongyangli@ddn.com>

Thanks, applied.

					- Ted
