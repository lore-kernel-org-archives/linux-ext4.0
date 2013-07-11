From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC PATCH 2/3] ext4: use unsigned int for es_status values
Date: Thu, 11 Jul 2013 20:48:23 +0800
Message-ID: <20130711124823.GB6427@gmail.com>
References: <1373517542-21234-1-git-send-email-tytso@mit.edu>
 <1373517542-21234-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52730 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab3GKM3l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jul 2013 08:29:41 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so7404595pdj.36
        for <linux-ext4@vger.kernel.org>; Thu, 11 Jul 2013 05:29:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1373517542-21234-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Thu, Jul 11, 2013 at 12:39:01AM -0400, Theodore Ts'o wrote:
> Don't use an unsigned long long for the es_status flags; this requires
> that we pass 64-bit values around which is painful on 32-bit systems.
> Instead pass the extent status flags around using the low 4 bits of an
> unsigned int, and shift them into place when we are reading or writing
> es_pblk.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Zheng Liu <wenqing.lz@taobao.com>

Thanks for fixing this.  One minor nit below.  Otherwise, the patch
looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

> ---
>  fs/ext4/extents_status.c    |  6 +++---
>  fs/ext4/extents_status.h    | 47 ++++++++++++++++++++++++++-------------------
>  fs/ext4/inode.c             |  4 ++--
>  include/trace/events/ext4.h | 14 +++++++-------
>  4 files changed, 39 insertions(+), 32 deletions(-)
> 
[...]
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 19a1643..f27fa9d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -554,7 +554,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  	}
>  	if (retval > 0) {
>  		int ret;
> -		unsigned long long status;
> +		unsigned int status;
>  
>  #ifdef ES_AGGRESSIVE_TEST
>  		if (retval != map->m_len) {

In ext4_map_blocks() function, we have two places that need to be
change.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f27fa9d..3cfbcaa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -655,7 +655,7 @@ found:
 
 	if (retval > 0) {
 		int ret;
-		unsigned long long status;
+		unsigned int status;
 
 #ifdef ES_AGGRESSIVE_TEST
 		if (retval != map->m_len) {

Thanks,
                                                - Zheng

> @@ -1638,7 +1638,7 @@ add_delayed:
>  		set_buffer_delay(bh);
>  	} else if (retval > 0) {
>  		int ret;
> -		unsigned long long status;
> +		unsigned int status;
>  
>  #ifdef ES_AGGRESSIVE_TEST
>  		if (retval != map->m_len) {
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 2068db2..47a355b 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -64,10 +64,10 @@ struct extent_status;
>  	{ EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER,	"LAST_CLUSTER" })
>  
>  #define show_extent_status(status) __print_flags(status, "",	\
> -	{ (1 << 3),	"W" }, 					\
> -	{ (1 << 2),	"U" },					\
> -	{ (1 << 1),	"D" },					\
> -	{ (1 << 0),	"H" })
> +	{ EXTENT_STATUS_WRITTEN,	"W" },			\
> +	{ EXTENT_STATUS_UNWRITTEN,	"U" },			\
> +	{ EXTENT_STATUS_DELAYED,	"D" },			\
> +	{ EXTENT_STATUS_HOLE,		"H" })
>  
>  
>  TRACE_EVENT(ext4_free_inode,
> @@ -2212,7 +2212,7 @@ TRACE_EVENT(ext4_es_insert_extent,
>  		__entry->lblk	= es->es_lblk;
>  		__entry->len	= es->es_len;
>  		__entry->pblk	= ext4_es_pblock(es);
> -		__entry->status	= ext4_es_status(es) >> 60;
> +		__entry->status	= ext4_es_status(es);
>  	),
>  
>  	TP_printk("dev %d,%d ino %lu es [%u/%u) mapped %llu status %s",
> @@ -2289,7 +2289,7 @@ TRACE_EVENT(ext4_es_find_delayed_extent_range_exit,
>  		__entry->lblk	= es->es_lblk;
>  		__entry->len	= es->es_len;
>  		__entry->pblk	= ext4_es_pblock(es);
> -		__entry->status	= ext4_es_status(es) >> 60;
> +		__entry->status	= ext4_es_status(es);
>  	),
>  
>  	TP_printk("dev %d,%d ino %lu es [%u/%u) mapped %llu status %s",
> @@ -2343,7 +2343,7 @@ TRACE_EVENT(ext4_es_lookup_extent_exit,
>  		__entry->lblk	= es->es_lblk;
>  		__entry->len	= es->es_len;
>  		__entry->pblk	= ext4_es_pblock(es);
> -		__entry->status	= ext4_es_status(es) >> 60;
> +		__entry->status	= ext4_es_status(es);
>  		__entry->found	= found;
>  	),
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
