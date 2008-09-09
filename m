From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 12:50:05 -0400
Message-ID: <20080909165005.GA24816@infradead.org>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org> <20080909134347.GB21071@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	adilger@sun.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbYIIQua (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 12:50:30 -0400
Content-Disposition: inline
In-Reply-To: <20080909134347.GB21071@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 09:43:47AM -0400, Theodore Tso wrote:
> The alternate is to create an entire new program (e4migrate) just to
> trigger a single ioctl.  The reality is this is probably going to more
> used by ext4 developers than anybody else, since it's rare that you
> would want to convert a single file from using indrect blocks to using
> extents.  In general, most users/system administrators will want to
> convert the entire filesystem; eventually this will probably be done
> via some combination with the userspace program to trigger online
> defrag, but this was just a stopgap measure to allow us to more easily
> exercise the kernel code more than anything else.
> 
> So given that this is only to enable extents on a single file, "chattr
> +e file" is very much in line with the rest of the chattr interface
> for setting other flags.

Well, if you think setting a flag is a good interface to convert to
extents, then do it all the way and allow setting the extent
flag in the kernel through FS_IOC_SETFLAGS instead of having an
interface schism.

