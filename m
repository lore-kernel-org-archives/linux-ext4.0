From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: Re: [PATCH] Fix commit block write in JBD2
Date: Thu, 24 Jan 2008 02:48:41 +0530
Message-ID: <1201123121.3706.9.camel@alpha.linsyssoft.com>
References: <20080123190943.GG10144@duck.suse.cz>
 <20080123191054.GH10144@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:58977 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYAWVTr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jan 2008 16:19:47 -0500
Received: from fe-apac-04.sun.com (fe-apac-04.sun.com [192.18.19.175] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m0NLBIAo027024
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jan 2008 21:11:29 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0JV4000016DA6900@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Thu, 24 Jan 2008 05:11:18 +0800 (SGT)
In-reply-to: <20080123191054.GH10144@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
	The loop was removed in journal checksum patch. There had been a
discussion (11 Jul 2007: [EXT4 set 8][PATCH 1/1]Add journal checksums)
about this part of code as checksum info was added to commit block. 

Regards,
Girish
On Wed, 2008-01-23 at 20:10 +0100, Jan Kara wrote:
> On Wed 23-01-08 20:09:43, Jan Kara wrote:
> >   Hi,
> > 
> >   the patch below fixes preparation of commit block in
> > journal_write_commit_record(). Obviously the bug doesn't really matter
> > since nobody reported it so far but let's cleanup the code... Andrew, could
> > you please queue it up? Thanks.
>   And the same fix for JBD2.
> 
> 									Honza
