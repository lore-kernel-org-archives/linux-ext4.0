From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [02/23] ext4: enforce bigalloc restrictions (e.g., no online
 resizing, etc.)
Date: Wed, 28 Sep 2011 08:55:45 -0400
Message-ID: <20110928125545.GB13578@thunk.org>
References: <1309970166-11770-2-git-send-email-tytso@mit.edu>
 <1309970166-11770-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devel@dbtest.test.cnz.alimama.com,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <sanbai@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38868 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101Ab1I1Mzv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Sep 2011 08:55:51 -0400
Content-Disposition: inline
In-Reply-To: <1309970166-11770-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 20, 2011 at 10:20:01AM +0800, Robin Dong wrote:
> From: Theodore Ts'o <tytso@mit.edu>
> 
> At least initially if the bigalloc feature is enabled, we will not
> support non-extent mapped inodes, online resizing, online defrag, or
> the FITRIM ioctl.  This simplifies the initial implementation.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Robin Dong <sanbai@taobao.com>
> Acked-by:

Hi Robin,

What was your purpose in resending these patches?  Did you modify them
in any way?   I can diff them all, but it's a pain...

       	      	    	      	       	    - Ted
