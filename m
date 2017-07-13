From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Fast symlinks stored slow
Date: Thu, 13 Jul 2017 18:13:35 +0100
Message-ID: <20170713171335.GT31999@redhat.com>
References: <20170712170711.GA19996@redhat.com>
 <20170712231737.nzi2dv6e6h6yvrsl@thunk.org>
 <20170713080213.GO31999@redhat.com>
 <20170713164959.m2hf72b6zqlorn5i@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdGMRNh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 13:13:37 -0400
Content-Disposition: inline
In-Reply-To: <20170713164959.m2hf72b6zqlorn5i@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 12:49:59PM -0400, Theodore Ts'o wrote:
> On Thu, Jul 13, 2017 at 09:02:13AM +0100, Richard W.M. Jones wrote:
> > 
> > From my point of view it's not too much trouble to recreate these
> > filesystems, and we've already proposed a fix for supermin so it
> > creates symlinks properly[1].
> 
> My concern is that people using libguestfs, et.al., on Fedura XX and
> then try to decide to upgrade to the 4.13 kernel.  So it sounds like
> the exposure could be pretty large.  Am I wrong?

In this case we're using libext2fs to build an appliance filesystem,
used to boot a small Linux system which is then run under qemu by
libguestfs.  This appliance is completely rebuilt automatically under
many circumstances, for example a host package upgrade (eg. upgrading
the kernel), so it's not a long-lived filesystem that would cause a
problem.  Rebuilding only takes a few seconds.

The process is described in more detail here:
http://libguestfs.org/supermin.1.html#SUPERMIN-APPLIANCES

>From our point of view the only issue are some prebuilt appliances
which we have provided to other distributions that cannot / don't want
to use supermin (http://download.libguestfs.org/binaries/appliance/)
and at some point I'm going to have to rebuild these using the fixed
supermin.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
