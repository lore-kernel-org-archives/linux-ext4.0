From: Andreas Dilger <adilger@sun.com>
Subject: Re: How were some of the lustre e2fsprogs test cases generated?
Date: Tue, 19 Feb 2008 04:40:32 -0700
Message-ID: <20080219114032.GL3029@webber.adilger.int>
References: <E1JRG0g-0001lz-Ur@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37141 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYBSLkf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 06:40:35 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1JBeY10006180
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 03:40:34 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWH00B01HQI0O00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 19 Feb 2008 03:40:34 -0800 (PST)
In-reply-to: <E1JRG0g-0001lz-Ur@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 18, 2008  19:06 -0500, Theodore Ts'o wrote:
> Anyway, no big deal, I'll just regenerate test cases as necessary, or
> just use them as they with different expect logs.  But this just brings
> up one question --- are we 100% sure that for all deployed versions of
> the clusterfs extents code, that the kernel-side implementation was
> always careful to clear the ee_start_hi and ee_leaf_hi fields?

No, it hasn't always been true that we cleared the _hi fields in the
kernel code.  But, it has been a year or more since we found this bug,
and all CFS e2fsprogs releases since then have cleared the _hi fields,
and there has not been any other e2fsprogs that supports extents, so
we expect that there are no filesystems left in the field with this
issue, and even then the current code will prefer to clear the _hi
bits instead of considering the whole extent corrupt.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
