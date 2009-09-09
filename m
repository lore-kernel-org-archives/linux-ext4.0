From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: ext4+quota+nfs issue
Date: Wed, 9 Sep 2009 10:45:06 -0700
Message-ID: <150c16850909091045h1962fd67n77c265c9b99c5f44@mail.gmail.com>
References: <4AA5E5F3.30309@primeinteractive.net>
	 <4AA72C14.1020005@primeinteractive.net>
	 <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz>
	 <4AA7C38E.8020306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jiri Kosina <jkosina@suse.cz>,
	Pavol Cvengros <pavol.cvengros@primeinteractive.net>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753555AbZIIRpH@vger.kernel.org>
In-Reply-To: <4AA7C38E.8020306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 9, 2009 at 8:02 AM, Eric Sandeen<sandeen@redhat.com> wrote:
>> On Wed, 9 Sep 2009, Pavol Cvengros wrote:
>>
>>> Hi,
>>>
>>> can somebody who is aware of ext4 and quota have a look on this one?
>>>
>
> This was also just reported at:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=521914
>
> -Eric
>

I've seen exactly the same thing myself as well, but on local I/O.
The only difference I was able to find between filesystems I saw this
on, versus filesystems that I didn't see this on, was how it was
created.  The filesystems without this issue were made using
mkfs.ext4, and the ones that _did_ have the issue were created with
mkfs.ext3, and then mounted -t ext4.  Pavol, can you check your
filesystem features from "dumpe2fs -h [your_device]"?

-Justin
