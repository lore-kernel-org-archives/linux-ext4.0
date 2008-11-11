From: "=?ISO-8859-1?Q?Cindy_Rubio_Gonz=E1lez?=" <crubio@cs.wisc.edu>
Subject: Re: Error Propagation bugs in ext4
Date: Tue, 11 Nov 2008 09:19:28 -0600
Message-ID: <adb1f7050811110719y382eb063id79e6a7912da9f24@mail.gmail.com>
References: <adb1f7050810311819s3ea0b8f1mbb4239b108f34c4e@mail.gmail.com>
	 <adb1f7050811041014r5be96821ie938c313aaf48334@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: adilger@clusterfs.com, cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:56525 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbYKKPT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2008 10:19:29 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1513733wah.21
        for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 07:19:28 -0800 (PST)
In-Reply-To: <adb1f7050811041014r5be96821ie938c313aaf48334@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

I am Ph.D. student at the University of Wisconsin-Madison and I
submitted some error-propagation bug reports a few days back. We were
wondering whether anyone has had the chance to look at some of these
reports. We are submitting this work for conference publication this
=46riday, November 14th. It would be really great to hear your
comments!! We are really excited to know how many of the reports are
true bugs and how serious these bugs are (even if the bugs have not
been fixed yet). Our deadline is close and we understand this
information may not be available yet, but please feel free to send us
any other general comments you may have.

Please let me know if you have any questions. Thank you!
Cindy

On Tue, Nov 4, 2008 at 12:14 PM, Cindy Rubio Gonz=E1lez
<crubio@cs.wisc.edu> wrote:
> Hi everyone,
>
> This is a follow-up to the e-mail sent a couple of days ago reporting
> some error-propagation bugs found using static analysis. We have 100
> additional unsaved-error reports:
>
> Total number of reports: 135
> Overwritten errors: 3
> Unsaved errors: 1
> Out-of-scope errors: 131
>
> I have attached the new ext4.summ and ext4.complete. We have manually
> inspected each unsaved-error report and we are now providing more
> information hoping it is easier and faster for you to determine
> whether they are indeed bugs. We have grouped unsaved-error reports b=
y
> callee in the ext4.summ file. For example, you can find:
>
> mpage_da_submit_io
> fs/ext4/inode.c:1903: potential non-tentative unchecked error is not =
saved
> fs/ext4/inode.c:1946: potential non-tentative unchecked error is not =
saved
> fs/ext4/inode.c:2050: potential non-tentative unchecked error is not =
saved
>
> Here there are three calls to mpage_da_submit_io where the error code
> returned is not saved.
>
> We have found that there are functions for which half of the callers
> save the error whereas the other half don't. This implies that the
> returned error code is somewhat important. However, we also know that
> there are cases where it is "okay" to neglect the error code. An
> example of this big inconsistency is the function "ext4_journal_stop"=
=2E
>
> It would be great to know what is your opinion on this matter.
> a) It is so common such that this type of inconsistency will always b=
e
> present in the future?
> b) It is bad. All callers should check the returned error code
> regardless of being in the exit path?
>
> Please let us know if you have any questions. It would be great if yo=
u
> could mark those reports found to be true bugs. This would help us to
> understand the sources of false positives and improve our tool. Also,
> it would be great to get any feedback, even if the bugs have not been
> fixed yet.
>
> Thank you very much for your time,
> Cindy
>
>
> On Fri, Oct 31, 2008 at 7:19 PM, Cindy Rubio Gonz=E1lez
> <crubio@cs.wisc.edu> wrote:
>> Hi,
>>
>> I am a graduate student at the University of Wisconsin-Madison. My
>> advisor (Prof. Ben Liblit) and I have been working on performing
>> static analysis to find error propagation bugs in Linux file system
>> implementations. ext4 is one of our case studies. We consider three
>> general scenarios in which unchecked error are commonly lost: the
>> variable holding the unchecked error value (1) is overwritten with a
>> new value, (2) goes out of scope, or (3) is returned by a function b=
ut
>> not saved by the caller. Our tool produces detailed witness traces
>> that illustrate each bug reported.
>>
>> We have results for Linux 2.6.27. Our tool has produced 35 bug
>> reports for ext4:
>>
>> Total number of reports: 35
>> Overwritten errors: 3
>> Unsaved errors: 1
>> Out-of-scope errors: 31
>>
>> Attached are two files with the results.
>>
>> ext4.summ includes the file and line number at
>> which an error may be dropped (and the classification: overwritten,
>> out of scope or unsaved).
>>
>> Example:
>> fs/ext4/extents.c:2078: overwriting potential non-tentative unchecke=
d
>> error in "err"
>>
>> ext4.complete - this file contains traces for each of the bugs
>> included in ext4.summ. There is a full trace and a slice (a trace
>> including only those lines relevant to the propagation of the error)=
=2E
>> The full trace and slice for each bug are separated by "=3D=3D=3D=3D=
".
>>
>> Example:
>> Full trace:
>> fs/jbd2/transaction.c:105:"ret" receives an error from "TENTATIVE_EN=
OMEM"
>> fs/jbd2/transaction.c:106:"ret" may have an unchecked error
>> fs/jbd2/transaction.c:239:"ret" may have an unchecked error
>> fs/jbd2/transaction.c:239:"ret" may have an unchecked error
>> fs/jbd2/transaction.c:239:"ret" may have an unchecked error
>> fs/jbd2/transaction.c:239:"ret" may have an unchecked error
>> fs/jbd2/transaction.c:241: an unchecked error may be returned
>> fs/jbd2/transaction.c:427:"ret" receives an error from function
>> "start_this_handle"
>> fs/jbd2/transaction.c:428: an unchecked error may be returned
>> fs/ext4/ext4_jbd2.h:188:"cabs2cil_" receives an error from function
>> "jbd2_journal_restart"
>> fs/ext4/ext4_jbd2.h:188: an unchecked error may be returned
>> fs/ext4/extents.c:104:"cabs2cil_" receives an error from function
>> "ext4_journal_restart"
>> fs/ext4/extents.c:104: an unchecked error may be returned
>> fs/ext4/extents.c:1933:"err" receives an error from function
>> "ext4_ext_journal_restart"
>> fs/ext4/extents.c:1934:"err" may have an unchecked error
>> fs/ext4/extents.c:1935:"err" may have an unchecked error
>> fs/ext4/extents.c:1980: an unchecked error may be returned
>> fs/ext4/extents.c:2040:"err" receives an error from function "ext4_e=
xt_rm_leaf"
>> fs/ext4/extents.c:2042:"err" may have an unchecked error
>> include/linux/buffer_head.h:270:"err" may have an unchecked error
>> fs/ext4/extents.c:2043:"err" may have an unchecked error
>> fs/ext4/extents.c:2044:"err" may have an unchecked error
>> fs/ext4/extents.c:2045:"err" may have an unchecked error
>> fs/ext4/extents.c:2037:"err" may have an unchecked error
>> fs/ext4/extents.c:2037:"err" may have an unchecked error
>> fs/ext4/extents.c:2037:"err" may have an unchecked error
>> fs/ext4/extents.c:2038:"err" may have an unchecked error
>> fs/ext4/extents.c:2049:"err" may have an unchecked error
>> fs/ext4/extents.c:2054:"err" may have an unchecked error
>> fs/ext4/extents.c:2056:"err" may have an unchecked error
>> fs/ext4/extents.c:2057:"err" may have an unchecked error
>> fs/ext4/extents.c:2069:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1992:"err" may have an unchecked error
>> fs/ext4/extents.c:1999:"err" may have an unchecked error
>> fs/ext4/extents.c:2001:"err" may have an unchecked error
>> fs/ext4/extents.c:2069:"err" may have an unchecked error
>> fs/ext4/extents.c:2069:"err" may have an unchecked error
>> fs/ext4/extents.c:2074:"err" may have an unchecked error
>> fs/ext4/extents.c:2074:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> fs/ext4/extents.c:68:"err" may have an unchecked error
>> fs/ext4/extents.c:69:"err" may have an unchecked error
>> fs/ext4/extents.c:70:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> include/linux/buffer_head.h:281:"err" may have an unchecked error
>> fs/buffer.c:1443:"err" may have an unchecked error
>> include/linux/buffer_head.h:281:"err" may have an unchecked error
>> include/linux/buffer_head.h:281:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> fs/ext4/extents.c:2076:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2081:"err" may have an unchecked error
>> fs/ext4/extents.c:2085:"err" may have an unchecked error
>> fs/ext4/ext4_extents.h:176:"err" may have an unchecked error
>> fs/ext4/extents.c:2085:"err" may have an unchecked error
>> fs/ext4/extents.c:2085:"err" may have an unchecked error
>> fs/ext4/extents.c:2085:"err" may have an unchecked error
>> fs/ext4/extents.c:2085:"err" may have an unchecked error
>> fs/ext4/extents.c:2085:"err" may have an unchecked error
>> fs/ext4/extents.c:2090:"err" may have an unchecked error
>> fs/ext4/extents.c:2094:"err" may have an unchecked error
>> fs/ext4/extents.c:2095:"err" may have an unchecked error
>> fs/ext4/extents.c:2037:"err" may have an unchecked error
>> fs/ext4/extents.c:2037:"err" may have an unchecked error
>> fs/ext4/extents.c:2037:"err" may have an unchecked error
>> fs/ext4/extents.c:2038:"err" may have an unchecked error
>> fs/ext4/extents.c:2049:"err" may have an unchecked error
>> fs/ext4/extents.c:2054:"err" may have an unchecked error
>> fs/ext4/extents.c:2056:"err" may have an unchecked error
>> fs/ext4/extents.c:2057:"err" may have an unchecked error
>> fs/ext4/extents.c:2069:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1990:"err" may have an unchecked error
>> fs/ext4/extents.c:1992:"err" may have an unchecked error
>> fs/ext4/extents.c:1999:"err" may have an unchecked error
>> fs/ext4/extents.c:2001:"err" may have an unchecked error
>> fs/ext4/extents.c:2069:"err" may have an unchecked error
>> fs/ext4/extents.c:2069:"err" may have an unchecked error
>> fs/ext4/extents.c:2074:"err" may have an unchecked error
>> fs/ext4/extents.c:2074:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> fs/ext4/extents.c:68:"err" may have an unchecked error
>> fs/ext4/extents.c:69:"err" may have an unchecked error
>> fs/ext4/extents.c:70:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> include/linux/buffer_head.h:281:"err" may have an unchecked error
>> fs/buffer.c:1443:"err" may have an unchecked error
>> include/linux/buffer_head.h:281:"err" may have an unchecked error
>> include/linux/buffer_head.h:281:"err" may have an unchecked error
>> fs/ext4/extents.c:2075:"err" may have an unchecked error
>> fs/ext4/extents.c:2076:"err" may have an unchecked error
>> fs/ext4/extents.c:2076:"err" may have an unchecked error
>> fs/ext4/extents.c:2078: overwriting potential non-tentative unchecke=
d
>> error in "err"
>>
>> Slice:
>> fs/jbd2/transaction.c:105:"ret" receives an error from "TENTATIVE_EN=
OMEM"
>> fs/jbd2/transaction.c:241: an unchecked error may be returned
>> fs/jbd2/transaction.c:427:"ret" receives an error from function
>> "start_this_handle"
>> fs/jbd2/transaction.c:428: an unchecked error may be returned
>> fs/ext4/ext4_jbd2.h:188:"cabs2cil_" receives an error from function
>> "jbd2_journal_restart"
>> fs/ext4/ext4_jbd2.h:188: an unchecked error may be returned
>> fs/ext4/extents.c:104:"cabs2cil_" receives an error from function
>> "ext4_journal_restart"
>> fs/ext4/extents.c:104: an unchecked error may be returned
>> fs/ext4/extents.c:1933:"err" receives an error from function
>> "ext4_ext_journal_restart"
>> fs/ext4/extents.c:1980: an unchecked error may be returned
>> fs/ext4/extents.c:2040:"err" receives an error from function "ext4_e=
xt_rm_leaf"
>> fs/ext4/extents.c:2078: overwriting potential non-tentative unchecke=
d
>> error in "err"
>> =3D=3D=3D=3D
>>
>> Any feedback will be greatly appreciated (we will be submitting this
>> work for conference publication in two weeks). Please let us know if
>> you
>> have any questions.
>>
>> Thank you very much for your time!
>> Cindy
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
