From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix panic on module unload when stopping
 lazyinit thread
Date: Thu, 3 Feb 2011 00:33:39 -0500
Message-ID: <20110203053339.GL4258@thunk.org>
References: <4D43402D.2000004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47257 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab1BCGNC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 01:13:02 -0500
Content-Disposition: inline
In-Reply-To: <4D43402D.2000004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 28, 2011 at 04:16:13PM -0600, Eric Sandeen wrote:
> This is for the latest reported module unload oops in
> kernel.org bugzilla #27652

Thanks, added to the ext4 patch queue.

		      	     	  	- Ted
