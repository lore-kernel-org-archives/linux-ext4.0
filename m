Return-Path: <SRS0=tX6L=ML=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34818 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728246AbeI2Vr7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 29 Sep 2018 17:47:59 -0400
Date: Sat, 29 Sep 2018 11:19:09 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: uninit_bg removed from mke2fs.conf
Message-ID: <20180929151908.GB2290@thunk.org>
References: <ac3c94bd-adf7-eb8a-f776-e6f3a31f9df9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3c94bd-adf7-eb8a-f776-e6f3a31f9df9@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 29, 2018 at 03:39:06PM +0200, Xose Vazquez Perez wrote:
> 
> It was removed from misc/mke2fs.conf.in in d0b9e0a6aa7d6805338a43b4e372623352d8df09
> 
> Was it intentional?

Yes, metadata_csum's functionality is a superset of uninit_bg with a
different way of checksuming the block group descriptors.  So it's
contradictory to have both metadata_csum and uninit_bg enabled at the
same time.

						- Ted
