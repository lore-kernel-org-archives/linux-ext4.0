From: Saugata Das <saugata.das@linaro.org>
Subject: Re: [PATCH v2 1/2] block: add BH_Meta flag
Date: Mon, 28 May 2012 20:00:07 +0530
Message-ID: <CAKLKtzfRysmG8Wj5_Lmjy2xH+-DJZ=Fwr7JydNJRc5A4+SnL0g@mail.gmail.com>
References: <1337257290-28547-1-git-send-email-saugata.das@stericsson.com>
	<x4962bouq71.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@linaro.org, arnd.bergmann@linaro.org, venkat@linaro.org,
	lporzio@micron.com, tytso@mit.edu, adilger@dilger.ca,
	hch@infradead.org, bharrosh@panasas.com, deepak.saxena@linaro.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46604 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2E1Oai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 May 2012 10:30:38 -0400
Received: by qabj40 with SMTP id j40so1310682qab.1
        for <linux-ext4@vger.kernel.org>; Mon, 28 May 2012 07:30:38 -0700 (PDT)
In-Reply-To: <x4962bouq71.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 22 May 2012 22:07, Jeff Moyer <jmoyer@redhat.com> wrote:
> Saugata Das <saugata.das@stericsson.com> writes:
>
>> From: Saugata Das <saugata.das@linaro.org>
>>
>> Today, storage devices like eMMC has special features like data tagg=
ing
>> (introduced in MMC-4.5 version) in order to improve performance of s=
ome
>> specific writes. On MMC stack, data tagging is used for all writes w=
hich
>> has REQ_META flag set. This patch adds the capability to add REQ_MET=
A flag
>> during meta data write.
>
> Presumably you're doing this to get better performance for some
> workload, yes? =A0Could you please let us know what workloads you tes=
ted
> and how this patch set helps? =A0In other words, what benchmarking di=
d you
> perform and what were the results? =A0Do you expect this to make some
> other workloads perform worse?
>

Sorry for the late reply.

The use cases, we are trying to improve are the file writes to eMMC by
redirecting the meta-data to a dedicated location within eMMC which
provides high write performance. With the proposed patch, I see that
for a 128KB file write, ~11% data writes are meta-data write. If we
consider, eMMC provides atleast double the performance for such writes
then this fetches ~5% improvement in overall file write performance.
Lower the file size, higher will be the gain. Note that eMMC
specification does not say how the memory devices will implement this
data tag feature, so the improvement seen will vary between devices
from different vendors.

There is no negative impact on any other use cases.


> Cheers,
> Jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
