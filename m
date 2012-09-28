From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [ext4:dev 47/50] fs/ext4/indirect.c:1799 ext4_ind_punch_hole()
 warn: inconsistent returns mutex:&inode->i_mutex: locked (1710) unlocked
 (1799)
Date: Fri, 28 Sep 2012 15:37:45 +0800
Message-ID: <20120928073744.GB8544@gmail.com>
References: <20120928060719.GA15218@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, kernel-janitors@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36747 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2I1H1G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Sep 2012 03:27:06 -0400
Content-Disposition: inline
In-Reply-To: <20120928060719.GA15218@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 28, 2012 at 02:07:19PM +0800, Fengguang Wu wrote:
> Hi Zheng,
> 
> FYI, there are new smatch warnings show up in

Hi Fengguang,

It is my fault that it will return directly when it starts a transaction
and gets an error.  I will fix it in next version.  Thanks.

Regards,
Zheng

> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   b2f1a8e5612e2488a3995ec06b422b44651d088b
> commit: 3e1b02687146ddefa8e53c2a5e13d3bd87b16b09 [47/50] ext4: add support for hole punching non-extent-mapped files
> 
> + fs/ext4/indirect.c:1799 ext4_ind_punch_hole() warn: inconsistent returns mutex:&inode->i_mutex: locked (1710) unlocked (1799)
> 
> vim +1799 fs/ext4/indirect.c
> 
> 3e1b0268 (Zheng Liu      2012-09-28  1783) 	down_write(&EXT4_I(inode)->i_data_sem);
> 3e1b0268 (Zheng Liu      2012-09-28  1784) 	ext4_discard_preallocations(inode);
> 3e1b0268 (Zheng Liu      2012-09-28  1785) 
> 3e1b0268 (Zheng Liu      2012-09-28  1786) 	err = ext4_free_hole_blocks(handle, inode, offsets1, n1, offsets2, n2);
> 3e1b0268 (Zheng Liu      2012-09-28  1787) 
> 3e1b0268 (Zheng Liu      2012-09-28  1788) 	if (IS_SYNC(inode))
> 3e1b0268 (Zheng Liu      2012-09-28  1789) 		ext4_handle_sync(handle);
> 3e1b0268 (Zheng Liu      2012-09-28  1790) 
> 3e1b0268 (Zheng Liu      2012-09-28  1791) 	up_write(&EXT4_I(inode)->i_data_sem);
> 3e1b0268 (Zheng Liu      2012-09-28  1792) 
> 3e1b0268 (Zheng Liu      2012-09-28  1793) out:
> 3e1b0268 (Zheng Liu      2012-09-28  1794) 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> 3e1b0268 (Zheng Liu      2012-09-28  1795) 	ext4_mark_inode_dirty(handle, inode);
> 3e1b0268 (Zheng Liu      2012-09-28  1796) 	ext4_journal_stop(handle);
> 3e1b0268 (Zheng Liu      2012-09-28  1797) error:
> 3e1b0268 (Zheng Liu      2012-09-28  1798) 	mutex_unlock(&inode->i_mutex);
> 3e1b0268 (Zheng Liu      2012-09-28 @1799) 	return err;
> 3e1b0268 (Zheng Liu      2012-09-28  1800) }
