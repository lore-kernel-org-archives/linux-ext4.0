From: Dave Chinner <david@fromorbit.com>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Fri, 9 Dec 2016 12:25:21 +1100
Message-ID: <20161209012521.GM4326@dastard>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net>
 <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca>
 <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net>
 <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca>
 <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca>
 <8760mv4mhi.fsf@turtle.gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andreas Dilger <adilger@dilger.ca>,
        Renaud Mariana <rmariana@online.net>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        debian-dpkg@lists.debian.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:46960 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752013AbcLIBZm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2016 20:25:42 -0500
Content-Disposition: inline
In-Reply-To: <8760mv4mhi.fsf@turtle.gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 07, 2016 at 07:34:17PM +0100, Sven Joachim wrote:
> On 2016-12-07 11:16 -0700, Andreas Dilger wrote:
> 
> > Add debian-dpkg mailing list to CC.
> >
> > On Dec 7, 2016, at 10:58 AM, Andreas Dilger <adilger@dilger.ca> wrote:
> >> 
> >> On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> wrote:
> >>> 
> >>> Here are my answers, hope it will help solve this issue, thanks.
> >>> 
> >>> Recap:
> >>> dpkg kibana on ext4 over a nbd device takes 10 minutes
> >>> with xfs it's only 30s.
> >>> with ext4 no extends only 30s.
> >>> 
> >>> 
> >>> kernels :
> >>> 4.5.7 has this issue as older kernel like 4.4.34
> >>> The issue is also when nbd client & server run on same host
> >>> 
> >>> 
> >>> How small are the files?
> >>> here is the histogram of file sizes : http://pasteboard.co/6HC3nKyk2.png
> >>> We can see 5000 files around 512 Bytes.
> >> 
> >> Definitely there is no value to use fallocate for 512-byte files, or any
> >> of the files that can be written in a single write() syscall.  I'd expect
> >> any reasonable tool to be using a write buffer of at least 2-4MB these
> >> days to get good performance, so writes below the buffer size shouldn't
> >> use fallocate() at all.
> 
> It should be noted that the latest dpkg (1.18.15) only uses fallocate
> for files which are at least 16 KiB in size[1], so it would be nice if
> Renaud could recheck with that version, or cherry-pick the patch into
> whatever version he uses.

The fallocate() call should be removed completely. Applications
should not be attempting to control file allocation like this as it
defeats all the optimisations that filesystems use to optimise IO
patterns and minimise filesystem fragmentation (e.g. delayed
allocation).

There is /rarely/ a need for applications to use fallocate() to
manage fragmentation - especailly as excessive use of fallocate()
actively harms performance and accelerates filesystem aging.

Unless an application has a specific, repeatable performance problem
due to file fragmentation, it should not be using fallocate() to
allocate file space.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
