From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] UPDATED3: types fixup for mballoc
Date: Tue, 8 Jan 2008 20:47:58 -0700
Message-ID: <20080109034757.GJ3351@webber.adilger.int>
References: <473CCEB8.5060201@redhat.com> <473D2147.9030504@redhat.com> <477BEDAC.1030802@redhat.com> <20080103191733.GJ3351@webber.adilger.int> <477D3678.7020203@redhat.com> <477D4152.4020901@redhat.com> <4783D4E2.5080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:47334 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYAIDsG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jan 2008 22:48:06 -0500
Content-Disposition: inline
In-Reply-To: <4783D4E2.5080801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 08, 2008  13:54 -0600, Eric Sandeen wrote:
> Note, the calculations Andreas & I were discussing only work properly
> for stripe <= blocks per group... I don't know if we'd need to enforce
> that at mount time?

I think that would be prudent, but can be done in a separate patch.
If the RAID stripe width is so large that one has to do read-modify-write
for a whole group write (8MB @ 1kB blocksize, 128MB @ 4kB blocksize)
then I don't think we can use that to align allocations.

I think Aneesh might be working on getting s_raid_stripe_width from the
superblock, and we may as well do the sanity checking in the same patch.
If sb->s_raid_stripe_width > EXT4_BLOCKS_PER_GROUP, then as a fallback
I'd suggest using sb->s_raid_stride if < EXT4_BLOCKS_PER_GROUP, or just
ignoring both if unsuitable.

> I ran into a potential overflow in ext4_mb_scan_aligned, 
> and went looking for others in mballoc.  This patch hits a 
> few spots, compile-tested only at this point, comments welcome.
> 
> This patch:
> 
> changes fe_len to an int, I don't think we need it to be a long,
> looking at how it's used (should it be a grpblk_t?)  Also change
> anything assigned to return value of mb_find_extent, since it returns
> fe_len.
> 
> changes anything that does groupno * EXT4_BLOCKS_PER_GROUP
> or pa->pa_pstart + <whatever> to an ext4_fsblk_t
> 
> avoids 64-bit divides & modulos, and...
> 
> fixes up any related formats
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

You can add a "Signed-off-by: Andreas Dilger <adilger@sun.com>" too.
The revised calcs look good to me.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
