From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 Patch Queue using stgit.
Date: Fri, 18 May 2007 12:06:26 -0400
Message-ID: <20070518160626.GA19911@thunk.org>
References: <464D9F2F.3030904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36546 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762652AbXERQGs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2007 12:06:48 -0400
Content-Disposition: inline
In-Reply-To: <464D9F2F.3030904@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 18, 2007 at 06:12:23PM +0530, Aneesh Kumar K.V wrote:
> Hi All,
> 
> I was looking at ext4 patch queue and was wondering why we are  putting 
> .patch under git. If we are looking for a quilt like functionality, one 
> can achieve the same using stgit. I was using stgit to maintain a set of
> patches before. 

The problem with stgit is that you lose the history of the patches.
This is why the stable kernel queue is also kept as a git repository
of patches.

Regards,

						- Ted
