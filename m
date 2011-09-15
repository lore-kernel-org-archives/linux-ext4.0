From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] libext2fs: add metadata checksum and snapshot
 feature flags
Date: Thu, 15 Sep 2011 19:11:27 -0400
Message-ID: <20110915231127.GK28181@thunk.org>
References: <1316127052-1890-1-git-send-email-tytso@mit.edu>
 <1316127052-1890-2-git-send-email-tytso@mit.edu>
 <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50516 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935246Ab1IOXLa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 19:11:30 -0400
Content-Disposition: inline
In-Reply-To: <F041558F-1F4B-4ADE-9DC2-53708C9124B8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 05:09:13PM -0600, Andreas Dilger wrote:
> 
> I thought it would be better to move s_checksum to be the last field in the
> superblock to avoid multiple calls to the CRC function? 

Did you see my comment about just zero'ing the checksum field before
running the CRC?  We're going to have to do that for other data
structures, such as the inode structure, and it's what we do with the
block group descriptor checksum.  Might as well do that everywhere for
consistency's sake.

						- Ted
