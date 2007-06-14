From: Theodore Tso <tytso@mit.edu>
Subject: Re: Couple of queries related to htree directory
Date: Thu, 14 Jun 2007 14:46:31 -0400
Message-ID: <20070614184630.GB14911@thunk.org>
References: <ffa0f8300706140622j104ad6d7ra3abb2c8779dece@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tejas Sumant <tejas.sumant@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47333 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbXFNSqz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2007 14:46:55 -0400
Content-Disposition: inline
In-Reply-To: <ffa0f8300706140622j104ad6d7ra3abb2c8779dece@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 14, 2007 at 06:52:01PM +0530, Tejas Sumant wrote:
> 
> Any idea, how to search a directory on given ext3 file system, which
> is having htree structure?

The same way you search any other Linux/Unix system.  I.e., using
opendir()/readir() from a C program, or /bin/ls from a shell program,
etc.  It's completely transparent. 

> Also is there any way to create a htree indexed directory explicitly?
> using some command or tool?

Once the dir_index feature is enabled, for all new directories and all
directories which are only take one disk block grow to bigger than one
disk block, they automatically get indexed.  (There's no point
indexing a single directory block since that's equivalent to a single
leaf block.)

To convert existing directories, you need to unmount the filesystem
and use the command:

	e2fsck -fD /dev/hdXX

This really should be added to an FAQ on ext4.wiki.kernel.org....

					 - Ted
