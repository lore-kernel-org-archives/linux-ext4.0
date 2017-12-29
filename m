From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question about enlarge ext4 more than 16T
Date: Thu, 28 Dec 2017 19:58:22 -0500
Message-ID: <20171229005822.GD30269@thunk.org>
References: <CAOHr082HDDUt6xwtjrfdTaCOr+zBmrPbUZqO0gy-f4qShZqm5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: rong zhao <zhaorbox@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34034 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751293AbdL2A6Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 28 Dec 2017 19:58:25 -0500
Content-Disposition: inline
In-Reply-To: <CAOHr082HDDUt6xwtjrfdTaCOr+zBmrPbUZqO0gy-f4qShZqm5g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 26, 2017 at 06:09:47PM +0800, rong zhao wrote:
> I find this page: https://bugzilla.redhat.com/show_bug.cgi?id=982871
> 
> According to this page, it seems on rhel7, it should be able to
> enlarge online, but unfortunately, I failed on rhel6 and I can only
> have rhel6...
> 
> From this patch, it seems that extend ext4 for more than 16T is
> possible, but I always fail on redhat 6.7.
> 
> At last, let me make a summary of my question:
> 1. if I create an ext4 FS more than 16T, it has no resize_inode flag,
> so I cannot extend it online
> 2. if I create an ext4 FS less than 16T, even with -O 64bit option, I
> cannot extend it to more than 16T, I tried online and offline

In order to support file system sizes larger than 16T, it's necessary
to have block numbers which are larger than 32-bits.  In other words,
it is necessary to support 64-bit block numbers.  Not all kernels and
versions of e2fsprogs can support the 64-bit filesystem feature.

I'm not a Red Hat expert; I'm an upstream developer and person who
uses and a Debian developer.  I used to have the headache of dealing
with Enterprise Linux Distributions, their arbitrary limitations, and
the arbitrary limtations of the I/T departments who require enterprise
distributions when I worked for IBM.  Blessedly, I no longer have to
deal with this headache now that I work for Google.  :-) So I can't
really speak to what RHEL 6 and RHEL 7 support.  You'll need to talk
to someone official from Red Hat.

I can say that historically, Red Hat has chosen not to support file
system upgrades because they have corner cases which can be dangerous.
So for example, with the right version of e2fsprogs, you *can* add the
64-bit feature as an off-line feature using tune2fs.  However, this
requires rewriting the block group descriptors, which is a core file
system data structure in place.  If you crash in the middle of that
operation, due to a power glitch, or an accidental control-C of the
program, etc., your file system will be very badly scrambled.  If you
have enabled the creation of an e2undo file, you *might* be able to
recover, but conversion of a file system that does not have the 64-bit
feature, to one that does, is one which is fraught with danger, and so
I generally recommend that people do a full backup before attempting
this operation.  And if it succeeds, you can be happy, but if it
doesn't, you can fall back to recreating the file system with the
64-bit feature set, and then restore from backups.

For resizing file systems < 16TB, the resize_inode feature is used, as
you have noted.  Beyond 16TB, we use a different scheme that involves
use of the meta_bg feature, which is turned on automatically when you
try to resize beyond 16TB by resize2fs or the kernel.  Support for
this resize feature is dependant on the having a sufficiently new
version of the kernel (for online resize) and e2fsprogs (for online
and off-line resize).

For better or worse, the customers (or the paranoid I/T departments of
those customers, which amounts to the same thing) have mandated that
they don't want risk by adding new code (or new versions which contain
new code), because new code is scary.  That is, except for whatever
favorite features might be required by that one specific customer.
Unfortunately, that "favorite feature" varies from customer to
customer, so what do you expect Red Hat to do?  As a result, if you
are stuck on RHEL 6 because of corporate policy, then some features
may simply not be available to you.  Having a customer complain about
this when they were the ones who mandated the use of an enterprise
distro is frustrating, and it's one of the reasons why I'm glad I no
longer work at IBM and have to deal customers who embodies such
contradictions.

As the old Chinese saying goes, "You can't expect a horse that goes
fast, but also want it to not eat grass."  :-)

又要马儿跑，又要马儿不吃草

At Google, we regularly update to new kernels, and yes, it takes
effort --- but we've learned the hard way that staying stuck on
ancient kernel is a form of technical debt, which one has to pay back
sooner or later, if you want either the latest features, or to support
the latest hardware.

Best regards,

      	     	  	    	     	 - Ted
					 
