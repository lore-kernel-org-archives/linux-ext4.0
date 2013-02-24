From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] ext4: no need to remove extent if len is 0 in ext4_es_remove_extent()
Date: Sun, 24 Feb 2013 13:06:21 +0800
Message-ID: <CA+dCu88diNbJfVf6O+_ySuq4MqGgcv8nai1tzU9TKX2on1A-dQ@mail.gmail.com>
References: <1361511243-2458-1-git-send-email-guaneryu@gmail.com>
 <20130222062509.GA2735@gmail.com> <20130222175557.GA21264@thunk.org>
 <CA+dCu89+h00LRts_wk2GTDmi7qR9nqZfGKvabFoAvee-FCUG7A@mail.gmail.com> <20130223234526.GA1196@thunk.org>
Reply-To: guaneryu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53030 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab3BXFGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Feb 2013 00:06:42 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so1588552wgb.24
        for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2013 21:06:41 -0800 (PST)
In-Reply-To: <20130223234526.GA1196@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 24, 2013 at 7:45 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Feb 23, 2013 at 11:40:13AM +0800, Eryu Guan wrote:
>> On Sat, Feb 23, 2013 at 1:55 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> > This patch didn't apply since it was apparently against an older
>> > version of the extents status patches.  Here is the version after I
>> > fixed it up so it would apply into the current ext4 tree.  Zheng, can
>>
>> Thanks Ted! I was making the patch on top of Linus' tree.
>> Linus' tree vs ext4 tree which one is preferred for submitting patch?
>
> The ext4 tree in general is the one which is preferred; the dev branch
> is the tip of what we hope to push to Linus.  At the moment, it's in
> final testing.  The three branch pointers which are important on the
> ext4 tree are origin, master, and dev.  The origin branch is where we
> have branched off of Linus's tree.  At the moment, ext4/origin is
> pointing at v3.8-rc3.  The ext4/master branch is always between origin
> and dev (inclusive).  The dev branch is a rewinding branch, which
> means that everything between master and dev may be get modified
> (i.e., to add a Reviewed-by: or to fix up some comments, etc.), or may
> get dropped (if it turns out we discover the patch is not ready for
> prime time).  The dev branch is also what gets included into
> linux-next.
>
> The master branch represents those patches which have been
> "finalized", which means once we bump the master branch, all of the
> commits between origin and master (inclusive) are guaranteed not to
> change.  So for people who are building on top of master, it's safe
> for them to use git.  For people who are building on top of dev, if
> you want to make changes, it's recommended you use a tool like quilt,
> guilt, or stgit.
>
> Speaking of quilt/guilt, the set of patches between master and dev can
> be found here:
>
>         http://repo.or.cz/w/ext4-patch-queue.git
>         git://repo.or.cz/ext4-patch-queue.git
>
> For those people who are interested, or who want to more easily cherry
> pick specific patches out of the ext4 patch queue, the ext4/dev branch
> (usually, assuming I've remembered to update the ext4 patch queue
> tree) can be reconstructed as follows:
>
>     git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git ext4
>     mkdir -p ext4/.git/patches
>     cd ext4/.git/patches
>     git clone git://repo.or.cz/ext4-patch-queue.git dev
>     cd dev
>     sh timestamps
>     cd ../../..
>     git branch dev $(head -1 .git/patches/dev/series | sed -e 's/# BASE //')
>     git checkout dev
>     guilt push stable-boundary
>     guilt pop
>
> (This assumes you are using guilt version v0.35, found at
> git://repo.or.cz/guilt.git; note that the tip of the guilt tree has
> incompatible changes in how they parse patches, so I haven't upgraded
> to the tip of guilt tree yet.)
>
> Anyway, most people will send me patches against Linus's tree, and
> that's fine; if there are problems, I can usually fix up the patches.
> But it's most convenient for me if people send against either the
> ext4/master, or most preferably, the ext4/dev branch.
>
> BTW, I've updated the ext4 wiki to include the above information.

Thanks for your excellent explanation! I think I'd like to try
ext4/master first :)

Eryu
>
> Thanks,
>
>                                    - Ted
