From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs 1.42-WIP-0702 released
Date: Tue, 09 Aug 2011 08:10:23 -0500
Message-ID: <4E4131BF.9040602@redhat.com>
References: <E1QdWwc-0002Qx-Th@tytso-glaptop> <4E117FB3.3030403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab1HINKY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Aug 2011 09:10:24 -0400
In-Reply-To: <4E117FB3.3030403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/4/11 3:54 AM, Ric Wheeler wrote:
> On 07/04/2011 01:23 AM, Theodore Ts'o wrote:
>> I've made the first WIP release of e2fsprogs 1.42.  The primary purpose
>> is for people to test the 64-bit functionality and be confident that we
>> didn't introduce any 32-bit regressions.
>>
>> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-1.42-WIP-0702.tar.gz
>>
>> This has been built for Debian unstable, so we can get some initial
>> testing.
>>
>>                         - Ted
> 
> Thanks Ted!
> 
> Do we have a specific idea of who is going to be testing and on what size file systems?
> 
> We might want to see about getting this ready for Fedora as well at some point....

I bit the bullet and put this into rawhide today.

-Eric

> Ric
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

