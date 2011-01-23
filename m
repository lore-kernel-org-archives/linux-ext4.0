From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 3/3] : Update ocfs2 for the changed jbd2 transaction
 allocation routines
Date: Sat, 22 Jan 2011 19:51:45 -0800
Message-ID: <20110123035144.GB3261@noexit>
References: <AANLkTi=xq=LF4EYoqb1o9=yVYnGD4i0t6qR6KnwduOOM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40043 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1AWDv6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Jan 2011 22:51:58 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=xq=LF4EYoqb1o9=yVYnGD4i0t6qR6KnwduOOM@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 22, 2011 at 07:36:38PM -0800, Manish Katiyar wrote:
> Hi Jan,
> 
> Update ocfs2 to use the updated transaction allocation routine. They
> still pass the old flag.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

	I think this is correct.  Thanks for noticing!

Joel

-- 

Life's Little Instruction Book #20

	"Be forgiving of yourself and others."

			http://www.jlbec.org/
			jlbec@evilplan.org
