From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH] ext4: increase the protection of drop nlink and ext4
 inode destroy
Date: Mon, 16 Jan 2017 11:24:46 +0800
Message-ID: <b891c283-c83b-83fd-91f6-db25529b3c4a@huawei.com>
References: <1482755657-28791-1-git-send-email-yi.zhang@huawei.com>
 <141922.1483225153@turing-police.cc.vt.edu>
 <10c6fa5d-a7bb-a87c-11ad-8d30230a6075@huawei.com>
 <20170104215424.GB14021@birch.djwong.org>
 <20170104233550.oy7nzc3rxppmejbk@thunk.org>
 <4febf11b-31ea-82a1-bf08-b6bebe08bc75@huawei.com>
 <20170111153449.ourcta6jraxo4mzy@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        <Valdis.Kletnieks@vt.edu>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        <viro@zeniv.linux.org.uk>, <miaoxie@huawei.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170111153449.ourcta6jraxo4mzy@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


on 2017/1/11 23:34, Theodore Ts'o wrote:
> On Wed, Jan 11, 2017 at 05:07:29PM +0800, zhangyi (F) wrote:
>>
>> (1) The file we want to unlink have many hard links, but only one dcache entry in memory.
>> (2) open this file, but it's inode->i_nlink read from disk was 1 (too low).
>> (3) some one call rename and drop it's i_nlink to zero.
>> (4) it's inode is still in use and do not destroy (not closed), at the same time,
>>     some others open it's hard link and create a dcache entry.
>> (5) call rename again and it's i_nlink will still underflow and cause memory corruption.
> 
> Do you have reproducers that make it easy to reproduce situations like
> this?  (It shouldn't be hard to write, but if you have them already
> will save me some effort.  :-)
> 

I make a reproducer, we can do the following steps to reproduce this probrem easily:
1) mount a ext4 file system, and create 3 files and 1 hard link,

    #mount /dev/sdax /mnt
    #cd /mnt
    #touch old_file1 old_file2 new_file
    #ln new_file new_link1

2) umount the file system and use the debugfs to change new_file's
   links_count value to 1, which is used to simulate the fs inconsistency,

   #umount /mnt
   #debugfs /dev/sdax -w
	set_inode_field new_file links_count 1

3) mount the fs again, and then execute the following program (Note:
   do not execute the ls cmd, it will create the second dcache entry),

   #define RENAME_OLD_FILE_1  "old_file1"
   #define RENAME_OLD_FILE_2  "old_file2"
   #define RENAME_NEW_FILE    "new_file"
   #define NEW_FILE_LINK_1    "new_link1"

   int main(int argc, char *argv[])
   {
        int fd = 0;
        int err = 0;

        fd = open(RENAME_NEW_FILE, O_RDONLY);
        if (fd < 0) {
                printf("open error:%d\n", errno);
                return -1;
        }

        err = rename(RENAME_OLD_FILE_1, RENAME_NEW_FILE);
        if (err < 0) {
                printf("rename error:%d\n", errno);
                close(fd);
                return -1;
        }

        err = rename(RENAME_OLD_FILE_2, NEW_FILE_LINK_1);
        if (err < 0) {
                printf("rename error:%d\n", errno);
                close(fd);
                return -1;
        }

        close(fd);
        return 0;
   }

4) after this, the new_file's inode->i_nlink is underflowed and add to orphan list,
   kernel dump like this:

    ------------[ cut here ]------------
   WARNING: CPU: 0 PID: 1814 at fs/inode.c:282 drop_nlink+0x3e/0x50
   ...
   Call Trace:
   dump_stack+0x63/0x86
   __warn+0xcb/0xf0
   warn_slowpath_null+0x1d/0x20
   drop_nlink+0x3e/0x50
   ext4_rename+0x532/0x8c0
   ext4_rename2+0x1d/0x30
   vfs_rename+0x728/0x940
    ? __lookup_hash+0x20/0xa0
    SyS_rename+0x3ba/0x3e0
    entry_SYSCALL_64_fastpath+0x1a/0xa9
   ...
    ---[ end trace b157dacbc891e6e8 ]---

5) then, we trigger mem shrink, this inode will be destroyed but it is still
   on the orphan list,

   #echo 3 > /proc/sys/vm/drop_caches

   kernrl dump:

   EXT4-fs (sdb1): Inode 16 (ffff98f4b3285c20): orphan list check failed!
   ...
   ffff98f4b3285d30: fa87e800 ffff98f4 b3285e80 ffff98f4  .........^(.....
   ffff98f4b3285d40: b20829d8 ffff98f4 00000010 00000000  .)..............
   ffff98f4b3285d50: ffffffff 00000000 00000000 00000000  ................
   ...
   Call Trace:
    dump_stack+0x63/0x86
    ext4_destroy_inode+0xa0/0xb0
    destroy_inode+0x3b/0x60
    evict+0x130/0x1c0
    dispose_list+0x4d/0x70
    prune_icache_sb+0x5a/0x80
    super_cache_scan+0x14b/0x1a0
    shrink_slab.part.40+0x1f5/0x420
    shrink_slab+0x29/0x30
    drop_slab_node+0x31/0x60
    drop_slab+0x3f/0x70
    drop_caches_sysctl_handler+0x71/0xc0
    proc_sys_call_handler+0xea/0x110
    proc_sys_write+0x14/0x20
    __vfs_write+0x37/0x160
    ? selinux_file_permission+0xd7/0x110
    ? security_file_permission+0x3b/0xc0
    vfs_write+0xb5/0x1a0
    SyS_write+0x55/0xc0
    entry_SYSCALL_64_fastpath+0x1a/0xa9
   ...
   bash (1594): drop_caches: 3

6) Some time later, if we change the orphan list, it will cause memory corruption.

Thanks.

zhangyi
