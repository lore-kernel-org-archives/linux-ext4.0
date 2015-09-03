From: Richard Yao <ryao@gentoo.org>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Thu, 3 Sep 2015 19:16:19 +0000
Message-ID: <20150903191619.GD7732@woodpecker.gentoo.org>
References: <20150831061920.GA2751@quack.suse.cz>
 <20150903182225.GA7732@woodpecker.gentoo.org>
 <20150903183657.GB10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Raymond Jennings <shentino@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, Albino B Neto <bino@riseup.net>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150903183657.GB10390@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 03, 2015 at 11:36:57AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 03, 2015 at 06:22:25PM +0000, Richard Yao wrote:
> > What happens with this patch if /dev/$DEVICE is ext4 formatted and someone runs
> > `mount -t ext3 /dev/$DEVICE $MNT`?
> > 
> > This should fail with the ext3 driver, but it looks like it will work fine with
> > CONFIG_EXT4_USE_FOR_EXT23 because ext3_fs_type maps to ext4_mount. My system is
> > not built with CONFIG_EXT4_USE_FOR_EXT23 (long story short: it uses a RHEL6
> > derived config on Linux 4.1) and I do not have time to rebuild it to verify my
> > suspicion, but I imagine there are others on the list that could trivially check
> > this.
> 
> On 4.2 with CONFIG_EXT4_USE_FOR_EXT23:
> 
> # mke2fs -T ext4 /dev/sda
> # mount /dev/sda /mnt -t ext3
> mount: wrong fs type, bad option, bad superblock on /dev/sda,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> # lsmod|grep ext 
> ext4                  630784  0 
> jbd2                  126976  1 ext4
> mbcache                20480  1 ext4
> # dmesg
> <snip>
> [74559.632979] EXT4-fs (sda): couldn't mount as ext3 due to feature incompatibilities
> 
> > Also, new kernels are typically drop-in replacements on older userlands. An edge
> > case that no one appears to have mentioned is the possibility of using a newer
> > kernel on an older system where the initramfs generator might only include ext3,
> > which this would break. It might not be terrible to write a small dummy ext3
> > module whose only purpose is to depend on ext4 and load it into the kernel on
> > those systems. That way initramfs software that properly grabs module
> > dependencies will include the ext4 module and `modprobe ext3` will do what it
> 
> Well, if it goes looking for ext3.ko directly it will fail, but...
> 
> # modinfo ext3
> filename:       /lib/modules/4.2.0-mcsum/kernel/fs/ext4/ext4.ko
> license:        GPL
> description:    Fourth Extended Filesystem
> author:         Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others
> alias:          fs-ext4
> alias:          ext3
> alias:          fs-ext3
> <snip>
> 
> I don't know about RHEL initrd scripts, but Ubuntu's use some modprobe trickery
> which ensures that it picks up the correct ext4.ko.  It does something similar
> to this:
> 
> # modprobe --ignore-install --quiet --show-depends ext3 | sed -e 's/^insmod //g'
> /lib/modules/4.2.0-mcsum/kernel/fs/mbcache.ko 
> /lib/modules/4.2.0-mcsum/kernel/fs/jbd2/jbd2.ko 
> /lib/modules/4.2.0-mcsum/kernel/fs/ext4/ext4.ko
> 
> to pick up the modules for the initramfs.  Not sure what the other distros
> do, though.

Unfortunately, the genkernel team was not aware of this when it wrote support
for including kernel modules and I suspect others writing initramfs archive
generators did not either.

https://gitweb.gentoo.org/proj/genkernel.git/tree/gen_initramfs.sh#n638
https://gitweb.gentoo.org/proj/genkernel.git/tree/gen_moddeps.sh
https://gitweb.gentoo.org/proj/genkernel.git/tree/defaults/modules_load

The way that works is that the module names are specified in a MODULES_*
variable and then we search for dependencies based on what is specified in
modules.dep. If you have an old enough version of the initramfs genreator, ext4
is not specified and it will not recognize the alias.

I admit that this is likely a very rare edge case. I do not feel too strongly
about breaking the older initramfs software. I just wanted to make sure others
knew that they were.

> > always did in terms of making ext3 file systems mountable. I suppose that we
> > could use aliases, but given that there is a compatibility shim for CONFIG_EXT3
> > to avoid surprises, a dummy module seems reasonable.
> > 
> > These are the only two things that I see preventing ext4 from being a drop-in
> > replacement for ext3.
> > 
> > That said, my only connection with ext3/ext4 is that I am one of the genkernel
> > developers (Gentoo's  Linux initramfs/kernel genreation framework/scripts), so
> > my opinion might not matter much here, but I am also in favor of killing ext3 in
> > favor of CONFIG_EXT4_USE_FOR_EXT23.
> 
> :)
> 
> --D
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
