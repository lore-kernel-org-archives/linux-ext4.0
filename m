From: Andreas Dilger <adilger@sun.com>
Subject: Re: Default size of journal?
Date: Mon, 11 Jan 2010 02:41:07 -0400
Message-ID: <1D207FF6-B457-4DF3-B7B0-F4090EB8CED5@sun.com>
References: <4B4A26B6.805@att.net>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Jeff Layton <laytonjb@att.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44289 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0AKGlM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jan 2010 01:41:12 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0B6f9JE011278
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jan 2010 22:41:11 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KW200G00KZN2U00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Sun,
 10 Jan 2010 22:41:09 -0800 (PST)
In-reply-to: <4B4A26B6.805@att.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-10, at 15:12, Jeff Layton wrote:
> I'm sorry if this is a repeat, but I was wondering what the
> default journal size is for ext4  when it's built on a single
> partition? Or does it vary in size as needed?


It varies with the size of the filesystem.  I believe the largest  
default size is 128MB, but I don't know offhand what the cutoff size is.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

