From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Get rid of extend_disksize parameter of
	ext4_get_blocks_handle()
Date: Fri, 22 May 2009 00:57:34 -0400
Message-ID: <20090522045734.GA11742@mit.edu>
References: <1242840334-5117-1-git-send-email-jack@suse.cz> <1242840334-5117-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41114 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbZEVE5j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2009 00:57:39 -0400
Content-Disposition: inline
In-Reply-To: <1242840334-5117-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2009 at 07:25:34PM +0200, Jan Kara wrote:
> Get rid of extenddisksize parameter of ext4_get_blocks_handle(). This seems to
> be a relict from some old days and setting disksize in this function does not
> make much sence. Currently it was set only by ext4_getblk().  Since the

s/sence/sense/

> parameter has some effect only if create == 1, it is easy to check that the
> three callers which end up calling ext4_getblk() with create == 1 (ext4_append,
> ext4_quota_write, ext4_mkdir) do the right thing and set disksize themselves.

So this patch doesn't apply any more since I've done my own set of
cleanups to the ext4 code base, so extend_disksize is no longer a
separate parameter, but a bit flag (and ext4_get_blocks_wrap has been
renamed to a more sensible ext4_get_blocks).

More to the point, this removess the code which sets the disksize --
which I agree is funny that it is done in ext4_ext4_get_blocks() and
ext4_ind_get_blocks() --- but I don't see anything in your patch which
actually sets disksize in ext4_append(), ext4_quota_write(), or
ext4_mkdir().  Do none of these actually need disksize to be set?  If
so, the commit message should explain that.

If not, perhaps it would be better if the update of the disksize field
be done in ext4_getblk()?

(And the same question here applies to the ext3 patch; it seems to
remove the code which manages the i_disksize without replacing it
anywhere that I can see.)

						- Ted
