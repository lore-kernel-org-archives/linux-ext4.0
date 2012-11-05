From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: optionally run all tests under quota
Date: Mon, 5 Nov 2012 20:56:43 +1100
Message-ID: <20121105095642.GL29378@dastard>
References: <4B71B6E7.1000203@redhat.com>
 <508ABF0E.70800@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Rich Johnston <rjohnston@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27114 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab2KEJ4q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2012 04:56:46 -0500
Content-Disposition: inline
In-Reply-To: <508ABF0E.70800@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 26, 2012 at 11:49:18AM -0500, Rich Johnston wrote:
> On 02/09/2010 01:26 PM, Eric Sandeen wrote:
> >This patch might be a little heavy handed, but it seems to
> >work; if you set USE_QUOTA=1 in your environment, all
> >tests should be run with quota on and enabled.
> >
> >This will hopefully help shake out some of the ext4
> >quota problems, although one needs to keep an eye
> >on the console to see whether warnings scroll by.
> >
> >Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >
> >---
> >
> >
> >diff --git a/common.rc b/common.rc
> >index 6424871..4fde921 100644
> >--- a/common.rc
> >+++ b/common.rc
> 
> Looks good
> 
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> 
> Eric,
> 
> This patch has been committed to
> git://oss.sgi.com/xfs/cmds/xfstests, master branch, commit ID
> edd6bcf9.

And here's the problem with committing 2 year old patches without
review:

$ grep "Can't initialize the DMAPI" [0-9]* | uniq
142.out.bad:Can't initialize the DMAPI
143.out.bad:Can't initialize the DMAPI
144.out.bad:Can't initialize the DMAPI
145.out.bad:Can't initialize the DMAPI
146.out.bad:Can't initialize the DMAPI
147.out.bad:Can't initialize the DMAPI
150.out.bad:Can't initialize the DMAPI
155.out.bad:Can't initialize the DMAPI
156.out.bad:Can't initialize the DMAPI
157.out.bad:Can't initialize the DMAPI
158.out.bad:Can't initialize the DMAPI
161.out.bad:Can't initialize the DMAPI
168.out.bad:Can't initialize the DMAPI
175.out.bad:Can't initialize the DMAPI
176.out.bad:Can't initialize the DMAPI
185.out.bad:Can't initialize the DMAPI

This breaks the dmapi mount error detection, and hence whether dmapi
is enabled or not in the kernel. The problem is this:

@@ -251,6 +277,7 @@ _scratch_mount_options()
 _scratch_mount()
 {
     _mount -t $FSTYP `_scratch_mount_options $*`
+    _setup_quota $SCRATCH_MNT
 }
 

means that callers no longer can check is the mount succeeded or not
by looking at the return of _scratch_mount(). Hence this code:

_dmapi_scratch_mount () {
    if [ `echo "$MOUNT_OPTIONS" | grep -c dmapi` -gt 0 -o \
        `echo "$MOUNT_OPTIONS" | grep -c dmi` -gt 0 ] ; then
        #already got dmapi options set
        _scratch_mount
        dmapi_mount_result=$?
    else
        _scratch_mount "-o dmapi,mtpt=$SCRATCH_MNT"
        dmapi_mount_result=$?
    fi

    if [ $dmapi_mount_result -ne 0 ] ; then
        _notrun "Assuming DMAPI modules are not loaded"
    fi
}

now fails to detect that mounts fail.

Can we revert this commit for now? If we really need this
functionality someone can fix the original patch and re-propose it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
