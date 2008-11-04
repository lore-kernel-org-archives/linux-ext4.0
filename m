From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] imporve jbd2 fsync batching
Date: Tue, 4 Nov 2008 15:52:23 -0500
Message-ID: <20081104205223.GW30291@mit.edu>
References: <20081104161024.GC28058@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46762 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752392AbYKDUw1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2008 15:52:27 -0500
Content-Disposition: inline
In-Reply-To: <20081104161024.GC28058@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks!!

Once tiny spelling nit, which I'll fix up before I put it in the ext4
patch queue.

On Tue, Nov 04, 2008 at 11:10:25AM -0500, Josef Bacik wrote:
> @@ -1222,6 +1224,17 @@ int jbd2_journal_stop(handle_t *handle)
>  	 * on IO anyway.  Speeds up many-threaded, many-dir operations
>  	 * by 30x or more...
>  	 *
> +	 * We try and optimize the sleep time against what the underlying disk
> +	 * can do, instead of having a static sleep time.  This is usefull for

s/usefull/useful/

							- Ted
