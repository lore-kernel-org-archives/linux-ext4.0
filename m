From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH 01/25] VFS: move attr_kill logic
	from	notify_change into helper function
Date: Mon, 06 Aug 2007 19:43:46 +0200
Message-ID: <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jffs-dev-VrBV9hrLPhE@public.gmane.org,
	reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zippel-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org,
	user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wli-tGiaVUSOoeej7qYf8Sx8sA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	joel.becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mikulas-TTVWCEgN8Z9G4ohzP4jBZS1Fcj925eT/@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, bfennema-gi/t4lz4P9Yq08oLxijIyCUISzVj0O8v@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-reply-to: <200708061354.l76Ds6sq002260-f+VxlG6Paaj0UfVguI6niVaTQe2KTcn/@public.gmane.org> (message from
	Jeff Layton on Mon, 6 Aug 2007 09:54:06 -0400)
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

> Separate the handling of the local ia_valid bitmask from the one in
> attr->ia_valid. This allows us to hand off the actual handling of the
> ATTR_KILL_* flags to the .setattr i_op when one is defined.
> 
> notify_change still needs to process those flags for the local ia_valid
> variable, since it uses that to decide whether to return early, and to pass
> a (hopefully) appropriate bitmask to fsnotify_change.

I agree with this change and fuse will make use of it as well.

Maybe instead of unconditionally moving attr_kill_to_mode() inside
->setattr() it could be made conditional based on an inode flag
similarly to S_NOCMTIME.  Advantages:

 - no need to modify a lot of in-tree filesystems
 - no silent breakage of out-of-tree fs

Actually I think the new flag would be used by exacly the same
filesystems as S_NOCMTIME, so maybe it would make sense to rename
S_NOCMTIME to something more generic (S_NOATTRUPDATE or whatever) and
use that.

But that could still break out-of-tree fs, so a separate flag is
probably better.

Miklos

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
