From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Slowness on ext4 master branch (Was: The new ext4 git tree re-org)
Date: Mon, 16 May 2011 17:48:49 +0300
Message-ID: <BANLkTimqL40+Tu67Fb705iciuY2XBwEpYA@mail.gmail.com>
References: <BANLkTi=ZgVsPRKE8tQZ=s6qjTLuYopMBBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46772 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab1EPOsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 May 2011 10:48:50 -0400
Received: by ewy4 with SMTP id 4so1267928ewy.19
        for <linux-ext4@vger.kernel.org>; Mon, 16 May 2011 07:48:49 -0700 (PDT)
In-Reply-To: <BANLkTi=ZgVsPRKE8tQZ=s6qjTLuYopMBBg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 14, 2011 at 9:49 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Wed, May 11, 2011 at 9:59 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Tue, May 10, 2011 at 4:56 PM, Theodore Ts'o <tytso@mit.edu> wrote=
:
>>>
>>> I've uploaded an updated dev branch to the ext4 tree. =A0Compared t=
o the
>>> previous version of dev branch, I've removed my modified version of
>>> Allison's "NULL pointer when make_indexed_dir returns -ENOSPC" patc=
h,
>>> and I've added Amir's alloc_semp removal patches. =A0I'm still in t=
he
>>> process of reviewing those patches; I've included them to make it e=
asier
>>> for I and others to test them.
>>>
>>
>> I have a general question regarding testing for next merge window.
>> What kernel do you usually use when testing the dev branch?
>> I started writing an xfstest to test online resize and filesystem
>> filling in parallel, based on test 224 (Delayed allocation at ENOSPC=
 test).
>> I started running test 224 on a kernel built from ext4/master
>> and it seemed to run too slow. looking at the waiting tasks
>> it looked like it could be related to I/O less throttling.
>> Since ext4/master is based on 2.6.39-rc3, I figured maybe I am runni=
ng
>> a buggy kernel, so I merged 2.6.39-rc7 to ext4/master to build a new=
 kernel.
>>
>> Am I going in the right direction at all?
>> I have a dedicated server for tests (X64_64 quad core), so it you wo=
uld
>> like me to run some xfstest runs with specific configuration, or cer=
tain
>> patches applied, please let me know.
>>
>>
>
> So now that I know I am not hearing voices, I guess test 224 is also =
too new
> to be tested by many people.
> The good news is that test 224 runs smoothly on kernel 2.6.39-rc7.
> on ext4 master branch is either hung or took too long time for me to =
wait.
> I will try to find the offending commit on Monday.

I couldn't reproduce this.

>
> Amir.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
