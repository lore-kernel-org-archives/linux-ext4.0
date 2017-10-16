From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ext4: fix interaction between i_size, fallocate, and
 delalloc after a crash
Date: Tue, 17 Oct 2017 00:11:40 +0300
Message-ID: <CAOQ4uxiKdRq1KyiEW-d9rp+hWQanVzMXQa1vW2JHmhtEVM1-GA@mail.gmail.com>
References: <1503830683-21455-1-git-send-email-amir73il@gmail.com>
 <59C8D147.1060608@cn.fujitsu.com> <CAOQ4uxgnK3mGKG+owRUNGyDVOCeicArwaufGgwXaSVxC26+peQ@mail.gmail.com>
 <CAFk8rvYvrGo6SjA6e0yj0XL_BARMmZoofB5kESM4EY4S2n-==w@mail.gmail.com>
 <59D5DEE0.6080506@cn.fujitsu.com> <CAFk8rvbi3MHbRBtaZVTJKDcORaDTtMpwy2X2ZdXTZt=LE5smZw@mail.gmail.com>
 <CAOQ4uxgc77_P472KEyHfAXSOE6DD7c=2VrJWBJT6ahiSYb=iJQ@mail.gmail.com>
 <CAFk8rvYtyraezVEP1e3LFEE+9t5YoRH2YwjKxex8hgSY74Lw7A@mail.gmail.com>
 <20171007032917.bntgnubthdstmrrt@thunk.org> <59DDFC47.3050300@cn.fujitsu.com>
 <CAFk8rvbi6eDn4P7rfBr6+90xbsQcfEBJAp0wQh+tczNEwdMTpw@mail.gmail.com>
 <CAOQ4uxjtf8_y7Hmb4GU9YN7DvMa7WNtpeRzGoK5m2=Vw=ChStA@mail.gmail.com> <CAFk8rvZoOcU4Di8mkV_uPd3e4ccqPrB5kg2Y5WufhJX6W73k7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>,
        Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        Vijay Chidambaram <vvijay03@gmail.com>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAFk8rvZoOcU4Di8mkV_uPd3e4ccqPrB5kg2Y5WufhJX6W73k7w@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 16, 2017 at 10:32 PM, Ashlie Martinez <ashmrtn@utexas.edu> wrote:
> Amir,
>
> I know this is a bit late, but I've spent some time working through
> the disk image that you provided (so that I could determine how/if I
> could modify CrashMonkey to catch errors like this) and I don't think
> I understand what state the disk image reflects.

The disk image SHOULD reflect a state on a disk after the power was
cut in the middle of mounted fs. Then power came back on, filesystem
was mounted, journal recovered, then filesystem was cleanly unmounted.
At this stage, I don't expect there should be anything interesting in the
journal.

> After digging around
> the journal of the disk image you provided, I found that the first 10
> journal blocks are used, with the journal superblock being placed in
> the very first block of the journal. The journal superblock says that
> the first journal transaction ID that should be in the journal is
> transaction ID 4. However, dumping the other journal blocks, I found
> that the next block is a descriptor block for transaction ID 2. The
> rest of the journal blocks are data blocks for that transaction plus a
> transaction commit block. This seems a little odd considering that the
> journal refers to a 4th transaction, which I have not been able to
> find (I quickly dumped the first 50 blocks in debugfs and found the
> rest to contain only zeros).
>

I did not spend time analyzing the image, so I'll take your word for it,
but I can't help you understand your findings.

> With this in mind, I looked back at the xfstests code for controlling
> the dm_flakey device. What I realized is the `nolockfs` flag is
> provided both when it switches from the real device to the flakey
> device that drops writes and when it switches from the flakey device
> back to the real device. I know there is a call to umount once the
> flakey device that drops writes is inserted, but do you think it is
> possible that the flakey device is swapped back to the real device
> before all the writes forced out by umount have made it to the flakey
> device?

I believe umount call should be blocked until all writes have been flushed
out to flakey device.

> Unfortunately I still don't have a local machine that is
> capable of reproducing your test results and I have not made any gce
> test appliance images to test this yet, so I'm not sure if this is a
> valid theory.
>

Ted explained that the bug related to very specific timing of flusher
thread vs. fallocate thread.
I was under the impression that CrashMonkey can only reorder writes
between recorded FLUSH requests, so I am not really sure how you intent to
modify CrashMonkey to catch this bug.

Cheers,
Amir.
