From: tytso@mit.edu
Subject: Re: Please reserve INCOMPAT flags
Date: Sun, 24 Jan 2010 14:48:39 -0500
Message-ID: <20100124194839.GB4372@thunk.org>
References: <20090906092546.GU4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39638 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0AXTst (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jan 2010 14:48:49 -0500
Content-Disposition: inline
In-Reply-To: <20090906092546.GU4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 06, 2009 at 11:25:46AM +0200, Andreas Dilger wrote:
> Ted,
> in addition to the data-in-dirent INCOMPAT flag Rahul sent the patches
> for last week, I would like to ensure that we also have the INCOMPAT
> flag for large EA-in-inode flag reserved.  This patch is going into
> testing at one of our large customers, and I want to make sure that
> we don't accidentally get a conflicting INCOMPAT flag assignment.
> 
> #define EXT4_FEATURE_INCOMPAT_EA_INODE	0x0400
> #define EXT4_FEATURE_INCOMPAT_DIRDATA   0x1000
> 
> #define EXT4_EA_INODE_FL	0x00200000 /* Inode used for large EA */
> 

Reserving... but stupid question, do you know if anyone is currently
using the inode flag 0x00100000?  I want to make sure that's properly
documented and reserved.

Thanks,

							- Ted
