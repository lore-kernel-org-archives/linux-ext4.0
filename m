From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] update contact address
Date: Sat, 17 Jul 2010 02:19:43 -0400
Message-ID: <20100717061943.GC27114@thunk.org>
References: <ECFABD91-8980-47EC-A43C-A68E90CD2A7D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	trivial@kernel.org, ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35987 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0GQGUY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jul 2010 02:20:24 -0400
Content-Disposition: inline
In-Reply-To: <ECFABD91-8980-47EC-A43C-A68E90CD2A7D@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 16, 2010 at 06:09:04PM -0600, Andreas Dilger wrote:
> I couldn't find a better place to send this.  There is no contact
> information in the MAINTAINERS list itself.

Probably the bigger set of changes we should make is to add Jan Kara
who I believe has taken on the formal ext3 maintainership role in
place of Andrew...

						- Ted

>diff --git a/MAINTAINERS b/MAINTAINERS
>index 449d444..bfc9c69 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -2169,7 +2169,7 @@ F:	include/linux/ext2*
> 
> EXT3 FILE SYSTEM
> M:	Andrew Morton <akpm@linux-foundation.org>
>-M:	Andreas Dilger <adilger@sun.com>
>+M:	Andreas Dilger <adilger.kernel@dilger.ca>
> L:	linux-ext4@vger.kernel.org
> S:	Maintained
> F:	Documentation/filesystems/ext3.txt
>@@ -2178,7 +2178,7 @@ F:	include/linux/ext3*
> 
> EXT4 FILE SYSTEM
> M:	"Theodore Ts'o" <tytso@mit.edu>
>-M:	Andreas Dilger <adilger@sun.com>
>+M:	Andreas Dilger <adilger.kernel@dilger.ca>
> L:	linux-ext4@vger.kernel.org
> W:	http://ext4.wiki.kernel.org
> Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
>
