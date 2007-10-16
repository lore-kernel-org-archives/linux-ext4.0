From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Tue, 16 Oct 2007 11:41:24 -0500
Message-ID: <20071016114124.1536e8e6@gara>
References: <E1IheLt-0001TN-65@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:50888 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbXJPQld (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2007 12:41:33 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9GGfRBL020326
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 12:41:27 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9GGfM2N296578
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 10:41:23 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9GGfMXr008164
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 10:41:22 -0600
In-Reply-To: <E1IheLt-0001TN-65@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 16 Oct 2007 00:48:21 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> * js/flex-bg (Mon Aug 13 23:33:14 2007 -0500) 7 commits
>  - New bitmap and inode table allocation for FLEX_BG

This one was more of an RFC to let folks play with different meta data
layouts.  Should probably stay outside the tree for now.  The other
three patches are whats needed to get e2fsprog in sync with the kernel.

>  - Relax group descriptor checking.

This one needs updating to be more in line with what we define FLEX_BG
to be in the kernel.  I thing I also encounter conflicts when pulling
from the git tree a while back, so the one in the mailing list will not
apply cleanly.
 
>  - Allow FLEX_BG to be use as a feature option at mke2fs time.
>  - Reserve the INCOMPAT feature number for FLEX_BG.
> 
> Relatively straight forward, so we should be able to merge this soon.

The last two are fine but its still missing documentation.  Skip this
series for now.  I will update and resend.

-JRS
