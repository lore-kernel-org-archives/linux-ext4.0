From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext4-patch-queue rebased to 2.6.22
Date: Tue, 10 Jul 2007 11:09:39 -0600
Message-ID: <20070710170939.GA6417@schatzie.adilger.int>
References: <E1I7xBM-00044G-2v@candygram.thunk.org> <20070710145422.GA1636@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:56361 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbXGJRJl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 13:09:41 -0400
Content-Disposition: inline
In-Reply-To: <20070710145422.GA1636@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  20:24 +0530, Amit K. Arora wrote:
> On Mon, Jul 09, 2007 at 01:37:56PM -0400, Theodore Ts'o wrote:
> > So we're just waiting for Amit to make the minor on-disk format change
> > Andreas suggested before we push to Linus.
> 
> 2. Added a new patch ext4-fallocate-8-new-ondisk-format and updated
>    the series file. This patch, as suggested by Andreas, will allow
>    an initialized extent to be of max 2^15 length. Main purpose of this
>    change is to have a better extent-to-group alignment.
>    For uninitialized extents the max length remains same - i.e. 2^15 - 1.

One tiny change I'd ask for in this patch (it isn't critical to get in
before the upstream submission as it is only code style) is instead of
using (EXT_MAX_LEN - 1) for uninitialized extents, instead use a separate
#define EXT_UNINIT_MAX_LEN (EXT_MAX_LEN - 1) and use that in the code.
While a minor change, this localizes the knowledge of the maximum length
of uninitialized extents into just one place - right after the maximum
length of initialized extents.

It might even make sense to change the other #define to be called
EXT_INIT_MAX_LEN so people have to think about this when using the #define.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
