From: "Tejas Sumant" <tejas.sumant@gmail.com>
Subject: Re: Couple of queries related to htree directory
Date: Fri, 15 Jun 2007 16:30:02 +0530
Message-ID: <ffa0f8300706150400u39c31a13l2805f4d8217eb4cf@mail.gmail.com>
References: <ffa0f8300706140622j104ad6d7ra3abb2c8779dece@mail.gmail.com>
	 <20070614184630.GB14911@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:31390 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbXFOLAC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2007 07:00:02 -0400
Received: by an-out-0708.google.com with SMTP id d31so184044and
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2007 04:00:02 -0700 (PDT)
In-Reply-To: <20070614184630.GB14911@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Theodore,

My file system has dir_index feature.
When I created new directory larger than blocksize and run htree
command of debugfs on it, I received message that the directory is not
in htree format.

Any idea why this happened?

Thanks

On 6/15/07, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Jun 14, 2007 at 06:52:01PM +0530, Tejas Sumant wrote:
> >
> > Any idea, how to search a directory on given ext3 file system, which
> > is having htree structure?
>
> The same way you search any other Linux/Unix system.  I.e., using
> opendir()/readir() from a C program, or /bin/ls from a shell program,
> etc.  It's completely transparent.
>
> > Also is there any way to create a htree indexed directory explicitly?
> > using some command or tool?
>
> Once the dir_index feature is enabled, for all new directories and all
> directories which are only take one disk block grow to bigger than one
> disk block, they automatically get indexed.  (There's no point
> indexing a single directory block since that's equivalent to a single
> leaf block.)
>
> To convert existing directories, you need to unmount the filesystem
> and use the command:
>
>        e2fsck -fD /dev/hdXX
>
> This really should be added to an FAQ on ext4.wiki.kernel.org....
>
>                                         - Ted
>


-- 
Tejas Sumant
