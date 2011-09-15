From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
 feature flags
Date: Thu, 15 Sep 2011 19:41:31 -0400
Message-ID: <20110915234131.GL28181@thunk.org>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
 <1316127052-1890-2-git-send-email-tytso@mit.edu>
 <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca>
 <20110915231127.GK28181@thunk.org>
 <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40501 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935248Ab1IOXle (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 19:41:34 -0400
Content-Disposition: inline
In-Reply-To: <14955E98-C987-40D6-A881-5D40077C2FB2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 05:34:41PM -0600, Andreas Dilger wrote:
> 
> Darrick and I discussed zeroing the checksum fields, but then there is a
> race with other threads accessing the same structure.

What race are you worried about?  The moment you modify some part of
the data structure, the checksum is going to be wrong.  This is true
whether you zero out the checksum field before you do the calculations
or not.

> If we went to a crc32c LSB for filesystems with RO_COMPAT_CSUM it would
> be possible to change how it is computed.  Since we have freedom to move
> the checksum field now, why have the added complexity to do zeroing of
> the field or two chunks?

Why is zero'ing out the field complex?  It's a single line of code....
It's certainly easier than doing it in two chunks, and there will be
some data structures (the block group descriptors at the very least)
where zero'ing the checksum is definitely going to be the easier way
to go.

   	      	       	      	     	    - Ted
