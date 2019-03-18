Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5761C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 22:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE6E20863
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 22:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfCRWEC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 18:04:02 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52757 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726911AbfCRWEC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Mar 2019 18:04:02 -0400
Received: from [10.0.88.1] (unknown [62.214.191.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9A4F3604E3BE3;
        Mon, 18 Mar 2019 23:03:59 +0100 (CET)
Subject: Re: New service e2scrub_reap
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-ext4@vger.kernel.org
References: <fb05730f-c078-ec94-72d3-83a398f936a7@molgen.mpg.de>
 <20190318214717.GB3859@mit.edu>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <9d83dc52-dda8-6241-40ae-8a4fec4bb9eb@molgen.mpg.de>
Date:   Mon, 18 Mar 2019 23:03:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190318214717.GB3859@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Dear Ted,


On 18.03.19 22:47, Theodore Ts'o wrote:
> On Mon, Mar 18, 2019 at 12:24:55PM +0100, Paul Menzel wrote:

>> On Debian Sid/unstable, I noticed the new service `scrub/e2scrub_reap.service`
>> installed in the default target [1][2].
>>
>> $ systemctl status -o short-precise e2scrub_reap.service
>> ● e2scrub_reap.service - Remove Stale Online ext4 Metadata Check Snapshots
>>     Loaded: loaded (/lib/systemd/system/e2scrub_reap.service; enabled; vendor preset: enabled)
>>     Active: inactive (dead) since Mon 2019-03-18 12:17:13 CET; 1min 1s ago
>>       Docs: man:e2scrub_all(8)
>>    Process: 447 ExecStart=/sbin/e2scrub_all -A -r (code=exited, status=0/SUCCESS)
>>   Main PID: 447 (code=exited, status=0/SUCCESS)
>>
>> Mar 18 12:17:08.223560 plumpsklo systemd[1]: Starting Remove Stale Online ext4 Metadata Check Snapshots...
>> Mar 18 12:17:13.996465 plumpsklo systemd[1]: e2scrub_reap.service: Succeeded.
>> Mar 18 12:17:13.996808 plumpsklo systemd[1]: Started Remove Stale Online ext4 Metadata Check Snapshots.
> 
> Yeah, that's unfortunate.  I'm seeing a similar time on my (fairly
> high-end) laptop:
> 
> # time e2scrub_all -A -r
> 
> real	0m4.356s
> user	0m0.677s
> sys	0m1.285s

Thank you for your response and tests.

> We should be able to fix this in general by avoiding the use of lsblk
> at all, and in the case of e2scrub -r, just simply iterating over the
> output of:
> 
> lvs --name-prefixes -o vg_name,lv_name,lv_path,origin -S lv_role=snapshot
> 
> (which takes about a fifth of a second on my laptop and it should be
> even faster if there are no LVM volumes on the system)
> 
> And without the -r option, we should just be able to do this:
> 
> lvs --name-prefixes -o vg_name,lv_name,lv_path -S lv_active=active,lv_role=public
> 
> Right now we're calling lvs for every single block device emitted by
> lsblk, and from what I can tell, we can do a much better job
> optimizing e2scrub_all.

Indeed. That sounds like a way to improve the situation.

>> Reading the manual, the switch `-r` “removes e2scrub snapshots but do not
>> check anything”.
>>
>> Does this have to be done during boot-up, or could it be done after the
>> default target was reached, or even during shutting down?
> 
> This shouldn't be blocking any other targets, I think there should be
> a way to configure the unit file so that it runs in parallel with the
> other systemd units.  My systemd-fu is not super strong, so I'll have
> to do some investigating to see how we can fix this.

Sorry about my wording. It’s not about blocking targets, but an 
additional program which fights for the resources. Until the graphical 
target (or graphical login manager) is reached on my system, a lot of 
process already wait for CPU resources. That is the bottleneck during 
the boot-up of my system.

So it’d be great, if services, which actually do not have to run during 
boot-up would only be started after the default target has been reached. 
Something like the ordering dependency

     After=default.target

which does not work though to my knowledge. I’ll ask the systemd folks 
again.


Kind regards,

Paul
