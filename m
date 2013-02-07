From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: How can I flush all writes before yanking the power cable?
Date: Thu, 7 Feb 2013 16:28:01 -0500
Message-ID: <CADzUK1+_2FVpMfKBOBAL4Q0xYiPuOmXRBTfdO-=A=xMONOMeeQ@mail.gmail.com>
References: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com>
	<5113EE8F.2080104@redhat.com>
	<CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
	<20130207205803.GB28084@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:48487 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398Ab3BGV2E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 16:28:04 -0500
Received: by mail-la0-f51.google.com with SMTP id fo13so3145180lab.38
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 13:28:01 -0800 (PST)
In-Reply-To: <20130207205803.GB28084@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 7, 2013 at 3:58 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Feb 07, 2013 at 02:37:02PM -0500, Autif Khan wrote:
>>
>> That was precisely my ignorance. I did not know about barrier. Adding
>> it during mount ro and remount rw seems to have fixed these issues.
>
> You also didn't say what file system you were using.  Was it ext4?
> ext3?  ext2?  What kernel version?  On modern kernels barrier is
> enabled by default for both ext3 and ext4.

The filesystem is ext4. Kernel version is 3.2.0

I could not grep -i  barrier in the kernel config. How is barrier
enabled or disabled in the kernel by default?
