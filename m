From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debugfs: print missing argument in usage for open, filefrag and
 ls
Date: Sun, 8 Dec 2013 21:09:15 -0500
Message-ID: <20131209020915.GA17967@thunk.org>
References: <1386400305-16757-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37887 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759129Ab3LICJR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Dec 2013 21:09:17 -0500
Content-Disposition: inline
In-Reply-To: <1386400305-16757-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've commited the first two hunks of this patch to the maint branch,
and fixed up a missing hyphen:

>  print_usage:
> -	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] [-c] "
> +	fprintf(stderr, "%s: Usage: open [-s superblock] [-b blocksize] "
> +		"[d image_filename] [-c] [-i] [-f] [-e] [-D] "


I'll add the final commit to the master/next branch, which is where
the ls -c option was added without updating the usage message.

       	  	     	   	   	    - Ted
