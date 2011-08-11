From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: copy cluster_bits in
 ext2fs_copy_generic_bmap
Date: Wed, 10 Aug 2011 21:50:30 -0400
Message-ID: <20110811015030.GB3625@thunk.org>
References: <418F4E42-50E6-4CAA-B6F5-CA59B17E84C0@whamcloud.com>
 <4E42D6FD.2020904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@whamcloud.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60012 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1HKBuf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2011 21:50:35 -0400
Content-Disposition: inline
In-Reply-To: <4E42D6FD.2020904@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Oops, thanks for catching this!  Applied to the e2fsprogs next branch.

      	     	 	  	 	 - Ted
