From: Sodagudi Prasad <psodagud@codeaurora.org>
Subject: Re: Remounting filesystem read-only
Date: Fri, 27 Jul 2018 12:26:25 -0700
Message-ID: <e9869d6cd358e9de395d730ab7b3aa60@codeaurora.org>
References: <366cf3ac534bbadaaa61714a43006ac7@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca, wen.xu@gatech.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <366cf3ac534bbadaaa61714a43006ac7@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2018-07-26 18:04, Sodagudi Prasad wrote:
> Hi All,
> 

+linux-kernel@vger.kernel.org list.

Hi All,

Observing the following issue with one of the partition on android 
device with 4.14.56 kernel.  When I try to remount this partition using 
the command - mount -o rw,remount /vendor/dsp, it is remounting as 
read-only.

[  191.364358] EXT4-fs error (device sde9): ext4_has_uninit_itable:3108: 
comm mount: Inode table for bg 0 marked as needing zeroing
[  191.364762] Aborting journal on device sde9-8.
[  191.365226] EXT4-fs (sde9): Remounting filesystem read-only
[  191.365232] EXT4-fs (sde9): re-mounted. Opts: data=ordere

If I revert this commit [1] -"ext4: only look at the bg_flags field if 
it is valid", the issue is not observed. It is just giving following 
warning message.
[1] - https://patchwork.ozlabs.org/patch/929239/.

[  123.373456] EXT4-fs (sde9): warning: mounting fs with errors, running 
e2fsck is recommended
[  123.389649] EXT4-fs (sde9): re-mounted. Opts: data=ordered

Can you provide some inputs what could be the issue with this partition?

> Observing the following issue with one of the partition on android
> device with 4.14.56 kernel.  When I try to remount this partition
> using the command - mount -o rw,remount /vendor/dsp, it is remounting
> as read-only.
> 
> [  191.364358] EXT4-fs error (device sde9):
> ext4_has_uninit_itable:3108: comm mount: Inode table for bg 0 marked
> as needing zeroing
> [  191.364762] Aborting journal on device sde9-8.
> [  191.365226] EXT4-fs (sde9): Remounting filesystem read-only
> [  191.365232] EXT4-fs (sde9): re-mounted. Opts: data=ordere
> 
> If I revert this commit [1] -"ext4: only look at the bg_flags field if
> it is valid", the issue is not observed. It is just giving following
> warning message.
> [1] - https://patchwork.ozlabs.org/patch/929239/.
> 
> [  123.373456] EXT4-fs (sde9): warning: mounting fs with errors,
> running e2fsck is recommended
> [  123.389649] EXT4-fs (sde9): re-mounted. Opts: data=ordered
> 
> Can you provide some inputs what could be the issue with this 
> partition?
> 
> -Thanks, Prasad

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
Linux Foundation Collaborative Project
