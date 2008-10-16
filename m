From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4 missing newlines
Date: Thu, 16 Oct 2008 10:48:53 -0400
Message-ID: <20081016144853.GB10825@mit.edu>
References: <20081016072614.GA23730@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38616 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753616AbYJPOs5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 10:48:57 -0400
Content-Disposition: inline
In-Reply-To: <20081016072614.GA23730@alice>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 09:26:14AM +0200, Eric Sesterhenn wrote:
> 
> there are some newlines missing in ext4_check_descriptors, which
> cause the printk level to be printed out when the next printk call
> is made:

Thanks for the patch; I've added it to the ext4 patch queue.

       	       	      	   	       	   - Ted
