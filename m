From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4_has_free_blocks always checks cap_sys_resource and makes
 SELinux unhappy
Date: Sun, 26 Oct 2008 20:39:47 -0500
Message-ID: <49051BE3.4080807@redhat.com>
References: <1224860735.3404.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, selinux@tycho.nsa.gov,
	sds@tycho.nsa.gov, esandeen@redhat.com, tytso@mit.edu,
	dwalsh@redhat.com, linux-security-module@vger.kernel.org
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbYJ0BkQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Oct 2008 21:40:16 -0400
In-Reply-To: <1224860735.3404.74.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Paris wrote:
> I'm running an ext4 root filesystem and regularly get SELinux denials
> like:
> 
> Oct 16 08:32:55 localhost kernel: type=1400 audit(1224160369.076:5):
> avc: denied  { sys_resource } for  pid=1624 comm="dbus-daemon"
> capability=24 scontext=system_u:system_r:system_dbusd_t:s0
> tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=467216

For the record, I've put a couple patches into the ext4 patch queue that
should do Eric's first suggestion of deferring the capable() check until
it's really needed.  Details are in the bug  above.

Thanks,
-Eric
