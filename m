From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Wed, 17 Dec 2008 23:51:10 -0700
Message-ID: <20081218065110.GD5000@webber.adilger.int>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:43572 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLRGvO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 01:51:14 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mBI6pCxA006039
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 22:51:12 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KC200501878QO00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 17 Dec 2008 22:51:12 -0800 (PST)
In-reply-to: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 10, 2008  15:54 -0800, Frank Mayhar wrote:
> A few weeks ago I posted a patch for discussion that allowed ext4 to run
> without a journal.  Since that time I've integrated the excellent
> comments from Andreas and fixed several serious bugs.  We're currently
> running with this patch and generating some performance numbers against
> both ext2 (with backported reservations code) and ext4 with and without
> a journal.  It just so happens that running without a journal is
> slightly faster for most everything.
> 
> We did
> 	iozone -T -t 4 s 2g -r 256k -T -I -i0 -i1 -i2
> 
> which creates 4 threads, each of which create and do reads and writes on
> a 2G file, with a buffer size of 256K, using O_DIRECT for all file opens
> to bypass the page cache.  Results:
> 
>                      ext2        ext4, default   ext4, no journal
>   initial writes   13.0 MB/s        15.4 MB/s          15.7 MB/s
>   rewrites         13.1 MB/s        15.6 MB/s          15.9 MB/s
>   reads            15.2 MB/s        16.9 MB/s          17.2 MB/s
>   re-reads         15.3 MB/s        16.9 MB/s          17.2 MB/s
>   random readers    5.6 MB/s         5.6 MB/s           5.7 MB/s
>   random writers    5.1 MB/s         5.3 MB/s           5.4 MB/s 
> 
> So it seems that, so far, this was a useful exercise.

This would imply that there is very little value in keeping ext2 or
ext3 around for the long term anymore (though of course I'm not going
to suggest that we get rid of them today).  It is now possible to mount
ext2 filesystems directly with ext4, and it seems clear that ext4 is
noticably faster, even with a journal.

> +#define EXT4_NOJOURNAL_MAGIC	(void *)0x457874344e6a6e6c /* "Ext4Njnl" */

While I wouldn't go so far as Ted suggests to use "1" as the magic value,
it is definitely reasonable to not use a valid pointer value (so it should
be an odd number) and keeping it out of the kernel address space is also
useful.  Ensuring that it is not a valid pointer is sufficient, because
the first element of struct handle_s is a pointer and it can never be an
odd number due to alignment requirements.

>> If you look at ext4_handle_valid you'll see where it's actually used.  I
>> admit this is very non-obvious (so far it has confused at least two
>> different reviewers); if you have a more clear way to handle it I'm all
>> ears.

Adding a clear comments explaining this (not just a one-liner) at 
ext4_sb_info so that no others are so confused about this.

> +	/*
> +	 * We're not journaling.  Return a pointer to our flag that
> +	 * indicates that fact.
> +	 */
> +	current->journal_info = (handle_t *)&EXT4_SB(sb)->s_nojournal_flag;
> +	return current->journal_info;


Since current->journal_info is a void * you shouldn't need to cast here.


Also, I thought there was somewhere that the "handle" was turned back into
ext4_sb_info again?  I can't see this after looking through the code.
The EXT4_NOJOURNAL_MAGIC and s_nojournal_flag is only used to determine if
a handle is not valid, and I can't see anywhere that a handle is turned
into ext4_sb_info.

If there is nowhere that you need to translate a handle into a superblock
anymore then having a pointer to a static variable would be sufficient.
There is no need for a magic value, and dereferencing it will give an oops:

static int dummy_handle = 0x0bad;
void *ext4_no_journal_in_use = &dummy_handle;

static inline int ext4_handle_valid(handle_t *handle)
{
	if (handle == ext4_no_journal_in_use)
		return 0;
	return 1;
}

handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
{

	/*
	 * We're not journaling.  Return a pointer to our flag that
	 * indicates that fact.
	 */
	current->journal_info = ext4_no_journal_in_use;
	return current->journal_info;
}



Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

