From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Tue, 12 Apr 2011 23:41:25 +0200
Message-ID: <4DA4C705.9060502@fastmail.fm>
References: <1302631493-9778-1-git-send-email-johann@whamcloud.com> <4DA4B885.6020004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Johann Lombardi <johann@whamcloud.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@whamcloud.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50856 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932568Ab1DLVl1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Apr 2011 17:41:27 -0400
In-Reply-To: <4DA4B885.6020004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/12/2011 10:39 PM, Eric Sandeen wrote:
> On 4/12/11 1:04 PM, Johann Lombardi wrote:
>> Prevent an ext4 filesystem from being mounted multiple times. A
>> sequence number is stored on disk and is periodically updated
>> (every 5 seconds by default) by a mounted filesystem. At mount
>> time, we now wait for s_mmp_update_interval seconds to make sure 
>> that the MMP sequence does not change. In case of failure, the
>> nodename, bdevname and the time at which the MMP block was last
>> updated is displayed.
>> 
>> Signed-off-by: Andreas Dilger <adilger@whamcloud.com> 
>> Signed-off-by: Johann Lombardi <johann@whamcloud.com> --- 
>> fs/ext4/ext4.h  |   56 ++++++++- fs/ext4/super.c |  363
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++- 2 files
>> changed, 416 insertions(+), 3 deletions(-)
>> 
> 
> There was a lot of skepticism about this last time, and I imagine
> there still is...
> 
> 400 new lines of kernel code for this, and if the other machine is
> hung up for 5 seconds and doesn't update, it can still be
> multiply-mounted anyway, right?
> 
> BUG: soft lockup - CPU#0 stuck for 10s! anyone?  :(

Please see my other comment about the two different intervals. Yes,
there is a minimal chance of a race. But firstly, 5s are too small,
already for performance reasons (setting the update-interval to 5s will
increase the min check-interval to 25s). Secondly, the mount-wait time is

+	wait_time = min(mmp_check_interval * 2 + 1,
+			mmp_check_interval + 60);

So even with Johanns patch it is at least 12s.

Thirdly, the check-interval is automatically increased, if updating the
mmp block takes too long. This value will also be saved in the
mmp-block. Of course, it has a disadvantage - the mount time increases.

> 
> I don't see the value in it for upstream ext4, but then hey, ext4
> rarely meets a feature it doesn't like ;)

Is ext4 is only used on desktop systems? IMHO, every HA solution that
does not use scsi reservations or another way to check if a device is
already in use, needs a solution like this. I have seen so many problems
with heartbeat/pacemaker to not properly detect an already mounted
devices (*) and this MMP patch already protected so many HA Lustre
installations from data corruption due to double mounts....
So why shouldn't other HA solutions benefit from such a nice feature?

Usually, the heartbeat/pacemaker issues to detect if a device is mounted
or not are due to unreliable information if a device is mounted or not.
/etc/mtab is entirely unreliable and /proc/mounts does not always show
if a device is mounted or not.
However, even if that would work somehow perfectly, without the MMP
patch there is still zero protection from user-errors. It can easily
happen an admin forgets about a mounted device and runs e2fsck or
manually mounts the device on another machine again.

So please, let this patch go in.

Thanks,
Bernd
