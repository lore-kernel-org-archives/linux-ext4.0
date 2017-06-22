From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] Add largedir feature
Date: Wed, 21 Jun 2017 21:11:42 -0400
Message-ID: <20170622011142.gu5qdyqsmuox7v4f@thunk.org>
References: <A4690934-D680-4735-AEA6-8BF995990546@dilger.ca>
 <1494094761-19108-1-git-send-email-artem.blagodarenko@seagate.com>
 <19F5F19B-23F5-466A-B934-EB15896E1B15@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Yang Sheng <yang.sheng@intel.com>,
        Artem Blagodarenko <artem.blagodarenko@seagate.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57270 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbdFVBL5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Jun 2017 21:11:57 -0400
Content-Disposition: inline
In-Reply-To: <19F5F19B-23F5-466A-B934-EB15896E1B15@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 08, 2017 at 05:17:05PM -0600, Andreas Dilger wrote:
> On May 6, 2017, at 12:19 PM, Artem Blagodarenko <artem.blagodarenko@gmail.com> wrote:
> > 
> > From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> > 
> > This INCOMPAT_LARGEDIR feature allows larger directories to be created
> > in ldiskfs, both with directory sizes over 2GB and and a maximum htree
> > depth of 3 instead of the current limit of 2. These features are needed
> > in order to exceed the current limit of approximately 10M entries in a
> > single directory.
> 
> Please also credit the original author.  Yang Sheng has been maintaining this
> patch and is listed as the author of the patches for other kernels.
> 
> Signed-off-by: Liang Zhen <liang.zhen@intel.com>
> 
> > Signed-off-by: Yang Sheng <yang.sheng@intel.com>
> > Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
> 
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

Applied, thanks.

					- Ted
