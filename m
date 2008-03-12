From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Wed, 12 Mar 2008 14:38:11 +0530
Message-ID: <20080312090811.GA9511@skywalker>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204888653.3627.37.camel@localhost.localdomain> <20080307113106.GA9896@skywalker> <20080307234751.GL1881@webber.adilger.int> <20080311152537.GE6544@atrey.karlin.mff.cuni.cz> <20080311165859.GA6490@skywalker> <20080312085629.GR5851@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:40087 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYCLJIV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2008 05:08:21 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2C97hEd013273
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 20:07:43 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2C98JKV3756236
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 20:08:19 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2C98IXo020135
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 20:08:19 +1100
Content-Disposition: inline
In-Reply-To: <20080312085629.GR5851@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 12, 2008 at 02:56:29AM -0600, Andreas Dilger wrote:
> On Mar 11, 2008  22:28 +0530, Aneesh Kumar K.V wrote:
> > On Tue, Mar 11, 2008 at 04:25:37PM +0100, Jan Kara wrote:
> > >   I agree here. IMHO the better option would be to just build the
> > > extent-tree for converted inode on best-effort basis. If we find in
> > > the end that someone has allocated new block to the file (via mmap
> > > filling a hole) while we are converting, we can just cancel the
> > > conversion. Because I think the cost of extra rwsem (both in terms of
> > > additional memory needed for each inode structure and in time needed for
> > > rwsem acquisitions) is more than I as a user would like to bear given
> > > how rare the conversion is.
> >
> > Something like the below ??
> >
> >  	down_write(&EXT4_I(inode)->i_data_sem);
> > +	/* check for number of blocks */
> > +	if (total_blocks  != inode->i_blocks) {
> > +		retval = -EAGAIN;
> > +		up_write(&EXT4_I(inode)->i_data_sem);
> > +		goto err_out;
> 
> Is this enough, or should we use the inode version instead

We are already holding inode->i_mutex. So the only possible operation is
adding new blocks via mmap write to holes. Also inode version is tricky
because it is available only with i_version mount option. We are also
interested only in new blocks added event.


-aneesh
