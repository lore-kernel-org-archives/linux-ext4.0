From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Wed, 8 Jun 2011 12:19:53 -0400
Message-ID: <BANLkTikZh5W3YBinhern54VtwUsu7aT91g@mail.gmail.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
 <alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>
 <BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com> <alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>
 <BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com> <alpine.LFD.2.00.1106081716200.6609@dhcp-27-109.brq.redhat.com>
 <BANLkTikfMJP70pWO5RQ1qyf=SU6WUwDUQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org, sandeen@redhat.com
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1FHQUP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 12:20:15 -0400
In-Reply-To: <BANLkTikfMJP70pWO5RQ1qyf=SU6WUwDUQw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 8, 2011 at 11:59 AM, Amir G. <amir73il@users.sourceforge.net> wrote:
> On Wed, Jun 8, 2011 at 6:38 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> Amir said:

>>> The question of whether the world needs ext4 snapshots is
>>> perfectly valid, but going back to the food analogy, I think it's
>>> a case of "the proof of the pudding is in the eating".
>>> I have no doubt that if ext4 snapshots are merged, many people will use it.
>>
>> Well, I would like to have your confidence. Why do you think so ? They
>> will use it for what ? Doing backups ? We can do this easily with LVM
>> without any risk of compromising existing filesystem at all. On desktop
>
> LVM snapshots are not meant to be long lived snapshots.
> As temporary snapshots they are fine, but with ext4 snapshots
> you can easily retain monthly/weekly snapshots without the
> need to allocate the space for it in advance and without the
> 'vanish' quality of LVM snapshots.

In that old sf.net wiki you say:
Why use Next3 snapshots and not LVM snapshots?
* Performance: only small overhead to write performance with snapshots

Fair claim against current LVM snapshot (but not multisnap).

In this thread you're being very terse on the performance hit you
assert multisnap has that ext4 snapshots does not.  Can you please be
more specific?

In your most recent post it seems you're focusing on "LVM snapshots"
and attributing the deficiencies of old-style LVM snapshots
(non-shared exception store causing N-way copy-out) to dm-multisnap?

Again, nobody will dispute that the existing dm-snapshot target has
poor performance that requires snapshots be short-lived.  But
multisnap does _not_ suffer from those performance problems.

Mike
