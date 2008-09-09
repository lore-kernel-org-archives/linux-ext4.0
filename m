From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 19:39:29 +0530
Message-ID: <20080909140929.GA5335@skywalker>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org> <20080909134347.GB21071@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:38172 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751606AbYIIOLS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 10:11:18 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m89EAi8c025378
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 19:40:44 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m89EAMxp1617940
	for <linux-ext4@vger.kernel.org>; Tue, 9 Sep 2008 19:40:22 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m89EALnW018515
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 00:10:21 +1000
Content-Disposition: inline
In-Reply-To: <20080909134347.GB21071@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 09:43:47AM -0400, Theodore Tso wrote:
> On Tue, Sep 09, 2008 at 07:46:47AM -0400, Christoph Hellwig wrote:
> > On Tue, Sep 09, 2008 at 02:42:22PM +0530, Aneesh Kumar K.V wrote:
> > > This patch adds new option, -E to chattr. The -E option
> > > is used to convert the ext3 format (non extent) file
> > > to ext4 (extent) format. This can be used to migrate
> > > the ext3 file system to ext4 file system.
> > 
> > I think this is an awkware interfac.  Chattr is supposed to set simple
> > binary flags and not a front end to complicated filesystem conversions.
> 
> The alternate is to create an entire new program (e4migrate) just to
> trigger a single ioctl.  The reality is this is probably going to more
> used by ext4 developers than anybody else, since it's rare that you
> would want to convert a single file from using indrect blocks to using
> extents.  In general, most users/system administrators will want to
> convert the entire filesystem; eventually this will probably be done
> via some combination with the userspace program to trigger online
> defrag, but this was just a stopgap measure to allow us to more easily
> exercise the kernel code more than anything else.
> 
> So given that this is only to enable extents on a single file, "chattr
> +e file" is very much in line with the rest of the chattr interface
> for setting other flags.
> 
> One of the things which we may want to do to use statfs() and checking
> f_type to make sure the file in question is located on an ext2/3/4
> filesystem before trying the ioctl, since it is true that a number of
> other filesystems have "borrowed" the chattr program and use it for
> their own purposes.  It's unlikely that the ext4 migration ioctl will
> be wired to anything on other filesystems, but it would be a good
> safety measure to add just in case.
> 

Shouldn't other file system give error when we call an ioctl with
EXT4_IOC_MIGRATE on the fd ?

On ext3 I get the below error
[an/chattr@e2fsprogs-upstream-build]$ ./misc/chattr -E ./misc/e2undo
./misc/chattr: Inappropriate ioctl for device while converting ./misc/e2undo to extent format

-aneesh
