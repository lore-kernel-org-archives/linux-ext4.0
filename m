From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from
 void * to journal_t * explicitly in kjournald/kjournald2
Date: Wed, 3 Aug 2011 07:38:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108030737020.4521@swampdragon.chaosbits.net>
References: <4E38AB50.9040804@gmail.com> <4E38AC92.4090501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22536 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1HCFip (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 01:38:45 -0400
In-Reply-To: <4E38AC92.4090501@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 3 Aug 2011, Li Zefan wrote:

> 09:58, Wang Sheng-Hui wrote:
> > The patch is against 3.0
> > 
> > The arg of kjournald/kjournald2 is void *, and points to type
> > journal_t. We should convert it to journal_t * explicitly in
> > the kjournald/kjournald2 function body.
> > 
> 
> Why?
> 
> Implicit convertion from void * to foo * is ok. Did the compiler
> complain about this to you?
> 

Not only is it perfectly OK to rely on the implicit conversion, a lot of 
work has gone into actively removing such unneeded explicit casts over the 
years, so let's not introduce new ones.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

