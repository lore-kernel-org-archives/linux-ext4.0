From: Paul FM <paulfm@me.umn.edu>
Subject: noacl and nouser_xattr
Date: Mon, 18 Nov 2013 08:26:31 -0600
Message-ID: <528A2397.8030402@me.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.enet.umn.edu ([128.101.142.226]:55046 "EHLO
	mail.enet.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KROhU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Nov 2013 09:37:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Yes - I need noacl and nouser_xattr

How about documenting your intent to remove them in the man pages.

acl support and user_xattr support need to be off on the / and /usr 
filesystems to simplify security. Actually I want a way to turn off ALL 
extended attribute support on any filesystem.  How about noxattr (which 
would turn off ALL extended attribute support including acls).  I also 
use nosuid on filesystems that shouldn't have any suid files.

This is to follow the security principal - "If you aren't using it and 
don't need it - turn it off".

The simple Posix/Unix permissions are more than enough security control 
in almost every situation I have run into (only wish I could use them in 
Windows).

Having worked extensively with ACLS on Windows (and some older Main 
Frame OSes) - I note that ACL's add a level of complexity to security 
that actually makes for less security.  I see the need to support them 
in Unix/Linux - but they should be OFF unless someone specifically wants 
to use them (at least don't make them hard to turn off).

Just try auditing the security of a windows filesystem if you don't 
think ACL's add extreme complexity (I gave up - I just forcibily set all 
the ACL's myself by script using the unix Owner,Group,Other concepts as 
a model to simplify what I am setting).




-- 

---------------------------------------------------------------------
The views and opinions expressed above are strictly
those of the author(s).  The content of this message has
not been reviewed nor approved by any entity whatsoever.
I should not be considered an "AUTHORITY" on any subject.
---------------------------------------------------------------------
Paul Markfort               Info: http://www.umn.edu/~paulfm
---------------------------------------------------------------------
