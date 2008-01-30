From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fw: [Bugme-new] [Bug 9849] New: NULL pointer deref in
 journal_wait_on_commit_record
Date: Wed, 30 Jan 2008 15:43:55 -0800
Message-ID: <20080130154355.4b1c32c8.akpm@linux-foundation.org>
References: <20080130120055.7dc3331b.akpm@linux-foundation.org>
	<1201735077.3873.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@sgi.com, linux-ext4@vger.kernel.org, girish@clusterfs.com,
	snakebyte@gmx.de, "Theodore Ts'o" <tytso@mit.edu>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896AbYA3Xow (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2008 18:44:52 -0500
In-Reply-To: <1201735077.3873.22.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 30 Jan 2008 15:17:57 -0800
Mingming Cao <cmm@us.ibm.com> wrote:

> The buufer head pointer passed to journal_wait_on_commit_record()
> could be NULL if the previous journal_submit_commit_record() failed
> or journal has already aborted.
> 
> We need to check the error returns from journal_submit_commit_record()
> and avoid calling journal_wait_on_commit_record() in the failure case.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/jbd2/commit.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc8/fs/jbd2/commit.c
> ===================================================================
> --- linux-2.6.24-rc8.orig/fs/jbd2/commit.c	2008-01-30 14:12:10.000000000 -0800
> +++ linux-2.6.24-rc8/fs/jbd2/commit.c	2008-01-30 15:09:50.000000000 -0800
> @@ -872,7 +872,8 @@ wait_for_iobuf:
>  		if (err)
>  			__jbd2_journal_abort_hard(journal);
>  	}
> -	err = journal_wait_on_commit_record(cbh);
> +	if (!err && !is_journal_aborted(journal))
> +		err = journal_wait_on_commit_record(cbh);
>  
>  	if (err)
>  		jbd2_journal_abort(journal, err);

Thanks.  Please note that I Cc'ed stable@kernel.org on this, for a 2.6.24.x
backport.
