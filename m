From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Fast symlinks stored slow
Date: Thu, 13 Jul 2017 21:27:20 +0100
Message-ID: <20170713202720.GV31999@redhat.com>
References: <20170712170711.GA19996@redhat.com>
 <20170712231737.nzi2dv6e6h6yvrsl@thunk.org>
 <20170713080213.GO31999@redhat.com>
 <20170713164959.m2hf72b6zqlorn5i@thunk.org>
 <20170713171335.GT31999@redhat.com>
 <20170713185037.yz3l6hq3mcc3wppm@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752880AbdGMU1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 16:27:22 -0400
Content-Disposition: inline
In-Reply-To: <20170713185037.yz3l6hq3mcc3wppm@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 02:50:37PM -0400, Theodore Ts'o wrote:
> On Thu, Jul 13, 2017 at 06:13:35PM +0100, Richard W.M. Jones wrote:
> > In this case we're using libext2fs to build an appliance filesystem,
> > used to boot a small Linux system which is then run under qemu by
> > libguestfs.  This appliance is completely rebuilt automatically under
> > many circumstances, for example a host package upgrade (eg. upgrading
> > the kernel), so it's not a long-lived filesystem that would cause a
> > problem.  Rebuilding only takes a few seconds.
> > 
> > The process is described in more detail here:
> > http://libguestfs.org/supermin.1.html#SUPERMIN-APPLIANCES
> > 
> > From our point of view the only issue are some prebuilt appliances
> > which we have provided to other distributions that cannot / don't want
> > to use supermin (http://download.libguestfs.org/binaries/appliance/)
> > and at some point I'm going to have to rebuild these using the fixed
> > supermin.
> 
> OK, so the risk is if there are other people who are using supermin to
> create appliances.  (One potential use case we might need to
> investigate are services such as SuSE Studio, since it can create
> turnkey VM appliances for its users.)  If these applianes are
> distributed end users (as opposed to being automatically rebuilt as in
> your use case), that's when we would potentially be at risk.

I can't speak about SuSE Studio, but supermin appliances aren't
distributed to end users, but get built on the fly on end user
machines.

I think you may be confusing supermin and libguestfs.  Supermin is a
component we use to make libguestfs work, but it's not how libguestfs
makes new filesystems.

For example if you write:

  $ guestfish -N disk.img=fs:ext4 -m /dev/sda1 touch /foo : ln-s /foo /bar
  $ ll disk.img 
  -rw-rw-r--. 1 rjones rjones 104857600 Jul 13 21:26 disk.img

then the result is a new ext4 filesystem in a disk image, containing a
symlink.  But it was created using the *kernel* + the symlink(2)
system call (not using libext2fs), and in all cases it was in the past
and will be in the future created correctly.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
