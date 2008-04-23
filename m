From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 0/4] jbd: possible filesystem corruption fixes
Date: Wed, 23 Apr 2008 19:59:43 +0900
Message-ID: <480F169F.4060104@hitachi.com>
References: <48089B86.5020108@hitachi.com>
    <20080418140946.GA26062@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58865 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYDWK7y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 06:59:54 -0400
In-Reply-To: <20080418140946.GA26062@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Josef Bacik wrote:

> On Fri, Apr 18, 2008 at 10:00:54PM +0900, Hidehiro Kawai wrote:
> 
>>Subject: [PATCH 0/4] jbd: possible filesystem corruption fixes
>>
>>This patch set fixes several error handling problems to protect
>>from filesystem corruption caused by I/O errors.  It has been
>>done only for JBD and ext3 parts.
>>
> There doesn't seem like much point in taking these patches as Jan is rewriting
> the ordered mode path and most of these functions will be going away soon.
> Those patches seem like they will be coming soon and will obsolete these.

Yes, PATCH 1/4 and PATCH 2/4 are specific to the ordered mode, and Jan's
patches seem to fix the same problems.  But the remain patches target
generic journaling problems, so I think those patches are still needed.

Regards,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


