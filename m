From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC][PATCH] vfs: always protect diretory file->fpos with inode
 mutex
Date: Tue, 19 Feb 2013 20:33:44 +0800
Message-ID: <20130219123344.GA18350@gmail.com>
References: <5122D3E0.6070800@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
	Wuqixuan <wuqixuan@huawei.com>,
	Al Viro <viro@ZenIV.linux.org.uk>, gregkh@linuxfoundation.org
To: Li Zefan <lizefan@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5122D3E0.6070800@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 19, 2013 at 09:22:40AM +0800, Li Zefan wrote:
> There's a long long-standing bug...As long as I don't know when it dates
> from.
> 
> I've written and attached a simple program to reproduce this bug, and it can
> immediately trigger the bug in my box. It uses two threads, one keeps calling
> read(), and the other calling readdir(), both on the same directory fd.

Hi Zefan,

Out of curiosity, why do you call read(2) on a directory fd?  I only
open(2) a directory in order to execute a flush operation to make sure
that a file is really created.

Regards,
                                                - Zheng

> 
> When I ran it on ext3 (can be replaced with ext2/ext4) which has _dir_index_
> feature disabled, I got this:
> 
> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=993, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=1009, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=993, inode=0, rec_len=0, name_len=0
> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory #34817: rec_len is smaller than minimal - offset=1009, inode=0, rec_len=0, name_len=0
> ...
> 
> If we configured errors=remount-ro, the filesystem will become read-only.
> 
> SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
> {
> 	...
> 		loff_t pos = file_pos_read(file);
> 		ret = vfs_read(file, buf, count, &pos);
> 		file_pos_write(file, pos);
> 		fput_light(file, fput_needed);
> 	...
> }
> 
> While readdir() is protected with i_mutex, f_pos can be changed without any locking
> in various read()/write() syscalls, which leads to this bug.
> 
> What makes things worse is Andi removed i_mutex from generic_file_llseek, so you
> can trigger the same bug by replacing read() with lseek() in the test program.
> 
> commit ef3d0fd27e90f67e35da516dafc1482c82939a60
> Author: Andi Kleen <ak@linux.intel.com>
> Date:   Thu Sep 15 16:06:48 2011 -0700
> 
>     vfs: do (nearly) lockless generic_file_llseek
> 
> I've tested ext3 with dir_index enabled and btrfs, nothing bad happened, but there
> should be some other vulnerabilities. For example, running the test program on /sys
> for a few minutes triggered this warning:
> 
> [  917.994600] ------------[ cut here ]------------
> [  917.994614] WARNING: at fs/sysfs/sysfs.h:195 sysfs_readdir+0x24c/0x260()
> [  917.994621] Hardware name: Tecal RH2285
> ...
> [  917.994725] Pid: 8754, comm: a.out Not tainted 3.8.0-rc2-tj-0.7-default+ #69
> [  917.994731] Call Trace:
> [  917.994736]  [<ffffffff81205c6c>] ? sysfs_readdir+0x24c/0x260
> [  917.994743]  [<ffffffff81205c6c>] ? sysfs_readdir+0x24c/0x260
> [  917.994752]  [<ffffffff81041fff>] warn_slowpath_common+0x7f/0xc0
> [  917.994759]  [<ffffffff8104205a>] warn_slowpath_null+0x1a/0x20
> [  917.994766]  [<ffffffff81205c6c>] sysfs_readdir+0x24c/0x260
> [  917.994774]  [<ffffffff8119cbd0>] ? sys_ioctl+0x90/0x90
> [  917.994780]  [<ffffffff8119cbd0>] ? sys_ioctl+0x90/0x90
> [  917.994787]  [<ffffffff8119cfc1>] vfs_readdir+0xb1/0xd0
> [  917.994794]  [<ffffffff8119d07b>] sys_getdents64+0x9b/0x110
> [  917.994803]  [<ffffffff814a45d9>] system_call_fastpath+0x16/0x1b
> [  917.994809] ---[ end trace 6efe15a65b89022a ]---
> [  917.994816] ida_remove called for id=13073 which is not allocated.
> 
> 
> We can fix this bug in each filesystem, but can't we just make sure i_mutex is
> acquired in lseek(), read(), write() and readdir() for directory file operations?
> 
> (the patch is for demonstration only)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index bb34af3..41f76e5 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -218,14 +218,25 @@ EXPORT_SYMBOL(default_llseek);
>  
>  loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	loff_t (*fn)(struct file *, loff_t, int);
> +	int ret;
>  
>  	fn = no_llseek;
>  	if (file->f_mode & FMODE_LSEEK) {
>  		if (file->f_op && file->f_op->llseek)
>  			fn = file->f_op->llseek;
>  	}
> -	return fn(file, offset, whence);
> +
> +	if (S_ISDIR(inode->i_mode)) {
> +		mutex_lock(&inode->i_mutex);
> +		ret = fn(file, offset, whence);
> +		mutex_unlock(&inode->i_mutex);
> +	} else {
> +		ret = fn(file, offset, whence);
> +	}
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(vfs_llseek);
>  
> @@ -442,12 +453,32 @@ EXPORT_SYMBOL(vfs_write);
>  
>  static inline loff_t file_pos_read(struct file *file)
>  {
> -	return file->f_pos;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	loff_t pos;
> +
> +	if (S_ISDIR(inode->i_mode)) {
> +		mutex_lock(&inode->i_mutex);
> +		pos = file->f_pos;
> +		mutex_unlock(&inode->i_mutex);
> +	} else {
> +		pos = file->f_pos;
> +	}
> +
> +	return pos;
>  }
>  
>  static inline void file_pos_write(struct file *file, loff_t pos)
>  {
> -	file->f_pos = pos;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +
> +	if (S_ISDIR(inode->i_mode)) {
> +		mutex_lock(&inode->i_mutex);
> +		file->f_pos = pos;
> +		file->f_version = 0;
> +		mutex_unlock(&inode->i_mutex);
> +	} else {
> +		file->f_pos = pos;
> +	}
>  }
>  
>  SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
> 
> 

> #include <unistd.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <dirent.h>
> #include <fcntl.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> 
> int main(int argc, char *argv[])
> {
> 	int fd;
> 	int ret;
> 	DIR *dir;
> 	struct dirent *ptr;
> 
> 	if (argc != 2)
> 		errx(1, "Please specify a directory");
> 
> 	dir = opendir(argv[1]);
> 	if (!dir)
> 		err(1, "Failed to open directory %s", argv[1]);
> 
> 	fd = dirfd(dir);
> 	if (fd < 0)
> 		err(1, "Failed to get dirfd");
> 
> 	ret = fork();
> 	if (ret == 0) {
> 		char buf[100];
> 
> 		while (1)
> 			read(fd, buf, 100);
> 	} else {
> 		int ret2;
> 
> 		while (1) {
> 			ret2 = lseek(fd, 0, SEEK_SET);
> 			if (ret2 < -1)
> 				err(1, "seek failed");
> 
> 			while (ptr = readdir(dir))
> 				;
> 		}
> 	}	
> 
> 	closedir(dir);
> 	return 0;
> }
