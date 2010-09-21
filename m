From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: use lazy inode init on some discard-able devices
Date: Mon, 20 Sep 2010 23:15:59 -0600
Message-ID: <E586FDF0-22B6-4FCD-80EB-F33F851AE031@dilger.ca>
References: <4C6EF67A.5080502@redhat.com> <20100920132324.GE3554@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27150 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0IUFQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Sep 2010 01:16:11 -0400
In-Reply-To: <20100920132324.GE3554@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 20, 2010 at 04:41:14PM -0500, Eric Sandeen wrote:
> If a device supports discard -and- returns 0s for discarded blocks,
> then we can skip the inode table initialization -and- the inode table
> zeroing at mkfs time, and skip the lazy init as well since they are
> already zeroed out.

Eric, do you have my patch for skipping the journal zeroing?  If you are already skipping the inode table zeroing (which is my bigger of a deal) then you may as well skip zeroing the journal at the same time.

Cheers, Andreas





