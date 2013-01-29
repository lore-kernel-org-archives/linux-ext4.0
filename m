From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: remove unnecessary NULL pointer check
Date: Mon, 28 Jan 2013 21:42:20 -0500
Message-ID: <20130129024220.GJ7003@thunk.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-4-git-send-email-yan@linux.vnet.ibm.com>
 <20130129012413.GC4754@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45979 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3A2CmX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:42:23 -0500
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

Thanks, applied.

					- Ted
