From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 09:43:47 -0400
Message-ID: <20080909134347.GB21071@mit.edu>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45885 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbYIINo7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 09:44:59 -0400
Content-Disposition: inline
In-Reply-To: <20080909114647.GA14052@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 07:46:47AM -0400, Christoph Hellwig wrote:
> On Tue, Sep 09, 2008 at 02:42:22PM +0530, Aneesh Kumar K.V wrote:
> > This patch adds new option, -E to chattr. The -E option
> > is used to convert the ext3 format (non extent) file
> > to ext4 (extent) format. This can be used to migrate
> > the ext3 file system to ext4 file system.
> 
> I think this is an awkware interfac.  Chattr is supposed to set simple
> binary flags and not a front end to complicated filesystem conversions.

The alternate is to create an entire new program (e4migrate) just to
trigger a single ioctl.  The reality is this is probably going to more
used by ext4 developers than anybody else, since it's rare that you
would want to convert a single file from using indrect blocks to using
extents.  In general, most users/system administrators will want to
convert the entire filesystem; eventually this will probably be done
via some combination with the userspace program to trigger online
defrag, but this was just a stopgap measure to allow us to more easily
exercise the kernel code more than anything else.

So given that this is only to enable extents on a single file, "chattr
+e file" is very much in line with the rest of the chattr interface
for setting other flags.

One of the things which we may want to do to use statfs() and checking
f_type to make sure the file in question is located on an ext2/3/4
filesystem before trying the ioctl, since it is true that a number of
other filesystems have "borrowed" the chattr program and use it for
their own purposes.  It's unlikely that the ext4 migration ioctl will
be wired to anything on other filesystems, but it would be a good
safety measure to add just in case.

Regards,

						- Ted
