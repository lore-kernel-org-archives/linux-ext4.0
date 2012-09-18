From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: ext4: convert file system to meta_bg if needed during resizing
Date: Tue, 18 Sep 2012 19:52:22 +0800
Message-ID: <20120918115222.GA17551@localhost>
References: <20120918114634.GA12383@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab2IRLw3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 07:52:29 -0400
Content-Disposition: inline
In-Reply-To: <20120918114634.GA12383@elgon.mountain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 02:46:35PM +0300, Dan Carpenter wrote:
> Hello Theodore Ts'o,
> 
> The patch 1c6bd7173d66: "ext4: convert file system to meta_bg if 
> needed during resizing" from Sep 13, 2012, leads to the following 
> warning:
> fs/ext4/resize.c:1829 ext4_convert_meta_bg()
> 	 error: potential NULL dereference 'ei'.
> 
>   1770  static int ext4_convert_meta_bg(struct super_block *sb, struct inode *inode)
>   1771  {
>   1772          handle_t *handle;
>   1773          struct ext4_sb_info *sbi = EXT4_SB(sb);
>   1774          struct ext4_super_block *es = sbi->s_es;
>   1775          struct ext4_inode_info *ei = 0;
>                                         ^^^^^^
> Sparse is going to complain.  Not sure why Fengguang hasn't emailed you.

Sorry I'm doing lots of changes these days and they apparently break
many things.. I'd expect the build test system to gradually restore to
normal in the coming days.

Thanks,
Fengguang
