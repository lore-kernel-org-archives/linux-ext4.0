From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Optimizing readdir()
Date: Tue, 15 Jan 2013 15:44:57 -0700
Message-ID: <B52E6F5A-F266-433C-AE80-2E78FD6920B9@dilger.ca>
References: <20130113152204.GB26803@laptop.redhat.com> <20130114045152.GF29329@thunk.org> <20130115072143.GA21506@laptop.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
To: Radek Pazdera <rpazdera@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59951 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934145Ab3AOW5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jan 2013 17:57:31 -0500
Received: by mail-pb0-f51.google.com with SMTP id ro12so329772pbb.24
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jan 2013 14:57:30 -0800 (PST)
In-Reply-To: <20130115072143.GA21506@laptop.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-15, at 12:21 AM, Radek Pazdera wrote:
> On Sun, Jan 13, 2013 at 11:51:52PM -0500, Theodore Ts'o wrote:
>> If we want to make the file system be backwards compatible, this
>> gets a bit more difficult, since the current code is not set up to
>> handle the info_length to be anything other than 8.  This won't be
>> a problem if you want to make the feature be completely backwards
>> incompatible, but if you want to allow at least read/only
>> compatibility, you might want to stick 64-bit block number at the
>> end of the dx_root block (this is why the directory checksum is in
>> the dx_tail structure).
> 
> Oh, I didn't realize that. I'll need to think about the impact on
> backwards and forwards compatibility a little more. I didn't think
> that through as much as I thought I did. I would like to break as
> few things as possible.

Did you consider my proposal to order the inode allocations so
that they are (partially) ordered by the directory hash?  That
would not require any on-disk format changes at all.  The theory
is that keeping the entries mostly sorted in the inode table is
enough to avoid the pathological case in large directories where
only a single entry in each block is processed per transaction.

Even if you don't get perfect sorting, processing ten entries
in each block instead of one would give a 10x reduction in
journal traffic and cache misses.

>> I wonder if the better approach is to just simply have some
>> easy-to-use library routines that do a readdir/sort in userspace.  The spd_readdir does basically this, and as we can see it's good
>> enough for most purposes.  The problem is danger when using this
>> in threaded programs, or if you have programs doing really strange
>> things with telldir/seekdir, etc.
> 
> I think this approach is great in the specific cases when you know
> you are going to have to deal with large dirs and your system can
> accommodate for the additional memory required to keep the whole
> directory file. But they can grow pretty quickly in the worst-case
> scenario of really long names.
> 
> The size would have to be limited (probably?) for security reasons
> (as it is in the spd_readdir) accordingly to the memory available
> on the target machine.

Having an upper limit on the directory cache is OK too.  Read all
of the entries that fit into the cache size, sort them, and return
them to the caller.  When the caller has processed all of those
entries, read another batch, sort it, return this list, repeat.

As long as the list is piecewise ordered, I suspect it would gain
most of the benefit of linear ordering (sequential inode table
reads, avoiding repeated lookups of blocks).  Maybe worthwhile if
you could test this out?

>> But it wouldn't be that hard to write a generic library function
>> which if it were used for find, ls, tar, and a few other key
>> programs, would solve the problem for most use cases.
> 
> I'm not sure if the possibility of allocating a fair amount of memory
> would be acceptable for these basic operations. They can be used on a
> variety of embedded devices that might have a problem with using
> something similar to scandir(3) (as Stewart pointed out) for reading
> a directory.

At the same time, the smaller the system, the smaller the directory
will typically be, so I don't think we need to go to extremes.  If
the piecewise ordering of readdir entries gives a sufficient speedup,
then it would be possible to efficiently process directories of 
arbitrary size, and optimally process the most common directories
that fit within the buffer.

Cheers, Andreas





