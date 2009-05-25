From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Get rid of extend_disksize parameter of
	ext4_get_blocks_handle()
Date: Mon, 25 May 2009 09:46:45 +0200
Message-ID: <20090525074645.GA23546@duck.suse.cz>
References: <1242840334-5117-1-git-send-email-jack@suse.cz> <1242840334-5117-3-git-send-email-jack@suse.cz> <20090522045734.GA11742@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZEYHqq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 May 2009 03:46:46 -0400
Content-Disposition: inline
In-Reply-To: <20090522045734.GA11742@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 22-05-09 00:57:34, Theodore Tso wrote:
> On Wed, May 20, 2009 at 07:25:34PM +0200, Jan Kara wrote:
> > Get rid of extenddisksize parameter of ext4_get_blocks_handle(). This seems to
> > be a relict from some old days and setting disksize in this function does not
> > make much sence. Currently it was set only by ext4_getblk().  Since the
> 
> s/sence/sense/
  Thanks.

> > parameter has some effect only if create == 1, it is easy to check that the
> > three callers which end up calling ext4_getblk() with create == 1 (ext4_append,
> > ext4_quota_write, ext4_mkdir) do the right thing and set disksize themselves.
> 
> So this patch doesn't apply any more since I've done my own set of
> cleanups to the ext4 code base, so extend_disksize is no longer a
> separate parameter, but a bit flag (and ext4_get_blocks_wrap has been
> renamed to a more sensible ext4_get_blocks).
> 
> More to the point, this removess the code which sets the disksize --
> which I agree is funny that it is done in ext4_ext4_get_blocks() and
> ext4_ind_get_blocks() --- but I don't see anything in your patch which
> actually sets disksize in ext4_append(), ext4_quota_write(), or
> ext4_mkdir().  Do none of these actually need disksize to be set?  If
> so, the commit message should explain that.
  All these functions already set i_disksize themselves. E.g. ext4_append()
does
bh = ext4_bread(handle, inode, *block, 1, err);
if (bh) {
         inode->i_size += inode->i_sb->s_blocksize;
         EXT4_I(inode)->i_disksize = inode->i_size;
         *err = ext4_journal_get_write_access(handle, bh);
...
  BTW: I've tried to mention this in the changelog but obviously I've
failed doing it clearly enough ;).

> If not, perhaps it would be better if the update of the disksize field
> be done in ext4_getblk()?
  I'd keep ext4_getblk() and ext4_bread() just being lowlevel functions
mapping / allocating a block. The caller is responsible for updating i_size
and i_disksize if it needs to be changed.
  I'll rediff the ext4 patch against your tree and resend it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
