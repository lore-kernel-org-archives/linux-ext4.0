From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] Add missing features and mount options to ext4 man
 page.
Date: Thu, 14 Dec 2017 14:59:34 -0500
Message-ID: <20171214195934.y5euctfdl2b2v6vd@thunk.org>
References: <cover.1513233071.git.tgnottingham@gmail.com>
 <66ae08c8ad25285fff38e65b0da40e14c28fa9c8.1513233071.git.tgnottingham@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tyson Nottingham <tgnottingham@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46328 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbdLNT7g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Dec 2017 14:59:36 -0500
Content-Disposition: inline
In-Reply-To: <66ae08c8ad25285fff38e65b0da40e14c28fa9c8.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 13, 2017 at 11:13:09PM -0800, Tyson Nottingham wrote:
> Add descriptions for ea_inode, large_dir, metadata_csum, and
> metadata_csum_seed features, as well as nombcache and prjquota
> mount options. Also, update a couple of descriptions.
> 
> Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>

Thanks, applied (split between the master and maint branches).

		       	       	   - Ted
