From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Atomic non-durable file write API
Date: Thu, 16 Dec 2010 15:11:36 -0500
Message-ID: <4D0A7278.3080506@gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>	<AANLkTimZtza_t8s1uOrE3BFfb-8FELjW95nrQz3RULWd@mail.gmail.com> <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41509 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0LPULk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Dec 2010 15:11:40 -0500
In-Reply-To: <AANLkTikhDgJNny74nyBugg9cUmxC9j8Eo8YY4Fr3fm=5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/16/2010 07:22 AM, Olaf van der Spek wrote:
> On Thu, Dec 9, 2010 at 1:03 PM, Olaf van der Spek<olafvdspek@gmail.com>  wrote:
>> Hi,
>>
>> Since the introduction of ext4, some apps/users have had issues with
>> file corruption after a system crash. It's not a bug in the FS AFAIK
>> and it's not exclusive to ext4.
>> Writing a temp file, fsync, rename is often proposed. However, the
>> durable aspect of fsync isn't always required and this way has other
>> issues.
>> What is the recommended way for atomic non-durable (complete) file writes?
>>
>> I'm also wondering why FSs commit after open/truncate but before
>> write/close. AFAIK this isn't necessary and thus suboptimal.
> Somebody?
>
> Olaf

Getting an atomic IO from user space down to storage is not really trivial.

What I think you would have to do is:

(1) understand the alignment and minimum IO size of your target storage device 
which you can get from /sys/block (or libblkid)

(2) pre-allocate the file so that you do not need to update meta-data for your write

(3) use O_DIRECT write calls that are minimum IO sized requests

Note that there are still things that could break your atomic write - failures 
in the storage device firmware, fragmentation in another layer (breaking up an 
atomic write into transport sized chunks, etc).

In practice, most applications that need to do atomic transactions use logging 
(and fsync()) calls I suspect....

Was this the kind of answer that you were looking for?

Ric

