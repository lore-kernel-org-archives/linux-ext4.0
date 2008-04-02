From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC PATCH 2/2] Add timeout feature
Date: Wed, 2 Apr 2008 16:21:47 +1000
Message-ID: <20080402062147.GH103491721@sgi.com>
References: <20080328180736t-sato@mail.jp.nec.com> <20080331000057.GI108924158@sgi.com> <2530BB4B166747659C8F65C9C3DE7CFB@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54150 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628AbYDBGWG (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2008 02:22:06 -0400
Content-Disposition: inline
In-Reply-To: <2530BB4B166747659C8F65C9C3DE7CFB@nsl.ad.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 01, 2008 at 07:54:42PM +0900, Takashi Sato wrote:
> Hi,
> 
> David Chinner wrote:
> >The timeout is not for the freeze operation - the timeout is
> >only set up once the freeze is complete. i.e:
> >
> >$ time sudo ~/test_src/xfs_io -f -x -c 'gfreeze 10' /mnt/scratch/test
> >freezing with level = 10
> >
> >real    0m23.204s
> >user    0m0.008s
> >sys     0m0.012s
> >
> >The freeze takes 23s, and then the 10s timeout is started. So
> >this timeout does not protect against freeze_bdev() hangs at all.
> >All it does is introduce silent unfreezing of the block device that
> >can not be synchronised with the application that is operating
> >on the frozen device.
> 
> Exactly my timeout feature is only for an application, not for 
> freeze_bdev().
> I think it is needed for the situation we can't unfreeze from userspace.
> (e.g. Freezing the root filesystem)

Ummm - why can't you unfreeze the root fs from userspace? freezing
only prevents modification to the filesystem. A frozen filesystem is
effectively a read-only filesystem...

On XFS:

# xfs_freeze -f /
# echo $?
0
# xfs_freeze -u /
# echo $?
0

The underlying filesystem is broken w.r.t. freezing if you can't
read from it successfully once it's been frozen....

> >FWIW, resetting this timeout from userspace is unreliable - there's
> >no guarantee that under load your userspace process will get to run
> >again inside the timeout to reset it, hence leaving you with a
> >unfrozen filesystem when you really want it frozen...
> 
> The timeout period specified to the reset ioctl should be much larger than
> the interval for calling the reset ioctl repeatedly.
> (e.g timeout period = 2 minutes, calling interval = 5 seconds)

What application developer will ever use this?

> The reset ioctl will work under such setting.
> If a timeout still occurs before a reset, it would imply that an unexpected
> problem (e.g. deadlock) occur in an application.

Right - the application is broken and needs fixing.  We don't need
to supply a crutch in a "new" API to support hypothetically broken
applications that don't actually exist yet.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
