From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Fix truncation of symlinks after failed write
Date: Wed, 15 Jul 2009 12:28:40 +0200
Message-ID: <20090715102840.GA25458@duck.suse.cz>
References: <1247513367-5609-1-git-send-email-jack@suse.cz> <1247513367-5609-3-git-send-email-jack@suse.cz> <20090715061856.GB17310@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZGOK2m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2009 06:28:42 -0400
Content-Disposition: inline
In-Reply-To: <20090715061856.GB17310@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 15-07-09 11:48:56, Aneesh Kumar K.V wrote:
> On Mon, Jul 13, 2009 at 09:29:27PM +0200, Jan Kara wrote:
> > Contents of long symlinks is written via standard write methods. So when the
> > write fails, we add inode to orphan list. But symlinks don't have .truncate
> > method defined so nobody properly removes them from the on disk orphan list.
> > 
> > Fix this by calling ext4_truncate() directly instead of calling vmtruncate()
> > (which is saner anyway since we don't need anything vmtruncate() does except
> > from calling .truncate in these paths).
> 
> We are fixing below by not adding the inode to orphan list if they don't
> have a .truncate call back right ?. So changing vmtruncate to ext4_truncate is
> not be really needed to fix the problem right ?
  Thanks for having a look.  ext4_can_truncate() does not check existence
of .truncate method. I feel it's mostly a pure coincidence that the result
of ext4_can_truncate() corresponds with the existence of .truncate method
in ext4_write_begin(). Moreover if copying of symlink data could fail
(which it cannot currently), we would really need to do the truncate. So
yes, the code would still work if we didn't change vmtruncate() to
ext4_truncate() but I feel it's *much* clearer this way.

> >We also add inode to orphan list only
> > if ext4_can_truncate() is true (currently, it can be false for symlinks when
> > there are no blocks allocated) - otherwise orphan list processing will complain
> > and ext4_truncate() will not remove inode from on-disk orphan list.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
