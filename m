From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Tue, 12 Apr 2011 17:08:43 -0400
Message-ID: <8F0B6BB7-1EBA-4233-9B0E-6E63B290AB27@whamcloud.com>
References: <1302631493-9778-1-git-send-email-johann@whamcloud.com> <4DA4B885.6020004@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Johann Lombardi <johann@whamcloud.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56126 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab1DLVIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 17:08:49 -0400
Received: by qwk3 with SMTP id 3so4116535qwk.19
        for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2011 14:08:48 -0700 (PDT)
In-Reply-To: <4DA4B885.6020004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-12, at 4:39 PM, Eric Sandeen wrote:
> On 4/12/11 1:04 PM, Johann Lombardi wrote:
>> Prevent an ext4 filesystem from being mounted multiple times.
>> A sequence number is stored on disk and is periodically updated (every 5
>> seconds by default) by a mounted filesystem.
>> At mount time, we now wait for s_mmp_update_interval seconds to make sure
>> that the MMP sequence does not change.
>> In case of failure, the nodename, bdevname and the time at which the MMP
>> block was last updated is displayed.
>> 
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
>> Signed-off-by: Johann Lombardi <johann@whamcloud.com>
>> ---
>> fs/ext4/ext4.h  |   56 ++++++++-
>> fs/ext4/super.c |  363 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>> 2 files changed, 416 insertions(+), 3 deletions(-)
>> 
> 
> There was a lot of skepticism about this last time, and I imagine there still is...
> 
> 400 new lines of kernel code for this, and if the other machine is hung up for 5 seconds and doesn't update, it can still be multiply-mounted anyway, right?
> 
> BUG: soft lockup - CPU#0 stuck for 10s! anyone?  :(

No, that isn't true, or the whole patch would be completely useless...

If the owning node is blocked for longer than the update interval then the kmmpd thread will detect this (it tracks the last time the IO was completed) it will attempt to "re-acquire" the MMP block (read, wait, re-read, update-if-unchanged) or mark the filesystem in error (mounted with errors={remount-ro,panic} to block the node from accessing the filesystem again.

Note also that MMP isn't intended to be a primary HA failover manager (i.e. having all nodes trying to mount a shared filesystem and depending on MMP to decide on a winner), but rather as a failsafe for broken HA managers that may fail due to many reasons, as we have found in the past (STONITH failure, admin mounting on backup node, mounting fs while e2fsck is running, broken HA scripts, etc).

> I don't see the value in it for upstream ext4, but then hey, ext4 rarely meets a feature it doesn't like ;)

While it is true that this is 400 lines of code, the only change to the main codepath is a few lines at mount/remount/unmount to start/stop the kmmpd thread.  The risk of this causing any problem for someone not using MMP is virtually non-existent, IMHO.


Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



