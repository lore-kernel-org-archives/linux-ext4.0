From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH 1/2] ext4: introduce new i_write_mutex to protect fallocate
Date: Tue, 27 May 2014 11:12:57 +0900
Message-ID: <001201cf7951$2d6f6260$884e2720$@samsung.com>
References: <001701cf6e40$fab98be0$f02ca3a0$@samsung.com>
 <20140526162900.GI22284@thunk.org> <20140527015959.GO22284@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: 'linux-ext4' <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Theodore Ts'o' <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26281 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaE0CM7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2014 22:12:59 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6700A3VNHMLM60@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 27 May 2014 11:12:58 +0900 (KST)
In-reply-to: <20140527015959.GO22284@thunk.org>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mon, May 26, 2014 at 12:29:00PM -0400, Theodore Ts'o wrote:
> > On Tue, May 13, 2014 at 09:19:17AM +0900, Namjae Jeon wrote:
> > > Introduce new i_write_mutex to protect new writes from coming while doing
> > > fallocate operations. Also, get rid of aio_mutex as it is covered by
> > > i_write_mutex.
> > >
> > Thanks, applied.
> >
> 
> I had to apply the following fix up patch, or else running generic/308
> using the ext3 config would end up returning to userspace with
> i_write_mutex still locked.
> 
> For all ext4 developers: please consider running at least
> "kvm-xfstests -g quick" (which would have shown this issue), or better
> yet, "kvm-xfstests -g auto" before sending patches.  It finds problems
> like this.  :-)
Hi Ted.

Sorry for my mistake... I will carefully test it next time. :)

Thanks a lot!!
> 
> Cheers,
> 
> 					- Ted
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 8c39305..e5cd87f 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -135,8 +135,8 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		if ((pos > sbi->s_bitmap_maxbytes) ||
>  		    (pos == sbi->s_bitmap_maxbytes && length > 0)) {
>  			mutex_unlock(&inode->i_mutex);
> -			ret = -EFBIG;
> -			goto errout;
> +			mutex_unlock(&EXT4_I(inode)->i_write_mutex);
> +			return -EFBIG;
>  		}
> 
>  		if (pos + length > sbi->s_bitmap_maxbytes) {
> @@ -196,7 +196,6 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	if (o_direct)
>  		blk_finish_plug(&plug);
> 
> -errout:
>  	if (unaligned_direct_aio)
>  		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
>  	return ret;

