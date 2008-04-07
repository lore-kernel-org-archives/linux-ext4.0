From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH][e2fsprogs] Allow user to disable Undo manager through
	MKE2FS_SCRATCH_DIR
Date: Mon, 7 Apr 2008 20:32:18 +0530
Message-ID: <20080407150218.GA6954@skywalker>
References: <20080404140235.28080.97243.stgit@gara.konoha.net> <20080406221947.GA13284@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:46229 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYDGPCo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 11:02:44 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m37F2Mor008003
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 01:02:22 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m37F2fa53133548
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 01:02:41 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m37F2gkN008152
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 01:02:42 +1000
Content-Disposition: inline
In-Reply-To: <20080406221947.GA13284@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 06, 2008 at 06:19:47PM -0400, Theodore Tso wrote:
> On Fri, Apr 04, 2008 at 09:02:35AM -0500, Jose R. Santos wrote:
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index c8170f0..3f9cbe2 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -1802,6 +1802,13 @@ static int filesystem_exist(const char *name)
> >  	__u16	s_magic;
> >  	struct ext2_super_block super;
> >  	io_manager manager = unix_io_manager;
> > +	char *tdb_dir;
> > +
> > +	tdb_dir = getenv("MKE2FS_SCRATCH_DIR");
> > +	if (tdb_dir && !strcmp(tdb_dir, "disable")) {
> > +		retval = 0;
> > +		goto open_err_out;
> > +	}
> 
> 
> Yuck.  Yuck, Yuck, Yuck, Yuck.
> 
> This functionality has nothing to do with filesystem_exist() and
> putting this kind of magic (a) means you have to read the environment
> variable twice, and (b) makes the code less maintainable in the
> long run.
> 
> While I was looking at the code, I also realized that the way the undo
> code was written it also wasn't compatible with configure
> --enable-testio-deug.
> 
> So here's a much better patch that does the right thing.
> 
> Looking over the undo code more closely, there's much I find that's
> ugly about this patch, including the fact that after you make a
> filesystem at some device, say /dev/sda1, you have to manually go and
> rm the file /var/lib/e2fsprogs/mke2fs-sda1 or you get the
> non-intuitive error message "File exist /var/lib/e2fsprogs/mke2fs-sda1".  

One of the reason for doing that is to make sure we don't overwrite the
backup file. I decided not to go for multiple backup files because that
would confuse the user when trying to undo the mke2fs. So at any point
there would be only one backup file for a partition and that would
contain data needed to undo the last operation.

> This made me reach for the barf bag; the undo-mgr patch branch needs
> cleanup before it's going into mainline.  In any case, here's a much
> better patch which co-exists with testio-debugging, and which actually
> decreases the number of lines of the code to support the undo feature.
> 
> (This will be merged into the patch "e2fsprogs: Make mke2fs use undo
> I/O manager" before the whole branch gets integrated into the next or
> master branches, using the magic that is git rebase --interactive.
> Also needing fixing is the code to hook into the profile lookup.)
> 


I haven't looked at undo manager for some time. I will try to work
on it after April 15th. If you can list down what changes you would
like to see in the patches please let me know. I will definitely try
to address them.

-aneesh
