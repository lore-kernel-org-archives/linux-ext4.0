From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Fri, 3 Jun 2011 01:00:55 -0400
Message-ID: <20110603050055.GA6136@infradead.org>
References: <20110602012209.GQ561@dastard>
 <20110602141716.GD18712@redhat.com>
 <20110602143633.GE18712@redhat.com>
 <20110602155610.GF18712@redhat.com>
 <20110602235153.GV561@dastard>
 <20110603002714.GA27129@redhat.com>
 <20110603004300.GE16306@thunk.org>
 <20110603005403.GB27129@redhat.com>
 <20110603010233.GA17726@infradead.org>
 <4DE8555E.7040404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Vivek Goyal <vgoyal@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35793
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab1FCFBC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2011 01:01:02 -0400
Content-Disposition: inline
In-Reply-To: <4DE8555E.7040404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 02, 2011 at 10:30:38PM -0500, Eric Sandeen wrote:
> On 6/2/11 8:02 PM, Christoph Hellwig wrote:
> > On Thu, Jun 02, 2011 at 08:54:03PM -0400, Vivek Goyal wrote:
> >> Just wondering why ext4 and XFS behavior are different and which is a
> >> more appropriate behavior. ext4 does not seem to be waiting for all
> >> pending AIO/DIO to finish while XFS does.
> > 
> > They're both wrong.  Ext4 completely misses support in fsync or sync
> > to catch pending unwrittent extent conversions, and thus fails to obey
> > the data integrity guarante.  
> 
> I'm not sure about that.
> 
> ext4_sync_file() does ext4_flush_completed_IO() which does:

> Granted, I get easily lost in ext4's codepaths here, which is actually
> why I suggested Vivek pose these questions to the list ;)

You're right it gets fsync right, but the sync still seems to be missing,
which does not just include sync, but also the syncfs system call
and unmount.

