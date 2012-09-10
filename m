From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 won't mount - fsck required - 2nd fsck in less than a week
Date: Sun, 9 Sep 2012 22:47:09 -0400
Message-ID: <20120910024709.GA3439@thunk.org>
References: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Terry <td3201@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49701 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab2IJCrN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Sep 2012 22:47:13 -0400
Content-Disposition: inline
In-Reply-To: <CAHSRzpC4bnZs1G8BHcuQL6Bf9cKiVb15Ha0sybRdkpwUZbdMKQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 09, 2012 at 09:34:10PM -0500, Terry wrote:
> 
> As the subject says, we have a 15 TB fsck drive that won't mount with
> these errors:
> 
> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): ext4_check_descriptors:
> Inode bitmap for group 3200 not in group (block 4161027887)!
> Sep 9 20:02:20 narf kernel: EXT4-fs (dm-9): group descriptors corrupted!

These indicate a very basic file system corruption where the block
group descriptors are corrupted.  E2fsck will complain immediately
upon seeing this sort of fs inconsistency, and the first thing it will
try to do is fix it.

> We did a proactive fsck on Tuesday of last week because it was
> starting to give filesystem errors. It ran through and mounted fine.
> 
> The filesystem lives on an equallogic SAN spread across 36 drives.
> Could this be something with the physical layer or is it not abnormal
> to have to run multiple rounds of fsck to fully fix an issue?

This is most probably a hardware problem; normally e2fsck will fix
file system corruptions (and certainly problems such as corrupt block
group scriptors) in a single pass.  If e2fsck finished and the file
system mounted fine last week, and now you're getting this kind of
error, it basically screams some kind of physical layer problem, or
perhaps a bad hard drive, or perhaps the SAN disk is getting
incorrectly written to by some other system, etc.

	    	       	       	     - Ted
