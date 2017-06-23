From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] test-appliance: add new test configuration:
 ext4/lustre_mds
Date: Fri, 23 Jun 2017 17:41:09 -0400
Message-ID: <20170623214109.3kwtxj3owi4noxda@thunk.org>
References: <20170609035943.26447-1-tytso@mit.edu>
 <CAO3qy=EVQtVVe2hvEvaYOTyArPpK7U6AYA9abu6Zum-p_sWqpg@mail.gmail.com>
 <20170609175910.shwqocbi3npfmoid@thunk.org>
 <087C00FA-AF13-498F-8D6A-B67A115D8DCE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38230 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753397AbdFWVlN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 17:41:13 -0400
Content-Disposition: inline
In-Reply-To: <087C00FA-AF13-498F-8D6A-B67A115D8DCE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 09, 2017 at 03:00:56PM -0600, Andreas Dilger wrote:
> 
> I didn't include large_dir because it isn't included in the upstream
> kernels yet, and we haven't been using this in production due to lack
> of e2fsck support (which Seagate has finally implemented, thank you).

Also, does Lustre use large_dir on the MDS server, or on the Lustre
data server?  Because I noticed that on the MDS server you're
apparently not using extents:

export EXT_MKFS_OPTIONS="-I 2048 -O ^64bit,mmp,uninit_bg,^extents,dir_nlink,...
                                                         ^^^^^^^^

Are you really using large_dir on a file system that is using indirect
block mapped files?

						- Ted
