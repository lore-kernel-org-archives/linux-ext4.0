From: Mike Galbraith <bitbucket@online.de>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Mon, 13 May 2013 07:18:26 +0200
Message-ID: <1368422306.5774.70.camel@marge.simpson.net>
References: <7032562.14371368411664268.JavaMail.weblogic@epml07>
	 <CA+8MBb+51dMaYQd-g-T40+UstbxsSbmewSXiUfNDrVouSA3=Zw@mail.gmail.com>
	 <20130513033655.GE25996@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Tony Luck <tony.luck@gmail.com>, eunb.song@samsung.com,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130513033655.GE25996@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2013-05-12 at 23:36 -0400, Theodore Ts'o wrote: 
> On Sun, May 12, 2013 at 08:11:59PM -0700, Tony Luck wrote:
> > 
> > My best guess as to why this commit causes problems is that there are places
> > where updates to individual fields in this structure used to be independent
> > because they were to whole words.  Now we have bitfileds there are races
> > between access to different fields in the same word.
> 
> Yeah, except we access the fields while holding a lock.... wait a
> minute.  We're using bit_spinlocks().... and am I missing something?
> 
> Where are the barrier statements to prevent the CPU or the compiler
> from reordering statements around bit_spin_lock()?  But if that's the
> problem, I would have expected lots of other things to be broken.

Those use test_and_set_bit(), which per Paul McMemory-Wizard...

ATOMIC OPERATIONS
-----------------

Whilst they are technically interprocessor interaction considerations, atomic
operations are noted specially as some of them imply full memory barriers and
some don't, but they're very heavily relied on as a group throughout the
kernel.

Any atomic operation that modifies some state in memory and returns information
about the state (old or new) implies an SMP-conditional general memory barrier
(smp_mb()) on each side of the actual operation (with the exception of
explicit lock operations, described later).  These include:

        xchg();
        cmpxchg();
        atomic_xchg();
        atomic_cmpxchg();
        atomic_inc_return();
        atomic_dec_return();
        atomic_add_return();
        atomic_sub_return();
        atomic_inc_and_test();
        atomic_dec_and_test();
        atomic_sub_and_test();
        atomic_add_negative();
        atomic_add_unless();    /* when succeeds (returns 1) */
        test_and_set_bit();
        test_and_clear_bit();
        test_and_change_bit();
