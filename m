From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: How can I flush all writes before yanking the power cable?
Date: Thu, 07 Feb 2013 15:29:47 -0600
Message-ID: <51141CCB.9060908@redhat.com>
References: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com> <5113EE8F.2080104@redhat.com> <CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com> <20130207205803.GB28084@thunk.org> <CADzUK1+_2FVpMfKBOBAL4Q0xYiPuOmXRBTfdO-=A=xMONOMeeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030275Ab3BGV3w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Feb 2013 16:29:52 -0500
In-Reply-To: <CADzUK1+_2FVpMfKBOBAL4Q0xYiPuOmXRBTfdO-=A=xMONOMeeQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/7/13 3:28 PM, Autif Khan wrote:
> On Thu, Feb 7, 2013 at 3:58 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Thu, Feb 07, 2013 at 02:37:02PM -0500, Autif Khan wrote:
>>>
>>> That was precisely my ignorance. I did not know about barrier. Adding
>>> it during mount ro and remount rw seems to have fixed these issues.
>>
>> You also didn't say what file system you were using.  Was it ext4?
>> ext3?  ext2?  What kernel version?  On modern kernels barrier is
>> enabled by default for both ext3 and ext4.
> 
> The filesystem is ext4. Kernel version is 3.2.0
> 
> I could not grep -i  barrier in the kernel config. How is barrier
> enabled or disabled in the kernel by default?


in ext4_fill_super():

        if ((def_mount_opts & EXT4_DEFM_NOBARRIER) == 0)
                set_opt(sb, BARRIER);

It's a mount option, not a kernel config option.

-Eric

