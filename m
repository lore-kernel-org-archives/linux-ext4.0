From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: correct endianness conversion in
 __xattr_check_inode()
Date: Sat, 15 Oct 2016 09:44:45 -0400
Message-ID: <20161015134445.tckdundg7pgsurnk@thunk.org>
References: <1476205286-136713-1-git-send-email-ebiggers@google.com>
 <20161012103646.GA14664@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35544 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754452AbcJONpj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 15 Oct 2016 09:45:39 -0400
Content-Disposition: inline
In-Reply-To: <20161012103646.GA14664@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 12, 2016 at 12:36:46PM +0200, Jan Kara wrote:
> On Tue 11-10-16 10:01:26, Eric Biggers wrote:
> > It should be cpu_to_le32(), not le32_to_cpu().  No change in behavior.
> > 
> > Found with sparse, and this was the only endianness warning in fs/ext4/.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied

						- Ted
