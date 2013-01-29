From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/10 v3] ext4: add physical block and status member into
 extent status tree
Date: Tue, 29 Jan 2013 12:28:14 -0500
Message-ID: <20130129172814.GC4261@thunk.org>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
 <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
 <20130129030353.GK7003@thunk.org>
 <20130129053415.GA27002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130129053415.GA27002@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 29, 2013 at 01:34:15PM +0800, Zheng Liu wrote:
> 
> Another choice is like this:
> 
>         struct extent_status {
>                 ...
>                 ext4_fsblk_t es_pblk;   /* first physical block */
>         };
> 
>         #define EXTENT_STATUS_WRITTEN   (1ULL << 60)
>         #define EXTENT_STATUS_UNWRITTEN (1ULL << 61)
>         #define EXTENT_STATUS_DELAYED   (1ULL << 62)
> 
> When we want to set extent status, we will need to do like the following:
> 
>         es->es_pblk |= EXTENT_STATUS_WRITTEN;
> 
> This can make us avoid non-protable code.  I am happy to refine this
> patch if you think the latter one is better.

This is probably the way I would have done it myself, but the then you
need to make sure that all of the places where es_pblk is used you
have to mask off the high bits.

At this point, though, I don't think it's worth it to make the change
now, especially since we're almost at -rc6, I want to make sure this
gets into linux-next and so we get lots of testing.

As a matter of fact, I've already started testing the v3 vesion of the
extent status patches from January 23rd, with the v2 version of the
slab reclaim patch.  It's in the unstable portion of the ext4 git
tree, at:

      http://repo.or.cz/w/ext4-patch-queue.git /
      git://repo.or.cz/ext4-patch-queue.git

I'm waiting for your next version of your patch series before I move
it into the dev branch which will get fed into linux-next; my
understanding is you're just about ready to push it out, right?

If we want to move away from using bitfields, we can do that as a
separate patch that gets submitted later, since that's pretty easy to
audit and verify for correctness.  Also, I've since tested clang and
noted that it supports bitfields for unsigned long long.  There is
some differences between how gcc and clang handles sign extension for
unsigned long values, though:

#include <stdio.h>
struct s
{
        unsigned long long a:2;
        unsigned long long b:40;
        unsigned long long c:22;
};

int main()
{
        struct s t = {1, 2, 3};
        printf("0x%llx\n",(t.b-8));
}

Gcc 4.7.2 will print "0xfffffffffa", while clang 3.0-6 will print
"0xfffffffffffffffa" for the same program.

I don't think this is a huge issue for us, but it's worth keeping in
mind...

So let's go ahead and keep the bitfields at least for the initial
patch submission.

Thanks for all your on this patch series!

					- Ted



