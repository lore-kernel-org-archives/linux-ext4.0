From: Curt Wohlgemuth <curtw@google.com>
Subject: Dirent blocks leaking into data file blocks
Date: Fri, 13 Nov 2009 15:46:09 -0800
Message-ID: <6601abe90911131546v43838123g3bc312d46a97e199@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:25230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454AbZKMXwt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Nov 2009 18:52:49 -0500
Received: from spaceape8.eur.corp.google.com (spaceape8.eur.corp.google.com [172.28.16.142])
	by smtp-out.google.com with ESMTP id nADNqrKM030636
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2009 15:52:54 -0800
Received: from pxi40 (pxi40.prod.google.com [10.243.27.40])
	by spaceape8.eur.corp.google.com with ESMTP id nADNqgQR030770
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2009 15:52:43 -0800
Received: by pxi40 with SMTP id 40so2593406pxi.13
        for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2009 15:52:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm seeing some corruption in data files during heavy use on ext4 file
systems, which appears to be a bug.  The symptom is this:

A random block in the middle of an otherwise undistinguished 8MB data file
has a pattern like this:

   $ od -Ax -x <file>
   ...
   001000 b4aa 0005 000c 0201 002e 0000 4e31 0005
   001010 0ff4 0202 2e2e 0000 ce67 0004 000c 0102
   001020 6e69 0000 ce69 0004 0fdc 0103 756f 0074
   001030 0000 0000 0000 0000 0000 0000 0000 0000
   *
   002000 8b83 f727 10d0 b918 ad2a 8edc 67f7 e178
   ...

The block from 0x1000 to 0x2000 looks an awful lot like a block of directory
entries, with the dirents:

   inode     : 373930
   rec_len   : 12
   name_len  : 1
   file_type : 2 (dir)
   name      : "."

   inode     : 347697
   rec_len   : 4084 (i.e., all the rest of the block
   name_len  : 2
   file_type : 2 (dir)
   name      : ".."

with remnants of other, deleted dirents following it.

These corruptions are pretty rare, and I can't replicate the problem in any
sort of simple test case.  But looking at the code, it seems that there's a
problem with deletion of "metadata" blocks full of dirents:  ext4_forget()
is never called for them.

For all other blocks used as metadata, ext4_forget() seems to be called when
they're about to be freed up:

   - extent blocks
   - indirect blocks
   - xattr blocks

But I don't see anywhere that we call ext4_forget() (or ext4_journal_forget
directly) for directory entries.

So when a directory is removed with "rm -rf foo" , as the files are deleted,
the directory block(s) are marked dirty.  But when the directory blocks
themselves are freed up, bforget() isn't called for their bufferheads, and
so they remain dirty in the page cache, and can be written down later, after
their blocks have been reused.

This is the same problem I saw with extent metadata blocks "leaking" into
data blocks, fixed with c7acb4c16646943180bd221c167a077e0a084f9c , which
added calls to bforget() in ext4_journal_{forget,revoke}() .  But in this
new case, it would seem to be an issue both with and without a journal, and
with both extent- and non-extent based directories.

Am I missing something?  And if not, suggestions on the best place to fix
this?  I was thinking of doing this in ext4_truncate() for all truncated
blocks if this is a directory; or in ext4_mb_free_blocks() if "metadata" is
1.  But this latter one would be overkill for all those "normal" metadata
blocks which already have been "forgotten."

Thanks,
Curt
