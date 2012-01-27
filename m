From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfstests: Sort recursive getfattr output in 062
Date: Fri, 27 Jan 2012 05:53:45 -0500
Message-ID: <20120127105344.GB23335@infradead.org>
References: <4EC10664.1080501@tuxadero.com>
 <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
 <20111115142246.GA7516@thunk.org>
 <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
 <4ECA4282.5020908@whamcloud.com>
 <401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
 <4ECB2ADE.3010007@redhat.com>
 <4ECD28D1.1080800@redhat.com>
 <4F20766E.9040902@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@MIT.EDU>, Yu Jian <yujian@whamcloud.com>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34565
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab2A0Kxs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jan 2012 05:53:48 -0500
Content-Disposition: inline
In-Reply-To: <4F20766E.9040902@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 25, 2012 at 03:38:54PM -0600, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Test 062 was made "generic" a while back, but it fails on any filesystem
> which returns getfattr -R results (aka readdir results) in something
> other than inode-order.
> 
> With a little awk-fu we can sort the records from getfattr -R so that
> the output is the same for xfs as well as ext4, etc.
> 
> Also filter out lost+found which extN creates at mkfs time, but
> some other filesystems do not.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> - ---
> 
> V2: move sorting function into common.attr

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
