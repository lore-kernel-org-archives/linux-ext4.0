From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unused block group, but all blocks not free?
Date: Fri, 22 May 2015 23:05:53 -0400
Message-ID: <20150523030553.GD2750@thunk.org>
References: <555BDEF4.1020704@ubuntu.com>
 <20150520151007.GK2871@thunk.org>
 <555CA52F.3010109@ubuntu.com>
 <20150520163148.GA23989@thunk.org>
 <555D0541.1000804@ubuntu.com>
 <20150521235940.GB2750@thunk.org>
 <555E7371.9060207@ubuntu.com>
 <20150522022837.GC2750@thunk.org>
 <555F2306.8010607@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phil Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54219 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbbEWDHJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 23:07:09 -0400
Content-Disposition: inline
In-Reply-To: <555F2306.8010607@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2015 at 08:37:26AM -0400, Phil Susi wrote:
> On 5/21/2015 10:28 PM, Theodore Ts'o wrote:
> >On Thu, May 21, 2015 at 08:08:17PM -0400, Phillip Susi wrote:
> >The change was that for uninitialized block bitmaps, dumpe2fs used to
> >display incorrect information (that is, it would claim all of the
> >blocks were free, even though in fact that was not true).
> 
> It seems to have actually been a change on disk, since e2defrag *used* to
> count the number of free blocks assuming an uninitialized bitmap meant that
> they were all free, and get the same number reported in the superblock.
> This was probably prior to the change you are thinking of.

The change was in libext2fs; it would actually initialize portion of
the bitmap coming from uninitialized block groups instead of actually
leaving that portion of the bitmap as all zero.

> IIRC, when I looked using debugfs, the block groups containing metadata
> always had their bitmaps initialized.

That's a different change.  We checked that the kernel and e2fsprogs
was doing the right thing if block gorups containing metadata were
left uninitialized (and in fact had been doing the right thing for a
long time), and so we started allowing mke2fs to mark those block
groups as uninitialized.

We didn't check e2defrag because I didn't realize you had ressurected
it.  (At least when I last looked at it, I was too scared about its
error handling, etc., and so I had deliberately declined to try to get
it into e2fsprogs as something I wasn't willing to support it.  So you
are a braver person than I....)

						- Ted
