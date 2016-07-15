From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Fri, 15 Jul 2016 10:15:31 +0900
Message-ID: <CAP9B-Qn0R1geR41BH-Eg6sqYUid734ar6Nq4sYyjK5PCrWFzAg@mail.gmail.com>
References: <20160706233533.GK27480@dastard> <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard> <20160708024654.GE19871@thunk.org>
 <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net> <20160708050228.GH19871@thunk.org>
 <20160711161556.GB9334@quack2.suse.cz> <20160711171242.GA21285@thunk.org>
 <20160712105908.GE16460@quack2.suse.cz> <20160712161547.GB11020@thunk.org> <20160714131331.GB13151@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
	Wang Shilong <wshilong@ddn.com>
To: Jan Kara <jack@suse.cz>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20160714131331.GB13151@quack2.suse.cz>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 14, 2016 at 10:13 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 12-07-16 12:15:47, Ted Tso wrote:

>> Does that sound like a plan?
>
> Yes. quotaoff will already disable only enforcement for ext4 with hidden
> quota files so there's no need to change anything there. We just need to
> add kernel support for enabling quota enforcement based on mount option.
> Attached patch should do that - I still need to test whether it doesn't
> break anything so don't apply it yet, just have a look whether it looks
> sane to you.

I sent a similar patch weeks ago.
http://marc.info/?l=linux-ext4&m=146787897927183&w=2

and also quota tools to support it:

http://marc.info/?l=linux-ext4&m=146787899027184&w=2


>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
