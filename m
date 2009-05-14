From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Thu, 14 May 2009 16:08:22 -0500
Message-ID: <4A0C8846.1050202@redhat.com>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <4A0C3C47.9080300@redhat.com> <20090514210709.GM5146@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbZENVIc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 17:08:32 -0400
In-Reply-To: <20090514210709.GM5146@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kevin Shanahan wrote:
> On Thu, May 14, 2009 at 10:44:07AM -0500, Eric Sandeen wrote:

...

>>> Extended attributes stored in inode body: 
>>>    = "01 00 00 00 01 00 06 00 02 00 07 00 12 27 00 00 04 00 05 00 08 00 05 00 57 27 00 00 08 00 07 00 98 27 00 00 10 00 06 00 20 00 00 00 " (44)
>>>   DOSATTRIB = "0x20" (4)
>> Apologies if I've asked before: DOSATTRIB is a samba xattr; how does
>> samba come into play in your setup, again?
> 
> This server is a Samba server. This file in particular is being
> written to via Samba by a Windows 2000 server over the network.
> 
>> I'm wondering what that other odd xattr value is too... (the one that
>> didn't even print a name)
> 
> I would assume that's the file ACL:

Ah, sure.  Ok thanks.

-Eric
