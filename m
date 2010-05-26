From: tytso@mit.edu
Subject: Re: [PATCH] ext4: restart ext4_ext_remove_space() after
 transaction restart V2
Date: Wed, 26 May 2010 10:45:45 -0400
Message-ID: <20100526144545.GD29528@thunk.org>
References: <1271910671-16627-1-git-send-email-dmonakhov@openvz.org>
 <20100525133241.GF5556@thunk.org>
 <87632ckqcy.fsf@openvz.org>
 <20100525214447.GA14530@thunk.org>
 <87hblvqb6c.fsf@openvz.org>
 <87pr0ilw3n.fsf_-_@openvz.org>
 <20100526132352.GA29528@thunk.org>
 <87k4qqlp1g.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
	aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46364 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0EZOps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 May 2010 10:45:48 -0400
Content-Disposition: inline
In-Reply-To: <87k4qqlp1g.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 26, 2010 at 06:23:55PM +0400, Dmitry Monakhov wrote:
> 
> Later if we face a needs to restart transaction which result in
> i_data_sem indernal drop/acquire.
> And when the sem was dropped new block may be allocated by a
> flusher task (delay allocation writeback in the middle of the file)
> 
> *Flusher* will discover than STATE_EXT_TRUNC is set and clear it
> is allocation is really necessary(EXT4_GET_BLOCKS_CREATE is set)
> By clearing STATE_EXT_TRUNC bit flusher let truncate task to know
> what it have to restart it's job. 

OK, but why not have the truncate *always* restart its job after
restarting the transaction?  #1, it's relatively rare in most
workloads that we need to restart the transaction at all in the first
place, and #2, it's easier to test if we always restart the truncate,
and #3, it's not like we'll be doing that much extra work if we
restart the truncate and the file wasn't extended significantly...

	    	     	     	  - Ted
