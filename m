From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: ext4-patch-queue rebased to 2.6.22
Date: Tue, 10 Jul 2007 20:24:22 +0530
Message-ID: <20070710145422.GA1636@amitarora.in.ibm.com>
References: <E1I7xBM-00044G-2v@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41811 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXGJOyP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 10:54:15 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AEtQfS031178
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 10:55:26 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AEsEaP503434
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 10:54:14 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AEsEWN018386
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 10:54:14 -0400
Content-Disposition: inline
In-Reply-To: <E1I7xBM-00044G-2v@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 09, 2007 at 01:37:56PM -0400, Theodore Ts'o wrote:
> So we're just waiting for Amit to make the minor on-disk format change
> Andreas suggested before we push to Linus.

I have commited following changes to the ext4 patch queue:

1. Updated ext4-fallocate-1-syscall_i386_amd64_ppc to add compat wrapper
   for x86_64/ia32. This addresses Heiko's concern that we did not have
   a wrapper for ia32.

2. Added a new patch ext4-fallocate-8-new-ondisk-format and updated
   the series file. This patch, as suggested by Andreas, will allow
   an initialized extent to be of max 2^15 length. Main purpose of this
   change is to have a better extent-to-group alignment.
   For uninitialized extents the max length remains same - i.e. 2^15 - 1.


Thanks!
--
Regards,
Amit Arora
