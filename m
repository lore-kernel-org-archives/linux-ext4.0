From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Update of e2fsprogs pu branch and ext4 dev branch
Date: Wed, 2 May 2012 12:40:21 -0600
Message-ID: <F23120C0-078E-44A2-96F9-521E48178AAC@dilger.ca>
References: <E1SObU7-0004xb-KU@tytso-glaptop.cam.corp.google.com> <20120502072944.GA11639@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <djwong@us.ibm.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:29050 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2EBSkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2012 14:40:23 -0400
In-Reply-To: <20120502072944.GA11639@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-02, at 1:29 AM, Zheng Liu wrote:
> On Sun, Apr 29, 2012 at 05:16:47PM -0400, Theodore Ts'o wrote:
> BTW, I have noticed that in current mainline kernel,
> EXT4_FEATURE_INCOMPAT_INLINEDATA is set to 0x8000.  So I will change it
> in e2fsprogs.  Meanwhile, I will add inline_data option into ext4dev in
> mke2fs.conf.  Later I will send the patch to the mailing list.

Right.  There was at one time EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM
using 0x2000, but that was is not currently needed.  I think it is a
bad idea to change INCOMPAT_INLINEDATA to use 0x2000 in e2fsprogs,
since there is already 0x8000 in by the upstream kernel.

Also, I don't see EXT4_FEATURE_INCOMPAT_LARGEDIR 0x4000 in e2fsprogs
either.  I submitted patches to reserve this flag in Dec 2011
"[PATCH 02/02] ext2: reserve INCOMPAT_LARGEDIR feature flag" but I
guess it was lost when we discovered the conflict between INLINEDATA
and META_CSUM.

AFAIR, all parties agreed to move INLINEDATA to 0x8000 (as was later
changed by Ted in the kernel) to avoid conflict with META_CSUM (which
was thought to be closer to landing, though it later turned out to
be unnecessary).

Cheers, Andreas





