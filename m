From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Thu, 5 Jan 2017 15:24:14 +0800
Message-ID: <5505c121-8038-1b72-423a-42f36257e959@huawei.com>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        <Valdis.Kletnieks@vt.edu>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104233550.oy7nzc3rxppmejbk@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


On 2017/1/5 7:35, Theodore Ts'o wrote:
> 
> So how exactly how did we get into this state?  When we read the inode
> into memory, if i_nlink is zero, we declare the file system as
> corrupted immediately.
> 
> So I assume this is happening the on-disk i_links_count (which is read
> into inode->i_nlink) was too low.  So I think the way we should be
> handling this is in unlink and rename, before we let i_nlink drop to
> zero, we need to check to see if there are other dcache entries
> pointing at the inode.  If so, we need to call ext4_error(), and in
> the errors=continue case, return EFSCORRUPTED (aka EUCLEAN).
> 

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3662,6 +3662,11 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
        }

        if (new.inode) {
+               if (new.inode->i_nlink == 0) {
+                       ext4_warning_inode(new.inode, "Removing file '%.*s' with no links",
+                                      new.dentry->d_name.len, new.dentry->d_name.name);
+                       set_nlink(new.inode, 1);
+               }
                ext4_dec_count(handle, new.inode);
                new.inode->i_ctime = ext4_current_time(new.inode);
        }

Because the filesystem have many errors, and the reason of i_nlink becomes zero is unknown,
the on-disk i_links_count was too low may be one reason.  I think we can add i_nlink check in
ext4_rename just like ext4_unlink did, it can avoid inversion under any case.
