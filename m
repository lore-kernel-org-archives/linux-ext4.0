From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Sun, 10 Jul 2011 19:13:37 -0400
Message-ID: <20110710231337.GD5615@thunk.org>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
 <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
 <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
 <4E14CE15.90404@linux.vnet.ibm.com>
 <CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
 <2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca>
 <4E1614C1.1050209@linux.vnet.ibm.com>
 <CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
 <4E16639A.3060504@linux.vnet.ibm.com>
 <CAOQ4uxjZNduK5BtmwBnGoz=Gvr2C3twV5aPK2xhT0YSC29RYOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33621 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab1GJXNr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 19:13:47 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjZNduK5BtmwBnGoz=Gvr2C3twV5aPK2xhT0YSC29RYOg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 08, 2011 at 09:29:16AM +0300, Amir Goldstein wrote:
> 
> Well, that really depends of the precise definition of "secure delete".
> If you agree with the "100% secure" interpretation, then your current patch
> is "almost" correct.
> I can see 2 things that are missing:
> 1. ext4_unlink() will have to invoke ext4_truncate(0) directly just
> like truncate system call does.
> This is to prevent an attacker from keeping the protected file open
> and preventing freeing
> of it's data when the file is removed from the name space.

Um, no.  This breaks Unix semantics, which is going to cause any kind
of headaches, especially if someone sets the secure delete flag on a
directory, and then a hapless application creates a file in said
directory expecting standard Posix semantics.

If the attacker has a handle on the file, he can just simply copy out
the data to another file; if you're worried about someone who manages
to open the file just 1 millisecond before you do the delete (as
opposed 100 milliseconds, when he would have copy out the file), I
don't think it's worth it.

> 2. ext4_truncate() currently changes i_disksize first (and adds inode
> to orphan list)
> and then frees the blocks. for 100% secure delete, you cannot change i_disksize
> before zeroing the blocks, so it has to be:
> - zeroout range
> - change i_disksize and add to orphan list
> - free blocks

What are you worried about here?

						- Ted
