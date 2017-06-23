From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 19:26:16 -0400
Message-ID: <20170623232616.r3ffksjntjfbrzgb@thunk.org>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
 <20170623122603.jmvyw4oqkojcapv3@thunk.org>
 <C37CE24B-A6E7-4B65-B0C4-4965B3C45007@dilger.ca>
 <CACGdZYJb4ouFMORaMTM5KubJv_SFpms35fXrTdAK0kxsa7-5Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Khazhismel Kumykov <khazhy@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACGdZYJb4ouFMORaMTM5KubJv_SFpms35fXrTdAK0kxsa7-5Cg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 23, 2017 at 03:33:46PM -0700, Khazhismel Kumykov wrote:
> 
> Giving up early or checking future blocks both work, critical thing
> here is not returning NULL after seeing a read error.
> Previously to this the behavior was to continue to check future blocks
> after a read error, and it seemed OK.

Whether or not it is OK probably depends on how big the directory is.
If we need to suffer through N long error retries, whether it is
caused by long SCSI error retries, or long iSCSI error retries, sooner
or later it's going to be problematic if the process which is taking
forever to search through the whole directory has a some kind health
monitoring service or other watchdog timer.

Still, I agree that there will be some cases where instead of "Fast
fail", having the file server try as hard as possible fetch the file
from the failing disk is worthwhile.  I tend to be focused on the
cluster file system case where if it's going to several hundred
milliseconds to fetch the file, you're better off getting it from the
one other replicated copies from another server, or start the
reed-solomon reconstruction from.  However, if you have an
architecture where the only copy of the file is on the particular file
server (perhaps because you are depending on RAID instead of n=3
replication or reed-solomon erasure codes), having the file server try
as hard as possible to find the file is a good thing.

I wonder if the right answer is to have "fastfail" and "nofastfail"
mount option.

					- Ted
