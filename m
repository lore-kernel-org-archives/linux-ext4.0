From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: I lost 15G from ext4 fsck failures tonight!
Date: Thu, 28 May 2009 22:22:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0905282211440.7424@bogon>
References: <23774225.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: ed1989 <edshrock@live.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:56149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZE2FWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 May 2009 01:22:14 -0400
In-Reply-To: <23774225.post@talk.nabble.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 28 May 2009, ed1989 wrote:
> I moved some data off of a 115G ext4 filesystem on an LVM logical volume. 
> Then I resized the ext4 filesystem.  Unfortunately, 15G of the remaining 95G
> in data was lost to /lost+found due to repeated fsck errors.

Did you run fsck (which version?) before or after the resizing process? 
IIRC resize2fs recommends running e2fsck before doing anything. Do you 
have a log of the errors reported by e2fsck? Also, were there any errors 
in your syslog (i.e. /var/log/messages, dmesg, etc.)
 
> I have also had the problem of ext4 destroying my kde4 configuration files
> so that my kde4 desktop would revert back to the defaults occasionally.

This has been discussed on this list (and elsewhere) before, in short: 
it's not really ext4 destroying but more like kde4 not really writing its 
configuration files. But this is an oversimplified version of the real 
issues, please search the archives for details.

> I am most likely going to move back to ext3 or else to some other stable
> filesystem like xfs.

Out of curiosity: why did you switch to ext4?

Christian.
-- 
BOFH excuse #310:

asynchronous inode failure
