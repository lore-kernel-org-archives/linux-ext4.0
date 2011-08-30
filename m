From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH 3 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Wed, 31 Aug 2011 00:07:24 +0200
Message-ID: <4E5D5F1C.3020502@fastmail.fm>
References: <20110816115404.1810393.47239.stgit@localhost.localdomain> <20110816115414.1810393.92169.stgit@localhost.localdomain> <20110819222951.GC3578@thunk.org> <8B32DE36-9AD0-4418-86D8-4E453AA910DB@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
	linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	bfields@fieldses.org, hch@infradead.org, yong.fan@whamcloud.com,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <8B32DE36-9AD0-4418-86D8-4E453AA910DB@whamcloud.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/20/2011 08:23 AM, Andreas Dilger wrote:
> On 2011-08-19, at 4:29 PM, Ted Ts'o wrote:
>> On Tue, Aug 16, 2011 at 01:54:14PM +0200, Bernd Schubert wrote:
>>> +static inline int is_32bit_api(void)
>>> +{
>>> +#ifdef HAVE_IS_COMPAT_TASK
>>> +	return is_compat_task();
>>> +#else
>>> +	return (BITS_PER_LONG == 32);
>>> +#endif
>>
>> I assume is_compat_task() is coming from another patch?  What is the
>> status of that change?
>
> No, is_compat_task() is upstream for most (all?) of the architectures
> that support hybrid 32-/64-bit operation.  It is set at 32-bit syscall
> entry when running on 64-bit architectures.
>
> The only minor error in this patch (fixed with a new version from Bernd)
> is that this should be under CONFIG_COMPAT instead of HAVE_IS_COMPAT_TASK.

Yes sorry again about this. Could you please see patch series v4 please?

>
>> In the case where is_compat_task() is not defined, we can't just test
>> based on BITS_PER_LONG == 32, since even on an x86_64 machine, it's
>> possible we're running a 32-bit binary in compat mode....
>
> It is definitely available on x86_64.

Yep, otherwise it even wouldn't compile, at least not with patch series v4.


Thanks,
Bernd
