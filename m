From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 3/3] ext4: Find desired extent in ext4_ext_shift_extents()
 using binsearch
Date: Wed, 4 Jan 2017 19:32:18 +0100
Message-ID: <CAJrWOzA467XZOpZmaGr6_z+nwNAxJZXYFmb4azS7Haag4dtWAQ@mail.gmail.com>
References: <20170102125450.22807-1-roman.penyaev@profitbricks.com>
 <20170102125450.22807-4-roman.penyaev@profitbricks.com> <20170103144041.t5lmorkdqqljnwvl@thunk.org>
 <CAJrWOzAsAyhpBOSm=Ot=iffqwCV7w8jGXLFieTxY11VTo9rOpA@mail.gmail.com> <20170103221510.dkrxqav7qrq772ji@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
        Roman Penyaev <roman.penyaev@profitbricks.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170103221510.dkrxqav7qrq772ji@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 3, 2017 at 11:15 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Jan 03, 2017 at 09:44:15PM +0100, Roman Penyaev wrote:
>>
>> (I had to say that right now I am testing on 4.4.28 kernel and testing
>>  on latest sources taken from linux-next will require some time, but of
>>  course I will retest and send up-to-date results)
>>
>> ---
>> Failures: ext4/302 ext4/303 ext4/304 generic/061 generic/063
>> generic/075 generic/079 generic/091 generic/112 generic/127
>> generic/252 generic/263
>> Failed 12 of 200 tests
>
> You didn't say what file system configuration you're using, but I'm
> assuming it's a default ext4 4k configuration?

Yep, that was the default run, 4K block.

> One of the things
> about my kvm-xfstests and gce-xfstests setup is that I test a range of
> file system configurations, and there are specific exclude files to
> skip certain known failures.  Currently we are skipping the following
> tests globally (from kvm-xfstests/test-appliances/files/root/fs/ext4/exclude):

[ cut ]

> You'll see that modulo the encryption failures and some failures on
> the 1k config case which I need to track down and iron out, we're in
> pretty good shape.  Below please find the summary; attached please
> find the full log file.

Thanks a lot.  Perfect reference. That is quite enough for a good start.

This kvm-xfstests is a nice thingy.  That was pretty annoying to rebuild
xfsprogs on a debian jessie, which does not have 'xfs_io -c finsert' by
default.

Theodore, recently I sent an ext4/023 xfstest test.  New test reproduces
the problem with a wrong right shift.  I tried to make the test explicit,
but not sure succeeded or not.  Probably, md5sum is not a good choice to
make things clear, but hexdump of 1000 blocks is quite large (~80K).
Could you please take a look?

Now I am running kvm-xfstests, will figure out what I've done wrong with
recent ext4 patches.

--
Roman
