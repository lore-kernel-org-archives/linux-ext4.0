From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] mke2fs.conf: remove legacy entry for ext4dev
Date: Wed, 23 Aug 2017 10:17:09 -0700
Message-ID: <20170823171709.GA32397@magnolia>
References: <20170823154210.8756-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44808 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932109AbdHWRRO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Aug 2017 13:17:14 -0400
Content-Disposition: inline
In-Reply-To: <20170823154210.8756-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 23, 2017 at 11:42:06AM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  misc/mke2fs.conf.in  | 5 -----
>  tests/mke2fs.conf.in | 5 -----
>  2 files changed, 10 deletions(-)
> 
> diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
> index 812f7c742..d0066b78b 100644
> --- a/misc/mke2fs.conf.in
> +++ b/misc/mke2fs.conf.in
> @@ -14,11 +14,6 @@
>  		features = has_journal,extent,huge_file,flex_bg,uninit_bg,64bit,dir_nlink,extra_isize
>  		inode_size = 256
>  	}
> -	ext4dev = {
> -		features = has_journal,extent,huge_file,flex_bg,uninit_bg,inline_data,64bit,dir_nlink,extra_isize
> -		inode_size = 256
> -		options = test_fs=1

LOL, that was still there?? :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> -	}
>  	small = {
>  		blocksize = 1024
>  		inode_size = 128
> diff --git a/tests/mke2fs.conf.in b/tests/mke2fs.conf.in
> index c06050d8d..ee246ba8b 100644
> --- a/tests/mke2fs.conf.in
> +++ b/tests/mke2fs.conf.in
> @@ -17,11 +17,6 @@
>  		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
>  		inode_size = 256
>  	}
> -	ext4dev = {
> -		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
> -		inode_size = 256
> -		options = test_fs=1
> -	}
>  	small = {
>  		blocksize = 1024
>  		inode_size = 128
> -- 
> 2.11.0.rc0.7.gbe5a750
> 
