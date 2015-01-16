From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v8 2/11] xfs: Add support FALLOC_FL_INSERT_RANGE for
 fallocate
Date: Fri, 16 Jan 2015 16:26:36 +0900
Message-ID: <005101d0315d$c31ad6e0$495084a0$@samsung.com>
References: <1421165126-3585-1-git-send-email-linkinjeon@gmail.com>
 <1421165126-3585-3-git-send-email-linkinjeon@gmail.com>
 <20150115122906.GC18876@bfoster.bfoster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: david@fromorbit.com, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, a.sangwan@samsung.com
To: 'Brian Foster' <bfoster@redhat.com>,
	'Namjae Jeon' <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62055 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbAPH0j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Jan 2015 02:26:39 -0500
In-reply-to: <20150115122906.GC18876@bfoster.bfoster>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, Jan 14, 2015 at 01:05:17AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
> >
> > 1) Make sure that both offset and len are block size aligned.
> > 2) Update the i_size of inode by len bytes.
> > 3) Compute the file's logical block number against offset. If the computed
> >    block number is not the starting block of the extent, split the extent
> >    such that the block number is the starting block of the extent.
> > 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
> >    towards right by len bytes. This step will make a hole of len bytes
> >    at offset.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> 
> Fixes look good (I assume nothing else changed between the few nits
> called out in v7) and survives overnight fsstress and fsx testing
> without any explosions:
Yes, I am also running test for long time, If there is any issue, will share.
Thanks for your review and help :)
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 

