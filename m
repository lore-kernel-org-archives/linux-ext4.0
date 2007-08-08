From: Jan Engelhardt <jengelh-bdq14YP6qtRlEiWPh9xO2Q@public.gmane.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Date: Wed, 8 Aug 2007 22:05:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708082204210.10387@fbirervta.pbzchgretzou.qr>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<20070808085435.722f2b10.jlayton@redhat.com>
	<20070808094853.8c27450c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codalist-OCorLXSLWn+MVn35/9/JlcWGCVk0P7UB@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jffs-dev-VrBV9hrLPhE@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, zippel-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wli-tGiaVUSOoeej7qYf8Sx8sA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	joel.becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mikulas-TTVWCEgN8Z9G4ohzP4jBZS1Fcj925eT/@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, bfennema-gi/t4lz4P9Yq08oLxijIyCUISzVj0O8v@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20070808094853.8c27450c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
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


On Aug 8 2007 09:48, Andrew Morton wrote:
>> > On Mon, 6 Aug 2007 09:54:03 -0400
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > 
>> > Is there any way in which we can prevent these problems?  Say
>> > 
>> > - rename something so that unconverted filesystems will reliably fail to
>> >   compile?
>> > 
>> 
>> I suppose we could rename the .setattr inode operation to something
>> else, but then we'll be stuck with it for at least a while. That seems
>> sort of kludgey too...
>
>Sure.  We're changing the required behaviour of .setattr.  Changing its
>name is a fine and reasonably reliable way to communicate that fact.

Maybe ->chattr/->chgattr?


	Jan
-- 

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
