From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: 32TB ext4 fsck times
Date: Thu, 23 Apr 2009 11:14:26 -0400
Message-ID: <20090423151426.GC8476@shell>
References: <10039.1240286799@gamaville.dokosmarshall.org> <49EE1F06.5040508@redhat.com> <20090422231816.GA7066@shell> <10808.1240466476@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZDWPOd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Apr 2009 11:14:33 -0400
Content-Disposition: inline
In-Reply-To: <10808.1240466476@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 23, 2009 at 02:01:16AM -0400, Nick Dokos wrote:
> Valerie Aurora Henson <vaurora@redhat.com> wrote:
> 
> > Back to something useful the short term... Was the file system created
> > with uninitialized block groups and lazy inode table initialization?
> > 
> 
> Uninit_bg was on but lazy inode table initialization was off.  I tried
> turning lazy_itable_init on but e2fsck gets tons of errors, starting
> with group descriptor checksum errors.  Unfortunately, I now get group
> descriptor checksum errors even without lazy_itable_init and I 'm not
> sure why. So I'm back to debugging mke2fs/e2fsck.

I ran into a few heisenbugs when I was working on this, and there's
still that one failing test.  I did track down the commit that started
it, it was:

commit de119e26eb2cf041a8365994dc3a32efc080682e
Author: Valerie Aurora Henson <vaurora@redhat.com>
Date:   Tue Feb 3 13:15:19 2009 -0800

    e2fsck: Miscellaneous e2fsck-related 64-bit fixes.

    With this change, e2fsck runs to completion on a minimal 33-bit file system.

    Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

I might take a look at the problem with the block group descriptors
and lazy itables; that was some crazy^Wcomplex code.

-VAL
