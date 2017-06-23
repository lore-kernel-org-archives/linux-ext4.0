From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Fri, 23 Jun 2017 08:26:03 -0400
Message-ID: <20170623122603.jmvyw4oqkojcapv3@thunk.org>
References: <20170622232307.48392-1-khazhy@google.com>
 <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Khazhismel Kumykov <khazhy@google.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 23, 2017 at 12:33:02AM -0600, Andreas Dilger wrote:
> On Jun 22, 2017, at 22:43, Theodore Ts'o <tytso@mit.edu> wrote:
> > 
> >> On Thu, Jun 22, 2017 at 04:23:07PM -0700, Khazhismel Kumykov wrote:
> >> Previously, a read error would be ignored and we would eventually return
> >> NULL from ext4_find_entry, which signals "no such file or directory". We
> >> should be returning EIO.
> >> 
> >> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > 
> > Thanks, applied.
> 
> I don't necessarily agree that this is an improvement. 
> 
> If the requested entry is not in the bad block, this will return an
> error even if the file name could be found in another block. It
> would be better to save the error until the end and only return -EIO
> if the entry cannot be found.

The problem is that if we continue, successive reads may all take
seconds or minutes to fail, thus tieing up the process for a long
time.  If this process happens to be, say, the node's Kubernetes
management server it can take down the entire node (since if there is
a watchdog daemon which assumes that if the management server is down,
it's time to kill and reset the entire node), and the file system is,
say, a network file system error which should only kill the individual
job, and not the entire node, the results could be quite unfortunate.

By returning EIO right away, we can "fast fail".

   	     	       	     	    - Ted
