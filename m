From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Add largedir feature
Date: Mon, 1 May 2017 22:44:42 -0400
Message-ID: <20170502024442.dfzaslsykjycu7md@thunk.org>
References: <1489657877-34478-1-git-send-email-artem.blagodarenko@seagate.com>
 <20170430005953.m74yjettitj7mzr6@thunk.org>
 <20170501185824.GB30027@gmail.com>
 <2C3E39F6-8143-415F-B9D5-F3363BDEBC45@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38250 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbdEBCou (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 May 2017 22:44:50 -0400
Content-Disposition: inline
In-Reply-To: <2C3E39F6-8143-415F-B9D5-F3363BDEBC45@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 01, 2017 at 05:39:41PM -0600, Andreas Dilger wrote:
> > FYI, this patch is causing a problem when creating many files in a directory
> > (without the largedir feature enabled).  I haven't looked into it but maybe it
> > will ring a bell for someone.
> 
> Hmm, is this also a problem without the patch, when creating large numbers
> of entries in a directory?

No, it works fine without the patch.  Turnkey reproduction for
kvm-xfstests which works fine without the largedir patch, but which
fails with the largedir patch:

   mke2fs -t ext4 -Fq /dev/vdc
   mount /vdc
   mkdir /vdc/a
   cd /vdc/a
   seq -f "abcdefghijklmnopqrstuvwxyz012345%.0f" 100000 | xargs touch
   umount /vdc
   e2fsck -fy /dev/vdc

The output of e2fsck:

e2fsck 1.43.5-WIP-ed1e950f (26-Apr-2017)
Pass 1: Checking inodes, blocks, and sizes
Inode 131073, i_size is 2080768, should be 2084864.  Fix? yes

Pass 2: Checking directory structure
Problem in HTREE directory inode 131073: root node fails checksum.
Clear HTree index? yes

Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/vdc: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdc: 30705/327680 files (0.0% non-contiguous), 42515/1310720 blocks

It looks the large_dir patch is responsible for a test regression ---
it is causing generic/339 to fail.

I'm going to drop the large dir patch for the 4.12 merge window.
Eric, thanks for noticing and pointing this out!

						- Ted
