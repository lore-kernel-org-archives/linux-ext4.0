From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: noacl and nouser_xattr
Date: Mon, 18 Nov 2013 12:31:24 -0600
Message-ID: <528A5CFC.1060706@redhat.com>
References: <528A2397.8030402@me.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Paul FM <paulfm@me.umn.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3KRSbo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Nov 2013 13:31:44 -0500
In-Reply-To: <528A2397.8030402@me.umn.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/18/13, 8:26 AM, Paul FM wrote:
> 
> Yes - I need noacl and nouser_xattr
> 
> How about documenting your intent to remove them in the man pages.
> 
> acl support and user_xattr support need to be off on the / and /usr
> filesystems to simplify security. Actually I want a way to turn off
> ALL extended attribute support on any filesystem.  How about noxattr
> (which would turn off ALL extended attribute support including acls).
> I also use nosuid on filesystems that shouldn't have any suid files.
> 
> This is to follow the security principal - "If you aren't using it
> and don't need it - turn it off".

FWIW, it still can be disabled at build time via CONFIG_EXT3_FS_POSIX_ACL

But if you are using a distro kernel that turns that on, I see
your point about noacl.

However, I'm not sure how nouser_xattr comes into the argument?
xattrs by themselves are just metadata; they don't impact security
control unless they are a special kind of xattrs (i.e. acls).

Thanks,
-Eric

> The simple Posix/Unix permissions are more than enough security
> control in almost every situation I have run into (only wish I could
> use them in Windows).
> 
> Having worked extensively with ACLS on Windows (and some older Main
> Frame OSes) - I note that ACL's add a level of complexity to security
> that actually makes for less security.  I see the need to support
> them in Unix/Linux - but they should be OFF unless someone
> specifically wants to use them (at least don't make them hard to turn
> off).
> 
> Just try auditing the security of a windows filesystem if you don't
> think ACL's add extreme complexity (I gave up - I just forcibily set
> all the ACL's myself by script using the unix Owner,Group,Other
> concepts as a model to simplify what I am setting).
> 
> 
> 
> 

