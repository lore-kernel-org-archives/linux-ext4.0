From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Date: Fri, 6 Jul 2007 09:51:56 -0400
Message-ID: <20070706135156.GD10812@fieldses.org>
References: <1183275424.4010.126.camel@localhost.localdomain> <1183388313.3864.35.camel@localhost.localdomain> <20070703221522.GE14074@fieldses.org> <20070703233200.GL6578@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.fieldses.org ([66.93.2.214]:50556 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXGFNwE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jul 2007 09:52:04 -0400
Content-Disposition: inline
In-Reply-To: <20070703233200.GL6578@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 03, 2007 at 05:32:00PM -0600, Andreas Dilger wrote:
> On Jul 03, 2007  18:15 -0400, J. Bruce Fields wrote:
> > How will nfsd tell whether it can really on a given filesystem's
> > i_version, or whether it should fall back on ctime?
> 
> Good question.

Well, we don't need anything particularly complicated--just a one-bit
flag on the superblock would be enough.

> > So what's the motivation for the "noversion" mount option?
> 
> Lustre needs to be able to control the version number directly (version
> number needs to be ordered between all inodes, is set by Lustre to be a
> transaction number).  Instead of trying to incorporate this unused code
> into ext4 we just turn off the ext4 version code and let Lustre control
> this directly.  It may even be that NFSv4 will need to control the version
> numbers itself...

I can't think of any reason we would need to in the near future, but
maybe I'm insufficiently creative.

The use of a mount option means the change attribute could be
inconsistent across mounts.  If we really need this, wouldn't it make
more sense for it to be a persistent feature of the filesystem, set at
mkfs time?

--b.
