From: Stephan Kulow <coolo@suse.de>
Subject: Re: file allocation problem
Date: Fri, 17 Jul 2009 07:17:12 +0200
Message-ID: <200907170717.12225.coolo@suse.de>
References: <200907161331.17623.coolo@suse.de> <200907161943.21575.coolo@suse.de> <20090717011219.GE8508@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:33139 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757791AbZGQFRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 01:17:16 -0400
In-Reply-To: <20090717011219.GE8508@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 17 July 2009 03:12:19 you wrote:
> On Thu, Jul 16, 2009 at 07:43:21PM +0200, Stephan Kulow wrote:
> > > If it is the case that this was originally an ext3 filesystem,
> > > e4defrag does have some definite limitations that will prevent it from
> > > doing a great job in such a case.  I'm guessing that's what's going on
> > > here.
> >
> > My problem is not so much with what e4defrag does, but the fact that
> > a new file I create with cp(1) contains 34 extents.
>
Hi,
>
> The reason why "cp" still created a file with 34 extents is because
> the free space was still fragmented.  As I said, e4defrag is quite
> primitive; it doesn't know how to defrag free space; it simply tries
> to reduce the number of extents for each file, on a file-by-file
> basis.
Well, is there a tool to check the overall state of the file system? I can't 
really believe it's 1010101010, but it's hard to say without a picture :)
>
> The other problem is that an ext3 filesystem that has been converted
> to ext4 does not have the flex_bg feature.  This is a feature that,
> when set at when the file system is formatted, creates a higher order
> flex_bg which combines several block groups into a bigger allocation
> group, a flex_bg.  This helps avoid fragmentation, especially for
> directories like /usr/bin which typically have more than 128 megs (a
> single block group) worth of files in it.

Oh, I enabled flex_bg after you asked, rebooted to get a e2fsck - and I still 
get 34 extents for my gimp-2.6.defrag. From what I understand, this doesn't 
help in the after fact, but then again how am I supposed to fix my file system
if even new files are created fragmented.

> In any case, I don't anything went _wrong_ per se, just that both
> e4defrag and our block allocator are insufficiently smart to help
> improve things for you given your current filesystem.  A backup,
> reformat, and restore will result in a filesystem that works far
> better.
I believe that, but my hope for online defrag was not having to rely on this 
80ties defrag method :)
>
> Out of curiosity, what sort of workload had the file system received?
> It looks like the filesystem hadn't been created that long ago, so
> it's bit surprising it was so fragmented.  Were you perhaps updating
> your system (by doing a yum update or apt-get update) very frequently,
> perhaps?
Yes, that's what I'm doing. I'm updating about every file in this file system 
every second day by means of rpm packages (openSUSE calls it factory, you will
now it as rawhide).

Greetings, Stephan
