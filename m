Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34942 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbeKPEF4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 23:05:56 -0500
Date: Thu, 15 Nov 2018 12:57:04 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Li Dongyang <dongyangli@ddn.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: check xattr 'system.data' before setting
 inline_data feature
Message-ID: <20181115175704.GD20617@thunk.org>
References: <20181030061501.24406-1-dongyangli@ddn.com>
 <20181115175431.GC20617@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115175431.GC20617@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 15, 2018 at 12:54:31PM -0500, Theodore Y. Ts'o wrote:
> On Tue, Oct 30, 2018 at 05:15:01PM +1100, Li Dongyang wrote:
> > ext2fs_inline_data_size will happy return 0 and set size to
> > EXT4_MIN_INLINE_DATA_SIZE even when inode doesn't have
> > xattr 'system.data', a corrupted i_flags could make e2fsck
> > enable the inline_data on the superblock.
> > 
> > We should only offer to enable inline_data when i_flags is set
> > and xattr 'system.data' can be found.
> > 
> > Signed-off-by: Li Dongyang <dongyangli@ddn.com>
> 
> Thanks, applied.

Oops, I see there's a V2 version of this patch.

      	    	      	 	 - Ted
