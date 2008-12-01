From: Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4 ENOSPC Bug
Date: Mon, 01 Dec 2008 12:42:04 -0700
Message-ID: <20081201194204.GZ3186@webber.adilger.int>
References: <200811291418.24672.andres@anarazel.de>
 <200812011335.00366.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53616 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYLATmc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 14:42:32 -0500
In-reply-to: <200812011335.00366.andres@anarazel.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 01, 2008  13:34 +0100, Andres Freund wrote:
> Are there any additional informations you could use?
> The filesystem is a bit big for you to download unfortunately (and the
> testdata  it contains a bit to sensitive).

Som information that would be useful:
- did you run "e2fsck -f" to see if there were any errors in the filesystem?
- do you run any specific applications that seem to trigger the problem
  (e.g.  Vuze (formerly azureus) as was reported by another user)
- do the applications writing to this file have any unusual IO pattern
  (e.g. mmap IO, lots of write+truncate+write on the same file, etc)

We discussed the creation of a debugging patch to help diagnose this
problem.  It looks like you have already compiled your own kernel, so
I assume it would be possible for you to run with an additional patch?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

