From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 3/3] ext4: Find desired extent in ext4_ext_shift_extents()
 using binsearch
Date: Fri, 6 Jan 2017 21:21:19 +0100
Message-ID: <CAJrWOzDDy+GETUTAiRT7Sunj_LK8A8Uq9Nodwd+UBFpvY2WsXg@mail.gmail.com>
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

I found a bug in my third patch, where I try to optimize linear search.
I missed the fact, that ext4_ext_binsearch() searches for the closest
extent from the left, but this linear search code does search for closest
extent from the right.

I ran the 'kvm-xfstests.sh -c 4k -g auto' against b25ead75e7b6 4.10-rc2
with and without my changes.  No failures.

1k configuration was run against latest Linus's mainline.  Also no
regressions were found: these two "generic/270, generic/273" fail
regardless my changes.

I will resend the patchset without latest patch shortly.

--
Roman
