From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Aw: Re: superblock completely overwritten
Date: Wed, 14 Dec 2016 10:28:01 -0600
Message-ID: <9df0fe06-da77-11f3-3d6b-dbf941df6376@redhat.com>
References: <trinity-fba1c40f-e300-43ee-a4cd-f9d7f48ecef2-1481643547528@3capp-gmx-bs76>
 <7a0b791c-8a9f-23e5-02a2-cd903024ef06@redhat.com>
 <20161213181346.GA6354@birch.djwong.org>
 <trinity-6030b51c-4ef2-49de-bc0d-da61db362d9c-1481708479043@3capp-gmx-bs37>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Heinz Nimmervoll <bt1now@gmx.at>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753335AbcLNQfO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 14 Dec 2016 11:35:14 -0500
In-Reply-To: <trinity-6030b51c-4ef2-49de-bc0d-da61db362d9c-1481708479043@3capp-gmx-bs37>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/14/16 3:41 AM, Heinz Nimmervoll wrote:
>>> - How is it possible, that even the magic number (and everything else) got overwritten?
>>> - Why could it ever be overwritten?

>> I don't think anyone here can tell you what happened, it is almost certainly not
>> an ext4 bug. Could be a driver bug, or an admin running a stray "dd" command,
>> or some other utility gone astray, or ... anything, really.

> I can rule out that it was the dd command. Eric, do you think it
> could also be a problem about the SD-card and wear levelling (just a
> guess)?

Ok, now that Darrick has pointed out that it's inode data, I am slightly
less sure that it is "almost certainly not an ext4 bug" :)

Still, I don't recall any other reports of this type of corruption, so
I think it's quite possible that it's a problem outside of ext4.

Depending on how hard it is to reproduce, you might consider retesting
several sd card types to see if it is hardware-dependent.

-Eric
