From: Sean McCauliff <Sean.D.McCauliff@nasa.gov>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Fri, 8 Jul 2011 10:41:13 -0700
Message-ID: <4E174139.4070501@nasa.gov>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>	<20110627030539.GF3064@thunk.org>	<341DAA96EE3A8444B6E4657BE8A846EA4B3DA12708@NDJSSCC06.ndc.nasa.gov>	<F673734C-4ECE-40B2-B283-959027C34B06@mit.edu>	<341DAA96EE3A8444B6E4657BE8A846EA4B3DA1270A@NDJSSCC06.ndc.nasa.gov>	<50F503A1-6A16-41C4-9C27-0662063C7817@mit.edu>	<4E0BBCE9.9020600@nasa.gov> <20110630023306.GY2729@thunk.org>	<4E17398F.2090609@nasa.gov> <m27h7sd742.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ndmsnpf01.ndc.nasa.gov ([198.117.0.121]:49430 "EHLO
	ndmsnpf01.ndc.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab1GHRlP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 13:41:15 -0400
In-Reply-To: <m27h7sd742.fsf@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

43% of the destination file system is in use.

Sean

On 07/08/2011 10:17 AM, Andi Kleen wrote:
> Sean McCauliff<Sean.D.McCauliff@nasa.gov>  writes:
>
>> I tried running perf on the copy program on subset of the sparse
>> files. It seems like ext4 is the source of high cpu utilization.  At
>> this point this high cpu utilization is very annoying, but I can live
>> with this problem.  If you know something simple I could do to
>> alleviate this problem I would be most appreciative.  At the end of
>> this email is a consolidation of information about this problem.
>>
>> Events: 6M cycles
>> -76.80%     java  [kernel.kallsyms]      [k] ext4_mb_good_group
>>    - ext4_mb_good_group
>
> Is your file system too full?
>
> A lot of file system get inefficient in allocating blocks when the
> file system is nearly full.
>
> -Andi
>

