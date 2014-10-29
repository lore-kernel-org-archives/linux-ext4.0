From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: RT/ext4/jbd2 circular dependency
Date: Wed, 29 Oct 2014 17:37:03 -0600
Message-ID: <54517A1F.1060102@windriver.com>
References: <544156FE.7070905@windriver.com> <54415991.1070907@pavlinux.ru> <CANGgnMbQmsdMDJUx7Bop9Xs=jQMmAJgWRjhXVFUGx-DwF=inYw@mail.gmail.com> <544940EF.7090907@windriver.com> <alpine.DEB.2.11.1410261516020.5308@nanos> <544E7144.4080809@windriver.com> <alpine.DEB.2.11.1410291854090.5308@nanos> <54513BDA.1050804@windriver.com> <alpine.DEB.2.11.1410292013510.5308@nanos> <20141029231916.GD5000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Austin Schuh <austin@peloton-tech.com>, <pavel@pavlinux.ru>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	<linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>,
	rt-users <linux-rt-users@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20141029231916.GD5000@thunk.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 10/29/2014 05:19 PM, Theodore Ts'o wrote:
> On Wed, Oct 29, 2014 at 08:26:36PM +0100, Thomas Gleixner wrote:
>>> For what it's worth, I'm currently testing a backport of commit b34090e from
>>> mainline (which in turn required backporting commits e5a120a and f5113ef).  It
>>> switches from using the BJ_Shadow list to using the BH_Shadow flag on the
>>> buffer head.  More interestingly, waiters now get woken up from
>>> journal_end_buffer_io_sync() instead of from
>>> jbd2_journal_commit_transaction().
>>>
>>> So far this seems to be helping a lot.  It's lasted about 15x as long under
>>> stress as without the patches.
>>
>> I fear that this is just papering over the problem, but you have to
>> talk to the jbd2 folks about that.
>
> No, it's a clean fix for the problem.  The main issue is that what the
> jbd2 commit was doing was starting inode writeback for those blocks
> needed to guarantee data=ordered mode (so this is what caused various
> pages to have writeback page set) as well as starting metadata writes
> to the commit (which is what caused the shadow bit to be set on the
> metadata buffers).
>
> Now that we clear the shadow flag when the metadata writes is
> complete, the writeback will eventually be allowed to complete and
> this prevents the deadlock.

Thanks for the explanation.

A few questions:

1) Is this something that could hit mainline as well, or just the RT kernel?

2) If it can hit mainline, is this something that should be considered 
for the various longterm-support kernels?  (3.10, maybe 3.4)

3) For 3.4, do you think that it's sufficient to backport the three 
commits I mentioned, or are you aware of others that I should be looking 
at as well?

Chris

