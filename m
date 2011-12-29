From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 4/5] ext4: flush journal when switching from journal
	data mode
Date: Thu, 29 Dec 2011 13:01:53 -0800
Message-ID: <20111229210153.GN8233@tux1.beaverton.ibm.com>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com> <1321344474-14707-4-git-send-email-xiaoqiangnk@gmail.com> <20111228185643.GD12370@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:51421 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1L2VCc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Dec 2011 16:02:32 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Thu, 29 Dec 2011 14:02:32 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBTL1t5B142596
	for <linux-ext4@vger.kernel.org>; Thu, 29 Dec 2011 14:01:56 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBTL1sQb005852
	for <linux-ext4@vger.kernel.org>; Thu, 29 Dec 2011 14:01:55 -0700
Content-Disposition: inline
In-Reply-To: <20111228185643.GD12370@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 28, 2011 at 01:56:43PM -0500, Ted Ts'o wrote:
> On Tue, Nov 15, 2011 at 04:07:53PM +0800, Yongqiang Yang wrote:
> > When switching from journal data mode, the data blocks
> > in journal will have no revoke record.  Thus, data could be
> > corrupted during replay.  However, there is no such problem in
> > switching to journal data mode.  So we flush journal only in
> > the case that swithes from journal data mode.
> > 
> > Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> Applied, with a slightly different (and more explanatory commit
> message):
> 
> ext4: flush journal when switching from data=journal mode
> 
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> 
> It's necessary to flush the journal when switching away from
> data=journal mode.  This is because there are no revoke records when
> we are data blocks are journalled,

Minor nit, but did you mean "when data blocks are journalled" ?

--D
> which are required in the other journal modes.
> 
> However, it is not necessary to flush the journal when switching into
> data=journal mode, and flushing the journal is expensive.  So let's
> avoid it in that case.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

