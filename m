From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Convert ext4 to new truncate calling convention
Date: Wed, 25 May 2011 17:34:47 +0200
Message-ID: <20110525153447.GA24867@quack.suse.cz>
References: <1306312988-5508-1-git-send-email-jack@suse.cz>
 <20110525134536.GB8476@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab1EYPet (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2011 11:34:49 -0400
Content-Disposition: inline
In-Reply-To: <20110525134536.GB8476@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 25-05-11 09:45:36, Ted Tso wrote:
> On Wed, May 25, 2011 at 10:43:08AM +0200, Jan Kara wrote:
> >  int ext4_can_truncate(struct inode *inode)
> >  {
> > -	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> > -		return 0;
> 
> I agree this change is correct, but I noticed that at the VFS level,
> the ftruncate() path doesn't seem to check for IS_APPEND() and
> IS_IMMUTABLE().  Am I missing something?  Fixing that should be a
> separate patch, of course, but it does seem to be a problem.
  It does check it - IMMUTABLE file cannot be open for writing so cannot
be ftruncated, APPEND file is checked in do_sys_ftruncate() AFAICS.


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
