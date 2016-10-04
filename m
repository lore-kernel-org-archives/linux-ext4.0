From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Tue, 4 Oct 2016 09:38:29 -0700
Message-ID: <20161004163829.GA127921@google.com>
References: <1475258329-146528-1-git-send-email-ebiggers@google.com>
 <CAFLxGvyCHwWms8wJf1gU0hRj__Q0Z2F2wKuZ3sYNfp8wQ9S4PQ@mail.gmail.com>
 <20161003180340.GA54410@google.com>
 <6c9b32ef-1e63-f721-1d7f-b0f1e0f2d1ca@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, jaegeuk@kernel.org,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c9b32ef-1e63-f721-1d7f-b0f1e0f2d1ca@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 04, 2016 at 10:46:54AM +0200, Richard Weinberger wrote:
> > Also, currently this code *is* only supposed to be used for XTS.  There's a bug
> > where a specially crafted filesystem can cause this code path to be entered with
> > CTS, but I have a patch pending in the ext4 tree to fix that.
> 
> David and I are currently working on UBIFS encryption and we have to support other cipher
> modes than XTS. So, keeping fscrypto as generic as possible would be nice. :-)
> 

The problem was that the kernel supported reading a file whose contents was
encrypted with CTS, which is only supposed to be used for filenames.  This was
inconsistent with FS_IOC_SET_ENCRYPTION_POLICY which currently only allows XTS
for contents and CTS for filenames.  So in other words I wanted to eliminate a
strange scenario that was not intended to happen and was almost certainly never
tested.

Either way, new modes can still be added if there is a good reason to do so.
What new encryption modes are you thinking of adding, would they be for contents
or for filenames, and are you thinking they would be offered by all filesystems
(ext4 and f2fs too)?

Eric
