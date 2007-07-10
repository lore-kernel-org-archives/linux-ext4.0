From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: ext4-patch-queue rebased to 2.6.22
Date: Tue, 10 Jul 2007 23:25:58 +0530
Message-ID: <20070710175558.GA15345@amitarora.in.ibm.com>
References: <E1I7xBM-00044G-2v@candygram.thunk.org> <20070710145422.GA1636@amitarora.in.ibm.com> <20070710170939.GA6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45328 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbXGJRzw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 13:55:52 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AGq4r7032693
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 12:52:04 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AHtlnT407342
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:55:47 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AHtkC1008520
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:55:47 -0400
Content-Disposition: inline
In-Reply-To: <20070710170939.GA6417@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 10, 2007 at 11:09:39AM -0600, Andreas Dilger wrote:
> On Jul 10, 2007  20:24 +0530, Amit K. Arora wrote:
> > On Mon, Jul 09, 2007 at 01:37:56PM -0400, Theodore Ts'o wrote:
> > > So we're just waiting for Amit to make the minor on-disk format change
> > > Andreas suggested before we push to Linus.
> > 
> > 2. Added a new patch ext4-fallocate-8-new-ondisk-format and updated
> >    the series file. This patch, as suggested by Andreas, will allow
> >    an initialized extent to be of max 2^15 length. Main purpose of this
> >    change is to have a better extent-to-group alignment.
> >    For uninitialized extents the max length remains same - i.e. 2^15 - 1.
> 
> One tiny change I'd ask for in this patch (it isn't critical to get in
> before the upstream submission as it is only code style) is instead of
> using (EXT_MAX_LEN - 1) for uninitialized extents, instead use a separate
> #define EXT_UNINIT_MAX_LEN (EXT_MAX_LEN - 1) and use that in the code.
> While a minor change, this localizes the knowledge of the maximum length
> of uninitialized extents into just one place - right after the maximum
> length of initialized extents.
> 
> It might even make sense to change the other #define to be called
> EXT_INIT_MAX_LEN so people have to think about this when using the #define.

Done. Changes are in ext4 patch queue.
Can you please have a quick look and see if this is what you preferred ?

--
Regards,
Amit Arora
