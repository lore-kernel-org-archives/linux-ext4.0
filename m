From: Theodore Tso <tytso@mit.edu>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 21:51:13 -0400
Message-ID: <20080814015113.GA8078@mit.edu>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu> <200808132307.07437.mail@eworm.de> <20080813220100.GE6142@mit.edu> <1218672653.6456.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Hesse <mail@eworm.de>, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55038 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbYHNBvU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 21:51:20 -0400
Content-Disposition: inline
In-Reply-To: <1218672653.6456.14.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 13, 2008 at 05:10:53PM -0700, Mingming Cao wrote:
> I could reproduce it.  
> 
> This patch works for me on top of Ted's change.  Christian, could you
> try it?

Thanks, mingming!  Looks good and I've added it to the patch queue.

							- Ted
