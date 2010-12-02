From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PARCH 0/1 RFC] e2image: Add support for QCOW2 image format
Date: Thu, 2 Dec 2010 12:03:31 +0200
Message-ID: <AANLkTinf9Ww8hA+i2pxJLwx-zzPdvN-t=UWrEe3CogAm@mail.gmail.com>
References: <1291225309-10750-1-git-send-email-lczerner@redhat.com>
	<AANLkTinkZeBPxazH3MxKcXhxQ+7P00dfus-1WrAR12bG@mail.gmail.com>
	<alpine.LFD.2.00.1012020916490.2874@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, adilger@dilger.ca, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55247 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0LBKDc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Dec 2010 05:03:32 -0500
Received: by qyk11 with SMTP id 11so3735300qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Dec 2010 02:03:31 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1012020916490.2874@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 2, 2010 at 10:23 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Wed, 1 Dec 2010, Amir Goldstein wrote:
>
>> On Wed, Dec 1, 2010 at 7:41 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> >
>> > QCOW2 format supports other neat features like compression, encryption and
>> > snapshots. None of those feature are supported in this patch and the question
>> > is, do we need it ? I can imagine for example snapshots to be useful for
>> > roll-back changes made by e2fsck, but this is hardly problem of e2image itself.
>> >
>> > So, please look at the patch, try it and let me know what else you thing is
>> > useful to implement, or what would you like to change.
>> >
>>
>> Hi Lukas,
>>
>> This is very cool :-)
>> My wish is to export next3/ext4 snapshots as qcow2 snapshots.
>> I actually thought of implementing e2image -x <snapid> as a way to
>> export a snapshot image,
>> but using qcow2, file system can be exported with all of it's snapshots.
>> It should be quite trivial since next3 snapshots contain a map of changed blocks
>> and I suppose qcow2 snapshots should be the same.
>> Now I only need to find the time to do it...
>>
>> Amir.
>
> Hi Amir,
>
> I seems like a cool feature, so when QCOW2 infrastructure is in place
> adding snapshots to it should not be a big deal (not that QCOW2
> infrastructure is :)), however I was wondering are you planning to
> export only metadata, or even data itself ?
>

There are 2 applications I can think of for exporting snapshots.
One needs only the metadata and the other requires the data as well.

1. Rollback to snapshot (metadata only)
----------------------------------------------------------
Unlike ZFS/Btrfs, there is no inherent way to "rollback to snapshot"
with Ext4 snapshots.
Instead, all changed metadata needs to be copied over from snapshot.
The only plausible way to do this is to un-mount the file system (or
re-mount read-only),
use e2image to export a metadata image of a snapshot to a different
location and then
overwrite the filesystem with snapshot metadata (data blocks are
already in-place).

This method can be applied today, even without qcow2 support, but with
qcow2 snapshots,
you can generate a single e2image, which can be used to rollback to
any snapshot and to
restore the original filesystem (as long as the rolled back version
wasn't modifed).

2. Filesystem replication (data + metadata)
--------------------------------------------------------------
This application is inspired by ZFS replication:
http://wikitech-static.wikimedia.org/articles/z/f/s/Zfs_replication.html
The idea is to start with a remote replica by transferring a full copy
of snapshot N1
and then push incremental differences N1..N2 to roll the replica to snapshot N2.
So if e2image has the ability to export a full snapshot image (including data)
and the capability to export incremental qcow2 snapshots, those could
be transferred
to the remote location and be used to create and update the replicated
filesystem.

So to answer your original question ("what else you thing is useful to
implement"),
e2image -d would be nice (export data blocks).

Amir.
