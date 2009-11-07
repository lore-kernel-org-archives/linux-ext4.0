From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 2/2] ext4: journal superblock modifications in ext4_statfs()
Date: Fri, 06 Nov 2009 17:26:51 -0700
Message-ID: <6BDA2C94-6FA5-48EE-9E68-56BDFC4B558A@sun.com>
References: <4AF4A429.7090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50070 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZKGA0s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Nov 2009 19:26:48 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA70Qss3001836
	for <linux-ext4@vger.kernel.org>; Fri, 6 Nov 2009 16:26:54 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSP00E00QFI6J00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 06 Nov 2009 16:26:54 -0800 (PST)
In-reply-to: <4AF4A429.7090507@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-06, at 15:33, Eric Sandeen wrote:
> commit a71ce8c6c9bf269b192f352ea555217815cf027e updated
> ext4_statfs() to update the on-disk superblock counters,
> but modified this buffer directly without any journaling of
> the change.  This is one of the accesses that was causing the crc  
> errors in journal replay as seen in kernel.org bugzilla #14354.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
>
> @@ -3650,20 +3652,33 @@ static int ext4_statfs(struct dentry  
> *dentry, struct kstatfs *buf)
> +	handle = ext4_journal_start_sb(sb, 1);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto out;
> +	}
> +	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
> +	if (err)
> +		goto journal_stop;
> +	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
> +	ext4_free_blocks_count_set(es, buf->f_bfree);
> +	err = ext4_handle_dirty_metadata(handle, NULL, EXT4_SB(sb)->s_sbh);


I admit to being the instigator of this change.

The intention is that we want to update the on-disk superblock block/ 
inode
counters from the per-cpu data periodically, since they are never  
updated
anymore (only the group summaries are updated, to avoid contention).   
However,
this isn't critical work, since it is only useful for read-only e2fsck  
not
reporting spurious errors on the filesystem and dumpe2fs/debugfs  
having some
chance at reporting a reasonable value for the filesystem space usage.

Starting a transaction as part of statfs is really counter-productive  
to making
that code efficient, which was the whole point of the original patch  
to remove
the per-call "overhead" calculation.

The intention was that the in-memory superblock would be updated  
whenever statfs
is called (this doesn't cost anything, since we've already computed  
the value
for statfs), and if the superblock is written to disk for some other  
reason they
will go along for the ride.

If the choice is between adding a proper transaction here, or not  
doing this at
all, I'd rather just not do it at all.  Of course, I'd like to work  
out some
kind of compromise, like only updating the superblock when there is  
already a shadow BH that is being used to write to the journal, or  
similar.

If there is a desire to keep a transaction here and update the  
superblock
counters, it _definitely_ doesn't need to be done on every statfs, but  
at most
once every 30 seconds or whatever.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

