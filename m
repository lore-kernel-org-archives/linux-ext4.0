From: Richard Weinberger <richard@nod.at>
Subject: Re: fscrypt: Howto resolve hash collisions?
Date: Sat, 8 Oct 2016 16:33:29 +0200
Message-ID: <3da5f592-0c1d-1b68-8a76-e6d4a6d616a8@nod.at>
References: <859a9544-fe9d-4656-7b45-b25719c8eadc@nod.at>
 <20161005154504.f72uovnew52jts4w@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751654AbcJHOfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 8 Oct 2016 10:35:08 -0400
In-Reply-To: <20161005154504.f72uovnew52jts4w@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

On 05.10.2016 17:45, Theodore Ts'o wrote:
> On Wed, Oct 05, 2016 at 04:00:36PM +0200, Richard Weinberger wrote:
>>
>> UBIFS uses the r5 hash algorithm for filenames and is able to resolve hash collisions.
>> Unless I miss something it is not possible to resolve hash collisions for bignames
>> in fscrypto....
>>
>> What do I miss? Are ext4 and f2fs not able to resolve hash collisions and therefore
>> nobody noticed?
> 
> 
> "Resolve hash collisions" is a fairly generic term.  There are many
> ways to resolve hash collisions, including linear probing --- which is
> what ext4 uses.

But hash collisions can happen and ext4 aborts then, right?
Some time ago I saw this:
http://blog.merovius.de/2013/10/20/ext4-mysterious-no-space-left-on.html

Which indicates that.

[...]

> For example, POSIX requires that file systems supports telldir()
> return a 64-bit cookie which will be valid in the face of intervening
> additions and deletions, and this cookie must be able to be fed back
> to seekdir() and resume the readdir() session from the location of the
> last telldir().  So you might be able to use whatever scheme you use
> to support telldir() and seekdir().  In retrospect, it probably would
> have been better if, when we refactored the code, to have made the
> interface be a 8 byte cookie.

Here starts the trouble. UBIFS does not support really telldir().
...and therefore also no NFS exports.

> It sounds like the main problem here is that Ubifs is using a 32-bit
> hash, and so the chances of collisions are much higher --- 1 in 65536,
> to be precise.  So the technique of using linear probing probably
> wouldn't work as well for Ubifs.  However, feel free to use the minor
> hash any which way you want.  The key is that you're starting with the
> encrypted filename in readdir, so you also know where the file is located.
> 
> I'm not sure which mechanism of "collision resolution" you're using,
> so at this point I can only make some conjections.  For example, are
> you using the mechanism of hash(name || counter), where you keep
> incrementing the counter until you find an empty slot in the your hash
> tree?  If so, what you could do is to figure out what counter value
> resulted in the location of the encrypted filename to that location in
> the hash tree, and you could store that counter value in the
> minor_hash field.

UBIFS accepts the fact that multiple directory entries can have the same
hash (also on flash). Upon lookup it computes hash(name), finds the first
directory entry with that hash _and_ compares the name. If the name
does not match we're facing a hash collision and lookup the next entry
with the same hash.

> Finally, if it would help, we could change the fs/crypt interface so
> that instead of using a 2x4 byte "cookie", we could make it be (for
> example) a 128 bit cookie.  However, given that ubifs must have some
> solution to the 64-bit telldir/seekdir cookie, maybe you can use that
> mechanism for handling the encrypted readdir() functionality.

Long story short, UBIFS has no solution to offer a telldir/seekdir cookie.
And I fear this time, for fscrypto, it really hurts.

Maybe it is acceptable to support only 200 char long filenames with enabled
encryption and always use base64 encoding.

Thanks,
//richard
