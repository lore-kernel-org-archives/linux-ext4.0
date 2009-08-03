From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Mon, 03 Aug 2009 17:21:30 -0500
Message-ID: <4A7762EA.5070701@sandeen.net>
References: <4A74584D.2010300@rtr.ca> <4A7722DF.80704@rtr.ca> <4A7725AF.6090106@redhat.com> <4A775FB9.80600@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755012AbZHCWVb@vger.kernel.org>
In-Reply-To: <4A775FB9.80600@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mark Lord wrote:
> Eric Sandeen wrote:
>> Mark Lord wrote:
>>> (resending, no ack from anyone first time around).
>> I had previously sent a fix for this to the ext4 list as well, although
>> w/o the added case for compat_ioctl or the extra #include.
>>
>> Because this ioctl should be 100% compat everywhere, I don't -think-
>> it's needed, and
>>
>> http://marc.info/?l=linux-ext4&m=124872536713005&w=2
>>
>> suffices....
> ..
> 
> Well, whichever of the two works best for the maintainers.
> 
> We need *something* for it upstream, and probably back in -stable too.
> Otherwise this prevents using 64-bit kernels on 32-bit userland,
> as Linus likes to recommend so often.  ;)
> 
> Cheers
> 

Heh, it's probably far from the only ioctl missing a compat handler, but
yeah.  :)

-Eric
