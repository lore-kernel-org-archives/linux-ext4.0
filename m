Return-Path: <SRS0=Jm56=PG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr690120.outbound.protection.outlook.com ([40.107.69.120]:30087
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbeL2NyY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Dec 2018 08:54:24 -0500
Date: Sat, 29 Dec 2018 08:54:17 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Eryu Guan <guaneryu@gmail.com>
CC: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Liu Bo <obuil.liubo@gmail.com>, <fstests@vger.kernel.org>
Subject: Re: [PATCH] ext4/034: adjust commit which fixes the problem tested
 by ext4/034
Message-ID: <20181229135417.GI5864@mit.edu>
References: <20181226160805.8987-1-tytso@mit.edu>
 <20181229050846.GC21777@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181229050846.GC21777@desktop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 29, 2018 at 01:08:46PM +0800, Eryu Guan wrote:
> On Wed, Dec 26, 2018 at 11:08:05AM -0500, Theodore Ts'o wrote:
> > Also add a requirment that fallocate and fiemap is supported.
> > (Fallocate isn't the case when we are emulating ext3, for example.)
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > Cc: Liu Bo <obuil.liubo@gmail.com>
> 
> Patch looks good, but I assume you meant to send it to
> fstests@vger.kernel.org not linux-fstests@mit.edu :)

Oops, yes, that'd be correct.

					- Ted
