From: Jan Kara <jack@suse.cz>
Subject: Re: Ext4 devel interlock meeting minutes (October 22, 2007)
Date: Wed, 24 Oct 2007 19:55:49 +0200
Message-ID: <20071024175549.GA13406@atrey.karlin.mff.cuni.cz>
References: <471E6279.2000603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50476 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbXJXRzu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 13:55:50 -0400
Content-Disposition: inline
In-Reply-To: <471E6279.2000603@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  Sorry for not taking part in the call but I was just on my way from NY
to Prague...

> Ext4 Developer Interlock Call
> October 22, 2007: Meeting Minutes
> 
> Attendees: Mingming Cao, Andreas Dilger, Eric Sandeen, Dave Kleikamp, 
> Jose Santos, Aneesh Veetil, Valerie Clement, Avantika Mathur
> 
> - There has been discussion on linux-ext4 about overflow in ext2 with 64 
> KB block size.  Discussed adding an incompat flag to this feature and 
> concluded that it is too late to do this; it will be treated as a bug fix.
  Hmm, why adding an incompat flag? Obviously there's no harm in doing
that but the large block size itself should be enough to protect old
kernels/utils touching it, shouldn't it?

> E2fsprogs
> - Ted has added new branches the the e2fsprogs git tree
>    - master: current stable version
>    - next: patches expected to go into the next stable version
>    - pu: proposed update; patches that are in preliminary review and 
> 	test phase
> - E2fsprogs patches should probably be submitted against the 'next' 
> branch of the git tree.
  BTW: We still don't have appropriate patches for large block size in
e2fsprogs. I guess I should ping Ted about merging the patch once more.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
