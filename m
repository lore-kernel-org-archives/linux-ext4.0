From: Theodore Tso <tytso@mit.edu>
Subject: Re: group descriptor contents and LAZY_BG
Date: Wed, 28 Mar 2007 09:14:39 -0400
Message-ID: <20070328131439.GA2913@thunk.org>
References: <20070324214056.GL5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Girish Shilamkar <girish@linsyssoft.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51907 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXC1NOn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2007 09:14:43 -0400
Content-Disposition: inline
In-Reply-To: <20070324214056.GL5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 24, 2007 at 03:40:57PM -0600, Andreas Dilger wrote:
> What do you think for the GDT_CSUM feature that we initialize the group
> descriptors as if the group had actually been formatted?  

I think that makes a huge amount of sense.  Initializing the group
descriptors isn't want takes the huge amount of time; it's
initializing the bitmap blocks and inode table.

						- Ted
