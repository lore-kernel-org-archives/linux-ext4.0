From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/26] jbd2: Transaction reservation support
Date: Tue, 4 Jun 2013 12:36:42 -0400
Message-ID: <20130604163642.GJ25160@thunk.org>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
 <1369993379-13017-10-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54747 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3FDQgq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Jun 2013 12:36:46 -0400
Content-Disposition: inline
In-Reply-To: <1369993379-13017-10-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 31, 2013 at 11:42:42AM +0200, Jan Kara wrote:
> In some cases we cannot start a transaction because of locking constraints and
> passing started transaction into those places is not handy either because we
> could block transaction commit for too long. Transaction reservation is
> designed to solve these issues. It reserves a handle with given number of
> credits in the journal and the handle can be later attached to the running
> transaction without blocking on commit or checkpointing. Reserved handles do
> not block transaction commit in any way, they only reduce maximum size of the
> running transaction (because we have to always be prepared to accomodate
> request for attaching reserved handle).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
