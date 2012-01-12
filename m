From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] vfs: Protect write paths by sb_start_write -
 sb_end_write
Date: Thu, 12 Jan 2012 21:11:21 +0100
Message-ID: <20120112201121.GD8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <1326331253-6497-3-git-send-email-jack@suse.cz>
 <FA7A1011-4312-4050-8AD5-C6060CFF3A55@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2ALULW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 15:11:22 -0500
Content-Disposition: inline
In-Reply-To: <FA7A1011-4312-4050-8AD5-C6060CFF3A55@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-01-12 12:56:01, Andreas Dilger wrote:
> On 2012-01-11, at 6:20 PM, Jan Kara wrote:
> > There are three entry points which dirty pages in a filesystem.  mmap (handled
> > by block_page_mkwrite()), buffered write (handled by
> > __generic_file_aio_write()), and truncate (it can dirty last partial page -
> > handled by do_truncate()). Protect these places with sb_start_write() and
> > sb_end_write().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/buffer.c  |   18 ++----------------
> > fs/open.c    |    6 ++++++
> > mm/filemap.c |    3 ++-
> > 3 files changed, 10 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 19d8eb7..8519405 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -2371,18 +2371,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
> 
> The comment for __block_page_mkwrite() needs to be updated to reference
> sb_start_write() and sb_end_write() instead of vfs_check_frozen().
  Thanks. Fixed.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
