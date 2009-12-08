From: Jody McIntyre <scjody@sun.com>
Subject: Re: [e2fsprogs] Implement resync of declared blocks for software	RAID
Date: Tue, 08 Dec 2009 16:22:07 -0500
Message-ID: <20091208212207.GA15105@clouds>
References: <20091208183046.GH4508@clouds> <87bpi9xldw.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42783 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966258AbZLHVWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 16:22:14 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nB8LMIHb028496
	for <linux-ext4@vger.kernel.org>; Tue, 8 Dec 2009 13:22:20 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KUC00L00R4JMM00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 08 Dec 2009 13:22:18 -0800 (PST)
In-reply-to: <87bpi9xldw.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 08, 2009 at 09:26:35PM +0100, Andi Kleen wrote:
> Is this the only e2fsprogs patch needed for this feature, apart
> from the kernel patches you posted?

It's untested but yes, I think this is all that's needed.

Cheers,
Jody

> Too bad you're not working on it anymore, I definitely liked
> the idea.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
