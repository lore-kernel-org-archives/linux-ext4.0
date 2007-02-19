From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: loopback mount EXT3 oops
Date: Mon, 19 Feb 2007 12:57:01 +1100
Message-ID: <1171850221.7918.58.camel@localhost.localdomain>
References: <1171842762.7918.47.camel@localhost.localdomain>
	 <20070218163100.a4b95b3a.akpm@linux-foundation.org>
	 <45D90007.5060006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXBSB5z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Feb 2007 20:57:55 -0500
In-Reply-To: <45D90007.5060006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2007-02-18 at 19:40 -0600, Eric Sandeen wrote:
> Andrew Morton wrote:
> > I thought Eric fixed that.  Maybe he broke it instead ;)
> 
> Eeek... I'll reserve judgment on who broke what until I see that 
> corrupted image... ;)  is it available?  How huge?

2G, but bzip'ed e2image -r is 54M:

http://ozlabs.org/~rusty/ubuntu-oopses-e2image-r.bz2 

Cheers!
Rusty.
