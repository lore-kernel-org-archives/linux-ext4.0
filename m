From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 06 Apr 2012 12:19:29 -0700
Message-ID: <4F7F41C1.9010208@redhat.com>
References: <20120330125726.GA26221@amd.home.annexia.org> <20120330131936.GB26221@amd.home.annexia.org> <4F760BC2.4070401@redhat.com> <20120406191401.GA8816@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab2DFTTi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:19:38 -0400
In-Reply-To: <20120406191401.GA8816@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/6/12 12:14 PM, Sami Liedes wrote:
> On Fri, Mar 30, 2012 at 02:38:42PM -0500, Eric Sandeen wrote:
>> On 3/30/12 8:19 AM, Richard W.M. Jones wrote:
>>> It seems like a non-64-bit-compatible bitmap was being created, and
>>> that doesn't have the bitmap->bitmap_ops field initialized because
>>> gen_bitmap.c doesn't use this field.  Somehow, though, we end up
>>> calling a function in gen_bitmap64.c which requires that this field be
>>> defined.
> 
> Argh, indeed. I thought the 32-bit bitfields also have the bitmap_ops
> field (and in the same offset), but they don't.

nope :)

>> Well here's what's busted:
>>
>>         if (bitmap->bitmap_ops->find_first_zero)
>>                 return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
>>
>>         if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
>>                 return EINVAL;
>>
>> bitmap->bitmap_ops->find_first_zero only exists for a 64-bit bitmap, which
>> gets tested after we try to deref it :(
> 
> Right, that's quite bogus. The !bitmap test should obviously be first,
> not after we first dereference it. Then we should test for 64-bitness,
> and only ever touch the bitmap_ops field if we have a 64-bit bitmap.
> 
>> I am a little confused by the existence of two different
>> struct ext2fs_struct_generic_bitmap's in the code.  But treating one as the
>> other looks doomed to failure ;)
> 
> In addition to that, there are actually three different versions of
> many operations; they are named ext2_foo_bmap(), ext2_foo_bitmap() and
> ext2_foo_bitmap2(). I'm quite confused too.

Yeah, it's rather inscrutable.

> While I suggest passing EXT2_FLAG_64BITS to ext2fs_open() - it should
> never break anything and only makes things faster - the code obviously
> shouldn't break when that is not passed.

Right, that was the whole point of the inscrutable mess above :(

> (I wonder if it would make sense to have something like
> EXT2_BASE_FLAGS that could include any flags which never hurt,
> currently apparently only EXT2_FLAG_64BITS. From the name of the flag
> EXT2_FLAG_64BITS it's not obvious that you should always use it. As
> far as I understand correctly, it's there only for ABI compatibility
> with code compiled before the flag was introduced and it never makes
> sense to not pass it in any new code.)
> 
> The patch below unbreaks the code (well, at least resize2fs
> modified to not pass EXT2_FLAG_64BITS) for me.

Thanks; I am actually just now testing my own patch, I wasn't sure if
you were around and I wanted to get this fixed.  :)

Mine is more invasive, with all of the full-on inscrutable redirection
mess every other bitmap function uses ;)  But maybe that's not necessary
for this new function, since there will be no old users of it.

We probably need a way to test at least every binary in e2fsprogs
with the 64-bit flags off, to be sure that old apps won't break.

For now I just edited every util which set the 64 bit flag and turned
that off, and ran make check.

I may send my patch as well, and see what Ted thinks is the best
fit for the current code layout... yours is simpler, and without
any API concerns/constraints, it may be better.

Thanks,
- -Eric

> 	Sami Liedes
> 
> ------------------------------------------------------------
> 
> commit bb8fe012a3b1705809f6129cd9c78d2cd855b1f8
> Author: Sami Liedes <sami.liedes@iki.fi>
> Date:   Fri Apr 6 22:06:30 2012 +0300
> 
>     Fix ext2fs_find_first_zero_generic_bmap() for 32-bit bitmaps.
>     
>     ext2fs_find_first_zero_generic_bmap() tries to handle old-style 32-bit
>     bitmaps, but fails in several different ways.
>     
>     Fix the order of the (in)validity tests and the fallback code to never
>     dereference the bitmap, as we don't know at that point if it's a
>     32-bit bitmap or a 64-bitmap bitmap whose backend implementation does
>     not support find_first_zero(). Use the generic bitop functions for
>     everything instead.
>     
>     Addresses-Red-Hat-Bugzilla: #808421
>     
>     Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
>     Reported-by: Richard W.M. Jones <rjones@redhat.com>
> 
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index e765d2c..7e9b8a0 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -770,19 +770,25 @@ errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
>  {
>  	int b;
>  
> -	if (bitmap->bitmap_ops->find_first_zero)
> +	if (!bitmap)
> +		return EINVAL;
> +
> +	if (EXT2FS_IS_64_BITMAP(bitmap) && bitmap->bitmap_ops->find_first_zero)
>  		return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
>  
> -	if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
> +	if (!EXT2FS_IS_32_BITMAP(bitmap) || bitmap->cluster_bits)
>  		return EINVAL;
>  
> -	if (start < bitmap->start || end > bitmap->end || start > end) {
> +	// We must be careful to not use any of bitmap's fields here,
> +	// as it may actually be the different 32-bit version of the structure
> +	if (start < ext2fs_get_block_bitmap_start(bitmap) ||
> +	    end > ext2fs_get_block_bitmap_end(bitmap) || start > end) {
>  		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
>  		return EINVAL;
>  	}
>  
>  	while (start <= end) {
> -		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
> +		b = ext2fs_test_generic_bitmap(bitmap, start);
>  		if (!b) {
>  			*out = start;
>  			return 0;

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPf0HAAAoJECCuFpLhPd7gGyQP/0qpH0dB55Ys5j70OBXIFtzT
rMqYcE7P+HZ66+zkWKqB2lKtnMLFXGxDkeQGQ4ECxrucKpcWWrwLSyvB11Py41rV
wal5Uymg41Q7lRjfnYeraKsObeT9VNlV5d/i1TVRZNG0ooHni/9loEShHnKUnlKs
kOROEFu6x/MHNTGeXtmU3aE2l9SCePJn3rQZHQrTeDo5/hm7lQwPUvTmk5Jg8F/v
uNW9zdnPOOvcSF1nmy8P32GKE750GwcrctVe0S9UUtiGr5XPSW7RdnynELRm/6kh
qpGv4v1dPjmG/uJvltxiKymhSv6zoj9NDqEz5V/iISrBvY108WWBFJVpp/EfgMph
luIPUV1zQ5KwQNyHSHgeGCuwa8R02I2sDwXQ/ZyZomOATK1dJ8s6ODkSFUL1pP3k
xZmnWJM9cw4pagCEagyvD6OtT43vvSVakPKxZGE/U67tVxLNZrzmGm79glDMhs70
xed0T5lYZoJEfoMAfLMW7CQYsceRs7bNLfBos1XL8vMhoq0ak8sXmSIiEzzHPOPK
scM+jKtisDqZE9s3j1LgA+aXhmag4/RwO8zTq0gNmZVD4slqbFXVXuIFjFbFR61i
F6ttZROBvo+//C7E7F1AXytCCvhPVQKgDH1aUq92mUmHsKh3CSEwr4BA+E+7+iOj
2WiGb4k3ZI0AcjcZljOi
=9/4M
-----END PGP SIGNATURE-----
