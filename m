Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from muru.com ([72.249.23.125]:57710 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeLLO7D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Dec 2018 09:59:03 -0500
Date: Wed, 12 Dec 2018 06:59:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: Regression in next-20181211 with fsverity changes
Message-ID: <20181212145900.GD6707@atomide.com>
References: <20181211191220.GW6707@atomide.com>
 <3171217.2PqYythArb@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3171217.2PqYythArb@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Chandan Rajendra <chandan@linux.vnet.ibm.com> [181212 04:16]:
> On Wednesday, December 12, 2018 12:42:20 AM IST Tony Lindgren wrote:
> > Hi,
> > 
> > Looks like commit 4de97efb578a ("fsverity: Move verity status check
> > to fsverity_file_open") causes a boot regression for me with root
> > on ext4 SDIO card, see below.
> > 
> 
> fsverity_file_open() used to incorrectly return -EOPNOTSUPP for non-fsverity
> files on kernels built without fsverity support. This bug has been fixed in
> the V4 patchset <https://marc.info/?l=linux-ext4&m=154458767124953&w=2>.

Yes thanks for the update.

Regards,

Tony
