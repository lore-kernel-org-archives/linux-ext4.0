From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V4 00/22] ext4: Add inline data support
Date: Wed, 22 Feb 2012 09:34:46 +0800
Message-ID: <4F444636.7070107@tao.ma>
References: <4F41EF95.2000909@tao.ma> <FA1EAF98-9D9C-408D-BB4C-4A116C6CEA19@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41406 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753086Ab2BVBet (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2012 20:34:49 -0500
In-Reply-To: <FA1EAF98-9D9C-408D-BB4C-4A116C6CEA19@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/22/2012 07:44 AM, Andreas Dilger wrote:
> On 2012-02-20, at 12:00 AM, Tao Ma wrote:
>> Hi Ted, Andreas and list,
>>        This is the v4 attempt to add inline data support to ext4 inode.
>> For more information about the background, please refer to the thread
>> http://marc.info/?l=linux-ext4&m=131715205428067&w=2
>>
>> Changlog from v3 to v4:
>> 1. Add support for truncate which is really a bug.
>> 2. Some bug fixes.
>> 3. rebased to the latest kernel.
> 
> I'm starting to look through this patch series, and a number of things are
Thanks for the review.
> missing that would make it much easier to understand and accept:
> - a good comment and possibly a diagram at the start of fs/ext4/xattr.c
>   that describes where and how the inline data is stored in the inode,
>   what the policies are for storing data inline or externally, etc.
sure, I will add it.
> - some benchmark data that shows why landing this code is desirable.
>   My comments in the above thread show that small files and directories
>   could benefit from this, but real proof now that you have made this
>   patch is whether this translates into noticeable space savings, and
>   hopefully also noticeable performance improvements in some benchmarks:
>   - I suspect that running some tests with bigalloc + 512-byte inodes
>     or similar could show significant space savings and speedups for
>     cold-cache directory traversal
>   - measuring boot time on a distro with Gnome or KDE could show real
>     speedups due to the many small files and directories used at startup
>   - running a benchmark like mongo or postmark with small files and
>     with 256- or 512-byte inodes may also show real speedups
>   - is there some workload that you are using that shows speedups that
>     could be described in general terms and show relative performance,
>     even if it is not possible to supply the actual benchmark/tests?
OK, I was just playing around with some bug fixes these days(to make it
stable in our production system) and doesn't do some performance tests
when upgrading from v2 to v3. I will try to do some tests and return the
data back in v5.

Thanks
Tao
> 
> I'll go through the patches and suggest cleanups and improvements, but
> without improved documentation and real performance tests the patch is
> very unlikely to be accepted by Ted.
> 
>> Changelog from v2 to v3:
>> 1. Add support for evict data from inode if we can store xattr in it.
>> 2. Add support for fiemap
>> 3. Some nasty bug fixes
>>
>> The v3 can be found here:
>> http://marc.info/?l=linux-ext4&m=132421821001634&w=2
>>
>> The v2 can be found here:
>> http://marc.info/?l=linux-ext4&m=132189338604177&w=2
>>
>> The v1 can be found here:
>> http://marc.info/?l=linux-ext4&m=131961438221255&w=2
>>
>> any suggestions are welcomed.
>>
>> Thanks
>> Tao
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

