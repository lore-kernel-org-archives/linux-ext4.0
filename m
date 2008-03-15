From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: strange ext{3,4}_settattr logic
Date: Sat, 15 Mar 2008 19:07:32 +0300
Message-ID: <20080315160731.GA4186@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:37120 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYCOQMD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Mar 2008 12:12:03 -0400
Received: from dmon-lap.sw.ru ([10.30.3.106])
	by relay.sw.ru (8.13.4/8.13.4) with ESMTP id m2FGBxio025539
	for <linux-ext4@vger.kernel.org>; Sat, 15 Mar 2008 19:12:00 +0300 (MSK)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.
I've found what ext3_setattr() code has some strange logic. I'm talking
about truncate path. 

int ext3_setattr(struct dentry *dentry, struct iattr *attr)
{
...
	if (S_ISREG(inode->i_mode) &&
            attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
                handle_t *handle;
<<< This is shrinking case, and according to function comments:
<<< "In particular, we want to make sure that when the VFS
<<< * shrinks i_size, we put the inode on the orphan list and modify
<<< * i_disksize immediately"
<<< we about to write i_disksize. But WHY do we have to do it explicitly?
<<< Later inode_setattr() will call ext3_truncate() which will do it
<<< this work for us.
                handle = ext3_journal_start(inode, 3);
                if (IS_ERR(handle)) {
                        error = PTR_ERR(handle);
                        goto err_out;
                }

                error = ext3_orphan_add(handle, inode);
                EXT3_I(inode)->i_disksize = attr->ia_size;
                rc = ext3_mark_inode_dirty(handle, inode);
                if (!error)
                        error = rc;
                ext3_journal_stop(handle);
        }
        rc = inode_setattr(inode, attr);
<<< Now the most interesting question. What we have to do now in 
<<< case of error? We are in tricky situation. Truncate not happened,
<<< and blocks visible to the user, but i_disksize was already written,
<<< so later memory reclaiming/ read_inode will result in unexpected
<<< updating i_size.
        /* If inode_setattr's call to ext3_truncate failed to get a
         * transaction handle at all, we need to clean up the in-core
         * orphan list manually. */
<<< Following code will remove inode only from in memory(because handle = NULL)
<<< orphan list. Please someone explain me what this lines suppose to do
<<< actually.
        if (inode->i_nlink)
                ext3_orphan_del(NULL, inode);
...
}
