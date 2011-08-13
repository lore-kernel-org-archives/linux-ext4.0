From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: xfstests #62 broken on ext4
Date: Sat, 13 Aug 2011 17:57:49 +0200
Message-ID: <4E469EFD.7070407@giantdisaster.de>
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:16777 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1HMQBN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Aug 2011 12:01:13 -0400
In-Reply-To: <E1QsFMR-0001iq-Vt@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13.08.2011 16:38, Theodore Ts'o wrote:
> Xfstests #62 was recently enabled by commit b2b36d0a4.
>
> However, this test is failing for ext4 because ext4 doesn't support
> extended attributes on anything other than regular files and
> directories.  This is behavior is documented in the attr(5) man page:

> (3) Modify test #62 so that it can support both the XFS and Linux
> generic behavior.

> (5) Change XFS to match the generic behavior, and then change test #62.

I would volunteer for implementing the required changes for option #3 
and start next week except people favour option #5.
