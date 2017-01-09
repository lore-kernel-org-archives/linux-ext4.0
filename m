From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH v2 2/2] ext4: Do not populate extents tree with outdated
 offsets while shifting extents
Date: Mon, 9 Jan 2017 13:36:50 +0100
Message-ID: <CAJrWOzDLhjdX=FV18Wty7bOkzD7rn_rcBUT2610O4XYqxgqpQg@mail.gmail.com>
References: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
 <20170106202601.32722-3-roman.penyaev@profitbricks.com> <20170107212746.6bqohlvik7laij7i@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
        Roman Pen <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170107212746.6bqohlvik7laij7i@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 7, 2017 at 10:27 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Jan 06, 2017 at 09:26:01PM +0100, Roman Pen wrote:
>> Inside ext4_ext_shift_extents() function ext4_find_extent() is called
>> without EXT4_EX_NOCACHE flag, which should prevent cache population.
>>
>> This leads to oudated offsets in the extents tree and wrong blocks
>> afterwards.
>>
>> Patch fixes the problem providing EXT4_EX_NOCACHE flag for each
>> ext4_find_extents() call inside ext4_ext_shift_extents function.
>>
>> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
>
> Thanks, applied.

Could you please provide with the SHA1 of the patch in your branch?
I want to make an exact reference in a new test of the xfstest which
covers that bug.

--
Roman
