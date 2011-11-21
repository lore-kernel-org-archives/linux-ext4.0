From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH v2] ext4: group info caches set to SLAB_MEM_SPREAD flags.
Date: Mon, 21 Nov 2011 10:09:14 +0530
Message-ID: <CADDb1s09iOvVUNJCLEzWu=7yykhNBhqTKpWRV_H7rP-UO8-gUw@mail.gmail.com>
References: <1321747359-1919-1-git-send-email-linkinjeon@gmail.com>
	<CAKYAXd_YXUymFjbxgXwV+pXJNvPhq-W_Pi96mU3NodO3yyNTrg@mail.gmail.com>
	<20111120183846.GB12868@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, NamJae Jeon <linkinjeon@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41028 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1KUEjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Nov 2011 23:39:16 -0500
In-Reply-To: <20111120183846.GB12868@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

=46irst of all extremely sorry for causing you inconvenience and making
you use of your time to review such trivial patches.

Yes, we are part of some company and we were looking for Ext4 as the
next big thing and looking forward to adopting that. We really need
complete understanding of Ext4 to stand out and gain confidence
ourselves first. We started with the initial anlalysis of Ext4 and
side-by-side looking at the source code.
As far as submitting patch is concerned - yes, It was part of our
learning curve - that we started the comparision.

In the past, I have literally focussed on our runtime environment and
raised issues. This was the firsttime - that there was something we
saw for code submission(may be just out of our childish curiosity).

I will make sure that there is no more inconvenience of that sort.

Thanks & Regards,
Amit Sahrawat


On Mon, Nov 21, 2011 at 12:08 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Nov 20, 2011 at 02:45:32PM +0900, NamJae Jeon wrote:
>> This patch is not really meaningful ? or you need to see performance
>> data although cpuset mem spread flags patch is proved before.
>> I am waiting for your decision.
>
> I don't think it's really going to make much of a difference, to be
> honest. =A0It's probably technically a little better, but at the end =
of
> the day, it's not really worth the tiny amount of effort to process
> the patch.
>
> I put it in the same category as people who like to remove whitespace=
s
> from files or remove unused variables. =A0It marginally makes the cod=
e a
> tiny amount better, but at the moment, review bandwidth in the ext4
> subsystem is a critically tight resource, and in terms of the grand
> scheme of things, there are higher priority things that I need to
> worry about, as opposed to people constantly resending trivial patche=
s
> and demanding a decision.
>
> So let me ask a counter question --- why are you sending these
> patches? =A0Especially when you don't even have a system that would
> benefit from such changes? =A0Is it just ego to have your name in the
> kernel, or to be counted amongst kernel developers? =A0Is this a warm=
 up
> because you'd like to do more substantive work in ext4, or other part=
s
> of the kernel? =A0Is this a University exercise? =A0And if you're fro=
m a
> company, which company, and what's your interest in ext4? =A0I
> understand how Whamcloud uses ext4, and how the Android folks are
> using ext4, and to a lesser extent how Tao Bao is using ext4, and tha=
t
> helps me understand where they are going with ext4 and why they submi=
t
> the kind of patches that they do.
>
> But I don't understand why *you* are submitting these sorts of
> patches. =A0If there's substantive work that you plan to do with ext4=
,
> then the investment I might make in helping you become more proficien=
t
> ext4 developers is quite different from say, the sort of attention I
> might give someone who is working on ext4 for a class project or for
> ego reasons.
>
> Best regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
