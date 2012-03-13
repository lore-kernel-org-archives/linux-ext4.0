From: Phillip Susi <phillsusi@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Tue, 13 Mar 2012 16:22:52 -0400
Message-ID: <4F5FAC9C.9070607@gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org> <4F5F9A97.5060404@ubuntu.com> <20120313195339.GA24124@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@whamcloud.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33356 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2CMUWz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2012 16:22:55 -0400
In-Reply-To: <20120313195339.GA24124@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/13/2012 3:53 PM, Ted Ts'o wrote:
> Because that would be a format change.

I think a format change would be preferable to runtime sorting.

> What we have today is not a hash table; it's a hashed tree, where we
> use a fixed-length key for the tree based on the hash of the file
> name.  Currently the leaf nodes of the tree are the directory blocks
> themselves; that is, the lowest level of the index blocks tells you to
> look at directory block N, where that directory contains the directory
> indexes for those file names which are in a particular range (say,
> between 0x2325777A and 0x2325801).

So the index nodes contain the hash ranges for the leaf block, but the 
leaf block only contains the regular directory entries, not a hash for 
each name?  That would mean that adding or removing names would require 
moving around the regular directory entries wouldn't it?

> If we aren't going to change the ordering of the directory directory,
> that means we would need to change things so the leaf nodes contain
> the actual directory file names themselves, so that we know whether or
> not we've hit the correct entry or not before we go to read in a
> specific directory block (otherwise, you'd have problems dealing with
> hash collisions).  But in that case, instead of storing the pointer to
> the directory entry, since the bulk of the size of a directory entry
> is the filename itself, you might as well store the inode number in
> the tree itself, and be done with it.

I would think that hash collisions are rare enough that reading a 
directory block you end up not needing once in a blue moon would be 
chalked up under "who cares".  So just stick with hash, offset pairs to 
map the hash to the normal directory entry.

