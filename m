From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Question about writable ext4-snapshot
Date: Fri, 20 Jan 2012 21:37:17 -0700
Message-ID: <46A86C42-E47C-43F7-A688-E15607CCF4A3@dilger.ca>
References: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com> <92365222-576D-43F6-8BC0-3F7D4A663D05@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Robin Dong <hao.bigrat@gmail.com>, Theodore Tso <tytso@mit.edu>,
	"amir73il@gmail.com" <amir73il@gmail.com>,
	Tao Ma <taoma.tm@gmail.com>, coly <colyli@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:41839 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab2AUEhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jan 2012 23:37:01 -0500
In-Reply-To: <92365222-576D-43F6-8BC0-3F7D4A663D05@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 20, 2012, at 9:45 PM, Robin Dong wrote:

> Hello, Amir
> 
> I am evaluating ext4-snapshot (on github) for TAOBAO recently. The
> snapshot of an ext4 fs is READONLY now, but we do need to write data
> into snapshot. We also want using  ext4-snapshot to do online-fsck on
> Hadoop clusters, but our hadoop clusters are using no-journal ext4
> now. 

When you write about online e2fsck, what do you mean exactly?  It is already possible with LVM to create a read-only snapshot of a device and run read-only e2fsck. This works because the LVM snapshot is hooked to ext4 to freeze the filesystem and flush the journal before the snapshot is done. 

At this point, if the fsck is clean then the original filesystem is clean also. This is the most common case. In the uncommon case of errors detected on the snapshot, then the filesystem would need to be taken offline to fix any problems.

By running the online fsck on the snapshot, one can be certain that the filesystem is clean, and reset the automatic checking date/mount counters.

If you are thinking about online repair, that would be much more complex, but may still be possible for some cases. 

Cheers, Andreas
