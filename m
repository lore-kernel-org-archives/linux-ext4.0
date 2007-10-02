From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/2] - ext3: fix setup_new_group_blocks locking
Date: Mon, 1 Oct 2007 23:42:44 -0600
Message-ID: <20071002054244.GG5702@schatzie.adilger.int>
References: <470149B5.1030007@redhat.com> <470149AF.10107@redhat.com> <47014984.9060600@redhat.com> <47014960.5060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:39250 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXJBFmp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 01:42:45 -0400
Content-Disposition: inline
In-Reply-To: <470149B5.1030007@redhat.com> <470149AF.10107@redhat.com> <47014984.9060600@redhat.com> <47014960.5060208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 01, 2007  14:24 -0500, Eric Sandeen wrote:
> setup_new_group_blocks() manipulates the group descriptor block bh
> under the block_bitmap bh's lock.  It shouldn't matter since nobody
> but resize should be touching these blocks, but it's worth fixing up.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by; Andreas Dilger <adilger@clusterfs.com>

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
