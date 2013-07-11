From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 3/3] ext4: cache all of an extent tree's leaf block
 upon reading
Date: Thu, 11 Jul 2013 15:33:56 -0400
Message-ID: <20130711193356.GB11689@thunk.org>
References: <1373517542-21234-1-git-send-email-tytso@mit.edu>
 <1373517542-21234-3-git-send-email-tytso@mit.edu>
 <20130711185423.GA25414@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36967 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476Ab3GKTeD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Jul 2013 15:34:03 -0400
Content-Disposition: inline
In-Reply-To: <20130711185423.GA25414@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 11, 2013 at 11:54:23AM -0700, Zach Brown wrote:
> 
> Isn't prev going to be reinitialized to 0 for every extent?

Whoops, nice catch.  I'll fix this in my next spin of the patches.

	     	     	      	   - Ted
