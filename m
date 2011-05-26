From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: hang in xfstest 204 with dev branch
Date: Thu, 26 May 2011 14:38:09 +0300
Message-ID: <BANLkTinzesK3zJvgtUxuH3rqTZt_O+aBFA@mail.gmail.com>
References: <BANLkTik66Fj7_uHmjsL65j+5s3VQ1_VdoQ@mail.gmail.com>
	<20110525213117.GA9520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55387 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab1EZLiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 May 2011 07:38:11 -0400
Received: by ewy4 with SMTP id 4so225400ewy.19
        for <linux-ext4@vger.kernel.org>; Thu, 26 May 2011 04:38:10 -0700 (PDT)
In-Reply-To: <20110525213117.GA9520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 26, 2011 at 12:31 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, May 25, 2011 at 10:01:38PM +0300, Amir Goldstein wrote:
>>
>> When running xfstests with 4K blocksize, test 204 (Test out ENOSPC
>> flushing on small filesystems)
>> hangs in an interruptible sleep (I can release it with ctrl-C).
>>
>> git bisect points at commit fc0d5c38963ed655e974025c63290563c172038a
>> =A0 =A0 ext4: add flag to ext4_has_free_blocks
>> as the offender.
>
> I found and fixed it. =A0It was a bug I accidently introduced when I =
was
> cleaning up that patches. =A0Try the latest dev branch from the ext4.=
git
> tree....

That works for me.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
