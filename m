From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] obsolete fragment from ext4
Date: Fri, 10 Aug 2007 02:43:00 -0600
Message-ID: <20070810084300.GM6689@schatzie.adilger.int>
References: <46BBD6D7.3050402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55915 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbXHJIm5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 04:42:57 -0400
Content-Disposition: inline
In-Reply-To: <46BBD6D7.3050402@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 10, 2007  11:09 +0800, Coly Li wrote:
> Once ext4 will not implement fragment, it is believed it will never be
> implement in future. Therefore fragment related source code in ext4
> should be obsoleted -- no one will use it.
> 
> This patch obsolete fragment from ext4.
> Another patch posted on linux-ext4 removing fragment supporting from e2fsprogs.
> I tested both patch.
> 
> 
> Signed-Off-By: Coly Li <coyli@suse.de>

Acked-by: Andreas Dilger <adilger@clusterfs.com>

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
