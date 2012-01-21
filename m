From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Question about writable ext4-snapshot
Date: Fri, 20 Jan 2012 23:24:01 -0500
Message-ID: <92365222-576D-43F6-8BC0-3F7D4A663D05@mit.edu>
References: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, amir73il@gmail.com,
	Tao Ma <taoma.tm@gmail.com>, coly <colyli@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:55105 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249Ab2AUEYG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jan 2012 23:24:06 -0500
In-Reply-To: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 20, 2012, at 9:45 PM, Robin Dong wrote:

> Hello, Amir
> 
> I am evaluating ext4-snapshot (on github) for TAOBAO recently. The
> snapshot of an ext4 fs is READONLY now, but we do need to write data
> into snapshot. We also want using  ext4-snapshot to do online-fsck on
> Hadoop clusters, but our hadoop clusters are using no-journal ext4
> now. So we have some question
> 
> 1. Will it be possible to implement a writable ext4-snapshot ?
> 2. Will it be possible to snapshot a no-journal ext4-fs ?
> 3. What's the difficult point of  implementing above ?

Something else to consider is that the device mapper thin-provisioning approach.   This approach does the snapshotting at the device-mapper layer, which means it is separate from the file system.  It relies on using the discard request when the file is unlinked to know when blocks can be released from the snapshot.  It also uses a granularity much smaller than that of the traditional LVM-style snapshots. 

This code will still need a few months to be mature (the thin-provisioning code just got merged into 3.2, but discard support isn't done yet, and the userspace support is lagging).   But in the long run, this might be a very attractive way of providing multiple levels of writeable snapshots, in a clean and relatively simple way.

-- Ted


