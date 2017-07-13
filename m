From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfstests PATCH] generic: add test of file mode when setfacl
 fails
Date: Thu, 13 Jul 2017 04:55:07 -0700
Message-ID: <20170713115507.GA10435@infradead.org>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
 <20170712114719.GA14398@infradead.org>
 <20170713094003.GA4959@debian.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org, fstests@vger.kernel.org
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42069 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdGMLzL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jul 2017 07:55:11 -0400
Content-Disposition: inline
In-Reply-To: <20170713094003.GA4959@debian.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 13, 2017 at 06:40:04AM -0300, Ernesto A. Fernández wrote:
> Check that the group permission bits of a file are not altered when setfacl
> fails. At the time of this patch the test fails for at least ext2, ext4 and
> jfs. It is not run against reiserfs, since xfstests claims that "attrs are
> not supported by this filesystem type".

That's odd, as common/config explicitly turns on user xattrs:

        reiserfs)
                # acls & xattrs aren't turned on by default on reiserfs
                export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"


> 
> The failure to set acls is induced by filling the device, so to save time
> this should probably be run with a small TEST_DEV.

If you run it on the scratch fs instead of the test fs you can use
_scratch_mkfs_sized to hand craft a small fs, which would be nice
to get a decent runtime.
