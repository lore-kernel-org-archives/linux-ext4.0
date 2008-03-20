From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Thu, 20 Mar 2008 11:16:19 +0300
Message-ID: <20080320081619.GB13928@dmon-lap.sw.ru>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr> <47E1CE7F.6050706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:47630 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYCTIWv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 04:22:51 -0400
Content-Disposition: inline
In-Reply-To: <47E1CE7F.6050706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 21:39 Wed 19 Mar     , Eric Sandeen wrote:
> Solofo.Ramangalahy@bull.net wrote:
> > Hello,
> > 
> > During stress testing (workload: racer from ltp + fio/iometer), here
> > is an error I am encountering:
> > 8<------------------------------------------------------------------------------
> > kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()
> 
> So this is WARN_ON(bh->b_size != blocksize);
> 
> What is b_size in this case?
FS block size, because this page pinned bh (it comes from page_buffers(page)), but
not dummy bh which may comes from {write,read}pages or direct_IO. 
Page's bh i_size must always be equal to fs blocksize.
This bh always constructed via following construction
if (!page_has_buffers(page))
	create_empty_buffers(page, 1<<inode->i_blkbits, flags)
So page's bh->b_size was inited with right value from very beginning, but
apparently somewhere this size was changed 
I guess i've localized buggy place, at least it's looks strange.
ext4_da_get_block_prep ()
{
...
	BUG_ON(create == 0);
        BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
	ret =  ext4_get_blocks_wrap(NULL,  inode, iblock, 1,  bh_result, 0, 0);
#Here ext4_get_block_write called with max_blocks == 1  ^^^^^
	...
	if (ret > 0) {
                        bh_result->b_size = (ret << inode->i_blkbits);
	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
## I don't understand this place. I hoped what (ret <= max_blocks) must always
##be true true. But after I've add debug info printing I've got following result.
                ret = 0;
        }
...
}
Some times I've seen following ,message 
 bh= {state=0,size=114688, blknr=18446744073709551615 dev=0000000000000000,count=0}, ret=28
And because it was page-cache's bh later this result in WARNING.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
