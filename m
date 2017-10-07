From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ext2/super: Fix a possible sleep-in-atomic bug in parse_options
Date: Fri, 6 Oct 2017 18:37:11 -0700
Message-ID: <CA+55aFw9UB1ZKMk-JgLm=xBRST-9JaWv4unFtE3fsygjeVxEjg@mail.gmail.com>
References: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, james.smart@broadcom.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jia-Ju Bai <baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507339246-13067-1-git-send-email-baijiaju1990@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 6, 2017 at 6:20 PM, Jia-Ju Bai <baijiaju1990@163.com> wrote:
>
> To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
> This bug is found by my static analysis tool and my code review.

I'm not saying your patch is wrong, but it's a shame that we do that
extra allocation in match_number() and match_u64int(), and that we
don't have anything that is just size-limited.

And there really isn't anything saying that we shouldn't do the same
silly thing to match_u64int(). Maybe we don't have any actual users
that need it for now, but still..

Oh well.

I do wonder if we shouldn't just use something like

 "skip leading zeroes, copy to size-limited stack location instead"

because the input length really *is* limited once you skip leading
zeroes (and whatever base marker we have). We might have at most a
64-bit value in octal, so 22 bytes max.

But I guess just changing the two GFP_KERNEL's to GFP_ATOMIC is much simpler.

               Linus
