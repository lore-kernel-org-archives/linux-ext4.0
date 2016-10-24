From: Richard Weinberger <richard@nod.at>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Mon, 24 Oct 2016 13:59:57 +0200
Message-ID: <cdd8d83f-bdc8-df01-1230-8cfb9ec4c8fb@nod.at>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
 <CA+POJK10M3_GhP_Ge4qkQF4gSNMUXVr5kem9Ak4EDmVRvRUg7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, kzak@redhat.com,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+POJK10M3_GhP_Ge4qkQF4gSNMUXVr5kem9Ak4EDmVRvRUg7g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Michael,

On 19.10.2016 19:36, Michael Halcrow wrote:
> On Wed, Oct 19, 2016 at 4:35 AM, Richard Weinberger <richard@nod.at> wrote:
>> Hi!
>>
>> Since file level encryption has more than one user, currently ext4, f2fs and soon ubifs
>> it would be nice to have a single tool to control fscrypto from userspace.
>>
>> For ext4 we have already at least two tools, one as part of e2fsprogs and another
>> one on github[0]. IMHO the latter one is much more user friendly and intuitive to use.
>> I as unable to find the userspace tool for f2fs.
>>
>> That said, what about implementing such a tool as part of util-linux to control
>> fscrypto? We (David and I) would volunteer.
> 
> While discussing several changes we have staged for release (we're
> trying to minimize churn by batching a large set of format changes all
> at once), we've recently recognized this need on my team and were
> planning on starting work on exactly what you propose.

Can you please some details?
Will it be GPL? Part of util-linux?
What features does it have?
I hope more than just being a wrapper to the ioctls().

Thanks,
//richard

