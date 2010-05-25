From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: Clear the EXT4_EOFBLOCKS_FL flag only when
 warranted
Date: Tue, 25 May 2010 09:15:44 -0400
Message-ID: <20100525131544.GE5556@thunk.org>
References: <20100525041737.GB5556@thunk.org>
 <1274761117-26560-2-git-send-email-tytso@mit.edu>
 <87zkzola0r.fsf@openvz.org>
 <20100525130331.GC5556@thunk.org>
 <87fx1gktvf.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36063 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0EYNPq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 May 2010 09:15:46 -0400
Content-Disposition: inline
In-Reply-To: <87fx1gktvf.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 05:12:36PM +0400, Dmitry Monakhov wrote:
> Yes but changes was requested, so i've prepared new version.
> I'll post it against Jan's xfsqa quota branch.

Is there a reason you don't just base it against the xfstests mainline
and send the patch directly to xfs@oss.sgi.com?  Your patch isn't
related to quota or has any dependency on other changes that might be
in Jan's branch, right?  Or am I missing something?

   	 	    	 	 	       	 - Ted


