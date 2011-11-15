From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ceph and ext4
Date: Tue, 15 Nov 2011 09:22:46 -0500
Message-ID: <20111115142246.GA7516@thunk.org>
References: <4EC10664.1080501@tuxadero.com>
 <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Mailand <martin@tuxadero.com>, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO47_-9nfO32nwOAQMVdqw6iWGWK+FWb+MD=WeOz_vr4YrrKmw@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 15, 2011 at 09:29:28AM +0100, Christian Brunner wrote:
> 
> I'd love to have a working filesystem for ceph, but the xattr issue
> with ext4 really scares me. That's why I'm still wrestling with btrfs.

FYI, there are patches to extend ext4 to store xattr's in a separate
inode.  They were submitted by the Whamcloud (formerly Oracle, Sun,
Clustrefs -- the Lustre folks).

Unfortunately I haven't had the personal time and review bandwidth to
go over the patches, and they haven't been rebased in a while.  I'm
not opposed to them; they just need some time and loving attention
from folks with ext4 expertise to accelerate the process of getting
the patches reviewed, and in mainline.

					- Ted
