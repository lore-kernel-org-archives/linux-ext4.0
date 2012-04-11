From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What is e2initrd_helper?
Date: Wed, 11 Apr 2012 10:55:17 -0500
Message-ID: <4F85A965.3040008@redhat.com>
References: <4F85A740.9080906@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2DKPzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 11:55:19 -0400
In-Reply-To: <4F85A740.9080906@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/11/12 10:46 AM, Phillip Susi wrote:
> I came across this program in e2fsprogs and it doesn't seem to have a
> man page.  What is its purpose?  Looking at the code, it appears to
> extract the fs type listed in the /etc/fstab of the root fs before it
> is mounted, but why?

+2004-09-18  Theodore Ts'o  <tytso@mit.edu>
+
+       * e2initrd_helper.c: New program which allows initrd scripts to
+               check on the contents of /etc/fstab without (a) needing to
+               mount the root filesystem, and (b) needing /bin/awk in the
+               initrd environment.  (Addresses Debian Bug #247775)
+

Other than that, I dunno, but Ted might.  :)

-Eric

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

