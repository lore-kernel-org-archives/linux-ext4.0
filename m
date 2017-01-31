From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v2] mke2fs: fix coping of empty file using fiemap
Date: Mon, 30 Jan 2017 21:52:36 -0500
Message-ID: <20170131025236.as4fvucj7qqphqef@thunk.org>
References: <CAO3qy=EeD4y6cX3JaA4ZKptoL9JH0Kc9zYqPWj-UZ+ythC6LXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47152 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdAaDaC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 22:30:02 -0500
Content-Disposition: inline
In-Reply-To: <CAO3qy=EeD4y6cX3JaA4ZKptoL9JH0Kc9zYqPWj-UZ+ythC6LXw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 17, 2017 at 06:14:19PM +0300, Artem Blagodarenko wrote:
> Hello,
> 
> Darrick J. Wong, thank you for inspection. Here is second version of the patch.
> 
> Changes since v1:
> * errno is returned in case failed ioctl
> * loop is terminated any time fm_mapped_extents == 0
> 
> During filesystem creation with -d option files copied from given
> directory. If supported, FS_IOC_FIEMAP ioctl is used to get file
> extents. For empty file fm_mapped_extents is 0 and no error code
> is returned, because this is not fail situation.
> 
> Without this patch errno from previous operation is returned and
> successful FS_IOC_FIEMAP ioctl call for empty file is interpreted
> as error.
> 
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
