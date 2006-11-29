From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: a question about ext4_fsblk_t
Date: Tue, 28 Nov 2006 17:13:35 -0800
Message-ID: <1164762815.6538.96.camel@dyn9047017103.beaverton.ibm.com>
References: <200610220858.k9M8wWHv013173@nrchpc.ac.cn>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49610 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1758570AbWK2BNh
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 20:13:37 -0500
To: guomingyang@nrchpc.ac.cn
In-Reply-To: <200610220858.k9M8wWHv013173@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On Sun, 2006-10-22 at 16:50 +0800, guomingyang wrote:
> 
>    I also find many places where the block number type is not changed in namei.c and dir.c. Why? 

They are all file logical blocks, ext4_fsblk_t is for on disk blocks.

Takashi Sato has a patch to define all file logical blocks as
ext3_fileblk_t, it did not make to mainline before ext4 was forked.
Probably we should bring the to ext3/4 to clarify the confusions.

Mingming
>    Thank you to anyone who offer help
> >Hello everyone:
> >
> >		I am a student interesting in linux filesystem, I have a problem about the replace of block number type to ext4_fsblk_t. Is it complete? Or has it passed all the test? Because I have found a place like this in linux-2.6.19-rc2/fs/ext4/inode.c 
> >
> >
> >
> >+struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
> >+                               int block, int create, int *err)
> >
> >
> >the block's type is not changed. Although I think it will bring no mistake, I doubt about why not change it. Thank you !
> >


> >
> >guomingyang
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> guomingyang
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
