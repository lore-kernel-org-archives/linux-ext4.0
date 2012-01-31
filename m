From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [BUG] e2fsprogs: e2fsck -b outputs checksum warnings
Date: Tue, 31 Jan 2012 15:17:40 -0700
Message-ID: <27A3067E-93E0-4452-968F-94634A72E546@dilger.ca>
References: <4E6726E4.8070203@rs.jp.nec.com> <4F28527D.9030405@redhat.com> <20120131205657.GC25951@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54220 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2AaWRl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jan 2012 17:17:41 -0500
In-Reply-To: <20120131205657.GC25951@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-31, at 1:56 PM, Ted Ts'o wrote:
>>> One or more block group descriptor checksums are invalid.  Fix<y>? yes
>>> 
>>> Group descriptor 0 checksum is invalid.  FIXED.
>>> Group descriptor 1 checksum is invalid.  FIXED.
>>> Group descriptor 2 checksum is invalid.  FIXED.
>>> Group descriptor 3 checksum is invalid.  FIXED.
> 
> This is certainly scary, though.  In the case where we do need to use
> the backup block group descriptors, it would be better to reset the
> checksum to the correct value so we don't get all of this extra
> output, which isn't useful to the user and is just going to alarm them
> unnecessarily.

I was thinking this is just an oversight in the code which is removing the
UNINIT flags.  It should just recompute the group checksum (which will
happen only rarely, and the performance isn't critical).

A patch has been submitted separately.

Cheers, Andreas





