From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Wed, 11 Jan 2017 17:07:29 +0800
Message-ID: <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong <darrick.wong@oracle.com>; Jan Kara" <jack@suse.cz>,
        <Valdis.Kletnieks@vt.edu>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <adilger.kernel@dilger.ca>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104233550.oy7nzc3rxppmejbk@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



on 2017/1/5 7:35, Theodore Ts'o wrote:
> On Wed, Jan 04, 2017 at 01:54:24PM -0800, Darrick J. Wong wrote:
>>
>> if (inode->i_nlink == 0) {
>> 	ext4_warning_inode(inode, "nlink is already 0");
>> 	return;
>> }
> 
> We can't do that because the place where Zhangyi is proposing to
> change is in fs/inode.c:drop_nlink(), so we can't add a call to
> ext4_error() or ext4_warning().
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
>     		    	  	 	      - Ted
> 

Hi Theodore:

The i_nlink underflow and memory corruption problem on ext4fs remains inconclusive.

You suggest we can check dcache entries when i_nlink drop to zero in unlink and
rename. But I think it may still have some problems, assume the following situation:

(1) The file we want to unlink have many hard links, but only one dcache entry in memory.
(2) open this file, but it's inode->i_nlink read from disk was 1 (too low).
(3) some one call rename and drop it's i_nlink to zero.
(4) it's inode is still in use and do not destroy (not closed), at the same time,
    some others open it's hard link and create a dcache entry.
(5) call rename again and it's i_nlink will still underflow and cause memory corruption.

For simplicity, I think we can add underflow protection in ext4_rename or
drop_nlink as V2 and V3 patch wrote. What do you think?

yi zhang
