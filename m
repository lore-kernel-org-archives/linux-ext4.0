From: Kelly Kane <kelly@hq.newdream.net>
Subject: Re: Call traces on console from a test machine
Date: Fri, 14 Nov 2008 12:29:23 -0800
Message-ID: <491DDFA3.2060605@hq.newdream.net>
References: <491CC6E3.7070808@hq.newdream.net> <491CDF90.8070802@hq.newdream.net> <20081114170930.GI25117@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@sun.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.hq.newdream.net ([66.33.206.127]:33190 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNUaF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 15:30:05 -0500
In-Reply-To: <20081114170930.GI25117@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:

 >
 > You can run "tune2fs -O ^uninit_bg /dev/XXX" to disable the group
 > descriptor checksums (and, unfortunately, the fast fsck benefits),
 > but at least it will allow you to mount the filesystem.

Thank you, we'll keep that in mind in case there is a next time. (Knock 
on wood.)

Theodore Tso wrote:
> On Thu, Nov 13, 2008 at 06:16:48PM -0800, Kelly Kane wrote:
>> Same block group each run through, different inode.
> 
> That's very strange...  and it's also strange that it would be
> constantly changing.  What version of e2fsprogs are you using?

It eventually started picking the same file each time. After about 5 
runs through I thought I saw a trend. We are using e2fsprogs 1.41.3 
compiled from source.

>> I ran e2image and produced the following file:
>>
>> http://ext4dev.dreamhosters.com/watanabe-home-2008-11-13-1712.e2image.bz2
> 
> Unfortunately, I need a raw image dump in order to be able to debug
> this.  Can you create it using:
> 
> e2image -r /dev/sdXX -  | bzip2 > /tmp/sdXX.e2i.bz2
> 
> ... and send it to me?

Sure. Once we finish restoring the data off the old partition I can do 
this. If that file is of no use I will delete the source files. The 
filesystem has been more heavily modified since the above image was 
created, details below.

> What's the underlying hardware for this filesystem, and I hate to ask
> it, but are you sure it's not a hardware problem?
> 
> One thing you can do is to use e2image to create a sparse file on
> another filesystem:
> 
> e2image -r /dev/sdXX /u2/sdXX.e2i

We have of course not ruled anything out. We will put the hardware 
through its paces before wiping it. I'll give this a go later as well.

The server is an intel xeon server on a supermicro board with a 3ware 
9690SE-8LPML w/ BBU, using Seagate 1tb 7200.11 disks. (ST31000340AS) We 
have an identical test server setup called `ext4dev` for use in 
troubleshooting this stuff. Sandeen has direct access to this machine, 
more accounts can be provided by him or myself via private email. It has 
a copy of our kernel source tree, sudo access, etc.

I eventually got the filesystem mounted by answering "yes" to fix the 
block group checksum error, "no" to all of the Pass 2 inode errors, and 
"yes" to the pass 5 "fix bitmap inconsistency" (or something) error. It 
does not cleanly fsck, still, but I can read data off it.

Thanks again,
Kelly
