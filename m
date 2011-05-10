From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 5/5] ext4: remove alloc_semp
Date: Tue, 10 May 2011 09:29:10 -0400
Message-ID: <20110510132910.GA6933@thunk.org>
References: <1300985893-4371-1-git-send-email-amir73il@users.sourceforge.net>
 <1300985893-4371-6-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: amir73il@users.sourceforge.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51885 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1EJN3O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 May 2011 09:29:14 -0400
Content-Disposition: inline
In-Reply-To: <1300985893-4371-6-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 24, 2011 at 06:58:13PM +0200, amir73il@users.sourceforge.net wrote:
> From: Amir Goldstein <amir73il@users.sf.net>
> 
> After taking care of all group init races, all that remains is to
> remove alloc_semp from ext4_allocation_context and ext4_buddy structs.
> 
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

Hey Amir,

What sort of testing have you done with this patch series?  In
particular, have you tried doing online resizes while the file system
is heavily loaded?

						- Ted
