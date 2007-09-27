From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH, RFC] ext3: lighten up resize transaction requirements
Date: Thu, 27 Sep 2007 17:15:06 -0600
Message-ID: <20070927231506.GQ32520@schatzie.adilger.int>
References: <46FC1B7D.2000601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60547 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbXI0XPJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Sep 2007 19:15:09 -0400
Content-Disposition: inline
In-Reply-To: <46FC1B7D.2000601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 27, 2007  16:07 -0500, Eric Sandeen wrote:
> I've got a fedora bug, which has been fairly widely reported around the
> net it seems, where attempting to do an online resize "requires too many
> credits".  This usually leaves the person trying to do the resize fairly
> befuddled.  There is a workaround to resize the journal to something larger,
> but then this must be done offline, so what's the point really? :)
> 
> The patch below resizes & restarts the transaction as necessary while
> setting up the new group, and should work with even the smallest journal.

Patch looks good to me, you can add:
Acked-by: Andreas Dilger <adilger@clusterfs.com>

(or Signed-off-by: ?, I'm not sure)  Thanks for fixing my broken code.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
