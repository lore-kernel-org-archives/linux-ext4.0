From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: support freezing ext2 (nojournal) file systems
Date: Thu, 18 Sep 2014 17:13:25 -0400
Message-ID: <20140918211325.GC26995@thunk.org>
References: <1411071989-4974-1-git-send-email-tytso@mit.edu>
 <1411071989-4974-2-git-send-email-tytso@mit.edu>
 <DF6FF9BB-702A-423B-B64E-2731A0347AE8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dexuan Cui <decui@microsoft.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36404 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbaIRVNa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 17:13:30 -0400
Content-Disposition: inline
In-Reply-To: <DF6FF9BB-702A-423B-B64E-2731A0347AE8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 18, 2014 at 02:46:34PM -0600, Andreas Dilger wrote:
> > +	if (journal)
> > +		/* we rely on upper layer to stop further updates */
> > +		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
> 
> This could use "journal" directly instead of "EXT4_SB(sb)->s_journal"

Good point, done.

				- Ted
