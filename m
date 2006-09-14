From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Wed, 13 Sep 2006 21:24:49 -0400
Message-ID: <20060914012449.GC22224@fieldses.org>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <20060913193130.GJ6441@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.fieldses.org ([66.93.2.214]:56739 "EHLO
	pickle.fieldses.org") by vger.kernel.org with ESMTP
	id S1751317AbWINBYw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Sep 2006 21:24:52 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20060913193130.GJ6441@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 13, 2006 at 01:31:30PM -0600, Andreas Dilger wrote:
> On Sep 13, 2006  18:42 +0200, Alexandre Ratchov wrote:
> > The patch also adds a new ``st_change_attribute'' field in the stat
> > structure, and modifies the stat(2) syscall accordingly. Currently the
> > change is only visible on i386 and x86_64 archs.
> 
> Is this really necessary for knfsd?

Of course knfsd is completely in kernel, so it doesn't care about the
userspace interface.

But I think that a change attribute is potentially an *extremely* useful
thing, and for more than just nfs servers.  Lots of userspace programs
also need to know whether a file has changed since they last examined
it, and also suffer from the limitations of using ctime or mtime as an
imperfect approximation to a real change attribute.

But it would make sense to split the user space changes into a second
patch and possibly apply it later.

--b.
