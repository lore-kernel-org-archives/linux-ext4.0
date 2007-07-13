From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 7][PATCH 1/1]Remove 32000 subdirs limit.
Date: Fri, 13 Jul 2007 09:53:43 -0700
Message-ID: <20070713095343.d2e76775.akpm@linux-foundation.org>
References: <1183275498.4010.135.camel@localhost.localdomain>
	<20070710224011.e60b9864.akpm@linux-foundation.org>
	<1184322648.4315.2.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33086 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750956AbXGMQxx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jul 2007 12:53:53 -0400
In-Reply-To: <1184322648.4315.2.camel@garfield.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 13 Jul 2007 16:00:48 +0530 Kalpak Shah <kalpak@clusterfs.com> wrote:

> > >  
> > > -	if (inode->i_nlink >= EXT4_LINK_MAX)
> > > +	if (EXT4_DIR_LINK_MAX(inode))
> > >  		return -EMLINK;
> > 
> > argh.  WHY_IS_EXT4_FULL_OF_UPPER_CASE_MACROS_WHICH_COULD_BE_IMPLEMENTED
> > as_lower_case_inlines?  Sigh.  It's all the old-timers, I guess.
> > 
> > EXT4_DIR_LINK_MAX() is buggy: it evaluates its arg twice.
> 
> #define EXT4_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT4_LINK_MAX)
> 
> This just checks if directory has hash indexing in which case we need not worry about EXT4_LINK_MAX subdir limit. If directory is not hash indexed then we will need to enforce a max subdir limit. 
> 
> Sorry, I didn't understand what is the problem with this macro?

Macros should never evaluate their argument more than once, because if they
do they will misbehave when someone passes them an
expression-with-side-effects:

	struct inode *p = q;

	EXT4_DIR_LINK_MAX(p++);

one expects `p' to have the value q+1 here.  But it might be q+2.

and

	EXT4_DIR_LINK_MAX(some_function());

might cause some_function() to be called twice.


This is one of the many problems which gets fixed when we write code in C
rather than in cpp.
