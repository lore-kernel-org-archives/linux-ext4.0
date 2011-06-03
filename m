From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Query about DIO/AIO WRITE throttling and ext4 serialization
Date: Thu, 02 Jun 2011 22:30:38 -0500
Message-ID: <4DE8555E.7040404@redhat.com>
References: <20110601215049.GC17449@redhat.com> <20110602012209.GQ561@dastard> <20110602141716.GD18712@redhat.com> <20110602143633.GE18712@redhat.com> <20110602155610.GF18712@redhat.com> <20110602235153.GV561@dastard> <20110603002714.GA27129@redhat.com> <20110603004300.GE16306@thunk.org> <20110603005403.GB27129@redhat.com> <20110603010233.GA17726@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Vivek Goyal <vgoyal@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1FCDay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2011 23:30:54 -0400
In-Reply-To: <20110603010233.GA17726@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/2/11 8:02 PM, Christoph Hellwig wrote:
> On Thu, Jun 02, 2011 at 08:54:03PM -0400, Vivek Goyal wrote:
>> Just wondering why ext4 and XFS behavior are different and which is a
>> more appropriate behavior. ext4 does not seem to be waiting for all
>> pending AIO/DIO to finish while XFS does.
> 
> They're both wrong.  Ext4 completely misses support in fsync or sync
> to catch pending unwrittent extent conversions, and thus fails to obey
> the data integrity guarante.  

I'm not sure about that.

ext4_sync_file() does ext4_flush_completed_IO() which does:

 * When IO is completed, the work to convert unwritten extents to
 * written is queued on workqueue but may not get immediately
 * scheduled. When fsync is called, we need to ensure the
 * conversion is complete before fsync returns.
 * The inode keeps track of a list of pending/completed IO that
 * might needs to do the conversion. This function walks through
 * the list and convert the related unwritten extents for completed IO
 * to written.

Granted, I get easily lost in ext4's codepaths here, which is actually
why I suggested Vivek pose these questions to the list ;)

-Eric
