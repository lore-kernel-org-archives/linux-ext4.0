From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: More ext4 corruption
Date: Fri, 03 Apr 2009 18:25:12 -0500
Message-ID: <49D69AD8.6070808@redhat.com>
References: <20090403221508.GA5436@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbZDCXZ1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 19:25:27 -0400
In-Reply-To: <20090403221508.GA5436@kulgan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kevin Shanahan wrote:
> Hi,
> 
> I'm seeing some more corruption on our ext4 filesystems. Last night's
> backup job had these errors:
> 
...

> rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200410_01.htm" failed: Input/output error (5)
> rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200709_01.pdf" failed: Input/output error (5)
> IO error encountered -- skipping file deletion
> skipping non-regular file "apps/CIM8/Release-Notes/rb_200803_02.pdf"
> rsync error: some files could not be transferred (code 23) at main.c(1524) [generator=3.0.3]
> setfacl: apps/CIM8/Release-Notes/rb_200803_02.pdf: No such file or directory
> 
> The "apps/Gestalt.Net/..." error is an old one and I need to chase
> that up some more[1]. The corruption in the "Release-Notes" directory
> is new last night.
> 
> My initial information gathering is below. Let me know what else might
> be helpful, but I'll have to fsck before Monday.

Any kernel messages this time?  You could also run e2fsck -n and provide
that output (it should not actually modify anything)

Thanks,
-eric

>  [1] http://marc.info/?l=linux-ext4&m=123695451828101&w=2
> 
> Regards,
> Kevin.

