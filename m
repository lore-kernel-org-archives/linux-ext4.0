From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Thu, 17 Sep 2009 23:55:47 -0600
Message-ID: <20090918055547.GO2537@webber.adilger.int>
References: <4AB2B6B9.7010506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62100 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZIRFzn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 01:55:43 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8I5tl7q021028
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 22:55:47 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ500300K4CU500@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 17 Sep 2009 22:55:47 -0700 (PDT)
In-reply-to: <4AB2B6B9.7010506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 17, 2009  17:22 -0500, Eric Sandeen wrote:
> This is just a rough cut, due to the blkid header selection
> issues I mentioned earlier on the list.  It'll also need
> some config-fu to be sure we've got a blkid which has these
> calls, but with it in place, we'll finally have automatic
> selection of stride/stripe:
> 
> # misc/mke2fs -b 4096 /dev/md0 
> mke2fs 1.41.9 (22-Aug-2009)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=16 blocks, Stripe width=32 blocks
> ...

Cool.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>  	printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
>  		s->s_log_frag_size);
> +	printf(_("Stride=%u blocks, Stripe width=%u blocks\n"),
> +	       s->s_raid_stride, s->s_raid_stripe_width);

I was going to say we should only print these if non-zero, but for
Pete's sake we print the "Fragment size", which has never been useful,
so I don't see any harm in this.  Maybe "RAID Stride ..."?

> +static errcode_t ext2fs_get_device_geometry(const char *file,
> +					    struct ext2_super_block *fs_param)
> +{
> +	rc = blkid_probe_set_device(pr, fd, 0, 0);

Is this in the e2fsprogs blkid code yet?  I'm guessing not, since you
are getting build problems, which means anyone building with something
other than latest & greatest util-linux will also get failures.

Either this needs to be configured in, or you need to upgrade the
blkid included with e2fsprogs to handle this.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

