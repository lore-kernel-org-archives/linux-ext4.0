From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: typo in jbd2_journal_begin_ordered_truncate()
Date: Tue, 3 Feb 2009 00:33:51 -0800
Message-ID: <20090203003351.1efaa6db.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0902012309120.26166@bikeee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821AbZBCIeb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 03:34:31 -0500
In-Reply-To: <alpine.DEB.2.00.0902012309120.26166@bikeee>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 3 Feb 2009 11:23:03 +0300 (EAT) Dan Carpenter <error27@gmail.com> wrote:

> This is jbd2_journal_begin_ordered_truncate() from fs/jbd2/transaction.c.
> 
> I think the "&&" is supposed to be an "||" on line 2144.  Just knowing 
> that inode->i_transaction is NULL should be enough, otherwise we would 
> immediately dereference a null on line 2146.
> 
>    2144          if (!inode->i_transaction && !inode->i_next_transaction)
>    2145                  goto out;
>    2146          journal = inode->i_transaction->t_journal;
> 

Could be.  Hard to tell from the code, changelog and (non) comments.  Perhaps
it's dead code.

Send a patch, become famous ;)

While you're there, rename local var `inode' to `jinode'.
