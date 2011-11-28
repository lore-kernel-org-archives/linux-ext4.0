From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Sort recursive getfattr output in 062
Date: Mon, 28 Nov 2011 06:03:02 -0500
Message-ID: <20111128110302.GD13766@infradead.org>
References: <4EC10664.1080501@tuxadero.com>
 <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
 <20111115142246.GA7516@thunk.org>
 <246EA1CC-3C33-4D41-80C0-2331C426EBB0@whamcloud.com>
 <4ECA4282.5020908@whamcloud.com>
 <401CC4FF-8955-4D5F-B620-5C39AF566123@mit.edu>
 <4ECB2ADE.3010007@redhat.com>
 <4ECD28D1.1080800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@MIT.EDU>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yu Jian <yujian@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51706
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab1K1LDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 06:03:04 -0500
Content-Disposition: inline
In-Reply-To: <4ECD28D1.1080800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 23, 2011 at 11:09:37AM -0600, Eric Sandeen wrote:
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

Looks fine to me, except that I'd put the sorting helper into
common.attr.


Reviewed-by: Christoph Hellwig <hch@lst.de>
