From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] ext3: set i_extra_isize of 11th inode
Date: Mon, 23 Aug 2010 09:16:58 +0900
Message-ID: <20100823091657.ACB6.61FB500B@jp.fujitsu.com>
References: <20100820112011.E6FA.61FB500B@jp.fujitsu.com> <0347DFC8-03A9-45DF-9B9F-ED4005720C49@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38530 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0HWARJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Aug 2010 20:17:09 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7N0H7xk027431
	for <linux-ext4@vger.kernel.org> (envelope-from m.mizuma@jp.fujitsu.com);
	Mon, 23 Aug 2010 09:17:08 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 998B93A62C2
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:17:07 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 75A461EF086
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:17:07 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 5324C1DB8016
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:17:07 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.249.87.104])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id CA1551DB8012
	for <linux-ext4@vger.kernel.org>; Mon, 23 Aug 2010 09:17:06 +0900 (JST)
In-Reply-To: <0347DFC8-03A9-45DF-9B9F-ED4005720C49@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 20 Aug 2010 01:42:25 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> On 2010-08-19, at 20:20, Masayoshi MIZUMA wrote:
> > In ext3 filesystem, if following conditions 1., 2., 3. and 4. is satisfied,
> > getfattr can't search the extended attribute (EA) after remount.
> > 
> > This happens because of following logic:
> >    i_extra_isize is set to over 0 by ext3_new_inode() when we create
> >    a file whose inode number is 11 after removing "lost+found". 
> >    Therefore setfattr creates the EA in-inode.
> >    After remount, i_extra_isize of 11th inode is set to 0 by ext3_iget()
> >    when we lookup the file, so getfattr tries to search the EA out-inode.
> >    However, the EA locates in-inode, so getfattr can't search the EA.
> 
> This was a workaround for a bug in mke2fs a couple of years ago, and is probably no longer needed.
I understand it. Thanks.

> 
> > @@ -2881,8 +2881,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
> > 		atomic_set(&ei->i_datasync_tid, tid);
> > 	}
> > 
> > -	if (inode->i_ino >= EXT3_FIRST_INO(inode->i_sb) + 1 &&
> > -	    EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
> > +	if (EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) {
> > 		/*
> > 		 * When mke2fs creates big inodes it does not zero out
> > 		 * the unused bytes above EXT3_GOOD_OLD_INODE_SIZE,
> 
> This should also remove the above comment, which is no longer relevant.
OK. I will resend the patch which is removed the above comment.

Thanks,
Masayoshi

