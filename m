From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Enabling h-trees too early?
Date: Wed, 19 Sep 2007 11:02:31 -0600
Message-ID: <20070919170231.GM32520@schatzie.adilger.int>
References: <20070919150715.GH9232@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55976 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762246AbXISRex (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 13:34:53 -0400
Content-Disposition: inline
In-Reply-To: <20070919150715.GH9232@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 19, 2007  17:07 +0200, Jan Kara wrote:
>   I was just wondering: Currently we start to build h-tree in a directory
> already when the size of directory exceeds one block. But honestly, it does
> not seem to make much sence to use this feature until the directory is much
> larger (I'd say at least 16 or 32 KB). It actually slows down some
> operations like deleting the whole directory, etc. So what is the reason
> for starting building the tree so early? Just the simplicity of building it
> when the directory is just one block large?

Yes, doing it at one block is easy, doing it with more blocks is complex.
At the time we added this feature, tests showed no performance difference
between 2 unhashed blocks and 2 hashed blocks so the easier code was used.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
