From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [RFC][PATCH 0/8 v2] ext4: extent status tree (step 1)
Date: Fri, 21 Sep 2012 11:19:54 +0800
Message-ID: <CAGBYx2bSCBzLAwXQOkgVOrOAxG_LJ2WzF_Bk6Oh9V6q1vuky0w@mail.gmail.com>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com> <20120920144126.GA22334@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58646 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab2IUDUP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Sep 2012 23:20:15 -0400
In-Reply-To: <20120920144126.GA22334@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi  Ted,

I notices you cares Signed-off line, so I just throw a message.

I noticed you changed all Signed-off line of patches, some patches are
written by me initially and is modified by Allison and Zheng. So I
think Signed-off line should be me, Allison and Zheng.  Do I
misunderstand the rules?

Yongqiang.

On Thu, Sep 20, 2012 at 10:41 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Hi Zheng,
>
> I've applied your patches to the ext4 patch queue, and so they have
> shown up in the dev branch of the ext4 git tree.
>
> One thing I've noticed in my regression tests is that there is a new
> test failure with this patch series applied.  It is xfstests #230,
> when bigalloc is enabled:
>
> FSTYP         -- ext4
> PLATFORM      -- Linux/i686 candygram 3.6.0-rc1-00043-ga3229f7
> MKFS_OPTIONS  -- -q -O bigalloc /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
>
> 230            - output mismatch (see 230.out.bad)
> --- 230.out    2012-09-19 01:15:44.000000000 -0400
> +++ 230.out.bad           2012-09-20 10:37:05.143728890 -0400
> @@ -5,7 +5,9 @@
>  ### create files, setting up ownership (type=u)
>  ### some buffered IO (type=u)
>  Write 900k...
> +pwrite64: Disk quota exceeded
>  Rewrite 1001k...
> +pwrite64: Disk quota exceeded
>  Write 1000k...
>  pwrite64: Disk quota exceeded
>  Write 4096...
> @@ -21,7 +23,9 @@
>  ### create files, setting up ownership (type=g)
>  ### some buffered IO (type=g)
>  Write 900k...
> +pwrite64: Disk quota exceeded
>  Rewrite 1001k...
> +pwrite64: Disk quota exceeded
>  Write 1000k...
>  pwrite64: Disk quota exceeded
>  Write 4096...
> Ran: 230
> Failures: 230
> Failed 1 of 1 tests
>
> I haven't had time to take a look at this, and it's only failing when
> bigalloc is enabled.  If you could take a look I would greatly
> appreciate it.
>
> Thanks!!
>
>                                         - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Wishes
Yongqiang Yang
