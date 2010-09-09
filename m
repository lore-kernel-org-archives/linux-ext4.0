From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 3/5] Add inode table initialization code for Ext4
Date: Thu, 9 Sep 2010 11:08:48 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009091030340.2889@dhcp-lab-213.englab.brq.redhat.com>
References: <1283965160-31597-1-git-send-email-lczerner@redhat.com> <1283965160-31597-4-git-send-email-lczerner@redhat.com> <B95B3853-8009-4664-A584-97C47569498E@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	rwheeler@redhat.com, sandeen@redhat.com, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0IIJIy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 05:08:54 -0400
In-Reply-To: <B95B3853-8009-4664-A584-97C47569498E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 8 Sep 2010, Andreas Dilger wrote:

> On 2010-09-08, at 10:59, Lukas Czerner wrote:
> > +extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t
> > +{
> > +	if (sb->s_flags & MS_RDONLY) {
> > +		ext4_warning(sb, "Filesystem mounted read only. "
> > +				 "Won't zeroout anything!");
> > +		ret = 1;
> > +		goto out;
> > +	}
> 
> Is it actually needed to print this error message?  This thread shouldn't
> be run if the filesystem was originally mounted read-only (that is checked
> in ext4_register_li_request()), and if it is later remounted read-only
> (due to user action or filesystem error) I don't think it is critical to
> print a message here.
> 
> The ext4lazyinit thread will be restarted when the filesystem is remounted
> read-write in the future.

Yeah, it is not needed, because when filesystem is mounted (or
remounted) as read only the thread would not start, or would be
destroyed. I'll get rid of that error message, but I would rather leave
the check anyway, just to be sure.

> 
> > +	/*
> > +	 * Skip zeroout if the inode table is full. But we set the ZEROED
> > +	 * flag anyway, because obviously, when it is full it does not need
> > +	 * further zeroing.
> > +	 */
> > +	if (unlikely(num == 0))
> > +		goto skip_zeroout;
> 
> In fact, this is still safe as long as num < EXT4_INODES_PER_GROUP(sb).

Yes, it is safe when num is zero, but in that case the barrier would be
sent anyway, so I rather skip it. Or I can fix the
blkdev_issue_zeroout() to check if nr_sects is zero and exit before the
barrier, this might be a better solution.

> 
> > +	ext4_debug("going to zero out inode table in group %d\n",
> > +		group);
> 
> the "group" should align with the '(' on the previous line.
> 
> > +/* Find next suitable group adn run ext4_init_inode_table */
> > +static int ext4_run_li_request(struct ext4_li_request *elr)
> > +{
> > +	for (group = elr->lr_next_group; group < ngroups; group++) {
> > +		gdp = ext4_get_group_desc(sb, group, NULL);
> > +		if (!gdp) {
> > +			ret = 1;
> > +			break;
> > +		}
> > +
> > +		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
> > +			break;
> > +	}
> 
> There is nowhere in the code that lr_next_group is increased.  That should
> probably be done in this function.  Otherwise, for a large filesystem with
> 256k groups in it there will be an O(n^2) search for the next group to zero.

I do not believe I forgot to set the lr_next_group, but obviously I
did :). I'll fix that.

> 
> > +static int ext4_lazyinit_thread(void *arg)
> > +{
> > +	while (true) {
> > +		list_for_each_safe(pos, n, &eli->li_request_list) {
> > +			/* Handle jiffies overflow - is it even possible?*/
> > +			if (timeout > jiffies)
> > +				timeout = (ULONG_MAX - timeout) + jiffies;
> > +			else
> > +				timeout = jiffies - timeout;
> 
> I'm not sure this is needed.  When you compute "jiffies - timeout", it
> doesn't matter if "jiffies" has suddenly wrapped, the result will be the
> same.

You're right, what I was thinking...

> 
> > +static ext4_group_t ext4_has_uninit_itable(struct super_block *sb)
> > +{
> > +	for (group = 0; group < ngroups; group++) {
> > +		gdp = ext4_get_group_desc(sb, group, NULL);
> > +		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
> > +			break;
> 
> It would be much more efficient to do this in ext4_check_descriptors(),
> which is already walking through all of the groups checking the validity
> of the group descriptors at mount time.

Sounds good.

> 
> An alternative that would speed up mounting of large filesystems is to
> do the ext4_check_descriptors() checks from the ext4lazyinit thread.
> If any groups are found to be in error (which should be very rare)
> they can be marked in the group descriptor with a new per-group
> EXT4_BG_ERROR flag and skipped for any future allocations.  This would
> need an additional in-memory flag that tracked if the group descriptor's
> checksum and block pointers had been validated yet or not, so that they
> are not used by anything before they are checked.  That is a change that
> could be made at some later stage, after the initial patch is landed.

Right now, when descriptors are bad filesystem is not mounted, which is
a good thing because we do not want to work with corrupted filesystem
and we are forcing user to run fsck to fix it (if it is possible). But
in your scenario we will be actually using the filesystem with errors.
Of course we will not be using corrupted groups, but user will probably
ignore the error and try to use the filesystem as he was used to. Is it
a good thing ? We won't be able to use data from corrupted groups
and what we will tell user when he would like to work with them ?

> 
> Cheers, Andreas
> 

Thanks a lot for you comments and suggestions Andreas, I really appreciate
it.

Regards.
-Lukas
