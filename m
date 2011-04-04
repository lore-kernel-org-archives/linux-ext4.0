From: Jim Meyering <jim@meyering.net>
Subject: Re: [PATCH 6/6] tests: avoid spurious parallel failure due to temporary disk full
Date: Mon, 04 Apr 2011 11:55:29 +0200
Message-ID: <87hbae9w8e.fsf@rho.meyering.net>
References: <1301894021-29180-1-git-send-email-jim@meyering.net>
	<1301894021-29180-7-git-send-email-jim@meyering.net>
	<4D997AAB.3070807@draigBrady.com> <87mxk69yfd.fsf@rho.meyering.net>
	<4D999098.5040502@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: coreutils@gnu.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:56963 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731Ab1DDJzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Apr 2011 05:55:39 -0400
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id E375D9403DC
	for <linux-ext4@vger.kernel.org>; Mon,  4 Apr 2011 11:55:31 +0200 (CEST)
In-Reply-To: <4D999098.5040502@draigBrady.com> (=?iso-8859-1?Q?=22P=E1drai?=
 =?iso-8859-1?Q?g?= Brady"'s message of
	"Mon, 04 Apr 2011 10:34:16 +0100")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

P=E1draig Brady wrote:

> On 04/04/11 10:08, Jim Meyering wrote:
>> P=E1draig Brady wrote:
>>> On 04/04/11 06:13, Jim Meyering wrote:
>>>> From: Jim Meyering <meyering@redhat.com>
>>>>
>>>> Running the new fiemap-empty test uses 600MB of disk space via
>>>> fallocate, and in so doing caused failure in unrelated tests that
>>>> were running in parallel on a small file system.  Rather than
>>>> simply running fallocate (which allocates the space, inducing
>>>> disk full when it fails), skip the test if there is less than
>>>> 800MB of free space, as computed via stat and awk.
>>
>> Thanks for looking.
>>
>>> Oops sorry.
>>> Maybe worth noting is that stat works at a lower level,
>>
>> Not sure what you mean?  Both use statfs.
>
> Oops right. df uses f_bavail, so perhaps it might
> be better to use %a rather than %f with `stat`?

Oh, yes.  Definitely.
I had thought I was using that one,
but had skimmed the descriptions too quickly (I spotted "superuser"
in the description of %a, so went with %f ;-).
Thanks!

I may adjust stat --help's description of %f to say this:

  %a   Free blocks available to non-superuser
  %f   Free blocks in file system (available to superuser)

> This fallocate() behavior is annoying anyway,
> as I'm not sure when it's useful, except for
> filling up a file system.
> It seems like a this would be useful.
>
> #define FALLOC_FL_FULL_SIZE     0x03 /* allocate all or nothing */

Good idea.
I read fallocate's manual looking for a command-line option
like that when I realized that its behavior was at the root
of my non-deterministic test failures.

Sounds like it'd make a good new option, if not the default.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
