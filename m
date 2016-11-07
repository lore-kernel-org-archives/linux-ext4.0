From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Mon, 7 Nov 2016 00:42:42 -0500
Message-ID: <20161107054242.m6q4rufasjpysnvp@thunk.org>
References: <20161103172842.q7avc7rztny3zndd@thunk.org>
 <E33408BD-68CC-49E4-9B32-EC06DB057509@dilger.ca>
 <20161104215105.waabpcf7zganrdbr@thunk.org>
 <20161106235722.GG28177@dastard>
 <20161107001456.muvwkwlqxucrzpzi@thunk.org>
 <20161107043035.GH28177@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        guy@linux.com, jra@google.com, drosen@google.com, hch@infradead.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54444 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750731AbcKGFmt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 00:42:49 -0500
Content-Disposition: inline
In-Reply-To: <20161107043035.GH28177@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2016 at 03:30:35PM +1100, Dave Chinner wrote:
> 
> OK, as long people are ok with things going wonky when the
> filesystem is mounted without those mount options, I'm not really
> fussed...

There are apparently NAS boxes that export the same directory with
case insensitive Samba and case sensitive NFS exports at the same
time, which would have all of these problems, and people apparently
don't complain much.

I agree we need to warn people in the documentation that if the file
system is initially mounted w/o case folding, and they create files
such as Readme and README in the same directory, and then mount the
file system with case folding, which file they get will be a bit Wonky
--- specifically, "Readme" and "README" will get the file which is an
exact match, but it is undefined which file "ReAdMe" will return.

Personally, I don't plan to lose any sleep over the issue.  :-)

	      	    	    	     	   - Ted
