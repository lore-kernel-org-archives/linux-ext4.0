From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 3/5] ocfs2: Update ocfs2 routines to use the updated
 journal routines to specify gfp_mask for transaction allocation.
Date: Wed, 27 Apr 2011 00:44:45 -0700
Message-ID: <20110427074444.GC28718@noexit>
References: <BANLkTi=H5zs9KnrUtXd=Q4uz3rTFGzfqhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Manish Katiyar <manish.katiyar@in.ibm.com>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:54407 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1D0Ho6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Apr 2011 03:44:58 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=H5zs9KnrUtXd=Q4uz3rTFGzfqhg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 24, 2011 at 05:15:35PM -0700, Manish Katiyar wrote:
> Update ocfs2 routines to use the updated journal routines passing an
> extra parameter to specify whether transaction allocation can fail or
> not.
> 
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

Works for me.
Acked-by: Joel Becker <jlbec@evilplan.org>

Joel

-- 

"Against stupidity the Gods themselves contend in vain."
	- Friedrich von Schiller

			http://www.jlbec.org/
			jlbec@evilplan.org
