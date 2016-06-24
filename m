From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] weirdness in ext4_sync_file()
Date: Fri, 24 Jun 2016 05:36:05 +0100
Message-ID: <20160624043604.GU14480@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Could somebody explain when would the second part of that test _not_ be true?

                if (!ret && !hlist_empty(&inode->i_dentry))
                        ret = ext4_sync_parent(inode);

inode is that of an opened file; how could it possibly _not_ have a dentry
alias?  Is that code actually supposed to check if the sucker is not
unlinked?  If so, it's not what we are actually checking - pinned dentry
remains positive (and unhashed) after unlink(2).  What's more, the loop
in ext4_sync_parent() is vulnerable to races with rmdir(2) - if you
get unlink and rmdir of ancestors between
                next = igrab(d_inode(dentry->d_parent));
and
                inode = next;
                ret = sync_mapping_buffers(inode->i_mapping);
                if (ret)
                        break;
                ret = sync_inode_metadata(inode, 1);
                if (ret)
                        break;
you are risking interesting things done in the middle of rmdir and/or
unlink; that might be actually safe, but in that case it's worth a comment
explaining that.
