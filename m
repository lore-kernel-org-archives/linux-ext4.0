From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Question on resize2fs with "combination of flex_bg and
 !resize_inode"
Date: Thu, 8 Nov 2012 18:03:08 -0500
Message-ID: <20121108230308.GN19977@thunk.org>
References: <k7h36p$qgp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mark Casey <markc@unifiedgroup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60129 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab2KHXDM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 18:03:12 -0500
Content-Disposition: inline
In-Reply-To: <k7h36p$qgp$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2012 at 02:03:38PM -0600, Mark Casey wrote:
> Regarding this patch to resize2fs:
> http://permalink.gmane.org/gmane.comp.file-systems.ext4/7379
> 
> In reading the comment, I was wondering if this problem scenario can
> also happen when shrinking an ext4 filesystem with this combination
> of features, or if it is only likely to be a problem when growing
> it?

It's only a problem when growing the file system.  The comment in the
patch explains the situation; when you are shrinking the file system,
there is never any need to move inode tables to make room for the new
block group descriptor blocks --- which are necessitated by the
additional block groups that come from growing the file system.

       	    	      	      	       - Ted
