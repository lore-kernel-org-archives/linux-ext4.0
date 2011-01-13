From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Hibernate: Don't mark pages dirty when reading
 pages while thawing
Date: Thu, 13 Jan 2011 13:36:15 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101131333071.1899@localhost6.localdomain6>
References: <20110113055612.GF13496@thunk.org> <1294898351-26156-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-pm@lists.linux-foundation.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:56642 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1AMMgS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 07:36:18 -0500
In-Reply-To: <1294898351-26156-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Thu, 13 Jan 2011, Theodore Ts'o wrote:
> Everything was sync'ed before the hibernation, so no pages could be
> dirty.  So this causes a lot of wasted I/O activity right after
> resuming from hibernation.
> 
> Worse, it also causes pages from files that were opened read/only to
> be marked writeble which makes them subject to writeback.  This was
> discovered when ext4 was changed to so that the jinode pointer was not
> initialized unless the file was opened read/write, and this caused
> things to blow up.  But that just unmasked a problem, since the pages
> belonging to the file in question should have never been marked dirty
> in the first place.  It increases the chances the text blocks for
> executables like /usr/bin/killall will get corrupted when they are
> needlessly written, and of course it means extra write cycles to the
> SSD.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
> Cc: linux-pm@lists.linux-foundation.org
> ---
>  kernel/power/block_io.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/block_io.c b/kernel/power/block_io.c
> index 83bbc7c..108a4f3 100644
> --- a/kernel/power/block_io.c
> +++ b/kernel/power/block_io.c
> @@ -49,8 +49,6 @@ static int submit(int rw, struct block_device *bdev, sector_t sector,
>  	if (bio_chain == NULL) {
>  		submit_bio(bio_rw, bio);
>  		wait_on_page_locked(page);
> -		if (rw == READ)
> -			bio_set_pages_dirty(bio);
>  		bio_put(bio);
>  	} else {
>  		if (rw == READ)
> -- 
> 1.7.3.1
> 
> 

I did some test with this patch applied, but sadly it didn't help.
The testcase was reduced to one hibernation followed by a sync.

Regards,
Sebastian
