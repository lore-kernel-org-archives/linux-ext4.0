From: Jan Kara <jack@suse.cz>
Subject: Re: Online defragmentation and ext4migrate
Date: Mon, 21 May 2007 12:42:03 +0200
Message-ID: <20070521104203.GC29416@atrey.karlin.mff.cuni.cz>
References: <464DA4ED.9040408@linux.vnet.ibm.com> <1179519594.6109.40.camel@eric-laptop> <cc723f590705210133w17e84f17t11aae329d1d3062@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric <erpo41@gmail.com>, linux-ext4 <linux-ext4@vger.kernel.org>
To: Aneesh Kumar <aneesh.kumar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:39938 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbXEUKmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 06:42:04 -0400
Content-Disposition: inline
In-Reply-To: <cc723f590705210133w17e84f17t11aae329d1d3062@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On 5/19/07, Eric <erpo41@gmail.com> wrote:
> >On Fri, 2007-05-18 at 18:36 +0530, Aneesh Kumar K.V wrote:
> >> The reason why i am asking this is to understand the
> >> usefulness of doing a ext4migrate followed by defrag.
> >> [...]
> >> Also looking at the version 0.4 I see that defrag ioctl only work if we
> >> have EXT4_EXTENTS_FL flag set.
> >
> >ext4migrate is necessary because the current ext4 defrag routines will
> >only defragment files stored as extents. AFAIK, converting a file to
> >extents does not allow the defrag routine to defragment it "better" than
> >an indirect block map inode, but converting any file to extents has
> >performance benefits regardless of whether it is later defragmented.
> >
> >> What are the plans for making defrag work
> >> with indirect block map inode ?
> >
> >I think there is a second set of patches to defragment non-extent
> >files.
> >
> 
> I was looking at this and didn't find the changes needed to defrag the
> non extent files.
> 
> http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg01522.html
  I've written a patch that defragments non-extent files but after
discussion with XFS guys I've decided that the interfaces should be made
more generic, so that XFS and other filesystems can use them too...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
