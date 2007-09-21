From: Theodore Tso <tytso@mit.edu>
Subject: Re: Patch format in ext4 patch queue.
Date: Fri, 21 Sep 2007 07:46:36 -0400
Message-ID: <20070921114636.GN30221@thunk.org>
References: <46F39DF6.30402@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34688 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbXIULql (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2007 07:46:41 -0400
Content-Disposition: inline
In-Reply-To: <46F39DF6.30402@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 21, 2007 at 04:03:26PM +0530, Aneesh Kumar K.V wrote:
> 
> I was looking at the patch queue and see patches with different formats. 
> If we can standardize on what rest of the linux kernel follows it would
> be nice.
> 
> First line should be
> <subsystem_name>: A single line description of the patch.
> This appear in the subject line of the mail that results from different
> commit list....

Yes, please!!!  Otherwise I end up having to fix up the patch tree
before I can suck it into git.

						- Ted
