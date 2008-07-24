From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: improve ext4_fill_flex_info() a bit
Date: Thu, 24 Jul 2008 14:25:49 -0400
Message-ID: <20080724182548.GD27129@mit.edu>
References: <4887DB2C.1080403@cn.fujitsu.com> <20080724120938.59bd2220@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46001 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbYGXS1l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2008 14:27:41 -0400
Content-Disposition: inline
In-Reply-To: <20080724120938.59bd2220@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2008 at 12:09:38PM -0500, Jose R. Santos wrote:
> On Thu, 24 Jul 2008 09:30:20 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > - use kzalloc() instead of kmalloc() + memset()
> > - improve a printk info
> 
> Nicer - Thanks
> 
> Acked-by: Jose R. Santos <jrs@us.ibm.com>

I've already merged this into the patch queue earlier today.

						- Ted
