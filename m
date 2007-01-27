From: Theodore Tso <tytso@mit.edu>
Subject: Re: where is the ext4 git tree ?
Date: Sat, 27 Jan 2007 16:53:28 -0500
Message-ID: <20070127215327.GA6414@thunk.org>
References: <1169805918.32648.14.camel@colyT43.site> <45BA24CB.5060501@us.ibm.com> <20070126165119.GC14759@thunk.org> <1169904387.10553.4.camel@colyT43.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: coly <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59535 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbXA0Vxk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Jan 2007 16:53:40 -0500
Content-Disposition: inline
In-Reply-To: <1169904387.10553.4.camel@colyT43.site>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 27, 2007 at 09:26:27PM +0800, coly wrote:
> 
> It seems the patch file is based on stable kernel tree, not -mm tree.
> Isn't it ?

Yes, it's based on 2.6.20-rc5.  I'm not sure it really makes sense to
use the term "stable kernel tree" as it relates to 2.6, but no, it's
not based off of the -mm tree.  

					- Ted
