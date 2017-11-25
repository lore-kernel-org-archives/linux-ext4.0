From: Dave Chinner <david@fromorbit.com>
Subject: Re: regression: 4.13 cannot follow symlinks on some ext3 fs
Date: Sun, 26 Nov 2017 09:32:02 +1100
Message-ID: <20171125223202.GL4094@dastard>
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

On Fri, Nov 24, 2017 at 03:03:37PM -0700, Andreas Dilger wrote:
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
> a 2007 system. 

I have multiple test VMs with root ext3 filesystems that date back
that far. Looks like the original install the root fs image was
derived from came from around 2006:

$ ls -lt /etc |tail -1
-rw-r--r--  1 root root       9 Aug  8  2006 host.conf
$ ls -lt /usr/bin |tail -2
-rwxr-xr-x 1 root   root         2038 Jun 18  2006 defoma-hints
-rwxr-xr-x 1 root   root         1761 Jun 18  2006 dh_installdefoma
$ uname -a
Linux test4 4.14.0-dgc #211 SMP PREEMPT Thu Nov 23 16:49:31 AEDT 2017 x86_64 GNU/Linux
$

These VMs are in use 24x7, and have been since they were created way
back when. When something in ext3 breaks, I tend to notice it and
report it.

They don't have any whacky symlinks around, but the modern ext4 code
does try to eat these filesystems every so often. Extended operation
at ENOSPC will eventually corrupt the rootfs and crash the kernel,
and then I play the "e2fsck doesn't detect corruption, kernel does"
game to get them fixed up and working again....

> > Requiring new e2fsck on old systems is a bad idea.
> 
> Any worse an idea than running a new kernel on an old system?
> Newer e2fsck fixes a lot of bugs that are present in older
> e2fsck as well...

I'm running with everything up to date (debian unstable) on these
VMs, they are just an old filesystem because some distros have had
reliable rolling updates for the entire life of these VMs. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
