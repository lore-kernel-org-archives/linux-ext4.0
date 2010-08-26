From: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH] [RESEND] ext3: set i_extra_isize of 11th inode
Date: Thu, 26 Aug 2010 09:26:37 +0900
Message-ID: <20100826092636.C31C.61FB500B@jp.fujitsu.com>
References: <20100825090551.DEB3.61FB500B@jp.fujitsu.com> <20100825230442.GH2738@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40307 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0HZA0L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 20:26:11 -0400
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o7Q0Q9vY012403
	for <linux-ext4@vger.kernel.org> (envelope-from m.mizuma@jp.fujitsu.com);
	Thu, 26 Aug 2010 09:26:10 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id B35D945DE52
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 09:26:09 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 8378345DE53
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 09:26:09 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 6774B1DB8018
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 09:26:09 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 180A91DB8017
	for <linux-ext4@vger.kernel.org>; Thu, 26 Aug 2010 09:26:09 +0900 (JST)
In-Reply-To: <20100825230442.GH2738@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 26 Aug 2010 01:04:42 +0200
Jan Kara <jack@suse.cz> wrote:

>   So I'd rather choose a safer approach for ext3 - see attached patch - it
> fixes the problem for me.  For ext4 your patch is definitely a way to go,
> so please port it to ext4 and send it to Ted Tso. Thanks.
This problem doesn't happen at ext4. Because, the i_extra_isize of 11th
inode is set to the suitable value by ext4_iget().
-----------------------------------------------------------
struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
{
(snip)     
        if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
                ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
                if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
                    EXT4_INODE_SIZE(inode->i_sb)) {
                        ret = -EIO;
                        goto bad_inode;
                }    
                if (ei->i_extra_isize == 0) { 
                        /* The extra space is currently unused. Use it. */
                        ei->i_extra_isize = sizeof(struct ext4_inode) -
                                            EXT4_GOOD_OLD_INODE_SIZE;
                } else {
                        __le32 *magic = (void *)raw_inode +
                                        EXT4_GOOD_OLD_INODE_SIZE +
                                        ei->i_extra_isize;
                        if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
                                ext4_set_inode_state(inode, EXT4_STATE_XATTR);
                }    
        } else 
                ei->i_extra_isize = 0; 
-----------------------------------------------------------
     
Thanks,
Masayoshi

