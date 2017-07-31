From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] ext4: preserve i_mode if __ext4_set_acl() fails
Date: Sun, 30 Jul 2017 22:44:47 -0400
Message-ID: <20170731024447.h4fiawhm6lcavahk@thunk.org>
References: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
 <52152ec4b83fe0c406475bfee39efafaaa2a88fb.1499805486.git.ernesto.mnd.fernandez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47240 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdGaCo4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Jul 2017 22:44:56 -0400
Content-Disposition: inline
In-Reply-To: <52152ec4b83fe0c406475bfee39efafaaa2a88fb.1499805486.git.ernesto.mnd.fernandez@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 12, 2017 at 06:53:51AM -0300, Ernesto A. Fernández wrote:
> When changing a file's acl mask, __ext4_set_acl() will first set the group
> bits of i_mode to the value of the mask, and only then set the actual
> extended attribute representing the new acl.
> 
> If the second part fails (due to lack of space, for example) and the file
> had no acl attribute to begin with, the system will from now on assume
> that the mask permission bits are actual group permission bits, potentially
> granting access to the wrong users.
> 
> Prevent this by only changing the inode mode after the acl has been set.
> 
> Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

Thanks, applied.

						- Ted
