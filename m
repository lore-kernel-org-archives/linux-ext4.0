From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: jbd2 inside a device mapper module
Date: Fri, 26 Dec 2008 14:17:08 -0200
Message-ID: <20081226161708.GC4127@blitiri.com.ar>
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar> <20081225155248.GJ9871@mit.edu> <20081226000005.GB4127@blitiri.com.ar> <20081226033736.GK9871@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4423 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYLZQTL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Dec 2008 11:19:11 -0500
Content-Disposition: inline
In-Reply-To: <20081226033736.GK9871@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 25, 2008 at 10:37:36PM -0500, Theodore Tso wrote:
> On Thu, Dec 25, 2008 at 10:00:05PM -0200, Alberto Bertogli wrote:
> > 
> > I think I'm not explaining myself correctly. My code has _nothing_ to do
> > with ext2/3/4 (or any other filesystem) whatsoever. I'm not using the
> > journal as an external one for a filesystem. I want to use it to be able
> > to do atomic writes in my own, filesystem independant, device-mapper
> > code.
> 
> How many block writes are you batching into a single transaction?  If
> you're not careful you may find that performance overhead will be
> quite expensive.

At this moment I'm trying to keep it simple, so I plan to batch two for
each sector written to the device: one for the metadata and one for the
data.


> > After what you told me (both this and the deprecation of
> > jbd2_journal_create()), I took a look at e2fsprogs' source. From what I
> > could see, "mke2fs -O journal_dev" creates the external journal inside
> > some ext2/3/4 structures, which caused my journal-loading code to fail
> > (because it doesn't know about ext stuff).
> 
> Yes, this is necessary because in a production system you need to be
> able to identify the external journal by UUID, and the ext2/3/4
> superblock makes it easy to add a label, UUID, et. al.  It also
> significantly lowers the chance that an external journal will get
> misidentified as some other filesystem based on the data stored in the
> journal.

Yes, it makes sense. I've reserved the first sector for that purpose.

Thanks a lot,
		Alberto

