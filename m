From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH acks] fs/*/Kconfig: drop links to 404-compliant
 http://acl.bestbits.at
Date: Wed, 20 Dec 2017 07:14:22 -0700
Message-ID: <20171220071422.5177d2cf@lwn.net>
References: <20171213053825.10903-1-kilobyte@angband.pl>
        <20171220135852.7662-1-kilobyte@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org
To: Adam Borowski <kilobyte@angband.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:52928 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754931AbdLTOOY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Dec 2017 09:14:24 -0500
In-Reply-To: <20171220135852.7662-1-kilobyte@angband.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 20 Dec 2017 14:58:52 +0100
Adam Borowski <kilobyte@angband.pl> wrote:

> This link is replicated in most filesystems' config stanzas.  Referring
> to an archived version of that site is pointless as it mostly deals with
> patches; user documentation is available elsewhere.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Acked-by: Jan Kara <jack@suse.cz>
> Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Acked-by: David Sterba <dsterba@suse.com>
> Acked-by: "Yan, Zheng" <zyan@redhat.com>
> Acked-by: Chao Yu <yuchao0@huawei.com>
> Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Acked-by: Steve French <smfrench@gmail.com>
> ---
> No changes, acks added (Dave Kleikamp's came without CCs).
> 
> Acked: btrfs ceph cifs ext2 f2fs jfs xfs.
> No ack: . 9p ext4 hfsplus jffs2 reiserfs -- but there's no point in caring
> this much for a trivial doc update, molesting the maintainers further is a
> waste of their time.

So how would you like this to go upstream?  I can certainly take it
through docs, but it seems like vfs might be the first choice...?

Thanks,

jon
