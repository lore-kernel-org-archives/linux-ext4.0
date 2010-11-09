From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Tue, 9 Nov 2010 16:41:47 -0500
Message-ID: <20101109214147.GK3099@thunk.org>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
 <20101109044242.GH2715@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46964 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0KIVlz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Nov 2010 16:41:55 -0500
Content-Disposition: inline
In-Reply-To: <20101109044242.GH2715@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 09, 2010 at 03:42:42PM +1100, Dave Chinner wrote:
> Implementation is up to the filesystem. However, XFS does (b)
> because:
> 
> 	1) it was extremely simple to implement (one of the
> 	   advantages of having an exceedingly complex allocation
> 	   interface to begin with :P)
> 	2) conversion is atomic, fast and reliable
> 	3) it is independent of the underlying storage; and
> 	4) reads of unwritten extents operate at memory speed,
> 	   not disk speed.

Yeah, I was thinking that using a device-style TRIM might be better
since future attempts to write to it won't require a separate seek to
modify the extent tree.  But yeah, there are a bunch of advantages of
simply mutating the extent tree.

While we're on the subject of changes to fallocate, what do people
think of FALLOC_FL_EXPOSE_OLD_DATA, which requires either root
privileges or (if capabilities are in use) CAP_DAC_OVERRIDE &&
CAP_MAC_OVERRIDE && CAP_SYS_ADMIN.  This would allow a trusted process
to fallocate blocks with the extent already marked initialized.  I've
had two requests for such functionality for ext4 already.  

(Take for example a trusted cluster filesystem backend that checks the
object checksum before returning any data to the user; and if the
check fails the cluster file system will try to use some other replica
stored on some other server.)

    		     	  		    	 - Ted
