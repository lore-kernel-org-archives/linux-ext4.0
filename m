From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: [PATCH] EXT_MAX_BLOCK for >= 16TB fs
Date: Tue, 08 Jul 2008 18:21:11 +0530
Message-ID: <1215521471.3249.15.camel@alpha.linsyssoft.com>
References: <1215449732.1167.11.camel@alpha.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: adilger@Sun.COM, Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:56189 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYGHMvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2008 08:51:25 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m68CpkSO001552
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 12:51:49 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K3O00401U70NW00@mail-apac.sun.com>
 (original mail from Girish.Shilamkar@Sun.COM) for linux-ext4@vger.kernel.org;
 Tue, 08 Jul 2008 20:50:50 +0800 (SGT)
In-reply-to: <1215449732.1167.11.camel@alpha.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,	
	Here is the patch for same.

Thanks,
Girish

On Mon, 2008-07-07 at 22:25 +0530, Girish Shilamkar wrote:
> Hi,
> 	The magic constant EXT_MAX_BLOCK = 0xffffffff in extents code is used
> in some places to return "invalid block number", and to set the extent
> length = "whole file" in other places.
> 	So with >= 16 TB fs we would prefer to use it differently. We can have
> EXT_UNSET_BLOCK = 1 to indicate "invalid block number" as it will never
> be valid block for allocation. And for "whole file" usecase we can
> continue using current EXT_MAX_BLOCK
> 
> Regards,
> Girish
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

