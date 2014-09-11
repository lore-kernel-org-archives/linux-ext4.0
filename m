From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/25] tests: test e2fsck recovery of corrupt descriptor
 blocks
Date: Thu, 11 Sep 2014 11:40:18 -0700
Message-ID: <20140911184018.GO10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231355.25904.14661.stgit@birch.djwong.org>
 <20140910011529.GG10351@birch.djwong.org>
 <20140911173337.GM10351@birch.djwong.org>
 <20140911181848.GA8366@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42812 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaIKSkX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 14:40:23 -0400
Content-Disposition: inline
In-Reply-To: <20140911181848.GA8366@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 02:18:48PM -0400, Theodore Ts'o wrote:
> On Thu, Sep 11, 2014 at 10:33:37AM -0700, Darrick J. Wong wrote:
> > I guess that my interpretation was incorrect; see Jan Kara's reply to "jbd2:
> > restart replay without revokes if journal block csum fails".  This test is
> > of course still broken, but the patchbomb is fine up through patch #20.
> 
> Is patch #22 ok?

Yeah, everything but #21 is ok.  I'll issue a new #21 shortly.

(and four other patches to fix other problems e2fuzz found along the way...)

--D

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
