From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Date: Wed, 08 Aug 2007 07:14:37 +0200
Message-ID: <E1IIdsT-0001dn-00@dorka.pomaz.szeredi.hu>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codalist-ySnCqBnJi5yMVn35/9/JlcWGCVk0P7UB@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jffs-dev-VrBV9hrLPhE@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, zippel-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wli-tGiaVUSOoeej7qYf8Sx8sA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	joel.becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mikulas-TTVWCEgN8Z9G4ohzP4jBZS1Fcj925eT/@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, bfennema-gi/t4lz4P9Yq08oLxijIyCUISzVj0O8v@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-reply-to: <20070807171501.e31c4a97.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> (message from
	Andrew Morton on Tue, 7 Aug 2007 17:15:01 -0700)
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

> >From a purely practical standpoint: it's a concern that all filesytems need
> patching to continue to correctly function after this change.  There might
> be filesystems which you missed, and there are out-of-tree filesystems
> which won't be updated.
> 
> And I think the impact upon the out-of-tree filesystems would be fairly
> severe: they quietly and subtly get their secutiry guarantees broken (I
> think?)
> 
> Is there any way in which we can prevent these problems?  Say
> 
> - rename something so that unconverted filesystems will reliably fail to
>   compile?

Maybe renaming ATTR_MODE to ATTR_MODE_SET (changing it's value as
well, so that binary stuff breaks visibly as well)?

This would make sense, because we are changing what this attribute
acually means.  In the new code attr->ia_mode only contains the
originally set mode, not the ones we've added to change the suid bits.

Miklos

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
