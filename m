From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Fri, 31 Oct 2008 13:37:24 -0500
Message-ID: <490B5064.2000506@redhat.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081030174057.GB7926@ajones-laptop.nbttech.com> <4909F705.8090904@redhat.com> <20081030213400.GA28900@ajones-laptop.nbttech.com> <20081031172446.GC8333@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arthur Jones <ajones@riverbed.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753451AbYJaShm@vger.kernel.org>
In-Reply-To: <20081031172446.GC8333@ajones-laptop.nbttech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Arthur Jones wrote:
> On Thu, Oct 30, 2008 at 02:34:00PM -0700, Arthur Jones wrote:
>> Hi Eric,  ...
>>
>> On Thu, Oct 30, 2008 at 11:03:49AM -0700, Eric Sandeen wrote:
>>> [...]
>>> Something is definitely racy here; in my simple testcase I get failures
>>> maybe 30-50% of the time...
>> Some more info: in the working case, the inodes are put
>> back on sb->s_dirty at then next ext3_sync_fs() call:
>>
>> __fsync_super -> DQUOT_SYNC -> ext3_sync_fs -> log_wait_commit
>>
>> In the failing case, journal_start_commit returns 0 in ext_sync_fs
>> and the inodes disappear into never-never land...
> 
> More details, these are dumps at __log_start_commit in the
> call chain described above, the first column is the failing
> case, the next column is working case, t_expires is the delta
> from the time the dump was taken:
> 
>         journal->j_flags                                0x10    0x10
>         journal->j_tail_sequence                         515     519
>         journal->j_transaction_sequence                  517     522
>         journal->j_commit_sequence                       514     519
>         journal->j_commit_request                        516     520
> 
>         journal->j_running_transaction->t_tid            516     521
>         journal->j_running_transaction->t_state            0       0
>         journal->j_running_transaction->t_updates          0       0
>         journal->j_running_transaction->t_handle_count 27305   27344
>         journal->j_running_transaction->t_expires       -566      28
> 
> Can you tell from this whether the transactions
> are messed up or whether we're just missing a
> wake_up?  Any other info you'd like to see?

That's kind of along the lines of what I'm seeing; also, in particular,
I'm never seeing the buffer_head in question (the one for the block
which contains the slow link's data) transition from jbddirty to normal
BH_Dirty.  I've had to take a break from this today, but will be back at
it a bit later... since I have a solid testcase I'm sure I'll get to the
bottom of it ... :)  I'll probably hook up akpm's buffer tracing
infrastructure, just need to find a decent thing to trigger on to dump
out the history.

-Eric
