From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] update contact address
Date: Mon, 19 Jul 2010 14:49:48 +0200
Message-ID: <20100719124948.GC3995@quack.suse.cz>
References: <ECFABD91-8980-47EC-A43C-A68E90CD2A7D@oracle.com>
 <20100717061943.GC27114@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab0GSMuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jul 2010 08:50:13 -0400
Content-Disposition: inline
In-Reply-To: <20100717061943.GC27114@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 17-07-10 02:19:43, Ted Ts'o wrote:
> On Fri, Jul 16, 2010 at 06:09:04PM -0600, Andreas Dilger wrote:
> > I couldn't find a better place to send this.  There is no contact
> > information in the MAINTAINERS list itself.
> 
> Probably the bigger set of changes we should make is to add Jan Kara
> who I believe has taken on the formal ext3 maintainership role in
> place of Andrew...
  Yes, I'm taking care of ext2 and ext3 these days. So we could add
line:
M:	Jan Kara <jack@suse.cz>
  to these two. I'll take care of pushing these MAINTAINERS changes
including Andreas's new address.

								Honza

> >diff --git a/MAINTAINERS b/MAINTAINERS
> >index 449d444..bfc9c69 100644
> >--- a/MAINTAINERS
> >+++ b/MAINTAINERS
> >@@ -2169,7 +2169,7 @@ F:	include/linux/ext2*
> > 
> > EXT3 FILE SYSTEM
> > M:	Andrew Morton <akpm@linux-foundation.org>
> >-M:	Andreas Dilger <adilger@sun.com>
> >+M:	Andreas Dilger <adilger.kernel@dilger.ca>
> > L:	linux-ext4@vger.kernel.org
> > S:	Maintained
> > F:	Documentation/filesystems/ext3.txt
> >@@ -2178,7 +2178,7 @@ F:	include/linux/ext3*
> > 
> > EXT4 FILE SYSTEM
> > M:	"Theodore Ts'o" <tytso@mit.edu>
> >-M:	Andreas Dilger <adilger@sun.com>
> >+M:	Andreas Dilger <adilger.kernel@dilger.ca>
> > L:	linux-ext4@vger.kernel.org
> > W:	http://ext4.wiki.kernel.org
> > Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
> >
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
