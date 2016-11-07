From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Sun, 6 Nov 2016 19:14:56 -0500
Message-ID: <20161107001456.muvwkwlqxucrzpzi@thunk.org>
References: <20161103172842.q7avc7rztny3zndd@thunk.org>
 <E33408BD-68CC-49E4-9B32-EC06DB057509@dilger.ca>
 <20161104215105.waabpcf7zganrdbr@thunk.org>
 <20161106235722.GG28177@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        guy@linux.com, jra@google.com, drosen@google.com, hch@infradead.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54016 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbcKGAPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Nov 2016 19:15:07 -0500
Content-Disposition: inline
In-Reply-To: <20161106235722.GG28177@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I talked to Christoph at the Plumbers Closing party, and he suggested
that we get something simple in first which (a) assumes no on-disk
format changes, (b) does everything in the VFS layer, by using a
MS_CASE_FOLD, uses a case-insensitive dentry hash, and which degrades
to a brute force search in the VFS by using readdir interfaces if the
direct lookup does not succeed, and (c) at least initially assumes
only ASCII.

This could be extended by individual file systems who are willing to
make on-disk format changes.

It could be further extended later to support Unicode, and worse,
different versions of Unicode.  (The XFS patches you referenced
support Unicode 7.0.0, and so they are already obsolete.  Now we're up
to Unicode 8.0.0.  Fun.)  The basic issue here is neither Christoph
nor I are paid enough to worry about Unicode, and all of the hacks out
there don't support Unicode anyway.  If someone wants to pay Collabra
$$$ to deal with the Unicode nightmare, life is simple if we let it
degrade to brute force search, and they can have that work done under
contract.  :-)

If we want to handle on-disk format changes, then the file system
superblock would have to specify whether it's using ASCII, Unicode v7,
Unicode v8, etc., and the kernel would have to provide helper routines
to deal with all Unicode versions that we've ever supported before.  I
agree if we go down that path, we should have generic helper functions
ala how we handled encryption.  But the idea is get something basic in
first, and then add other support later, incrementally.

Christoph also suggested at the party that we should look at whether
or not Android weird permissions system could be handled using an LSM.
(It would have to be a stackable LSM, layered on top of SELinux.)
That was definitely an intriguing idea, and much more likely to be
sane than trying to use a wrapfs-based hack.  The problem is I don't
understand the weird Android permissions model well enough to know
whether or not this is doable, but it's something I may try to take a
look at if I can find enough round tuits.

						- Ted
