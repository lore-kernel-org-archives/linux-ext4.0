From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Tue, 4 Oct 2016 10:46:54 +0200
Message-ID: <6c9b32ef-1e63-f721-1d7f-b0f1e0f2d1ca@nod.at>
References: <1475258329-146528-1-git-send-email-ebiggers@google.com>
 <CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com>
 <20161003180340.GA54410@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161003180340.GA54410@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric,

On 03.10.2016 20:03, Eric Biggers wrote:
>>>  {
>>> -       u8 xts_tweak[FS_XTS_TWEAK_SIZE];
>>> +       struct {
>>> +               __le64 index;
>>> +               u8 padding[FS_XTS_TWEAK_SIZE - sizeof(__le64)];
>>> +       } xts_tweak;
>>
>> While we are here, wouldn't it make sense to rename the variable to "iv"?
>> In aes-xts mode the IV is used as tweak. But it is still an IV and passed
>> as IV parameter to the crypto API.
>>
>> Especially when other cipher modes are used this is confusing.
>>
> 
> Good idea --- I agree that "iv" is a better name, so as to not tie the code to
> XTS specifically.  But I think the renaming should be a separate patch.

Sure. I can do that.

> Also, currently this code *is* only supposed to be used for XTS.  There's a bug
> where a specially crafted filesystem can cause this code path to be entered with
> CTS, but I have a patch pending in the ext4 tree to fix that.

David and I are currently working on UBIFS encryption and we have to support other cipher
modes than XTS. So, keeping fscrypto as generic as possible would be nice. :-)

Thanks,
//richard
