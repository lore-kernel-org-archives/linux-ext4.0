From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] fix ext2 allocator overflows above 31 bit blocks
Date: Fri, 20 Apr 2007 17:02:08 -0600
Message-ID: <20070420230208.GU5967@schatzie.adilger.int>
References: <4628F3ED.9040101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:58608 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767308AbXDTXCL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2007 19:02:11 -0400
Content-Disposition: inline
In-Reply-To: <4628F3ED.9040101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 20, 2007  12:10 -0500, Eric Sandeen wrote:
> If ext3 can do 16T, ext2 probably should be able to as well.
> There are still "int" block containers in the block allocation path
> that need to be fixed up.

Yeah, but who wants to do 16TB e2fsck on every boot?  I think there
needs to be some limits imposed for the sake of usability.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
