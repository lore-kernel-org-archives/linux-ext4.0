From: Jan Kara <jack@suse.cz>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Mon, 4 Dec 2017 17:35:26 +0100
Message-ID: <20171204163526.GD17047@quack2.suse.cz>
References: <20171123203330.GN2482@two.firstfloor.org>
 <20171123222317.bq2v26zm5i2jspui@thunk.org>
 <20171123233101.GP2482@two.firstfloor.org>
 <700971AC-BDE2-4993-BD56-7497AD8A0FC4@dilger.ca>
 <20171124020435.GQ2482@two.firstfloor.org>
 <C656DD8B-7521-4281-8D55-4416A3C75161@dilger.ca>
 <20171124165102.GS2482@two.firstfloor.org>
 <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Ts'o <tytso@mit.edu>,
        Tahsin Erdogan <tahsin@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <706E8F37-95C7-4321-AACA-2ED11F82E625@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 24-11-17 15:03:37, Andreas Dilger wrote:
> On Nov 24, 2017, at 9:51 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >> We checked old kernels, and old e2fsprogs, and didn't see any cases
> >> where fast (<= 60 chars) symlinks were created using external blocks.
> >> It seems that _something_ did create them, and it would be good to
> >> figure that out so we can determine if it is a widespread problem
> > 
> > I assume it was the original kernel.
> > 
> >> 
> >> I think e2fsck can fix this quite easily, and there really isn't
> >> an easy way to revert to the old method if the large xattr feature
> >> is enabled.  If you are willing to run a new kernel, you should also
> >> be willing to run a new e2fsck.
> > 
> > It's obviously not enabled on ext3.
> > 
> >> We could probably add a fallback to the old mechanism (and print
> >> a one-time warning to upgrade to a newer e2fsck) if an external fast
> >> symlink is found and the large xattr  feature is not enabled, which
> >> would give more time to fix this (hopefully rare in the wild) case.
> > 
> > If the old kernel created it, then likely all the
> > /lib{,64}/ld-linux.so.2 symlinks have that, which breaks all ELF
> > executables. I suspect in these old file systems it's not particularly rare.
> 
> Sure, but not many people are going to be running a 4.14 kernel with
> a 2007 system.  Could you please run the updated find command to see
> whether this is an isolated case, or if it is a common case:
> 
> find / -type l -size -60c -print0 | xargs -0r ls -dils | awk '$2 != 0 { print }'
> 
> It would also be useful if anyone else reading this that has an old
> system (2005-2011 install date) ran the same to see if any such
> symlinks are found.  To see when the root filesystem was created, run:
> 
> dumpe2fs -h $(df -P / | awk '/dev/ { print $1 }') 2>&1 | grep created

I have one fs image around from:

Filesystem created:       Tue Nov 15 04:43:22 2005

and it indeed does have these problematic symlinks as well:

none):~# l /usr/share/terminfo/x/xterm-r5
lrwxrwxrwx 1 root root 24 May 19  2006 /usr/share/terminfo/x/xterm-r5 ->
/lib/terminfo/x/xterm-r5
(none):~# stat /usr/share/terminfo/x/xterm-r5
  File: `/usr/share/terminfo/x/xterm-r5' -> `/lib/terminfo/x/xterm-r5'
  Size: 24        	Blocks: 8          IO Block: 4096   symbolic link
Device: 6200h/25088d	Inode: 98027       Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2017-12-04 16:27:29.000000000 +0000
Modify: 2006-05-19 21:12:53.000000000 +0000
Change: 2006-05-19 21:12:53.000000000 +0000

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
