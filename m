Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38592 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbeLDCZT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Dec 2018 21:25:19 -0500
Date: Mon, 3 Dec 2018 21:25:16 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Fix tst_super_size after ext2_super_block changes
Message-ID: <20181204022516.GA32349@thunk.org>
References: <20181128160834.1729-1-artem.blagodarenko@gmail.com>
 <050FAC09-2437-417C-AF69-7637613BA7BB@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <050FAC09-2437-417C-AF69-7637613BA7BB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2018 at 12:09:26PM -0700, Andreas Dilger wrote:
> On Nov 28, 2018, at 9:08 AM, Artem Blagodarenko <artem.blagodarenko@gmail.com> wrote:
> > 
> > Commits "Reserve feature bit and SB field bit for filename encoding"
> > and "Add timestamp extension bits to superblock" change
> > ext2_super_block structure, but don't change tst_super_size test,
> > so "make check" fails with message:
> > 
> > error: s_reserved size 380 should be 392
> 
> How did these patches even land without "make check" being run once?
> Does this test failure not cause "make check" to fail?

My bad; I failed to run the make check before pushing it out.  I fixed
this before seeing Artem's patch, and the fix was what he pushed out.

     	    	   	   	      - Ted
