From: =?ISO-8859-1?Q?Kai_Gro=DFhaus?= <kai@grosshaus.org>
Subject: Re: [PATCH] resize2fs: support online-resizing for meta_bg and  64bits
 features
Date: Tue, 04 Sep 2012 01:33:29 +0200
Message-ID: <50453E49.40309@grosshaus.org>
References: <1346579549-25122-1-git-send-email-xiaoqiangnk@gmail.com> <CAGBYx2bobtLQmtexLtVCXSQBpK5-4-4q3MHS3bXcew=iKRhqig@mail.gmail.com> <20120903164525.GD5066@thunk.org> <50451AD9.30006@vbcl.de> <20120903230030.GF5066@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vbcl.de ([94.230.50.52]:43117 "EHLO mail.vbcl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab2IDAAV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Sep 2012 20:00:21 -0400
In-Reply-To: <20120903230030.GF5066@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04.09.2012 01:00, Theodore Ts'o wrote:
> On Mon, Sep 03, 2012 at 11:02:17PM +0200, Kai Grosshaus wrote:
>> is offline resizeing possible with this patch without online resize
>> kernel patches (i use 3.2.0) with this features?
>>
>> Filesystem features:      has_journal ext_attr dir_index filetype
>> needs_recovery meta_bg extent 64bit flex_bg sparse_super large_file
>> huge_file uninit_bg dir_nlink extra_isize
>>
>> I had no luck offline resizing my 24TB fs with e2fstools version
>> 1.42 and 1.42.5.
> No, offline resizing for 64-bit file systems (and file systems with
> meta_bg) hasn't been implemented yet.  It's on the todo list, but the
> main issue is that for many of the ext4 developers, our employers
> don't require the use of large RAID arrays, so the development has
> been somewhat delayed between my work responsibilities and organizing
> the kernel summit last week in San Diego.  Yongqiang's patches were
> posted for review quite some time ago, but I knew they needed some
> review and reworking, and it just didn't rise to the top of the
> priority heap until now.
>
> (I'm technically on vacation this week in Santa Fe, and hacking online
> resizing for ext4 is fun, so I've been using the early morning and
> late nights to finally get around to making forward progress for
> online resize.  :-)

interesting what you call fun ;) But thx, i appreciate your work!

>
> Technically, off-line shrink for meta_bg/64-bit file systems is easy,
> and off-line growth isn't fundamentally hard, but it simply requires
> teaching resize2fs about the new meta_bg and flex_bg formats.  It's
> probably only a week or so, full-time, by someone who really
> understands the code in question.  The only problem is the only person
> who understands that code deeply is me, and I've just been completely
> swamped these last couple of months.  Hopefully, now that the kernel
> summit is behind me, I'll have a bit more time to work on off-line
> resize, as well as reviewing the many other patches for ext4 which
> have been submitted in the past few months (i.e., the extent status
> tree, which enables SEEK_HOLE and fixing the bigalloc ENOSPC problem
> with delalloc bufferred writes, and the inline data patches).
>
> I suspect that for people who really want to be able to grow their
> large 64-bit ext4 file systems, the best path forward will be for me
> to backport the on-line resizing (for enlarging 64-bit file systems)
> patches to 3.2.x, once I'm convinced we've shaken out all of the bugs
> and they are well-tested.
>
> Technically, they wouldn't be material for the 3.2.x stable branch
> since they're not a bugfix, but if some distro using 3.2 is willing to
> sponsor them, we could make the case that since one or more distro's
> are willing to use them in shipping product, they should be in 3.2.x.
> (Or I could just abuse the fact that no one is currently actively
> enforcing rules around the criteria for stable tree patches, but that
> would just be bad kernel developer citizenship.  :-)

I didn't want to press on it, but thx for the detailed response. Ill 
stay tuned here to read about the progress. But could you do me the 
favor and answer me an additional question.

If i create a fs with the kernel, e2fsprog versions and the features i 
mentioned, could i grow it in future when the work on e2fsprogs is done. 
I mean recreating the fs is no option for me ;)

thx a lot and have a good vacation,

Regards,
Kai Grosshaus

