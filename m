From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 filesystem corruption across partitions
Date: Thu, 17 Apr 2014 12:12:49 -0400
Message-ID: <20140417161249.GH18591@thunk.org>
References: <1397747123.6833.24.camel@luigi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Devrin Talen <dct23@cornell.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56672 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaDQQMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 12:12:52 -0400
Content-Disposition: inline
In-Reply-To: <1397747123.6833.24.camel@luigi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 11:05:23AM -0400, Devrin Talen wrote:
> Hi all,
> 
> I'm debugging an issue on my platform.  In short, I can corrupt an ext4
> filesystem on one partition by writing a file on a different one.  I'm
> suspecting something is off either with my partition table or filesystem
> parameters, but I'm such an ext4 beginner that I thought I'd start here
> to get some help in where to look.

The partition table looks fine.  (What I did was to take the lba_start
and partition_size fields from your table, imported them into a
spreadsheet, and then verified that "lba_start + partition_size/512"
for each partition was the same as the lba_start of the next
partition.  Obviously, there is no partition table overlap.)

The kernel is supposed to make sure that writes in one partition can't
affect another parition, so either you have a kernel bug in the block
device layer or driver, or you have a hardware problem.

I hate to ask this, but are you sure you have a quality 4GB sd card?
There are fraudulent cards out there where a card will be marked as
having X GB, but it only really has Y GB, or even Y MB worth of flash.
The people making these fraudulent cards rely on the fact that very
often people don't actually fill up their flash cards, so as long as
they don't write to more than Y GB worth of disk sectors, they won't
notice anything wrong.  But if you do write to more sectors than there
is flash, then the N+Ith unique disk sector write ends up going to the
Ith disk sector that had been written.

						- Ted
