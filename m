From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Fri, 8 Jul 2011 09:11:53 +0300
Message-ID: <CAOQ4uxgWCn2u5gbkPRAwf1vsJrADLXA8+aj2Yq_CZheDTMu24w@mail.gmail.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
	<CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
	<4E14CE15.90404@linux.vnet.ibm.com>
	<CAOQ4uxh4iUKjDgCBV54VxZ4PhDi18aqL3O6YHOoMYrHyXcECiA@mail.gmail.com>
	<2DE49B61-CC67-4613-99EB-88601D6EC564@dilger.ca>
	<4E1614C1.1050209@linux.vnet.ibm.com>
	<CAOQ4uxiV+h3G7vPZtZp0afbhek8uAP0gER+H7yS9xdrr_XBmVw@mail.gmail.com>
	<7AE9DA58-62BA-4FE9-B4C0-AEB6D46DB096@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41827 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1GHGLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2011 02:11:54 -0400
Received: by wwg11 with SMTP id 11so259893wwg.1
        for <linux-ext4@vger.kernel.org>; Thu, 07 Jul 2011 23:11:53 -0700 (PDT)
In-Reply-To: <7AE9DA58-62BA-4FE9-B4C0-AEB6D46DB096@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 8, 2011 at 5:46 AM, Andreas Dilger <adilger@dilger.ca> wrot=
e:
> On 2011-07-07, at 6:09 PM, Amir Goldstein wrote:
>> On Thu, Jul 7, 2011 at 11:19 PM, Allison Henderson
>> <achender@linux.vnet.ibm.com> wrote:
>>>
>>> Ah, ok then. =A0Yes, part of the requirements was to make secure de=
lete work
>>> for partial truncates, punch hole, and also indexed files. =A0So th=
at will
>>> save me some time if I can get the migrate routines work. =A0Thx fo=
r the
>>> pointers all!
>>
>> I realized that there is a basic flaw in the concept of deferred-sec=
ure-delete.
>> From a security point of view, after a crash during a secure-delete,
>> if the file is not there, all its data should have been wiped.
>> Orphan cleanup on the next mount may be done on a system that
>> doesn't respect secure delete.
>> So for real security, the unlink/truncate command cannot return befo=
re
>> all data is wiped.
>
> I don't necessarily agree. =A0People who are using secure delete don'=
t
> necessarily want their performance to go into the toilet, which is wh=
at
> would happen if each unlink/zero happened sequentially. =A0It is far =
more
> efficient to submit a large batch of unlink/zero operations and then =
do
> an sync() or fsync() at the end. =A0This allows multiple journal oper=
ations
> to be coalesced (e.g. unlinks from directory) and block zero requests=
 to
> be merged.
>
>> The unlink/truncate metadata changes must not even be committed
>> before all data is wiped (or at least part of the data with partial =
truncate).
>
> That depends on the user, I think. =A0If someone does "rm -r {dir}" i=
t may
> be better that the files are removed from the namespace more quickly,=
 and
> secure deleted (in a batch) more quickly, than having "rm" wait for e=
ach
> file to be unlinked and maybe leave files in the namespace that didn'=
t
> even get a chance to be unlinked.
>

if my system crashes in the middle of "rm -rf my_darkest_secrets/"
I want to be able to see if there are leftovers after reboot, therefore
the directory and files cannot be removed from namespace before
I get the secured delete guaranty.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
