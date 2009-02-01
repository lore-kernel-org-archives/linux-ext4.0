From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 12594] New: filesystem corruption while running bonnie
Date: Sun, 01 Feb 2009 10:14:52 -0600
Message-ID: <4985CA7C.70302@redhat.com>
References: <bug-12594-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51129 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbZBAQO6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Feb 2009 11:14:58 -0500
In-Reply-To: <bug-12594-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bugme-daemon@bugzilla.kernel.org wrote:

> mkdir /mnt/tmp /tmp/tmp ; mount -t tmpfs /dev/null /mnt
> chown folkert /mnt/tmp /tmp/tmp
> 
> and then in parallel:
> while [ 1 ] ; do bonnie++ -d /tmp/tmp -s 128 -r 64 -x 1 -u folkert ; done
> while [ 1 ] ; do bonnie++ -d /mnt/tmp -s 128 -r 64 -x 1 -u folkert ; done
> 
> then after say 15 minutes i run the reboot command (normal via init) during the
> fsck (I always do a touch /forcefsck) I get:
> fsck 1.41.3 (12-Oct-2008)
> /dev/mapper/VGODR-tmp contains a file system with errors, check forced.

Need to look at system logs before this to see why the fs has errors, I
think.

-Eric

