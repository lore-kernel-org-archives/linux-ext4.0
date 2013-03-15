From: zhuyj <zyjzyj2000@gmail.com>
Subject: Re: Ext4:can not rm directories on 2.6.3x
Date: Fri, 15 Mar 2013 15:16:52 +0800
Message-ID: <5142CAE4.3070400@gmail.xom>
References: <CAAO_Xo5g2LR54ry=SU7UhGbv-chdkdd6foq+-LjnuE8yAj8ikg@mail.gmail.com> <513EDC2B.9020604@gmail.xom> <20130312134229.GJ18595@thunk.org> <513FF163.7080606@gmail.xom>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: zhuyj <zyjzyj2000@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f170.google.com ([209.85.160.170]:60544 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3COHYK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2013 03:24:10 -0400
Received: by mail-gh0-f170.google.com with SMTP id g14so555548ghb.29
        for <linux-ext4@vger.kernel.org>; Fri, 15 Mar 2013 00:24:09 -0700 (PDT)
In-Reply-To: <513FF163.7080606@gmail.xom>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, all

The two patches can fix this problem.
ext4: Fix fs corruption when make_indexed_dir() fails
ext4: don't dereference null pointer when make_indexed_dir() fails

If any one comes across this problem, he can apply the above two patches.

Zhuyj

On 03/13/2013 11:24 AM, zhuyj wrote:
> OK. Thanks a lot.
> This bug can happen on Ubuntu 11.04,10.10 with kernel 2.6.3x.
> Follow the above steps, this bug can be reproduced.
>
> Anyone has the same experience?
>
> On 03/12/2013 09:42 PM, Theodore Ts'o wrote:
>> On Tue, Mar 12, 2013 at 03:41:31PM +0800, zhuyj wrote:
>>> If I use kernel>=3.0, this will not occur.
>> Sounds like this is a problem in 2.6.39 that has since been fixed in
>> newer kernels.
>>
>>> So is this is a bug?
>> Sure looks like it's a bug.  :-)
>>
>> There are so many distributions and other old embedded systems, etc.,
>> using older kernels that there's just no way that upstream developers
>> can try to debug every single older kernel --- and 2.6.39 isn't even a
>> kernel that is being supported by a volunteer as a long-term supported
>> kernel.
>>
>> See http://www.kernel.org for a list of kernels which are supported as
>> long-term kernels, and even then, please remember that unless fixes
>> are automatically backported, or someone manually backports a fix that
>> doesn't automatically apply to an older kernel, it's not going to
>> happen.....
>>
>> Regards,
>>
>>                     - Ted
>>
>> P.S.  Your problem appears to be completely unrelated to the thread
>> which you replied to.  This makes it hard for us to keep track of
>> questions/bug reports which users submit.
>>
>
>

