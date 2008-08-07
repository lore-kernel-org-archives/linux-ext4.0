From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Porting Zfs features to ext2/3
Date: Thu, 07 Aug 2008 14:09:35 +0200
Message-ID: <877iat6n7k.fsf@frosties.localdomain>
References: <18674437.post@talk.nabble.com> <1217199281.6992.0.camel@telesto>
	<20080727233855.GB9378@mit.edu>
	<loom.20080729T222131-137@post.gmane.org>
	<20080730012909.GC29748@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Szabolcs Szakacsits <szaka@ntfs-3g.org>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:37933 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbYHGM3L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Aug 2008 08:29:11 -0400
In-Reply-To: <20080730012909.GC29748@mit.edu> (Theodore Tso's message of "Tue,
	29 Jul 2008 21:29:09 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@MIT.EDU> writes:

> On Tue, Jul 29, 2008 at 10:52:26PM +0000, Szabolcs Szakacsits wrote:
>> I did also an in memory test on a T9300@2.5, with disk I/O completely 
>> eliminated. Results:
>> 
>> tmpfs:    975 MB/sec
>> ntfs-3g:  889 MB/sec  (note, this FUSE driver is not optimized yet)
>> ext3:     675 MB/sec
...
> So it's issueing lots of 4k writes, one page at a time, because it
> needs to track the completion of each block.  This creates a
> significant CPU overhead, which dominates in an all-memory test.
> Although this is not an issue in real-life today, it will likely
> become an issue in real-life solid state disks (SSD's).

This already is a major issue for us. We are starting to use SAS raid boxes
that deliver >350MB/s write and >600MB/s read performance with lustre,
which is ext3 with patches. It is somewhat between ext3 and ext4 in
that it has some of its features but not all.

> Fortunately, ext4's blktrace when copying a large file looks like
> this:

That is promising. Once the 64BIT feature becomes usable we plan to
port lustre to use ext4 as base filesystem. The current 8TiB limit is
a real pain.

MfG
        Goswin
