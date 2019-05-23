Return-Path: <SRS0=Ikgj=TX=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435C5C282DD
	for <linux-ext4@archiver.kernel.org>; Thu, 23 May 2019 23:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D43E2133D
	for <linux-ext4@archiver.kernel.org>; Thu, 23 May 2019 23:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbfEWXco (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 May 2019 19:32:44 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:50834 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXcn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 23 May 2019 19:32:43 -0400
Received: from [4.30.142.84] (helo=srivatsab-a01.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hTxCO-000Pj9-7L; Thu, 23 May 2019 19:32:36 -0400
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     Paolo Valente <paolo.valente@linaro.org>
Cc:     linux-fsdevel@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        linux-ext4@vger.kernel.org, cgroups@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        jmoyer@redhat.com, Theodore Ts'o <tytso@mit.edu>,
        amakhalov@vmware.com, anishs@vmware.com, srivatsab@vmware.com
References: <8d72fcf7-bbb4-2965-1a06-e9fc177a8938@csail.mit.edu>
 <1812E450-14EF-4D5A-8F31-668499E13652@linaro.org>
 <46c6a4be-f567-3621-2e16-0e341762b828@csail.mit.edu>
 <07D11833-8285-49C2-943D-E4C1D23E8859@linaro.org>
 <A0DFE635-EFEC-4670-AD70-5D813E170BEE@linaro.org>
 <5B6570A2-541A-4CF8-98E0-979EA6E3717D@linaro.org>
 <2CB39B34-21EE-4A95-A073-8633CF2D187C@linaro.org>
 <FC24E25F-4578-454D-AE2B-8D8D352478D8@linaro.org>
 <0e3fdf31-70d9-26eb-7b42-2795d4b03722@csail.mit.edu>
 <F5E29C98-6CC4-43B8-994D-0B5354EECBF3@linaro.org>
 <686D6469-9DE7-4738-B92A-002144C3E63E@linaro.org>
 <01d55216-5718-767a-e1e6-aadc67b632f4@csail.mit.edu>
 <CA8A23E2-6F22-4444-9A20-E052A94CAA9B@linaro.org>
 <cc148388-3c82-d7c0-f9ff-8c31bb5dc77d@csail.mit.edu>
Message-ID: <a0096333-55c0-eb30-87fc-d63b5e285b99@csail.mit.edu>
Date:   Thu, 23 May 2019 16:32:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cc148388-3c82-d7c0-f9ff-8c31bb5dc77d@csail.mit.edu>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On 5/22/19 7:30 PM, Srivatsa S. Bhat wrote:
> On 5/22/19 3:54 AM, Paolo Valente wrote:
>>
>>
>>> Il giorno 22 mag 2019, alle ore 12:01, Srivatsa S. Bhat <srivatsa@csail.mit.edu> ha scritto:
>>>
>>> On 5/22/19 2:09 AM, Paolo Valente wrote:
>>>>
>>>> First, thank you very much for testing my patches, and, above all, for
>>>> sharing those huge traces!
>>>>
>>>> According to the your traces, the residual 20% lower throughput that you
>>>> record is due to the fact that the BFQ injection mechanism takes a few
>>>> hundredths of seconds to stabilize, at the beginning of the workload.
>>>> During that setup time, the throughput is equal to the dreadful ~60-90 KB/s
>>>> that you see without this new patch.  After that time, there
>>>> seems to be no loss according to the trace.
>>>>
>>>> The problem is that a loss lasting only a few hundredths of seconds is
>>>> however not negligible for a write workload that lasts only 3-4
>>>> seconds.  Could you please try writing a larger file?
>>>>
>>>
>>> I tried running dd for longer (about 100 seconds), but still saw around
>>> 1.4 MB/s throughput with BFQ, and between 1.5 MB/s - 1.6 MB/s with
>>> mq-deadline and noop.
>>
>> Ok, then now the cause is the periodic reset of the mechanism.
>>
>> It would be super easy to fill this gap, by just gearing the mechanism
>> toward a very aggressive injection.  The problem is maintaining
>> control.  As you can imagine from the performance gap between CFQ (or
>> BFQ with malfunctioning injection) and BFQ with this fix, it is very
>> hard to succeed in maximizing the throughput while at the same time
>> preserving control on per-group I/O.
>>
> 
> Ah, I see. Just to make sure that this fix doesn't overly optimize for
> total throughput (because of the testcase we've been using) and end up
> causing regressions in per-group I/O control, I ran a test with
> multiple simultaneous dd instances, each writing to a different
> portion of the filesystem (well separated, to induce seeks), and each
> dd task bound to its own blkio cgroup. I saw similar results with and
> without this patch, and the throughput was equally distributed among
> all the dd tasks.
> 
Actually, it turns out that I ran the dd tasks directly on the block
device for this experiment, and not on top of ext4. I'll redo this on
ext4 and report back soon.

Regards,
Srivatsa
VMware Photon OS
