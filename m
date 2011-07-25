From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3.txt: update the links in the section "useful
 links" to the latest ones
Date: Mon, 25 Jul 2011 16:37:00 +0200
Message-ID: <20110725143700.GB6107@quack.suse.cz>
References: <4E2A1F21.5060604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab1GYOhC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 10:37:02 -0400
Content-Disposition: inline
In-Reply-To: <4E2A1F21.5060604@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Sat 23-07-11 09:08:49, Wang Sheng-Hui wrote:
> The patch is against 3.0.
> 
> In Documentation/filesystems/ext3.txt, the section "useful links"
> provides two links which link to ibm developerworks articles. While
> the second one can be redirected to the latest one, the first one
>    http://www.ibm.com/developerworks/library/l-fs7.html
> fails to be redirected.
> 
> Update the 2 links to the latest ones.
  Thanks. I've merged the patch into my tree.

								Honza
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  Documentation/filesystems/ext3.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
> index 272f80d..a779614 100644
> --- a/Documentation/filesystems/ext3.txt
> +++ b/Documentation/filesystems/ext3.txt
> @@ -227,5 +227,5 @@ kernel source:	<file:fs/ext3/>
>  programs: 	http://e2fsprogs.sourceforge.net/
>  		http://ext2resize.sourceforge.net
>  
> -useful links:	http://www.ibm.com/developerworks/library/l-fs7.html
> -		http://www.ibm.com/developerworks/library/l-fs8.html
> +useful links:	http://www.ibm.com/developerworks/library/l-fs7/index.html
> +        http://www.ibm.com/developerworks/library/l-fs8/index.html
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
