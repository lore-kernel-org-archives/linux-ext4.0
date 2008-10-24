From: Eric Paris <eparis@redhat.com>
Subject: ext4_has_free_blocks always checks cap_sys_resource and makes
 SELinux unhappy
Date: Fri, 24 Oct 2008 11:05:35 -0400
Message-ID: <1224860735.3404.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sds@tycho.nsa.gov, esandeen@redhat.com, tytso@mit.edu,
	dwalsh@redhat.com, linux-security-module@vger.kernel.org
To: linux-ext4@vger.kernel.org, selinux@tycho.nsa.gov
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46115 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbYJXPFm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Oct 2008 11:05:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm running an ext4 root filesystem and regularly get SELinux denials
like:

Oct 16 08:32:55 localhost kernel: type=1400 audit(1224160369.076:5):
avc: denied  { sys_resource } for  pid=1624 comm="dbus-daemon"
capability=24 scontext=system_u:system_r:system_dbusd_t:s0
tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability

https://bugzilla.redhat.com/show_bug.cgi?id=467216

Since this doesn't happen with people who have ext3 filesystems but
everything else the same it lead me to look at ext4.  I see that
ext?_has_free_blocks() has changed since ext3 and now we always check
for capable(CAP_SYS_RESOUCE).  If a process actually has the capability
in pE (as many root processes would) but doesn't have the capability in
SELinux policy we will get a denial.

I can think of a couple ways to fix this:

the first (and one I like) is to change ext4 to stop checking
CAP_SYS_RESOURCE all the time.  It's not really 'pretty' but I think you
would actually get a better performing function.  Just always calculate
root_blocks and if we don't have enough room then then do the whole
check to see if are root and recalculate without root_blocks.  I'd guess
that a great majority of the time operations will succeed even with a
non-zero root_blocks and I would guess that most process aren't going to
be root processes and so we would be calculating root_blocks anyway.
This would (like ext3) only cause these denials when it was filled up.
We've been living with that forever, so I don't see a problem there...

The second way would be a new lsm hook.  Instead of calling capable(),
ext4 could call something like a new capable_noaudit() which would
return the same result but would tell the lsm that this isn't a security
decision and shouldn't be audited.  The LSM doesn't currently have any
kind of syntax or representation like this exposed to the main kernel,
so I'm a little skeptical how the LSM community at large would respond
to exposing such a thing...

Another would be a new specific LSM call to just check cap_sys_resource
which also doesn't get audited.

Do others have thoughts?

-Eric

