From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5 01/19] fs: new API for handling inode->i_version
Date: Thu, 18 Jan 2018 16:38:21 -0500
Message-ID: <20180118213821.GA5299@fieldses.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
 <20180109141059.25929-2-jlayton@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org,
        jack-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180109141059.25929-2-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 09, 2018 at 09:10:41AM -0500, Jeff Layton wrote:
> --- /dev/null
> +++ b/include/linux/iversion.h
> @@ -0,0 +1,236 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_IVERSION_H
> +#define _LINUX_IVERSION_H
> +
> +#include <linux/fs.h>
> +
> +/*
> + * The change attribute (i_version) is mandated by NFSv4 and is mostly for
> + * knfsd, but is also used for other purposes (e.g. IMA). The i_version must
> + * appear different to observers if there was a change to the inode's data or
> + * metadata since it was last queried.
> + *
> + * Observers see the i_version as a 64-bit number that never changes.

I don't understand that sentence.

> If it
> + * remains the same since it was last checked, then nothing has changed in the
> + * inode. If it's different then something has changed. Observers cannot infer
> + * anything about the nature or magnitude of the changes from the value, only
> + * that the inode has changed in some fashion.

As we've discussed before, there may be brief windows where the first
two statements aren't quite correct.  I think that would be worth a
mention if we can keep it concise.  Maybe add something like this?:

	It may be impractical for filesystems to keep i_version updates
	atomic with respect to the changes that cause them.  They
	should, however, guarantee that i_version updates are never
	visible before the changes that caused them.  Also, i_version
	updates should never be delayed longer than it takes the
	original change to reach disk.

Or maybe those details are best left to documentation on the relevant
parts of the api below (maybe inode_maybe_inc_iversion?).

I dunno if it's also worth mentioning that nfsd doesn't actually use the
raw i_version--it mixes it with ctime to prevent i_version reuse after
reboot.  Presumably that doesn't matter to IMA since it doesn't compare
i_version across reboots.

The documentation here is all very helpful, thanks.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
