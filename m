From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Mon, 13 May 2013 05:06:36 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DAE3A4D8@ATLEXMBX4.ARRS.ARRISI.com>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
 <CA+8MBbKHJgnueAurRV1aeeV-NdzRTz_gVwYcJuyDrjJLErtcfg@mail.gmail.com>
 <871u9e6ji1.fsf@openvz.org>
 <CA+8MBbLY1jQCQmBrKdVpihkqFBf93iJKZ7J8E_JXcu9NVeff_w@mail.gmail.com>
 <20130513030712.GC25996@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Theodore Ts'o <tytso@mit.edu>, Tony Luck <tony.luck@gmail.com>,
	"Dmitry Monakhov" <dmonakhov@openvz.org>,
	"eunb.song@samsung.com" <eunb.song@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Bitfields are likely to be implemented using read-modify-write semantics.
Modifications of either b_jlist or b_jmodified must be done under lock
since they share same uint. I guess this lock is missing somewhere.

Regards,
Andrei.

On 12.05.2013 20:07, Theodore Ts'o wrote:
> On Sun, May 12, 2013 at 07:04:45PM -0700, Tony Luck wrote:
>> My git bisect finally competed and points the a finger at:
>>
>> commit ae4647fb7654676fc44a97e86eb35f9f06b99f66
>> Author: Jan Kara <jack@suse.cz>
>> Date:   Fri Apr 12 00:03:42 2013 -0400
>>
>>     jbd2: reduce journal_head size
>>
>>     Remove unused t_cow_tid field (ext4 copy-on-write support doesn't seem
>>     to be happening) and change b_modified and b_jlist to bitfields thus
>>     saving 8 bytes in the structure.
> Both you and Eunbong Song bisected to the same commit, so presumably
> the right thing to do at this point is to revert it.  Have you tried
> reverting the commit and demonstrating that the problem goes away
> afterwards?
>
> The reason why I ask is that I'm completely at a lost to understand
> why this commit could be making a difference.  Loooking at the commit,
> we're converting two unsigned fields, neither of which use more than 4
> bits or 1 bits, respectively, to use bitfields instead.  Why this
> could be causing __journal_remove_journal_head() to fail, especially
> in the way that it does, isn't making any sense to me.  We are
> technically accessing jh->b_jlist without first locking
> jbd2_lock_bh_state(), but (a) it shouldn't make a difference whether
> we use a bitfield or 32-bit unsigned value, and (b) by the time we get
> to __journal_remove_journal_head(), nothing should be using the
> journal head, and we've locked jbd_lock_bh_journal_head(), which
> should prevent any one else from starting to use the journal head.
>
> Applying patch where I don't understand how it would make things
> better, even if it is a revert, scares me.  If we are going to do
> this, and since I haven't yet been able to reproduce it on my testing
> setup, could you try taking Linus's just released 3.10-rc1 release,
> and revert commit ae4647fb765467, and confirm that this avoids the
> crash which you are seeing?
>
> Thanks,
>
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
