From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: disable defrag for metadata_csum file systems
Date: Fri, 19 Apr 2013 02:19:09 -0400
Message-ID: <20130419061909.GB10053@thunk.org>
References: <1366322282-4673-1-git-send-email-tytso@mit.edu>
 <51707E06.2050105@gmail.com>
 <20130419054738.GA5617@blackbox.djwong.org>
 <20130419061727.GA10053@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42794 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab3DSGTM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 02:19:12 -0400
Content-Disposition: inline
In-Reply-To: <20130419061727.GA10053@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 19, 2013 at 02:17:27AM -0400, Theodore Ts'o wrote:
> On Thu, Apr 18, 2013 at 10:47:38PM -0700, Darrick J. Wong wrote:
> > 
> > I think this happens because mext_insert_extents() open-codes the metadata
> > dirtying and forgets to update the extent block header.  It should call
> > ext4_ext_dirty() at the end, instead. :(
> 
> Yes.  The following patch seems to fix the problem.

Ah, I see you posted a similar patch.  I'll take yours, since it's cleaner.

      	      	       	       	       	    - Ted
