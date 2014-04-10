From: jon ernst <jonernst07@gmail.com>
Subject: Re: xfstest-bld generic/018 fails due to e4defrag issue
Date: Thu, 10 Apr 2014 00:13:49 -0400
Message-ID: <CAGW2f1Fn2caBtQPjZnXyMdVf9H6wGvS_0YrLReggwujKZXL8CQ@mail.gmail.com>
References: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
	<20140409220320.GC15303@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:40826 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934602AbaDJENt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2014 00:13:49 -0400
Received: by mail-qg0-f43.google.com with SMTP id f51so3332835qge.2
        for <linux-ext4@vger.kernel.org>; Wed, 09 Apr 2014 21:13:49 -0700 (PDT)
In-Reply-To: <20140409220320.GC15303@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 9, 2014 at 6:03 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Apr 09, 2014 at 01:37:04AM -0400, jon ernst wrote:
>> running latest xfstest-bld with latest ext4 kernel "dev"
>> branch(ad6599ab3a).I always get generic/018 failed.
>> Then I took closer look and found out this issue.
>
> That's a renamed tested; it was previously shared/218.  It's a test
> which is known to fail for ext4, since its idea of how a defrag
> program should work is slightly different from how e4defrag works:
>
> shared/218 7s ...   [20:48:32] [20:48:39] - output mismatch (see /results/results-4k/shared/218.out.bad)
>     --- tests/shared/218.out   2014-04-01 18:46:39.000000000 +0000
>     +++ /results/results-4k/shared/218.out.bad               2014-04-03 20:48:39.795694518 +0000
>     @@ -10,7 +10,7 @@
>      After: 1
>      Write backwards sync, but contiguous - should defrag to 1 extent
>      Before: 10
>     -After: 1
>     +After: 10
>      Write backwards sync leaving holes - defrag should do nothing
>      Before: 16
>     ...
>     (Run 'diff -u tests/shared/218.out /results/results-4k/shared/218.out.bad'  to see the entire diff)
>
> What you are seeing is something very different, though.
>
>> Even though the file does exist. e4defrag complains about:
>>
>> (this output comes from kvm guest machine)
>> > e4defrag -v /vdf/testfile
>> Can't get super block info: Success
>> "/vdf/testfile"
>>
>> Is this a known issue or something I did wrong.
>
> Unfortunately, e4defrag has horrible error handling, so we can't see
> the error code properly, so we can't see why it's failing, but this is
> from an attempt to open the file system to get some low-level
> information.
>
> How is /etc/mtab set up on your test machine?  It looks like it failed
> to find block device for the file system in question.
>
>                                          - Ted

I found the root cause of this failure.

The failure case happens on "bigalloc" testing option.
ext2fs_open failed due to EXT2_FLAG_64BITS is not being set in testing
rootfs image. So ext2fs_open in e4defrag.c returns err: 2133571465.

Because bigalloc requires cluster-aware bitfield operations, which
means we need EXT2_FLAG_64BITS.
I see e2image.c creates image always with EXT2_FLAG_64BITS flag. It is
safe to do same thing for e4defrag in my opinion. Please correct me if
I am wrong.




[PATCH] e4defrag: open fs with EXT2_FLAG_64BITS flag

Signed-off-by: Jon Ernst <jonernst07@gmail.com>
---
 misc/e4defrag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 620f4e7..c5a2754 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1794,7 +1794,7 @@ int main(int argc, char *argv[])

                if (current_uid == ROOT_UID) {
                        /* Get super block info */
-                       ret = ext2fs_open(dev_name, 0, 0, block_size,
+                       ret = ext2fs_open(dev_name,EXT2_FLAG_64BITS,
0, block_size,
                                        unix_io_manager, &fs);
                        if (ret) {
                                if (mode_flag & DETAIL) {
-- 
1.8.1.2
