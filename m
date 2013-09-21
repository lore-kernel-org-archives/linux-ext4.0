From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
Date: Sat, 21 Sep 2013 14:53:04 -0400
Message-ID: <20130921185304.GB8606@thunk.org>
References: <52309F27.8060008@redhat.com>
 <alpine.DEB.2.02.1309111325270.5862@nftneq.ynat.uz>
 <5230D739.9010109@redhat.com>
 <20130911212523.GE13397@thunk.org>
 <5230D450.7000609@hp.com>
 <20130912122317.GC12918@thunk.org>
 <5232FF3E.7080604@hp.com>
 <5233609F.7060303@redhat.com>
 <523886CE.2070203@hp.com>
 <5239B65E.4060202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	Andreas Dilger <adilger@dilger.ca>,
	T Makphaibulchoke <tmac@hp.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	aswin@hp.com, aswin_proj@lists.hp.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35376 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3IUSyg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Sep 2013 14:54:36 -0400
Content-Disposition: inline
In-Reply-To: <5239B65E.4060202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 18, 2013 at 09:19:10AM -0500, Eric Sandeen wrote:
> > I think I found out why we get into the mbcache path.  The test uses
> > ramfss, which are mounted and unmounted at the start and end of the
> > test.  Looks like a ramfs' default inode size is 128, causing all the
> > mbcaching for the xattrs.  There seems to be nothing wrong with
> > either SELinux or xattr.  Sorry for the confusion.
> 
> smaller filesystems go back to 128 byte inodes, IIRC.

Mak, did you mean a ext4 file system created on a ramdisk, using a
/dev/ramNN device, or the literal "ramfs" file system?

I assume the former, right?

					- Ted
