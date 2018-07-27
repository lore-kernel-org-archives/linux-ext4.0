From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Remounting filesystem read-only
Date: Fri, 27 Jul 2018 15:52:13 -0400
Message-ID: <20180727195213.GE13922@thunk.org>
References: <366cf3ac534bbadaaa61714a43006ac7@codeaurora.org>
 <e9869d6cd358e9de395d730ab7b3aa60@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, wen.xu@gatech.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sodagudi Prasad <psodagud@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9869d6cd358e9de395d730ab7b3aa60@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2018 at 12:26:25PM -0700, Sodagudi Prasad wrote:
> On 2018-07-26 18:04, Sodagudi Prasad wrote:
> > Hi All,
> > 
> 
> +linux-kernel@vger.kernel.org list.
> 
> Hi All,
> 
> Observing the following issue with one of the partition on android device
> with 4.14.56 kernel.  When I try to remount this partition using the command
> - mount -o rw,remount /vendor/dsp, it is remounting as read-only.
> 
> [  191.364358] EXT4-fs error (device sde9): ext4_has_uninit_itable:3108:
> comm mount: Inode table for bg 0 marked as needing zeroing
> [  191.364762] Aborting journal on device sde9-8.
> [  191.365226] EXT4-fs (sde9): Remounting filesystem read-only
> [  191.365232] EXT4-fs (sde9): re-mounted. Opts: data=ordere
> 
> If I revert this commit [1] -"ext4: only look at the bg_flags field if it is
> valid", the issue is not observed. It is just giving following warning
> message.
> [1] - https://patchwork.ozlabs.org/patch/929239/.
> 
> [  123.373456] EXT4-fs (sde9): warning: mounting fs with errors, running
> e2fsck is recommendedt
> [  123.389649] EXT4-fs (sde9): re-mounted. Opts: data=ordered
> 
> Can you provide some inputs what could be the issue with this partition?

The error should be pretty clear: "Inode table for bg 0 marked as
needing zeroing".  That should never happen.  The warning "mounting fs
with errors" means the file system was corrupted.  The commit is now
telling more about how the file system was corrupted, and is
protecting you from further data loss.  (You shoud never, ever, ever,
allow a file system to be mounted read/write with corruptions.  The
file system should have been checked using fsck.ext4, aka e2fsck,
before the file system was allowed to be mounted.)

       	   	       	   	      - Ted
