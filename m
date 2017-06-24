From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 20:24:54 -0400
Message-ID: <20170624002454.wjieb3ppvljumzzj@thunk.org>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
 <20170623122603.jmvyw4oqkojcapv3@thunk.org>
 <C37CE24B-A6E7-4B65-B0C4-4965B3C45007@dilger.ca>
 <CACGdZYJb4ouFMORaMTM5KubJv_SFpms35fXrTdAK0kxsa7-5Cg@mail.gmail.com>
 <20170623232616.r3ffksjntjfbrzgb@thunk.org>
 <54BEB476-F6E0-4421-B381-92442457910F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Khazhismel Kumykov <khazhy@google.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54BEB476-F6E0-4421-B381-92442457910F@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 23, 2017 at 05:34:23PM -0600, Andreas Dilger wrote:
> 
> Sure, but that is a problem independent of the readdir case I think?

This is lookup case not the readdir case....

> Wouldn't it just make sense to mount the filesystem with "errors=remount-ro"
> or "errors=panic" in your case, where you can give up on a single node
> easily if it detects device-level errors, rather than "errors=continue" as
> it seems you currently have?  This is what we do in HA environments, and
> fail the storage over to a backup server in case the problem is with the
> node, SCSI cards, cables, etc. and not the disk (preventing further automatic
> failback to prevent node ping-pong if there is actually a media error).

"errors=remount-ro" doesn't really help when it ends up tieing up
process doing the lookup for long periods of time.

"errors=panic" isn't helpful if you have a large number of file
systems mounted.  The system might have dozens of disks mounted (as
individual file systems) on a file server, or there might be even more
networked-block devices mounted on a container-oriented job server.
So you really don't want to blow away a node with a reboot just
because errors are found on a single device or network device.

In such an environment it might be far more appropriate to return an
error to userspace with dispatch, and trust userspace to take the
appropriate recovery steps.

					- Ted
