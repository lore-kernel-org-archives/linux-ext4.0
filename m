From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/22] ext4 crypto: partial update to namei.c for fname
 crypto
Date: Sun, 12 Apr 2015 01:06:36 -0400
Message-ID: <20150412050636.GJ6540@thunk.org>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
 <1428012659-12709-18-git-send-email-tytso@mit.edu>
 <799E1747-6588-4AA2-9A2C-97FEB11CDA5A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34807 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbbDLFGn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 01:06:43 -0400
Content-Disposition: inline
In-Reply-To: <799E1747-6588-4AA2-9A2C-97FEB11CDA5A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2015 at 11:44:05AM -0600, Andreas Dilger wrote:
> > +				if (ctx == NULL) {
> > +					/* Directory is not encrypted */
> > +					while (len--)
> > +						printk("%c", *name++);
> 
> This is a bit strange, why not use "printk("%*.s", len, name)"?

This was copied from grotty debug code that no one has really cleaned
up in a long time.  That's a good idea, thanks.

      	     	    	     	  - Ted
