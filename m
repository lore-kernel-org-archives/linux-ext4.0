From: Arthur Jones <ajones@riverbed.com>
Subject: Re: ext3: slow symlink corruption on umount...
Date: Fri, 31 Oct 2008 10:24:46 -0700
Message-ID: <20081031172446.GC8333@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081030174057.GB7926@ajones-laptop.nbttech.com> <4909F705.8090904@redhat.com> <20081030213400.GA28900@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sct@redhat.com" <sct@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.riverbed.com ([206.169.144.7]:14867 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYJaRYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 13:24:47 -0400
Content-Disposition: inline
In-Reply-To: <20081030213400.GA28900@ajones-laptop.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 30, 2008 at 02:34:00PM -0700, Arthur Jones wrote:
> Hi Eric,  ...
> 
> On Thu, Oct 30, 2008 at 11:03:49AM -0700, Eric Sandeen wrote:
> > [...]
> > Something is definitely racy here; in my simple testcase I get failures
> > maybe 30-50% of the time...
> 
> Some more info: in the working case, the inodes are put
> back on sb->s_dirty at then next ext3_sync_fs() call:
> 
> __fsync_super -> DQUOT_SYNC -> ext3_sync_fs -> log_wait_commit
> 
> In the failing case, journal_start_commit returns 0 in ext_sync_fs
> and the inodes disappear into never-never land...

More details, these are dumps at __log_start_commit in the
call chain described above, the first column is the failing
case, the next column is working case, t_expires is the delta
from the time the dump was taken:

        journal->j_flags                                0x10    0x10
        journal->j_tail_sequence                         515     519
        journal->j_transaction_sequence                  517     522
        journal->j_commit_sequence                       514     519
        journal->j_commit_request                        516     520

        journal->j_running_transaction->t_tid            516     521
        journal->j_running_transaction->t_state            0       0
        journal->j_running_transaction->t_updates          0       0
        journal->j_running_transaction->t_handle_count 27305   27344
        journal->j_running_transaction->t_expires       -566      28

Can you tell from this whether the transactions
are messed up or whether we're just missing a
wake_up?  Any other info you'd like to see?

Arthur
