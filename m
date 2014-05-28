From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH] ext4: fix missing unlock on error in collapse range
Date: Wed, 28 May 2014 09:15:00 +0900
Message-ID: <000501cf7a09$dd420720$97c61560$@samsung.com>
References: <000601cf793f$e5377070$afa65150$@samsung.com>
 <20140527164820.GC1158@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Dan Carpenter' <dan.carpenter@oracle.com>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:24429 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaE1APC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 May 2014 20:15:02 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6900F38CP0WX90@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 28 May 2014 09:15:00 +0900 (KST)
In-reply-to: <20140527164820.GC1158@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
> On Tue, May 27, 2014 at 09:09:15AM +0900, Namjae Jeon wrote:
> > Add i_write_mutex unlock on the error handling path in collapse_range().
> >
> > Cc: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/extents.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Thanks for the patch!
> 
> This is the increment diff which I'm going to apply instead.  It
> results in a net decrease of one line of code, instead of a net
> increase of two, and it is more consistent in terms of the error
> handling style.
Yes, Right. Thanks Ted!
> 
> Cheers,
> 
> 					- Ted
> 
>  fs/ext4/extents.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 8ffab40..cb23a34 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5423,10 +5423,8 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	/* Call ext4_force_commit to flush all data in case of data=journal. */
>  	if (ext4_should_journal_data(inode)) {
>  		ret = ext4_force_commit(inode->i_sb);
> -		if (ret) {
> -			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
> -			return ret;
> -		}
> +		if (ret)
> +			goto out_i_write_mutex;
>  	}
> 
>  	/*
> @@ -5439,7 +5437,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset,
>  					   LLONG_MAX);
>  	if (ret)
> -		return ret;
> +		goto out_i_write_mutex;
> 
>  	/* Take mutex lock */
>  	mutex_lock(&inode->i_mutex);
> @@ -5512,6 +5510,7 @@ out_dio:
>  	ext4_inode_resume_unlocked_dio(inode);
>  out_mutex:
>  	mutex_unlock(&inode->i_mutex);
> +out_i_write_mutex:
>  	mutex_unlock(&EXT4_I(inode)->i_write_mutex);
>  	return ret;
>  }

