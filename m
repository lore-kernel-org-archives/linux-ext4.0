From: Jan Kara <jack@suse.cz>
Subject: Re: Used dd to copy an ext4 filesystem, but target contained an
 old (mounted!) filesystem
Date: Tue, 18 Oct 2011 03:06:39 +0200
Message-ID: <20111018010639.GJ4528@quack.suse.cz>
References: <4E9C1704.5000304@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1JRBGn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Oct 2011 21:06:43 -0400
Content-Disposition: inline
In-Reply-To: <4E9C1704.5000304@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,
On Mon 17-10-11 12:52:36, Bas van Schaik wrote:
> Long story short: I dd'ed 1.5TB of data to an LVM volume 'newdata'
> that already contained a filesystem (which I wanted to get rid of).
> Unfortunately, the old filesystem turned out to be mounted during
> the dd. After noticing this, I quickly created LVM snapshots of the
> 'newdata' volume before unmounting the old filesystem (hoping that
> it didn't write out it fs data structures to 'newdata' yet, as I
> didn't access it) and tried mounting the snapshot. Unfortunately, it
> showed the old directory listing.
  So let me check I understand what happened. You had some "sourcevol"
containing a filesystem and 1.5 TB of data. You did:
  dd if=sourcevol of=newdata
Now you noticed newdata was mounted so you created lvm snapshot of newdata.
Then umount newdata.

Now if you mount newdata you still see contents of "sourcevol" but you'd
like to see "newdata". Am I correct?

If that's the case, shouldn't you try to mount the snapshot volume instead
of simply "newdata"?

> The actual data is definitely sitting on the 'newdata' volume, but
> the filesystem datastructures simply don't know about it. The source
> of the data is definitely gone, I can't simply dd it again.
> 
> Is there any other location where ext4 stores a copy of its data
> structures?
  Not really. Only the superblock is duplicated.

> Or any other tips & tricks?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
