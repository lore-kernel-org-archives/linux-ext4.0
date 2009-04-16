From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] ext3 data=guarded v3
Date: Thu, 16 Apr 2009 11:37:32 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904161129460.4042@localhost.localdomain>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>  <1239881953.20254.17.camel@marge.simson.net>  <1239893771.4346.0.camel@think.oraclecorp.com> <1239901977.4346.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mike Galbraith <efault@gmx.de>, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757505AbZDPSlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Apr 2009 14:41:19 -0400
In-Reply-To: <1239901977.4346.3.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 16 Apr 2009, Chris Mason wrote:
> 
> Ah ok, it is just a missed i_size update.  Basically because file_write
> doesn't wait for page writeback to finish, someone can be updating
> i_size at the same time the end_io handler for the last page is running.
> 
> Git triggers this when it does the sha1flush just before closing the
> file.

Can you say exactly what the IO pattern is?

One of the original git design issues was to actually never _ever_ do 
anything even half-way strange in the filesystem patterns, exactly because 
I've seen so many filesystem bugs over the years.

Now, it turns ou that "original design intent" and "actual code" then 
don't always match, and git did some things that are unusual and triggered 
bugs.

Example: in order to be extra safe, git does "fchown()" after doing all 
the writes to file descriptor just before closing it. I wanted git to make 
it hard to corrupt things by mistake, and marking all the files that only 
get written once (which is most of them) read-only as soon as possible 
seemed to be a great safety feature.

Except, in the process it triggers a network filesystem bug where earlier 
writes were still writeback cached data hadn't made it to the server yet, 
and then the client would do the whole "mark it read-only" before the 
writes had even been done. Oops.

We had a few other issues with just renaming files around (basic rule: 
only rename files _within_ one directory if you want to avoid filesystem 
bugs) and with using "pread/pwrite" (basic rule: pread/pwrite is unusual, 
and is apparently buggy on some operating systems. So avoid them).

Anyway, what was the exact pattern that caused this to show, and maybe I 
can find yet another place where git could just be even more anally safe 
by not doing anything half-way odd?

			Linus
