From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 11:12:46 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0JVJMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 05:12:52 -0400
In-Reply-To: <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 21 Oct 2010, Andreas Dilger wrote:

> On 2010-10-21, at 08:15, Lukas Czerner wrote:
> > In Pass 5 when we are checking block and inode bitmaps we have great
> > opportunity to discard free space and unused inodes on the device,
> > because bitmaps has just been verified as valid. This commit takes
> > advantage of this opportunity and discards both, all free space and
> > unused inodes.
> > 
> > I have added new option '-K' which when set, disables discard. Also when
> > the underlying device does not support discard, or BLKDISCARD ioctl
> > returns any kind of error, or when some errors occurred in bitmaps, the
> > discard is disabled.
> 
> I'm always a bit nervous with patches like this, that will prevent data recovery after an e2fsck run (which seems like the opposite of what we want from e2fsck).
> 
> Two suggestions:
> - it probably makes sense to disable this by default, and allow it to be
>   specified on the command-line and e2fsck.conf
> - should we really have a short option, or a "-E discard" and "-E nodiscard"
>   options, which allow us to change the default easily at some later time
>   (which we can't do with a single -K flag)

Right, I agree it would be probably better to disable this by default.

> 
> > +static void e2fsck_discard_blocks(e2fsck_t ctx, blk_t start,
> > +				  blk_t count)
> > +{
> > +	fd = open64(fs->device_name, O_RDWR);
> > +	if (fd < 0) {
> > +		com_err("open", errno,
> > +			_("while opening %s for discarding"),
> > +			ctx->device_name);
> > +		fatal_error(ctx, 0);
> > +	}
> > +
> > +	ret = ioctl(fd, BLKDISCARD, &range);
> > +	if (ret)
> > +		ctx->options &= ~E2F_OPT_DISCARD;
> > +
> > +	close(fd);
> > +}
> 
> If we are calling this ioctl for a lot of small block ranges, doing an open/close for each one could add significant overhead.  The unix struct_io_manager already has an open file descriptor for this block device, maybe it is better to encapsulate this operation there?  The ioctl also doesn't make sense for non-Linux platforms (though they may have a different ioctl that is equivalent) so that may be a better solution.

That is why the #ifdef __linux__ is there. I agree with using
struct_io_manager file descriptor.

> 
> (defect) It makes sense to start with a blk64_t for this function, instead of a blk_t that needs to be fixed immediately for > 16TB filesystems, or the block number will be truncated and accidentally discard the wrong data.  Oops.

Oh, I have missed that out.

> 
> 
> Cheers, Andreas

Thanks for review Andreas.

-Lukas
