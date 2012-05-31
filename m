From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 10/12] container quota: bill container inodes alloc/free
 on ext4.
Date: Thu, 31 May 2012 13:15:25 +0400
Message-ID: <4FC736AD.2070404@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com> <1338389946-13711-11-git-send-email-jeff.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<jack-AlSwsSmVLrQ@public.gmane.org>, <daniel.lezcano-GANU6spQydw@public.gmane.org>, <tytso-3s7WtUTddSA@public.gmane.org>,
	<bpm-sJ/iWh9BUns@public.gmane.org>, <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	<christopher.jones-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	<tinguely-sJ/iWh9BUns@public.gmane.org>, <tm-d1IQDZat3X0@public.gmane.org>, <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338389946-13711-11-git-send-email-jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 05/30/2012 06:59 PM, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org wrote:
> +#include "../ns_quotaops.h"
> +
>   /*
>    * ialloc.c contains the inodes allocation and deallocation routines
>    */
> @@ -233,6 +235,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
>   	dquot_initialize(inode);
>   	ext4_xattr_delete_inode(handle, inode);
>   	dquot_free_inode(inode);
> +	ns_dquot_free_inode(inode);
>   	dquot_drop(inode);

This should be inside dquot_free_inode().

No need to go patch inode.c
