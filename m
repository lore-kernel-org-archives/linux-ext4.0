From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Wed, 12 Mar 2008 02:56:29 -0600
Message-ID: <20080312085629.GR5851@webber.adilger.int>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204888653.3627.37.camel@localhost.localdomain>
 <20080307113106.GA9896@skywalker> <20080307234751.GL1881@webber.adilger.int>
 <20080311152537.GE6544@atrey.karlin.mff.cuni.cz>
 <20080311165859.GA6490@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62787 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYCLI5h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2008 04:57:37 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2C8vaXX001636
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2008 01:57:36 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXM00J010V5P500@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 12 Mar 2008 01:57:36 -0700 (PDT)
In-reply-to: <20080311165859.GA6490@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 11, 2008  22:28 +0530, Aneesh Kumar K.V wrote:
> On Tue, Mar 11, 2008 at 04:25:37PM +0100, Jan Kara wrote:
> >   I agree here. IMHO the better option would be to just build the
> > extent-tree for converted inode on best-effort basis. If we find in
> > the end that someone has allocated new block to the file (via mmap
> > filling a hole) while we are converting, we can just cancel the
> > conversion. Because I think the cost of extra rwsem (both in terms of
> > additional memory needed for each inode structure and in time needed for
> > rwsem acquisitions) is more than I as a user would like to bear given
> > how rare the conversion is.
>
> Something like the below ??
>
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +	/* check for number of blocks */
> +	if (total_blocks  != inode->i_blocks) {
> +		retval = -EAGAIN;
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		goto err_out;

Is this enough, or should we use the inode version instead?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

