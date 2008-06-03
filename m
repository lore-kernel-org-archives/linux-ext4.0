From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5] jbd: abort when failed to log metadata buffers
Date: Tue, 3 Jun 2008 15:35:06 -0700
Message-ID: <20080603153506.8a9ca2a4.akpm@linux-foundation.org>
References: <4843CE15.6080506@hitachi.com>
	<4843CF6A.7090107@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbYFCWgx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 18:36:53 -0400
In-Reply-To: <4843CF6A.7090107@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 02 Jun 2008 19:46:02 +0900
Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> Subject: [PATCH 3/5] jbd: abort when failed to log metadata buffers
> 
> If we failed to write metadata buffers to the journal space and
> succeeded to write the commit record, stale data can be written
> back to the filesystem as metadata in the recovery phase.
> 
> To avoid this, when we failed to write out metadata buffers,
> abort the journal before writing the commit record.
> 
> Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> ---
>  fs/jbd/commit.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.26-rc4/fs/jbd/commit.c
> ===================================================================
> --- linux-2.6.26-rc4.orig/fs/jbd/commit.c
> +++ linux-2.6.26-rc4/fs/jbd/commit.c
> @@ -734,6 +734,9 @@ wait_for_iobuf:
>  		/* AKPM: bforget here */
>  	}
>  
> +	if (err)
> +		journal_abort(journal, err);
> +
>  	jbd_debug(3, "JBD: commit phase 6\n");
>  
>  	if (journal_write_commit_record(journal, commit_transaction))
> 

I assume this has all been tested?

How are you finding these problems and testing the fixes?  Fault
injection?

Does it make sense to proceed into phase 6 here, or should we bale out
of commit at this point?

