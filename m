From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] ext4: remove unnecessary NULL pointer check
Date: Tue, 29 Jan 2013 10:40:01 +0800
Message-ID: <20130129024001.GA10442@yanx>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-4-git-send-email-yan@linux.vnet.ibm.com>
 <20130129012413.GC4754@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59108 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3A2CkL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 21:40:11 -0500
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <yan@linux.vnet.ibm.com>;
	Tue, 29 Jan 2013 12:34:47 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 96F322BB0050
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2013 13:40:07 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r0T2SDlu4063628
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2013 13:28:14 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0T2e6lr001411
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2013 13:40:06 +1100
Content-Disposition: inline
In-Reply-To: <20130129012413.GC4754@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 05:24:13PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 18, 2013 at 04:01:14PM +0800, Guo Chao wrote:
> > brelse() and ext4_journal_force_commit() are both inlined and able
> > to handle NULL.
> > 
> > Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> 
> This one looks ok too, so:
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> PS: Does the order of the patches matter?  Or are these just four patches that
> are mostly independent of each other?
> 
> --D

They are random independent fixes.

Thanks


