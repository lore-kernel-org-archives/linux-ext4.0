From: Mingming Cao <cmm@us.ibm.com>
Subject: ext3_forget() and ext3_free_blocks()
Date: Thu, 01 Feb 2007 12:56:13 -0800
Message-ID: <1170363373.4271.44.camel@localhost.localdomain>
References: <20070201010836.31a63ef2.akpm@osdl.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andreas Gruenbacher <agruen@suse.de>
To: Andrew Morton <akpm@osdl.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:41112 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423006AbXBAU4W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 15:56:22 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l11KuENs019283
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 15:56:14 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l11KuEwv510456
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 13:56:14 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l11KuE4d005743
	for <linux-ext4@vger.kernel.org>; Thu, 1 Feb 2007 13:56:14 -0700
In-Reply-To: <20070201010836.31a63ef2.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I am chasing a ext3 bug which double free the same xattr block from two
different inode. While I am looking at the code ext3_xattr_release_block
() I found ext3_free_block() is called before ext3_forget():

ext3_xattr_release_block(handle_t *handle, struct inode *inode,
                         struct buffer_head *bh)
{
        struct mb_cache_entry *ce = NULL;

        ce = mb_cache_entry_get(ext3_xattr_cache, bh->b_bdev, bh->b_blocknr);
        if (BHDR(bh)->h_refcount == cpu_to_le32(1)) {
                ea_bdebug(bh, "refcount now=0; freeing");
                if (ce)
                        mb_cache_entry_free(ce);
                ext3_free_blocks(handle, inode, bh->b_blocknr, 1);
                get_bh(bh);
                ext3_forget(handle, 1, inode, bh, bh->b_blocknr);
        } else {

Is this a potential problem? Looks like other places calling
ext3_free_block() it all has ext3_forget() called before that.

Though this seems not related to the double-free bug I see, as I
reversed the order and rerun the test, the bug still reproduced. But
just curious..


Thanks,
Mingming
