From: Theodore Tso <tytso@mit.edu>
Subject: Re: Convert between journal features and strings
Date: Fri, 14 Mar 2008 16:41:28 -0400
Message-ID: <20080314204128.GD13733@mit.edu>
References: <1205519369.3465.23.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51159 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753012AbYCNUlj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2008 16:41:39 -0400
Content-Disposition: inline
In-Reply-To: <1205519369.3465.23.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 14, 2008 at 11:59:29PM +0530, Girish Shilamkar wrote:
> Hi Ted,
> 	e2p_string2feature() and e2p_feature2string() can operate on ext2/3/4
> features list as there is only one struct feature feature_list[] and no
> corresponding journal features list. 
> After introducing journal_checksum and journal_async_commit features, we
> needed to display the features using debugfs which does it through the
> two e2p_* functions. A new struct feature jrnl_feature_list[] was added.
> The e2p_* functions were passed an additional argument so it can decide
> which feature list to use.
> Change in the APIs of e2p_* functions might not be acceptable so we have
> an option to either make e2p_feature2string2() function or add
> a new e2p_jnl_feature2string()
> 
> Would like to know what will be preferred e2p_feature2string2() or
> e2p_jnl_feature2string() ?

Two new functions are definitely preferable to changing the ABI's of
two existing functions.

Regards,

					- Ted
