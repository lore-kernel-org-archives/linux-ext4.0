From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 23/39] fallthru: ext2 fallthru support
Date: Fri, 13 Aug 2010 15:52:02 +0200
Message-ID: <E1Ojufy-0004Df-PA@pomaz-ex.szeredi.hu>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-24-git-send-email-vaurora@redhat.com>
Cc: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, vaurora@redhat.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <1281282776-5447-24-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Sun, 8 Aug 2010 11:52:40 -0400)
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun,  8 Aug 2010, Valerie Aurora wrote:
> Add support for fallthru directory entries to ext2.

This still doesn't work correctly, only now after unmounting/mounting
the top layer the directory appears empty:

uml:~# mount -oloop -r ext3.img /mnt/img/
uml:~# losetup /dev/loop2  ovl.img  
uml:~# /host/store/git/e2fsprogs/misc/mke2fs -O whiteout,fallthru /dev/loop2
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
1280 inodes, 10240 blocks
512 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=10485760
2 block groups
8192 blocks per group, 8192 fragments per group
640 inodes per group
Superblock backups stored on blocks: 
        8193

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 24 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
uml:~# mmount -b 8 -t ext2 /dev/loop2 /mnt/img/
uml:~# "ls" /mnt/img
lost+found  union
uml:~# "ls" /mnt/img/union
1  2  3
uml:~# umount /mnt/img
uml:~# mmount -b 8 -t ext2 /dev/loop2 /mnt/img/
uml:~# ls -l /mnt/img/
total 13
drwx------ 2 root root 12288 Aug 13 13:42 lost+found
drwxr-xr-x 2 root root  1024 Aug 13 13:42 union
uml:~# ls -la /mnt/img/union/
total 2
drwxr-xr-x 2 root root 1024 Aug 13 13:42 .
drwxr-xr-x 4 root root 1024 Aug 13 13:42 ..
uml:~# grep /mnt/img /proc/self/mountinfo 
21 12 7:0 / /mnt/img ro,relatime - ext3 /dev/loop0 ro,errors=continue,barrier=0,data=writeback
22 21 7:2 / /mnt/img rw,relatime,union - ext2 /dev/loop2 rw,errors=continue

Thanks,
Miklos
