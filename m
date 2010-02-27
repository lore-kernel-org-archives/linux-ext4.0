From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Fri, 26 Feb 2010 19:12:00 -0600
Message-ID: <4B887160.2090606@redhat.com>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966723Ab0B0BMH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 20:12:07 -0500
In-Reply-To: <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Piszcz wrote:
...

>> Were the filesystems created to align with raid geometry?
> Only default options were used except the mount options.  If that is the
> culprit, I have some more testing to do, thanks, will look into it.
> 
>>
>> mkfs.xfs has done that forever; mkfs.ext4 only will do so (automatically)
>> with recent kernel+e2fsprogs.
> How recent?

You're recent enough.  :)

mkfs.ext4 output should include the stripe info if it was found.

        printf(_("Block size=%u (log=%u)\n"), fs->blocksize,
                s->s_log_block_size);
        printf(_("Fragment size=%u (log=%u)\n"), fs->fragsize,
                s->s_log_frag_size);
        printf(_("Stride=%u blocks, Stripe width=%u blocks\n"),
               s->s_raid_stride, s->s_raid_stripe_width);
        printf(_("%u inodes, %llu blocks\n"), s->s_inodes_count,
               ext2fs_blocks_count(s));

etc.

-Eric
