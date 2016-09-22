From: Richard Weinberger <richard@nod.at>
Subject: Re: fscrypt: in-place decrypt vs. out-of-place encrypt?
Date: Thu, 22 Sep 2016 16:13:41 +0200
Message-ID: <5bac3219-9a76-3828-c6bb-e26bad4752fa@nod.at>
References: <f3f489f1-3ec0-e8c8-d5ae-ea6b9e5d5571@nod.at>
 <20160922131409.k3da62qznmgjucpx@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        David Gstir <david@sigma-star.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160922131409.k3da62qznmgjucpx@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,

On 22.09.2016 15:14, Theodore Ts'o wrote:
> On Thu, Sep 22, 2016 at 10:49:41AM +0200, Richard Weinberger wrote:
>>
>> While reading the fscrypt code I noticed that some functions use the bounce pages
>> and some not.
>> fscrypt_decrypt_page() and fscrypt_decrypt_bio_pages() work in-place while
>> fscrypt_encrypt_page() and fscrypt_zeroout_range() use a bounce page.
>>
>> So, both ext4 and f2fs encrypt data using an extra buffer but decrypt mostly
>> in-place without the need of an extra buffer.
>> Why that? I'd assume when decryption can be done in-place also encryption is possible
>> that way.
> 
> The problem is that the page may be mapped into some process's (or
> multiple processes') address space.  The only way we can encrypt in
> place is if we make sure that it is not mapped into any processes'
> page tables, and prohibit it from being mmapped, *and* prevent any
> simultaneous reads from accessing the page for which we are in the
> process of destroying its original contents because we are doing an
> in-plance encrypt.
> 
> So it could be done, but you would have to remove the page from the
> page cache first (meaning making sure it's not in any page tables) so
> it can't be found by subsequent reads and mmaps, and then sure you
> have a lock out which prevents anyone else from trying to read or mmap
> the page(s) in question, since the version on the storage device is
> out-of-date, because it hasn't been written yet.
> 
> So basically, it's a mess, and if you do need the page again after
> it's been written, the fact that you have to read it back in from the
> storage device would also be a performance hit in some cases.

For UBIFS the story is a bit different. UBIFS operates on a kmap()'ed
page and has already a temporary buffer where it prepares and compresses data.
So, I can use in-place encryption. All I have to do is massaging the fscrypt
interface to allow the filesystem to select when a bouncing page (or buffer in
my case) is needed or not.
I've extended the fscrypt API already to work on buffers too.
In MTD world we don't have struct bio and other fancy stuff. :-)

Thanks,
//richard
