From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fiemap is broken for sparse file in ext4?
Date: Fri, 11 Jun 2010 11:56:11 -0500
Message-ID: <4C126AAB.4040802@redhat.com>
References: <4C119C2E.2090801@oracle.com>	<4C11B6D8.8070909@redhat.com>	<4C11C41C.9070000@oracle.com>	<4C125A6C.2090805@redhat.com> <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tao Ma <tao.ma@oracle.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim9xIyL842wapccPIwEPVgd3BY8_r0tBGfGgvOt@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Greg Freemyer wrote:
> On Fri, Jun 11, 2010 at 11:46 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Tao Ma wrote:
>>
>>>> What are you using to call fiemap?  Here it seems to be working:
>>> I just wrote a simple test program by calling ioctl. It is attached.
>>> btw, you need to call it immediately after dd so that we have a chance
>>> that ext4 don't have time to allocate extents. ;)
>> OK I take it back, I do see it.  *cough* too many different filesystems
>> on this box ... ;)
>>
>> Yes, it does look like a bug.
>>
>> -Eric
> 
> I'm not clear how this is supposed to work.
> 
> Is this just a userspace bug in that FIEMAP_FLAG_SYNC is needed in the
> fiemap call, or is there a kernel bug as well?

The flag is optional, though maybe filefrag should use it.

Without it, we should get the proper logical offset and a delalloc-flagged
extent returned

> If fiemap is called with the FIEMAP_FLAG_SYNC flag is there currently a problem?

yep, we should get one delalloc extent in the results and we don't.

-Eric

> Thanks
> Greg
