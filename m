From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Thu, 30 Nov 2017 08:46:34 +0200
Message-ID: <CAOQ4uxi9DVH1LbMMQ8ZOKBpGq5XBRmJk4=BmgdDTaP1P+6rcbQ@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org> <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <20171130002408.5w4axekvcdrbag53@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ashlie Martinez <ashmrtn@utexas.edu>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:40652 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdK3Gqf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Nov 2017 01:46:35 -0500
Received: by mail-yb0-f180.google.com with SMTP id p128so2334923yba.7
        for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2017 22:46:35 -0800 (PST)
In-Reply-To: <20171130002408.5w4axekvcdrbag53@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 30, 2017 at 2:24 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Nov 29, 2017 at 10:07:39AM +0200, Amir Goldstein wrote:
>> If you could work out how to fix the test to catch the bug in kvm-xfstests
>> that would be nice.
>
> One question, how did you actually test it using kvm-xfstests?  The
> kvm-xfstests image that I had up on www.kernel.org did not have
> generic/456.  It was dated from September 2017, so it didn't have that
> test.  Since the publically available image didn't have generic/456,
> did you create your own image some how?

Of course. I am using my own image and update xfstests frequently.

>
> I just updated the test appliance yesterday, so it does now.  The
> version stamp on it is:
>
> e2fsprogs       v1.43.6-85-g7595699d0 (Wed, 6 Sep 2017 22:04:14 -0400)
> fio             fio-3.2 (Fri, 3 Nov 2017 15:23:49 -0600)
> quota           4d81e8b (Mon, 16 Oct 2017 09:42:44 +0200)
> stress-ng       977ae35 (Wed, 6 Sep 2017 23:45:03 -0400)
> xfsprogs        v4.14.0-rc2-1-g19ca9b0b (Mon, 27 Nov 2017 10:56:21 -0600)
> xfstests-bld    0b27af9 (Tue, 28 Nov 2017 16:28:51 -0500)
> xfstests        linux-v3.8-1797-g4f1eaa02 (Tue, 28 Nov 2017 15:49:06 -0500)
>
> Can you try the latest version of the kvm-xfststs test appliance image
> that is on www.kernel.org, with the latest xfstests-bld git repo to
> drive it?

It works with latest image.
456 fails on old kernel and pass on v4.15-rc1.

When I get to it, I will also check dm-log-write tests with latest image
and rebuild my image from scratch to see if that changes anything.

Thanks,
Amir.
