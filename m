From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Thu, 10 Sep 2009 12:27:47 +0530
Message-ID: <20090910065747.GC8690@skywalker.linux.vnet.ibm.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:58111 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZIJG5q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 02:57:46 -0400
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp06.in.ibm.com (8.14.3/8.13.1) with ESMTP id n8A6vm8H017749
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:27:48 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8A6vmGd1601708
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:27:48 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n8A6vlLM021799
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 12:27:48 +0530
Content-Disposition: inline
In-Reply-To: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 07:55:00PM -0700, Frank Mayhar wrote:
> Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> mode:  If we're not using a journal, ext4_write_inode() now calls
> ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> with a new "do_sync" parameter.  If that parameter is nonzero
> ext4_do_update_inode() calls sync_dirty_buffer() instead of
> ext4_handle_dirty_metadata().
> 
> This problem was found in power-fail testing, checking the amount of
> loss of files and blocks after a power failure when using fsync() and
> when not using fsync().  It turned out that using fsync() was actually
> worse than not doing so, possibly because it increased the likelihood
> that the inodes would remain unflushed and would therefore be lost at
> the power failure.
> 

I think this is related to the other thread discussing the extent leak
with non journal mode. I don't find ext4 without journal adding meta
data blocks to the inode's address space mapping private_list. That 
would mean sync_mapping_buffers -> fsync_buffers_list won't sync 
the related metadata blocks.Tell me what i am missing 

-aneesh
