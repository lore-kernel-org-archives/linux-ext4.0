From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/9] tune2fs: confirm dangerous operations
Date: Sun, 6 Mar 2016 00:10:57 -0500
Message-ID: <20160306051057.GI10297@thunk.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
 <20160213223811.25381.24546.stgit@birch.djwong.org>
 <D0778787-FF4B-440B-919B-84430E48EFE8@dilger.ca>
 <20160215165300.GF6338@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36906 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbcCFFLB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 00:11:01 -0500
Content-Disposition: inline
In-Reply-To: <20160215165300.GF6338@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've tried it out, and I think 5 seconds is enough time.  I'll note
that just hitting the return key will abort the operation, so the user
has to type 'y', return in order to continue.  In fact I will probaby
change the prompt so it looks like this:

Proceed anyway (or wait %d seconds) (y,n) ? <n>

This should make it clear that if the sysadmin is not sure, just
hitting return is enough to cancel the operation.

> > On Feb 13, 2016, at 3:38 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > 
> > > Give admins a short amount of time to confirm that they want to
> > > proceed with a dangerous operation.  Refuse to perform the op
> > > unless the filesystem is freshly checked.
> > > 
> > > Cc: Andreas Dilger <adilger@dilger.ca>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
