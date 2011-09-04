From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/2] jbd2: remove an unneeded NULL check
Date: Sun, 4 Sep 2011 10:15:02 -0400
Message-ID: <20110904141502.GF3461@thunk.org>
References: <20110826091931.GM5975@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:JOURNALLING LAYER..." <linux-ext4@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41001 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab1IDOPD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Sep 2011 10:15:03 -0400
Content-Disposition: inline
In-Reply-To: <20110826091931.GM5975@shale.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 12:19:31PM +0300, Dan Carpenter wrote:
> We dereference "transaction" at the start of the function so the NULL
> check isn't needed here.  It's not harmful, but it silences a static
> checker warning when we remove this.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks for pointing this out; I've merged in the fix.

       	   	    	      	   	  - Ted
