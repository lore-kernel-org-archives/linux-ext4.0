From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4_ext_insert_index error
Date: Thu, 20 Oct 2011 10:07:27 +0800
Message-ID: <20111020020727.GA11540@localhost>
References: <20111020012353.GA8653@localhost>
 <4E9F7F1E.8070809@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab1JTCHc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Oct 2011 22:07:32 -0400
Content-Disposition: inline
In-Reply-To: <4E9F7F1E.8070809@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 20, 2011 at 09:53:34AM +0800, Tao Ma wrote:
> Hi Fengguang,
> 	sorry for the trouble.

That's fine. 

> On 10/20/2011 09:23 AM, Wu Fengguang wrote:
> > Hi,
> > 
> > I got these errors when switch the kernel from 3.1-rc8 to linux-next.  Commit
> > 4fd30c0330ba951 looks most likely the culprit in the linux-next change set.
> This should be already fixed in Ted's tree. Please check whether the fix
> works.
> http://comments.gmane.org/gmane.comp.file-systems.ext4/28575

Glad to hear that, I'll try it.

Thanks,
Fengguang
