From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: e2dis: a Jigdo-like tool for Ext2+ FS
Date: Mon, 15 Aug 2011 18:12:54 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1108151759040.3695@dhcp-27-109.brq.redhat.com>
References: <86ei0p8ve2.fsf@gray.siamics.net> <alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com> <86zkjb3p7f.fsf@gray.siamics.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1319028455-1313424776=:3695"
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1HOQM5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Aug 2011 12:12:57 -0400
In-Reply-To: <86zkjb3p7f.fsf@gray.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1319028455-1313424776=:3695
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 15 Aug 2011, Ivan Shmakov wrote:

> >>>>> Lukas Czerner <lczerner@redhat.com> writes:
> >>>>> On Sat, 13 Aug 2011, Ivan Shmakov wrote:
> 
>  >> A couple of weeks ago I've started working on a tool (tentantively
>  >> named “Ext2 disassembler”) to walk through an Ext2+ filesystem (or
>  >> an image of) and produce the mapping of files' (inodes') relative
>  >> block numbers to the image's (or “physical”) block numbers.
> 
>  > I have not seen your code, but that sounds like something that
>  > debugfs (part of e2fsprogs) is already doing very well (and a lot
>  > more).  This is exactly the "extN disassembler" you're talking about
> 
> 	Not quite.  The meaning of “disassembler” here is that the image
> 	is torn in parts, which could later be assembled together to
> 	form exactly the same image (by an “image assembler” tool.)

Ok then, I have misunderstood your intentions. I thought that you need
to get logical to physical mappings of inodes.

> 
> 	It's not implied that e2dis will ever produce some sort of
> 	human-readable output (as its primary result.)  For that,
> 	debugfs(8) should indeed suffice.

Ok, I was just implying that you can use debugfs as a tool to figure out
what to read e.g. what physical blocks belongs to what inode. If you
have already tried debugfs and it did not suit you needs I am ok with
that.

> 
>  > and with a little bit of scripting around it you should be able dig
>  > any information you desire from the file system so I do not think
>  > that new application is needed.  But I might be wrong, just take a
>  > look at it.
> 
> 	Indeed, my first try was to use debugfs(8).  However, there're
> 	several issues with it:
> 
> 	• I see no way to obtain the list of used inodes in debugfs(8)
> 	  (as of 1.41.12 debian 2); therefore, I have had to resort to
> 	  trying the ‘stat’ command on every possible inode number;

I am not sure if there is a way to list used inodes in debugfs but it
should be very easy to implement.

> 
> 	• also, the (binary) filesystem data is serialized into ASCII by
> 	  debugfs(8) and is parsed afterwards by the invoking tool,
> 	  which is computationally-inefficient; (especially if applied
> 	  to a filesystem with size in the order of several GiB's, and
> 	  the number of used inodes in the order of tens of thousands,
> 	  or more);

Oh, I was not trying to say that you should use debugfs to dig data out,
but rather to get hint of where data lies in the image.

> 
> 	• moreover, I see no claims that the output of the debugfs(8)
> 	  ‘stat’ command won't ever change (neither I see the formal
> 	  description of the aforementioned output — its source is the
> 	  only form of specification I could rely); my guess is that the
> 	  C API, being documented, is going to be much more stable;

Well, you can probably say that about every tool, but that is not good
enough reason to duplicate the code for everything. Although I am not
saying that you're doing so.

Thanks!
-Lukas

> 
> 	That being said, the most of the code I've written so far is
> 	concerned /not/ with the filesystems per se (i. e., libext2fs
> 	calls), but with data recording: representing the data in a
> 	compact way, interfacing SQLite, etc.  (The SHA-1 computation
> 	and GNU-style CLI will require some coding as well, thus making
> 	the Ext2+ FS-specific parts even smaller when compared to the
> 	overall code size.)

--8323328-1319028455-1313424776=:3695--
