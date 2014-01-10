From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: A proposal for making ext4's journal more SMR (and flash) friendly
Date: Fri, 10 Jan 2014 01:14:36 -0700
Message-ID: <BCE18F0F-D8C9-41F3-A252-2E68C9A1421D@dilger.ca>
References: <nsxfvozavl2.fsf@lambda.thunk.org> <22006ACD-BC60-4462-B000-CB121DC26FBE@dilger.ca> <20140109134102.GA18972@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38123 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaAJIOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jan 2014 03:14:41 -0500
Received: by mail-ig0-f178.google.com with SMTP id ut6so9908251igb.5
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jan 2014 00:14:40 -0800 (PST)
In-Reply-To: <20140109134102.GA18972@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 9, 2014, at 6:41, Theodore Ts'o <tytso@mit.edu> wrote:
> [Another design tangent: with SMR drives, it's clear that atime
> updates are going to be a big deal.  So the question is how much will
> our users really care about atime.  Can we just simply say, "use
> noatime", or should we think about some way of handling atime updates
> specially?  (For example, we could track atime updates separately, and
> periodically include in the journal a list of inode numbers and their
> real atimes.)  This is not something we should do early on --- it's
> another later optional enhancement --- but it is something to think
> about.

We already have noatime and relatime, since atime hurts on
spinning disks as well.  It wouldn't be impossible to do the atime updates in
the journal initially, and only write the inodes to their final resting place after
enough have been accumulated. 

I think when there are many atime updates together (e.g. "grep -r") it
will be reasonable to checkpoint them to the filesystem, and when
there are only a few those inodes could be rewritten to the journal.

I'm thinking the same could be done with data journaling for small files. 
It makes sense to write a small file's data to the journal, but write large
file data directly to its final resting place. 

Cheers, Andreas

