From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Print extent information in debugfs
Date: Mon, 27 Jul 2009 10:34:13 -0400
Message-ID: <20090727143413.GF17272@mit.edu>
References: <6601abe90907231336o64cdc786r634d29be822316af@mail.gmail.com> <20090727030219.GE17272@mit.edu> <4A6D1C6A.1000900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57807 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZG0OeX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jul 2009 10:34:23 -0400
Content-Disposition: inline
In-Reply-To: <4A6D1C6A.1000900@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 26, 2009 at 10:18:02PM -0500, Eric Sandeen wrote:
> 
> Perhaps a bit late, but I find the "#<extent length>" reporting very
> unintuitive.  Doesn't "#X" usually imply ordering?  How about:
> 
> (0-60 [61b]): 342272-342332, (61-127 [67b,uninit]): 537822-537888
> 
> ... or maybe some other ideas.  IMHO it's all a bit hard to read anyway
> unless it's printed in a table format ala the new filefrag output.

That's a good idea.  I've switched it to use a table format:

Level Entries       Logical          Physical Length Flags
 0/ 0   1/  2     0 -    60  342272 -  342332     61 
 0/ 0   2/  2    61 -   127  537822 -  537888     67 Uninit

and

Level Entries           Logical          Physical Length Flags
 0/ 2   1/  4       1 -  274323   24844           274323
 1/ 2   1/ 84       1 -     387    8458              387
 2/ 2   1/ 84       1 -       1   10242 -   10242      1 
 2/ 2   2/ 84       4 -       4   10245 -   10245      1 
 2/ 2   3/ 84       8 -       8   10249 -   10249      1 

I've also simplified the debugfs stat output so it looks more like the
"BLOCKS" output:

 mtime: 0x4a6d164e:861ee098 -- Sun Jul 26 22:51:58 2009
crtime: 0x4a6d164e:82c08b38 -- Sun Jul 26 22:51:58 2009
Size of extra inode fields: 28
EXTENTS:
(0-60): 342272-342332, (61-127 [uninit]): 537822-537888

Hopefully that's easier for everyone to understand.

							- Ted
