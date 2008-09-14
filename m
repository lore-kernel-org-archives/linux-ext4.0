From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 14 Sep 2008 09:51:38 -0400
Message-ID: <20080914135138.GC21746@infradead.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu> <29D7C671-F1D5-48BE-AEB4-07669FC3B405@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, akpm@linuxfoundation.org,
	Mark Fasheh <mfasheh@suse.com>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59373 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYINNvk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Sep 2008 09:51:40 -0400
Content-Disposition: inline
In-Reply-To: <29D7C671-F1D5-48BE-AEB4-07669FC3B405@cam.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2008 at 10:59:40PM +0100, Anton Altaparmakov wrote:
>> In fact, the previous version of the patch had a flag for compression,
>> but Cristoph Hellwig objected because he claimed there were no users
>> for it.
>
> He is plain wrong then!  NTFS supports compressed files and always has  
> done!  We only support them read-only at present but that does not  
> matter for the purposes of FIEMAP.  And in any case one day we will have 
> write support for compressed files, too...

Note that I didn't object it because there are not user, this is just
Ted making up BS because he's frustrated.  I said don't add it until we
actually have users so we know their requirements.  The nice part about
this interface is that there is no problem adding more flags once we
need them, if it's just flags, and if we need mor information than just
the flags we're better of discussing these bits beforehand.

> We already have two file systems in the mainline kernel tree that  
> support transparent compression/decompression: ntfs and zisofs so there 
> is no "future" anywhere in sight...  (-;

or cramfs.  But no one involved with this patch srries bothered actually
looking into the requirements.

