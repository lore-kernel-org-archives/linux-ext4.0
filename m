From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Reserve FEATURE_RO_COMPAT and INO flag
Date: Fri, 3 May 2013 02:53:04 -0400
Message-ID: <20130503065304.GB32297@thunk.org>
References: <1366900760-18899-1-git-send-email-lczerner@redhat.com>
 <2B5199BA-39D5-4118-B4FC-96C8B800507B@dilger.ca>
 <alpine.LFD.2.00.1304291454240.20016@localhost>
 <3CAF5E28-8718-4078-ACB9-607CA8DC5BA5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46077 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933378Ab3ECGxI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 May 2013 02:53:08 -0400
Content-Disposition: inline
In-Reply-To: <3CAF5E28-8718-4078-ACB9-607CA8DC5BA5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 29, 2013 at 12:35:18PM -0600, Andreas Dilger wrote:
> 
> One real problem that I see is that EXT4_REPLICA_INO uses the
> last reserved inode.  I recall in the past that Ted wanted to
> make this last reserved inode a hidden directory, so that it
> would be possible to put special inodes in there and access them
> by name.  Not quite as easy as accessing a reserved inode by
> number, but still preferable to not being able to have filesystem
> internal inodes at all in the future.

That wasn't my idea, but it's not a bad one.  I'm not too worried
about running out of file system internal inodes, though.  There are
two main benefits of having special inode numbers.  First, it's a low
numbered inode, so it's easy to recognize.  Second, it's easier to add
a new file system feature to an existing file system.  But either way,
it's not impossible.

First of all, "the first non-reserved inode" is actually a superblock
field, so we could actually change that for newer file systems, and
hence effectively create new reserved inodes.  Secondly, it's simple
enough just to use a superblock field to designate a particular inode
as being special.  This is how we originally dealt with the journal
inode, after all.

Cheers,

						- Ted
