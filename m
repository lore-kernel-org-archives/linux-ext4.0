From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Wed, 4 Jan 2017 16:29:33 +0800
Message-ID: <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>
To: <Valdis.Kletnieks@vt.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <141922.1483225153@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2017/1/1 6:59, Valdis.Kletnieks@vt.edu said:
> On Mon, 26 Dec 2016 20:34:17 +0800, yi zhang said:
>> Because of the disk and hardware issue, the ext4 filesystem have
>> many errors, the inode->i_nlink of ext4 becomes zero abnormally
>> but the dentry is still positive, it will cause memory corruption
>> after the following process:
>>
>>  1) Due to the inode->i_nlink is 0, this inode will be added into
>> the orhpan list,
> 
>> +	if (WARN(inode->i_nlink == 0, "inode %lu nlink"
>> +		" is already 0", inode->i_ino))
> 
> Can we get the filesystem? Or at least the device major/minor? If a system
> has multiple large ext4 filesystems, it would be helpful to know which
> one is having the problem.
> 

        if (WARN(inode->i_nlink == 0,
-               "inode %lu nlink is already 0", inode->i_ino))
+               "inode %lu nlink is already 0, dev=%u:%u",
+               inode->i_ino, MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev)))
                return;

We can modify as above, it's enough to know which filesystem is having the
problem, what do you think?

yi zhang
