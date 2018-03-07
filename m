From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: ext4 ignoring rootfs default mount options
Date: Wed, 7 Mar 2018 10:14:28 -0500
Message-ID: <20180307151427.i6vbeq6kqo55cdgs@csclub.uwaterloo.ca>
References: <20180306190315.puocf5bu3bfz6yct@csclub.uwaterloo.ca>
 <20180307040608.GA2462@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307040608.GA2462@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 06, 2018 at 11:06:08PM -0500, Theodore Y. Ts'o wrote:
> On Tue, Mar 06, 2018 at 02:03:15PM -0500, Lennart Sorensen wrote:
> > While switching a system from using ext3 to ext4 (It's about time) I
> > discovered that setting default options for the filesystem using tune2fs
> > -o doesn't work for the root filesystem when mounted by the kernel itself.
> > Filesystems mounted from userspace with the mount command use the options
> > set just fine.  The extended option set with tune2fs -E mount_opts=
> > works fine however.
> 
> Well.... it's not that it's being ignored.  It's just a
> misunderstanding of how a few things.  It's also that the how we
> handled mount options has evolved over time, leading to a situation
> which is confusing.
> 
> First, tune2fs changes the default of ext4's mount options.  This is
> stated in the tune2fs man page:
> 
> -o [^]mount-option[,...]
>               Set or clear the indicated default mount options in the filesys‐
>               tem.   Default  mount options can be overridden by mount options
>               specified either in /etc/fstab(5) or on the command  line  argu‐
>               ments  to mount(8).  Older kernels may not support this feature;
>               in particular, kernels which predate  2.4.20  will  almost  cer‐
>               tainly ignore the default mount options field in the superblock.
> 
> Secondly, the message when af ile sytem is mounted, e.g.:
> 
> > EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> 
> ... is the mount option string that are passed to the mount system
> call.
> 
> The extended mount options is different.  It was something that we
> added later.  If it is present, this the extended mount options is
> printed first, followed by a semi-colon, followed by string passed to
> the mount system call.
> 
> Hence:
> 
> > tune2fs -E mount_opts=nodelalloc /dev/sda1
> > 
> > at boot we got:
> > EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: nodelalloc; (null)
> 
> 
> The description of -E option in the tune2fs man page talks about some
> of this, but it's arguably confusing.
> 
> You can see exactly what mount options that are active by looking at
> the file /proc/fs/ext4/<dev>/options.  So this is how you can prove to
> yourself that tune2fs -o works.

OK that does in fact seem to be the case.  That's good.

> root@kvm-xfstests:~# dmesg -n 7
> root@kvm-xfstests:~# tune2fs -o nodelalloc /dev/vdc 
> tune2fs 1.44-WIP (06-Sep-2017)
> root@kvm-xfstests:~# mount /dev/vdc /vdc
> [   27.389192] EXT4-fs (vdc): mounted filesystem with ordered data mode. Opts: (null)
> root@kvm-xfstests:~# cat /proc/fs/ext4/vdc/options 
> rw
> bsddf
> nogrpid
> block_validity
> dioread_lock
> nodiscard
> nodelalloc
> journal_checksum
> barrier
> auto_da_alloc
> user_xattr
> acl
> noquota
> resuid=0
> resgid=0
> errors=continue
> commit=5
> min_batch_time=0
> max_batch_time=15000
> stripe=0
> data=ordered
> inode_readahead_blks=32
> init_itable=10
> max_dir_size_kb=0
> 
> > For filesystems mounted from userspace with the mount command, either
> > method works however.  The first option however is what the comment in
> > fs/ext4/super.c suggests to use.
> > 
> > Of course I also got the messages:
> > EXT4-fs (sda1): Mount option "nodelalloc" incompatible with ext3
> > EXT4-fs (sda1): failed to parse options in superblock: nodelalloc
> > EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
> 
> So what's happening here is something that has recently started
> getting reported by users.  Most modern distro's use an initial
> ramdisk to mount the root file system, and they use blkid to determine
> the file system with the right file system type.  If the kernel is
> mounting the root file system.  An indication that this is what's
> happening is the following message in dmesg:
> 
> [    2.196149] VFS: Mounted root (ext4 filesystem) readonly on device 254:0.
> 
> This message means the kernel fallback code was used to mount the file
> system, not the initial ramdisk code in userspace.
> 
> If you are using the kernel fallback code, it will first try to mount
> the file system as ext3, and if you have "nodelalloc" in the extended
> mount options in the superblock, it will try it first.  The messages
> you have quoted above are harmless.  But they are scaring users, so we
> are looking into ways to suppress them.
> 
> > And of course the last annoying thing I noticed is that /proc/mounts
> > doesn't actually tell you that nodelalloc is active when it is set
> > from the default mount options rather than from the mount command line
> > (or fstab).  Lots of other non default options are explicitly handled,
> > but not delalloc.  The only place you see it, is in the dmesg line
> > telling you what options the filesystem was mounted with.
> 
> That's because /proc/mounts is trying to emulate the user-space
> maintained /etc/mtab file.  So we deliberately suppress default mount
> options.  If you take out this feature:
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 756f515b762d..e93b86f68da5 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2038,8 +2038,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
>  		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
>  		    (m->flags & MOPT_CLEAR_ERR))
>  			continue;
> -		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
> -			continue; /* skip if same as the default */
> +//		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
> +//			continue; /* skip if same as the default */
>  		if ((want_set &&
>  		     (sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
>  		    (!want_set && (sbi->s_mount_opt & m->mount_opt)))
> 
> 
> ... then /proc/mounts looks a lot messier, and most users would not
> like the result:
> 
> /dev/vdc /vdc ext4 rw,relatime,bsddf,nogrpid,block_validity,dioread_lock,nodiscard,nodelalloc,journal_checksum,barrier,auto_da_alloc,user_xattr,acl,noquota,data=ordered 0 0

Yes that gets too messy.

> If you really want the reliable "what are the mount options right
> now", the place to look is /proc/fs/ext4/<device>/options, as
> described above.

But delalloc is the default for ext4, so a filesystem mounted with
nodelalloc ought to show that in /proc/mounts as far as I am concerned.
The comment in the code says anything that is different than the global
defaults and the filesystem defaults will be shown, but in this case it
is not.  Maybe the comment is just wrong or unclear and this is actually
the intended behaviour.  I don't think I like the behaviour if it is
intended to work this way.  The /proc/fs/ext4/ option at least looks
workable.  Strangely I found the function that implements it but couldn't
find anything using it for some reason.  I must have just missed it
since it obviously is there.

-- 
Len Sorensen
