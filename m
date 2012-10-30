From: Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH] Remove VLAIS usage from JBD2 code
Date: Tue, 30 Oct 2012 15:02:43 -0400
Message-ID: <50902453.9090404@converseincode.com>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com> <1351622404-18214-2-git-send-email-behanw@converseincode.com> <20121030190032.GB5044@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51814 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965521Ab2J3TCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 15:02:45 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so920525iea.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 12:02:45 -0700 (PDT)
In-Reply-To: <20121030190032.GB5044@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12-10-30 03:00 PM, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 02:40:04PM -0400, Behan Webster wrote:
>> From: Mark Charlebois <charlebm@gmail.com>
>>
>> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
>> precludes the use of compilers which don't implement VLAIS (for instance the
>> Clang compiler). Since ctx is always a 32-bit CRC, hard coding a size of 4
>> bytes accomplishes the same thing without the use of VLAIS. This is the same
>> technique already employed in fs/ext4/ext4.h
>>
>> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
> That's reasonable, but in order to be safe to make sure we don't
> accidentally introduce a stack overrun bug at some point in the
> future, we should do something like this instead
>
> +	#define JBD_MAX_CHECKSUM_SIZE 4
> 	.
> 	.
> 	.
>
> -		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
> +		char ctx[JBD_MAX_CHECKSUM_SIZE];
> 	.
> 	.
> 	.
> +		BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) >
> + 		       JBD_MAX_CHECKSUM_SIZE);
>
>
> I just like being careful and paranoid; using magic numeric constants
> for buffer sizes is just a scary thing to do.  If you could resubmit
> the patch with this change, I'd really appreciate it.  Thanks!!
A very good idea. Will do. Expect it soon.

Behan

-- 
Behan Webster
behanw@converseincode.com

