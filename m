From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Date: Wed, 8 Aug 2007 09:48:53 -0700
Message-ID: <20070808094853.8c27450c.akpm@linux-foundation.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<20070808085435.722f2b10.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: codalist-OCorLXSLWn+MVn35/9/JlcWGCVk0P7UB@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	mikulas-TTVWCEgN8Z9G4ohzP4jBZS1Fcj925eT/@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	zippel-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	wli-tGiaVUSOoeej7qYf8Sx8sA@public.gmane.org, joel.becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jffs-dev-VrBV9hrLPhE@public.gmane.org,
	user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, bfennema-gi/t4lz4P9Yq08oLxijIyCUISzVj0O8v@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20070808085435.722f2b10.jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

On Wed, 8 Aug 2007 08:54:35 -0400 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 7 Aug 2007 17:15:01 -0700
> Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> 
> > On Mon, 6 Aug 2007 09:54:03 -0400
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > Is there any way in which we can prevent these problems?  Say
> > 
> > - rename something so that unconverted filesystems will reliably fail to
> >   compile?
> > 
> 
> I suppose we could rename the .setattr inode operation to something
> else, but then we'll be stuck with it for at least a while. That seems
> sort of kludgey too...

Sure.  We're changing the required behaviour of .setattr.  Changing its
name is a fine and reasonably reliable way to communicate that fact.

> > - leave existing filesystems alone, but add a new
> >   inode_operations.setattr_jeff, which the networked filesytems can
> >   implement, and teach core vfs to call setattr_jeff in preference to
> >   setattr?
> > 
> > Something else?
> 
> There's also the approach suggested by Miklos: Add a new inode flag that
> tells notify_change not to convert ATTR_KILL_S* flags into a mode
> change. Basically, allow filesystems to "opt out" of that behavior. 
> 
> I'd definitly pick that over a new inode op. That would also allow the
> default case be for the VFS to continue handling these flags.
> Everything would continue to work but filesystems that need to handle
> these flags differently would be able to do so.
> 

We should opt for whatever produces the best end state in the kernel tree. 
ie: if it takes more work and a larger patch to create a better result,
let's go for the better result.  We merge large patches all the time.  We
prefer to smash through, get it right whatever the transient cost.  But
quietly making out-of-tree filesystems less secure is a pretty high cost.

I'm suspecting that adding more flags and some code to test them purely to
minimise the size of the patch and to retain compatibility with the old
.setattr is not a good tradeoff, given that we'd carry the flags and tests
for evermore.

So I'd suggest s/setattr/something_else/g.

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
