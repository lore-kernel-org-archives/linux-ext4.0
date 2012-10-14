From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: metadata_csum set but no space in dir leaf for checksum
Date: Sun, 14 Oct 2012 10:55:08 -0400
Message-ID: <20121014145508.GC6207@thunk.org>
References: <20121013050554.9442.qmail@science.horizon.com>
 <65D4536C-0F58-4A26-A562-B665EC6CBBB2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55443 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab2JNOzN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2012 10:55:13 -0400
Content-Disposition: inline
In-Reply-To: <65D4536C-0F58-4A26-A562-B665EC6CBBB2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 14, 2012 at 12:43:47AM -0600, Andreas Dilger wrote:
> 
> This means there was an existing directory block that was completely full and
> could not have the checksum added.  It isn't harmful, the chance of having
> silent corruption in this specific block is very small.

Was this a freshly created ext4 file system with the metadata_csum
checksum, or was this a previously existing ext4 file system where the
metadata_csum feature was added later?

I've pushed an update to the e2fsprogs repository which allows htree
and "ls -c" to actually show us the directory leaf block checksums.
Previously, they were hidden, which means that it's hard to tell
whether a directory had all of its directory blocks properly
checksummed or not.

> The message itself should be quieted though, since there isn't anything to be
> helped by printing it continuously.  I guess there is something missing in
> e2fsck that it doesn't add a checksum to this block, however.

Either that, or somehow there is a case where the directory tail
containing the checksum is getting overwritten, or a directory block
isn't getting a checksum after a htree node split.  The e2fsprogs
changes will hopefully make it easier for us to figure out what is
going on.

					- Ted
