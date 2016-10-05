From: David Gstir <david@sigma-star.at>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization endian-independent
Date: Wed, 5 Oct 2016 11:08:24 +0200
Message-ID: <6AF457D3-BC0E-40B6-844A-8C6B85E5BFBC@sigma-star.at>
References: <1475258329-146528-1-git-send-email-ebiggers@google.com> <CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com> <20161003180340.GA54410@google.com> <6c9b32ef-1e63-f721-1d7f-b0f1e0f2d1ca@nod.at> <20161004163829.GA127921@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Richard Weinberger <richard@nod.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20161004163829.GA127921@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric,

> On 04.10.2016, at 18:38, Eric Biggers <ebiggers@google.com> wrote:
> 
> On Tue, Oct 04, 2016 at 10:46:54AM +0200, Richard Weinberger wrote:
>>> Also, currently this code *is* only supposed to be used for XTS.  There's a bug
>>> where a specially crafted filesystem can cause this code path to be entered with
>>> CTS, but I have a patch pending in the ext4 tree to fix that.
>> 
>> David and I are currently working on UBIFS encryption and we have to support other cipher
>> modes than XTS. So, keeping fscrypto as generic as possible would be nice. :-)
>> 
> 
> The problem was that the kernel supported reading a file whose contents was
> encrypted with CTS, which is only supposed to be used for filenames.  This was
> inconsistent with FS_IOC_SET_ENCRYPTION_POLICY which currently only allows XTS
> for contents and CTS for filenames.  So in other words I wanted to eliminate a
> strange scenario that was not intended to happen and was almost certainly never
> tested.
> 
> Either way, new modes can still be added if there is a good reason to do so.
> What new encryption modes are you thinking of adding, would they be for contents
> or for filenames, and are you thinking they would be offered by all filesystems
> (ext4 and f2fs too)?

We currently have one case where our embedded platform is only able to do AES-CBC in hardware, not AES-XTS. So switching to AES-CBC for file contents would yield far better performance while still being "secure enough".

Generally speaking though, it would be great to have encryption _and_ authentication for file contents. AEAD modes like GCM or future finalists of the CAESAR competition come to mind. IIRC the ext4 encryption design document mentions this, but it's unclear to me why AES-GCM wasn't used for file contents from the beginning. I'd guess it has to do with where to store the authentication tag and performance.
Does anybody have details on that?

Thanks,
David

