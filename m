From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 1 Aug 2008 20:03:05 -0400
Message-ID: <20080802000305.GA8433@mit.edu>
References: <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1217383118.27664.14.camel@mingming-laptop> <1217417361.3373.15.camel@localhost> <1217527631.6317.6.camel@mingming-laptop> <20080801054932.GF8736@mit.edu> <1217613795.12413.15.camel@mingming-laptop> <20080801191015.GH8654@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42799 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbYHBADo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 20:03:44 -0400
Content-Disposition: inline
In-Reply-To: <20080801191015.GH8654@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2008 at 03:10:15PM -0400, Theodore Tso wrote:
> > Currently ext4_delete_inode() uses blocks_for_truncate(inode) to
> > calculate credits, by the time ext4_delete_inode() is called, i_blocks
> > seems to 0 (I need to double check this). 

You were right; I didn't realize bonnie's create/delete files was
doing so with zero length blocks.  So yes, there is no need to call
truncate.  I'm still confused why we're running out of credits, given
that we allocate EXT4_DATA_TRANS_BLOCKS(sb) credits which is:

#define EXT4_DATA_TRANS_BLOCKS(sb)	(EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + \
					 EXT4_XATTR_TRANS_BLOCKS - 2 + \
					 2*EXT4_QUOTA_TRANS_BLOCKS(sb))

EXT4_SINGLEDATA_TRANS_BLOCKS is 27 credits when extents are enabled,
and XATTR_TRANS_BLOCKS is another 6, so we are reserving 31 credits
with quotas disabled.  Given that bonnie++ doesn't create extended
attributes, and the 27 credits were for 5 levels of extent tree, why
did we run out?  

We can make ext4_delete_inode() request an extra 3 blocks (one for the
inode bitmap, and two to update the orphaned inode linked list), but
I'm not sure why the 31 credits wasn't enough.

In any case, I figurd out why my patch wasn't enough.  There was a bug
in ext4_ext_journal_restart:

int ext4_ext_journal_restart(handle_t *handle, int needed)
{
	int err;

	if (handle->h_buffer_credits > needed)
		return 0;
	err = ext4_journal_extend(handle, needed);
	if (err)
		return err;
	return ext4_journal_restart(handle, needed);
}

This is buggy; ext4_journal_extend returns < 0 on an error, 0 if the
handle was successfully extended without needing a journal restart,
and > 0 if the ext4_journal_restart() needs to be called.  So the
current code returns a failure and doesn't restart the journal when it
is needed, and calls ext4_journal_restart() needlessly when it is not
needed and the handle could be extended without closing the current
transaction.

The fix is a simple one-liner:

int ext4_ext_journal_restart(handle_t *handle, int needed)
{
	int ret;

	if (handle->h_buffer_credits > needed)
		return 0;
	err = ext4_journal_extend(handle, needed);
	if (ret < = 0)
		return ret;
	return ext4_journal_restart(handle, needed);
}

This seems to indicate ext4_ext_journal_restart() has never been
called in anger by the ext4_ext_truncate() code.  We may want to
double check it with a really big, mongo extent tree and make sure it
does the right thing one of these days.

							- Ted
