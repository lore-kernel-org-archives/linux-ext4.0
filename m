Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58553 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727341AbeK1TCy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 14:02:54 -0500
Reply-To: grendel@twistedcode.net
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Andrey Jr. Melnikov" <temnota.am@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <b43fb902-9b64-22d9-25ca-c970b3842a43@roeck-us.net>
 <vb31df-25g.ln1@banana.localnet> <20181128041555.GE31885@thunk.org>
From: Marek Habersack <grendel@twistedcode.net>
Message-ID: <5d21196e-15d5-3351-e431-576d3640387f@twistedcode.net>
Date: Wed, 28 Nov 2018 09:02:05 +0100
MIME-Version: 1.0
In-Reply-To: <20181128041555.GE31885@thunk.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 28/11/2018 05:15, Theodore Y. Ts'o wrote:
> On Wed, Nov 28, 2018 at 03:16:33AM +0300, Andrey Jr. Melnikov wrote:
>> Corrupted inodes - always directory, not touched at least year or
>> more for writing. Something wrong when updating atime?
I've just seen the errors come back despite having MQ off :( However, this time it took 5 days for them to come back, so
MQ must play a role here. Also, indeed, they happened after fstrim ran and this time *only* on the SSD disks reported
below, another clue? This time the errors were "just" orphaned inodes + invalid free inode counts, all repaired without
issues by fsck.

> 
> We're not sure.  The frustrating thing is that it's not reproducing
> for me.  I run extensive regression tests, and I'm using 4.19 on my
> development laptop without notcing any problems.  If I could reproduce
> it, I could debug it, but since I can't, I need to rely on those who
> are seeing the problem to help pinpoint the problem.
> 
> I'm trying to figure out common factors from those people who are
> reporting problems.
> 
> (a) What distribution are you running (it appears that many people
> reporting problems are running Ubuntu, but this may be a sampling
> issue; lots of people run Ubuntu)?  (For the record, I'm using Debian
> Testing.)
Ubuntu 18.10 here

> 
> (b) What hardware are you using?  (SSD?  SATA-attached?
> NVMe-attached?)
The errors occured on both SSD:
  - Samsung SSD 850 EVO 1TB, firmware rev EMT03B6Q
  - OCZ-AGILITY3, firmware rev 2.25

and spinning rust:
  - Seagate ST2000DX001-1CM164, firmware revision CC43

> 
> (c) Are you using LVM?  LUKS (e.g., disk encrypted)?
LUKS. Both the Samsung and the Seagate use DM for encryption.

> (d) are you using discard?  One theory is a recent discard change may
> be in play.   How do you use discard?   (mount option, fstrim, etc.)
fstrim runs weekly and the Samsung SSD is mounted with

   rw,nosuid,nodev,noatime,discard,helper=crypt

marek
> 
>       	      	     	     		- Ted
> 
