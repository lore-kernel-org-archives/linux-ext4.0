From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Wed, 5 Oct 2016 23:18:37 +0200
Message-ID: <b38b2f9b-a598-f2ee-65d2-e89a08bc3129@nod.at>
References: <20161005170659.GA110549@google.com>
 <20161005182307.GA1164@google.com>
 <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
 <20161005211157.GB1164@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: David Gstir <david@sigma-star.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Anand Jain <anand.jain@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161005211157.GB1164@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Michael,

On 05.10.2016 23:11, Michael Halcrow wrote:
>>> In the meantime, to address the CBC thing, I'd want to understand what
>>> the hardware is doing exactly.  I wouldn't want the existence of code
>>> that supports CBC in fs/crypto to be interpreted as some sort of
>>> endorsement for using it rather than XTS (when unauthenticated
>>> encryption is for some reason the only viable option) for new storage
>>> encryption applications.
>>
>> The hardware offers AES-CBC, accessible via the kernel crypto API.
> 
> I presume your goal is to usually package up relatively large segments
> of data you'd like to chain together under one key/IV?

Yes. That's the plan.

> Else, for random-access block storage, I would like to get on idea on
> what the latency/throughput/power impact would be vs. just doing
> AES-XTS on the CPU.

Hopefully I can report some results soon. :-)

> Regardless, if you need IV generation in fs/crypto, you can use ESSIV
> from eCryptfs as an example.  Except you'll probably want to use
> SHA-256 instead of MD5, if only for the sake of hygiene.

Thanks for the pointer.

Thanks,
//richard
