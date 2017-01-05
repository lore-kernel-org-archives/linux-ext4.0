From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 3/3] ext4: Find desired extent in ext4_ext_shift_extents()
 using binsearch
Date: Thu, 5 Jan 2017 09:02:35 +0100
Message-ID: <CAJrWOzCE=pvQmgo0Lv1xNLsNTM==0EyqFt=x12x7pEyCak3FKQ@mail.gmail.com>
References: <20170102125450.22807-1-roman.penyaev@profitbricks.com>
 <20170102125450.22807-4-roman.penyaev@profitbricks.com> <20170103144041.t5lmorkdqqljnwvl@thunk.org>
 <CAJrWOzAsAyhpBOSm=Ot=iffqwCV7w8jGXLFieTxY11VTo9rOpA@mail.gmail.com>
 <20170103221510.dkrxqav7qrq772ji@thunk.org> <CAJrWOzA467XZOpZmaGr6_z+nwNAxJZXYFmb4azS7Haag4dtWAQ@mail.gmail.com>
 <20170104235818.v3fwchrjnxnhuble@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
        Roman Penyaev <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104235818.v3fwchrjnxnhuble@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 5, 2017 at 12:58 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> It looks like the original (before your patch) 1k failures due to a
> bug introduced via the block.git tree, which has since been fixed in
> Linus's mainline tree as of today.  It wouldn't surprise me if the bug
> interacted poorly your changes, so things will probably better with
> your patches applied directly on top of the tip of Linus's tree.
>
> That being said, it looks like there were still regressions introduced
> on the 4k configuration, so I'm in the middle of rerunning my baseline
> and trying out your patches as well.

It seems that some of the "finsert" tests from xfstests are broken by my
patches.  Now I am able to run all configurations with a kvm-xfstests
help, so will take a look deeply.

--
Roman
