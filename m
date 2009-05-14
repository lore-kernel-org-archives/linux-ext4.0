From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 06:37:09 +0930
Message-ID: <20090514210709.GM5146@kulgan>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <4A0C3C47.9080300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:53085 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZENVHL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 17:07:11 -0400
Content-Disposition: inline
In-Reply-To: <4A0C3C47.9080300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 10:44:07AM -0500, Eric Sandeen wrote:
> Kevin Shanahan wrote:
> 
> > hermes:~# debugfs /dev/dm-0
> > debugfs 1.41.3 (12-Oct-2008)
> > debugfs:  stat <759>
> > 
> > Inode: 759   Type: regular    Mode:  0660   Flags: 0x80000
> > Generation: 3979120103    Version: 0x00000000:00000001
> > User:     0   Group: 10140   Size: 14615630848
> > File ACL: 0    Directory ACL: 0
> > Links: 1   Blockcount: 28546168
> > Fragment:  Address: 0    Number: 0    Size: 0
> >  ctime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
> >  atime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
> >  mtime: 0x4a0acdb5:2a88cbec -- Wed May 13 23:10:05 2009
> > crtime: 0x4a0ac45b:10899618 -- Wed May 13 22:30:11 2009
> > Size of extra inode fields: 28
> > Extended attributes stored in inode body: 
> >    = "01 00 00 00 01 00 06 00 02 00 07 00 12 27 00 00 04 00 05 00 08 00 05 00 57 27 00 00 08 00 07 00 98 27 00 00 10 00 06 00 20 00 00 00 " (44)
> >   DOSATTRIB = "0x20" (4)
> 
> Apologies if I've asked before: DOSATTRIB is a samba xattr; how does
> samba come into play in your setup, again?

This server is a Samba server. This file in particular is being
written to via Samba by a Windows 2000 server over the network.

> I'm wondering what that other odd xattr value is too... (the one that
> didn't even print a name)

I would assume that's the file ACL:

hermes:/srv/samba/local/dumps/exchange# getfacl --numeric exchange-2000-UCWB-KVM-18.bkf
# file: exchange-2000-UCWB-KVM-18.bkf
# owner: 0
# group: 10140
user::rw-
user:10002:rwx                  #effective:rw-
group::r-x                      #effective:r--
group:10071:r-x                 #effective:r--
group:10136:rwx                 #effective:rw-
mask::rw-
other::---

Cheers,
Kevin.
