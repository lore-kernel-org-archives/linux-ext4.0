From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH] Inverse locking order of page_lock and
	transaction start
Date: Mon, 7 Apr 2008 21:00:03 +0530
Message-ID: <20080407153003.GA20303@skywalker>
References: <20080327162742.GC32534@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:45485 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYDGPaa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 11:30:30 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m37FU780014919
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 01:30:07 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m37FYIW2263728
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 01:34:18 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m37FUQiW011867
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 01:30:26 +1000
Content-Disposition: inline
In-Reply-To: <20080327162742.GC32534@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 27, 2008 at 05:27:42PM +0100, Jan Kara wrote:
>   Hi,
> 
>   below is the first version of the patch that reverses locking order of
> page_lock and transaction start. I have tested it with fsx-linux, ltp DIO
> tests etc. and lockdep didn't complain so hopefully I got it mostly right
> but review is definitely needed. Especially I'd like to know what people
> think about the way I've implemented ext3_page_mkwrite() - ext4 has
> an incorrect code AFAICT because in ordered and journaled modes we should
> write block of zeros and properly journal it (and no, block_page_mkwrite()
> doesn't do it). We could implement ext3/4_page_mkwrite() in a similar way
> we currently implement writepage calls but calling write_begin + write_end
> does the job and should be only a tiny bit slower...
>   If nobody finds a serious flaw in the approach, I'll rediff the patch
> against ext4 (I'll also try to convert delayed-alloc path - from a quick
> look converting da_writepages path is going to be interesting).
>   I'm looking forward to your comments :)
> 

I guess we should make this change first to Ext4 and then make the
same to ext3.

-aneesh
