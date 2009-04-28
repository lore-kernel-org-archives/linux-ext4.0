From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 undeletion question
Date: Tue, 28 Apr 2009 12:11:06 -0400
Message-ID: <20090428161106.GB24043@mit.edu>
References: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, mike-mobile@trausch.us
To: "Michael B. Trausch" <mbt@zest.trausch.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59443 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbZD1QLM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 12:11:12 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 28, 2009 at 10:42:39AM -0400, Michael B. Trausch wrote:
> (First things first, please keep my cell phone -- mike-mobile@trausch.us  
> -- on the cc list, as I cannot easily read mail on my system since it is, 
> more or less, crippled at the moment.)
>
> Alright, so I have found myself in a troublesome situation.  I had a  
> directory which I accidentally deleted (instead of an identically-named  
> directory in *another* directory) and I need to get it back; it was a  
> version control repository directory and contains ~150 revisions of a  
> project I have been working on this week.  (Ironically, I was preparing 
> to back it up today, heh.)
>
> Anyway, is there _any_ means by which to recover files from an ext4  
> filesystem?  The utils for ext2 filesystems don't work (not surprising),  
> and I am wondering if there is a way to look for deleted files, knowing  
> what their name was, and recover them if they are not yet overwritten.  I 
> have my home directory mounted read-only at this point so as to minimize  
> the chance of the latter, and discovered my mistake nearly immediately so 
> I hope that the data are still intact.

There is the program "ext3grep" which will look for older versions of
the directory and inode table blocks in the journal.  This can work,
but unfortunately I don't think it's been extended to understand about
the ext4 extent data structure.

						- Ted
