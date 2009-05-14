From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 10:44:07 -0500
Message-ID: <4A0C3C47.9080300@redhat.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44450 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394AbZENPoN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 11:44:13 -0400
In-Reply-To: <20090514143014.GH5146@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kevin Shanahan wrote:

> hermes:~# debugfs /dev/dm-0
> debugfs 1.41.3 (12-Oct-2008)
> debugfs:  stat <759>
> 
> Inode: 759   Type: regular    Mode:  0660   Flags: 0x80000
> Generation: 3979120103    Version: 0x00000000:00000001
> User:     0   Group: 10140   Size: 14615630848
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 28546168
> Fragment:  Address: 0    Number: 0    Size: 0
>  ctime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
>  atime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
>  mtime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
> crtime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
> Size of extra inode fields: 28
> Extended attributes stored in inode body: 
>    = "01 00 00 00 01 00 06 00 02 00 07 00 12 27 00 00 04 00 05 00 08 00 05 00 57 27 00 00 08 00 07 00 98 27 00 00 10 00 06 00 20 00 00 00 " (44)
>   DOSATTRIB = "0x20" (4)

Apologies if I've asked before: DOSATTRIB is a samba xattr; how does
samba come into play in your setup, again?

I'm wondering what that other odd xattr value is too... (the one that
didn't even print a name)

-Eric
