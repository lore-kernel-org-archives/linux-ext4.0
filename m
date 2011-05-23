From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3] Make block_page_mkwrite() handle frozen fs (V2)
Date: Mon, 23 May 2011 10:47:50 -0400
Message-ID: <20110523144750.GJ10009@thunk.org>
References: <1305731882-8334-1-git-send-email-jack@suse.cz>
 <20110518180022.GM18929@tux1.beaverton.ibm.com>
 <20110519105708.GD8417@quack.suse.cz>
 <20110520175953.GE29282@thunk.org>
 <20110523132158.GB4716@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48439 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab1EWOsC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 10:48:02 -0400
Content-Disposition: inline
In-Reply-To: <20110523132158.GB4716@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 23, 2011 at 03:21:58PM +0200, Jan Kara wrote:
> > Does your 3/3 ext4 patch have dependencies on your 1/3 and 2/3
> > VFS-layer patches?
>   Yes, it does depend on the new helper introduced in 1/3. Should I push
> 3/3 via Al as well or just wait with it until Al merges the first two
> patches and then push it to you?

Hmm...  I guess it depends on how quickly Al is going to be pushing
VFS changes to Linus (I assume you're hoping this is going to get
pushed during this merge window, yes?).  I still have at least a day
or two worth of final merging and testing to do, and your 3/3 ext4
patch has a dependency on Darrick's T10 DIF/DIX patch as I recall.

      	    	       	  	    	- Ted
