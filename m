From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: new block group bitmaps not being initialized after resize!?
Date: Sun, 13 Jan 2013 00:26:45 -0500 (EST)
Message-ID: <AA104FC2-C0C6-4465-8AA1-74D99E19EE9C@redhat.com>
References: <20130111000711.GA2490@andromeda.usersys.redhat.com> <50EF65C3.8010406@redhat.com> <25BFE2C2-8FF2-4064-86D3-6CFBF5A2931F@dilger.ca> <50F033F5.6080008@redhat.com> <20130113043615.GE19503@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:57801 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3AMF0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jan 2013 00:26:49 -0500
In-Reply-To: <20130113043615.GE19503@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 12, 2013, at 10:36 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Fri, Jan 11, 2013 at 09:47:01AM -0600, Eric Sandeen wrote:
>>> Zeroing the inode table but not setting the INODE_ZEROED flag
>>> would not be harmful, but this seems to not be the case.
>> 
>> we appear to be not zeroing the table, and not setting INODE_ZEROED.
>> But we should have set INODE_UNINIT, or zeroed it, right?
> 
> The flag names are confusing.  INODE_ZEROED means that the inode table
> is not zero'ed.

Please tell me you said that backwards?

>  This is correct.
> 
> INODE_UNINIT refers to the inode allocation bitmap not being
> initialized, and what we are doing is correct as well.
> 
> What we should be doing is making sure that we kick off the lazyinit
> thread.  So it's basically a missing call to
> ext4_register_li_request(sb).
> 
>> Hum, but lazyinit will take some time to complete; in this case
>> we resized, unmounted, ran fsck and everything was a mess.  Even if
>> we'd started lazyinit I don't think that'ts enough, because we never
>> flagged the group as uninit.
> 
> But as near as I can tell, at least with the latest upstream kernel,
> the flags are being set correctly.  INODE_ZEROED is not being set, but
> that's correct, because the inode table has not been zeroed.  
> 
> The real problem was the bug which was fixed by 93f905264; previous to
> this commit, the unused inode count was incorrect.  My fault for not
> understanding the consequences of this bug.  I was thinking in terms
> of the e2fsck taking too long, but of course if there were previously
> valid inodes in those blocks, e2fsck would in fact go crazy.  So that
> commit really should have been marked cc: stable@vger.kernel.org.
> 
If setting the unused inode count is enough, then I guess it's resolved...
> Regards,
> 
>                        - Ted
