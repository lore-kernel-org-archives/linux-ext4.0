From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Mon, 27 Sep 2010 11:20:57 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1009271113210.2743@dhcp-lab-213.englab.brq.redhat.com>
References: <1285342559-16424-1-git-send-email-lczerner@redhat.com> <1285342559-16424-2-git-send-email-lczerner@redhat.com> <F2605A93-6209-4A10-A444-E936FE7B882D@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	snitzer@gmail.com
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298Ab0I0JVE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Sep 2010 05:21:04 -0400
In-Reply-To: <F2605A93-6209-4A10-A444-E936FE7B882D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 24 Sep 2010, Andreas Dilger wrote:

> On 2010-09-24, at 09:35, Lukas Czerner wrote:
> > array[0] - (start) first Byte to trim
> > array[1] - (len) number of Bytes to trim from start
> > array[2] - (minlen) minimum extent length to trim, free extents shorter
> > 
> > than this number of Bytes will be ignored. This number will be rounded
> > up to the block size.
> > 
> > It is also possible to specify NULL as an argument. In this case the
> > arguments will set itself as follows:
> > 
> > args[0] = 0;
> > args[1] = ULLONG_MAX;
> > args[2] = 0;
> 
> (minor) you use "array[]" in one place and "args[]" in another.
> 
> > +#define FITRIM		_IOWR('X', 121, uint64_t)	/* Trim */
> 
> This ioctl definition isn't strictly correct.  The "size" parameter is actually uint64_t[3], though I'm not sure whether you need to define a structure in order to specify this.

You,re probably right. A structure would be better. But for example
BLKDISCARD takes takes uint64_t[2] and its definition looks like:

#define BLKDISCARD _IO(0x12,119)

which confuses me a bit.

> 
> Cheers, Andreas
