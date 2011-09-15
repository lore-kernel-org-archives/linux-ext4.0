From: Ted Ts'o <tytso@mit.edu>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Thu, 15 Sep 2011 16:05:12 -0400
Message-ID: <20110915200512.GF28181@thunk.org>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
 <20110915165512.GA12086@tux1.beaverton.ibm.com>
 <20110915171934.GB12086@tux1.beaverton.ibm.com>
 <7755CB79-FD71-49BE-AF93-0A49CA25CEAC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, Amir Goldstein <amir73il@gmail.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43501 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934532Ab1IOUFP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 16:05:15 -0400
Content-Disposition: inline
In-Reply-To: <7755CB79-FD71-49BE-AF93-0A49CA25CEAC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 01:10:41PM -0600, Andreas Dilger wrote:
> 
> This is also a possible alternative, though it makes for more fragments that
> need to be checksummed.  I think as a general rule it makes sense to store
> the checksum as the last word in the structure, if possible, so that the
> checksum can be computed in a single call.  This is already done for 128-byte
> inodes and for 32-byte group descriptors, but should also be done for the
> s_checksum field in the superblock (i.e. put it after s_reserved instead of
> before).

Or we just zero out the checksum field, checksum the entire data
structure, and then fill in the newly calculated checksum.  In fact
that's what I assumed Darrick was going to do.

	       	    	    	      - Ted
