From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem becomes unreadable upon -ENOMEM at
 __ext4_read_dirblock()?
Date: Wed, 12 Jun 2013 10:35:42 -0400
Message-ID: <20130612143542.GC27403@thunk.org>
References: <201306122216.HGF26015.OVOtFOFHSJMQLF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57266 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab3FLOfq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 10:35:46 -0400
Content-Disposition: inline
In-Reply-To: <201306122216.HGF26015.OVOtFOFHSJMQLF@I-love.SAKURA.ne.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 10:16:11PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I used systemtap instead of CONFIG_FAILSLAB=y for uniquely injecting kmalloc()
> failure events.

Hi Tetsuo,

Thanks for doing this experiment.  Yes, it looks like we are not
properly reflecting the ENOMEM failure back up to the value that gets
returned by ext4_lookup(), and so the VFS gets a result which is
indistinguishable from "file not found".  This is probably then
getting cached as a negative dentry by the VFS layer.

Thanks for the bug report; it's something we should fix.

Regards,

						- Ted

> 
> $ wget http://sourceware.org/systemtap/ftp/releases/systemtap-2.2.1.tar.gz
> $ echo '5be8b55864c5b1b50fc361991bb9a4dd  systemtap-2.2.1.tar.gz' | md5sum --check -
> $ tar -zxf systemtap-2.2.1.tar.gz
> $ cd systemtap-2.2.1
> $ ./configure --prefix=$HOME/systemtap.tmp
> $ make -s
> $ make -s install
> $ sudo ~/systemtap.tmp/bin/stap -g -DSTP_NO_OVERLOAD -e '
> global __GFP_NOFAIL = 0x800;
> global traces_bt;
> probe begin {
>   printf("Probe start!\n");
> }
> probe kernel.function("__kmalloc") {
>   bt = backtrace();
>   if (traces_bt[bt]++ == 0) {
>     print_stack(bt);
>     printf("\n\n");
>     if (($flags & __GFP_NOFAIL) == 0 && execname() != "stapio")
>       $size = 1 << 31;
>   }
> }
> '
> 
> After seeing several errors caused by kmalloc() failure, at least on
> 2.6.32-358.6.2.el6.x86_64 kernel, I get strange directory entries where
> /bin/ls reports only filetype and filename.
> 
> ---------- Excerpt of /bin/ls -l /lib64/ ----------
> -?????????? ? ?    ?         ?                ? libthread_db-1.0.so
> lrwxrwxrwx. 1 root root     19 2013-03-11 09:11 libthread_db.so.1 -> libthread_db-1.0.so
> -rwxr-xr-x  1 root root 138280 2010-08-19 00:42 libtinfo.so.5.7
> l?????????? ? ?    ?         ?                ? libtirpc.so.1
> lrwxrwxrwx  1 root root     16 2013-05-02 10:25 libuuid.so.1 -> libuuid.so.1.3.0
> lrwxrwxrwx. 1 root root     16 2012-04-05 13:33 libwrap.so.0 -> libwrap.so.0.7.6
> -rwxr-xr-x. 1 root root  40792 2011-12-08 02:45 libwrap.so.0.7.6
> lrwxrwxrwx. 1 root root     36 2013-03-11 09:37 libxtables.so.4 -> /etc/alternatives/libxtables4.x86_64
> l?????????? ? ?    ?         ?                ? libxtables.so.4-1.4.7
> -rwxr-xr-x  1 root root  91096 2013-02-22 08:02 libz.so.1.2.3
> drwxr-xr-x. 2 root root   4096 2013-03-11 09:14 multipath
> d?????????? ? ?    ?         ?                ? rsyslog
> drwxr-xr-x. 2 root root   4096 2013-03-11 09:11 rtkaio
> ---------- Excerpt of /bin/ls -l /lib64/ ----------
> 
> Likewise, after seeing several errors caused by kmalloc() failure, files which
> were previously accessible suddenly become inaccessible.
> 
> ---------- Another excerpt start ----------
> [root@(none) ~]# uname -a
> -bash: fork: Cannot allocate memory
> [root@(none) ~]# uname -a
> -bash: fork: Cannot allocate memory
> [root@(none) ~]# uname -a
> -bash: /bin/uname: Cannot allocate memory
> [root@(none) ~]# uname -a
> -bash: /bin/uname: Cannot allocate memory
> [root@(none) ~]# uname -a
> Segmentation fault
> [root@(none) ~]# uname -a
> Linux (none) 2.6.32-358.6.2.el6.x86_64 #1 SMP Thu May 16 20:59:36 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> [root@(none) ~]# find / > /dev/null
> [root@(none) ~]# find / > /dev/null
> [root@(none) ~]# find / > /dev/null
> [root@(none) ~]# uname -a
> Linux (none) 2.6.32-358.6.2.el6.x86_64 #1 SMP Thu May 16 20:59:36 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> [root@(none) ~]# echo 3 > /proc/sys/vm/drop_caches
> [root@(none) ~]# uname -a
> -bash: /bin/uname: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]# find / > /dev/null
> -bash: /bin/find: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]#
> ---------- Another excerpt end ----------
> 
> Filesystem containing these files is mounted read-only and /sbin/e2fsck with -f
> option reports no errors. Therefore, this problem seems to be caused by
> directory entry read failures due to kmalloc() failure.
> 
> ---------- cat /proc/mounts ----------
> rootfs / rootfs rw 0 0
> proc /proc proc rw,relatime 0 0
> sysfs /sys sysfs rw,relatime 0 0
> devtmpfs /dev devtmpfs rw,relatime,size=1011388k,nr_inodes=252847,mode=755 0 0
> devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
> tmpfs /dev/shm tmpfs rw,relatime 0 0
> /dev/sda1 / ext4 ro,relatime,barrier=1,data=ordered 0 0
> none /tmp tmpfs rw,relatime 0 0
> debugfs /sys/kernel/debug debugfs rw,relatime 0 0
> ---------- cat /proc/mounts ----------
> 
> This problem seems to be remaining unfixed as of commit 34376a50 on linux.git.
> 
> ---------- Excerpt start ----------
> [root@(none) ~]# find / > /dev/null
> -bash: fork: Cannot allocate memory
> [root@(none) ~]# find / > /dev/null
> -bash: fork: Cannot allocate memory
> [root@(none) ~]# find / > /dev/null
> -bash: /bin/find: Cannot allocate memory
> [root@(none) ~]# find / > /dev/null
> -bash: /bin/find: Cannot allocate memory
> [root@(none) ~]# find / > /dev/null
> Segmentation fault
> [root@(none) ~]# find / > /dev/null
> [root@(none) ~]# find / > /dev/null
> -bash: /bin/find: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]# find / > /dev/null
> -bash: /bin/find: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]# dmesg -c
> -bash: /bin/dmesg: Input/output error
> [root@(none) ~]# dmesg -c
> -bash: /bin/dmesg: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]# dmesg -c
> -bash: /bin/dmesg: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> ---------- Excerpt end ----------
> 
> ---------- Another excerpt start ----------
> [root@(none) ~]# uname -a
> -bash: fork: Cannot allocate memory
> [root@(none) ~]# uname -a
> -bash: fork: Cannot allocate memory
> [root@(none) ~]# uname -a
> -bash: /bin/uname: Cannot allocate memory
> [root@(none) ~]# uname -a
> -bash: /bin/uname: Cannot allocate memory
> [root@(none) ~]# uname -a
> Segmentation fault
> [root@(none) ~]# uname -a
> Linux (none) 3.10.0-rc5-00043-g34376a5 #129 SMP Wed Jun 12 14:47:13 JST 2013 x86_64 x86_64 x86_64 GNU/Linux
> [root@(none) ~]# find / > /dev/null
> [root@(none) ~]# find / > /dev/null
> ^C
> [root@(none) ~]# find / > /dev/null
> ^C
> [root@(none) ~]# uname -a
> Linux (none) 3.10.0-rc5-00043-g34376a5 #129 SMP Wed Jun 12 14:47:13 JST 2013 x86_64 x86_64 x86_64 GNU/Linux
> [root@(none) ~]# ls -l /lib64/ld-linux-x86-64.so.2
> Bus error
> [root@(none) ~]# ls -l /lib64/ld-linux-x86-64.so.2
> ls: /lib64/ld-linux-x86-64.so.2: Cannot allocate memory
> lrwxrwxrwx 1 root root 10 Mar 11 09:11 /lib64/ld-linux-x86-64.so.2 -> ld-2.12.so
> [root@(none) ~]# ls -l /lib64/ld-linux-x86-64.so.2
> lrwxrwxrwx 1 root root 10 Mar 11 09:11 /lib64/ld-linux-x86-64.so.2 -> ld-2.12.so
> [root@(none) ~]# echo 3 > /proc/sys/vm/drop_caches
> [root@(none) ~]# ls -l /lib64/ld-linux-x86-64.so.2
> -bash: /bin/ls: No such file or directory
> [root@(none) ~]# ls -l /lib64/ld-linux-x86-64.so.2
> -bash: /bin/ls: No such file or directory
> [root@(none) ~]# uname -a
> -bash: /bin/uname: Input/output error
> [root@(none) ~]# uname -a
> -bash: /bin/uname: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]# uname -a
> -bash: /bin/uname: /lib64/ld-linux-x86-64.so.2: bad ELF interpreter: No such file or directory
> [root@(none) ~]# ls -l /lib64/ld-linux-x86-64.so.2
> -bash: /bin/ls: No such file or directory
> ---------- Another excerpt end ----------
> 
> Since the message
> 
> EXT4-fs warning (device sda1): __ext4_read_dirblock:XXX: error reading directory block (ino XXXXXX, block X)
> 
> is printed before this problem happens, the problem could be
> "ext4 is not retrying reading directory blocks when it failed with -ENOMEM"?
> 
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
