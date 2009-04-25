From: Theodore Tso <tytso@mit.edu>
Subject: Re: Use of kmalloc vs vmalloc in ext4?
Date: Fri, 24 Apr 2009 23:39:55 -0400
Message-ID: <20090425033955.GF13608@mit.edu>
References: <6601abe90903110732n5c9df9b9td317be316921b7a6@mail.gmail.com> <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com> <20090425030703.GD13608@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36134 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZDYDkD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 23:40:03 -0400
Content-Disposition: inline
In-Reply-To: <20090425030703.GD13608@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

P.S.   What sort of flex_bg size are you using?

          EXT4-fs: not enough memory for 8198 flex groups
          EXT4-fs: unable to initialize flex_bg meta info!

Modern e2fsprogs default to using 16 block groups per flex_bg, which
means 8198 flex groups is a little over 16 TB --- which the mainline
e2fsprogs doesn't support yet.  You wouldn't be using a smaller
flex_bg size for some reason, are you?

If so, can you say something about why?  I've been actually thinking
that we might want to bump up the flex_bg size slight more, but it
appears you're using something smaller; was this deliberate.

	       	     	       		    - Ted
