From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: nowait aio return value
Date: Wed, 26 Jul 2017 16:19:34 -0500
Message-ID: <08dcc9f7-2460-c262-3194-062a25052bc3@suse.de>
References: <04be5a78-3428-c09e-bc63-5061fa568ea5@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: jack@suse.cz, axboe@kernel.dk, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <04be5a78-3428-c09e-bc63-5061fa568ea5@akamai.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jason,

On 07/26/2017 01:45 PM, Jason Baron wrote:
> Hi,
> 
> In testing nowait aio on ext4, I found that when appending to a file
> the return value is EAGAIN/EWOULDBLOCK, because as mentioned in the
> commit this will potentially trigger an allocation. However, the EAGAIN,
> seems somewhat misleading to me, in that if I continuously try the
> write, it will never succeed.
> 
> The relevant commit is:
> 728fbc0 ext4: nowait aio support
> 
> As you can see there, failure to get the inode lock is treated as
> EAGAIN, which seems more appropriate to me, as its very likely
> to succeed on subsequent calls.
> 
> Perhaps, it could be switched to -EINVAL, or something else?
> 

Thanks for testing this.

I would suggest read it as -EWOULDBLOCK. The idea is to pass on
IOCB_NOWAIT when we don't want the I/O process to wait, and if it does
return -EWOULDBLOCK. If it returns EWOULDBLOCK in case of allocation,
you may want to allocate your file space before performing the I/O.

I would return EINVAL in case the parameters passed are incorrect.

-- 
Goldwyn
