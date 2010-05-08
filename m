From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sun, 9 May 2010 00:56:11 +0200
Message-ID: <AANLkTilwa_j51pzHXJwa9rWQWrBUbxWbt9LGCVqoH1-d@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
	 <20100504224226.GE6344@thunk.org>
	 <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>
	 <87vdaz21b0.fsf@basil.nowhere.org>
	 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>
	 <4BE4855E.40808@redhat.com>
	 <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
	 <4BE55E49.5000006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@halobates.de>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40846 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0EHW4N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 May 2010 18:56:13 -0400
Received: by bwz19 with SMTP id 19so1151990bwz.21
        for <linux-ext4@vger.kernel.org>; Sat, 08 May 2010 15:56:11 -0700 (PDT)
In-Reply-To: <4BE55E49.5000006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 8, 2010 at 2:51 PM, Ric Wheeler wrote:
> On 05/08/2010 01:43 AM, Amir G. wrote:
>
> As Ted mentioned in his reply, the big concern is that you are forking ext3
> instead of adding a new feature to the end of the ext* family of file
> systems.
>

That is a valid concern, but this is where Next3 stands today.
There is no intention of replacing Ext4 with Next4  as the leading ext* f/s.
The branch from Ext3 was made at the time to speed up the development
process of the snapshot feature.

> Since we have multiple snapshot mechanisms in place already (not just btrfs
> & lvm, but don't forget all of the builtin array snapshots), I think that we
> are not in a hurry to get this done quickly. I would strongly prefer we get
> this rebased onto the latest ext4 and resubmitted.
>

If I were you I would also prefer to get snapshots in ext4, and even
snapshots along side extent mapped files,
but unfortunately, I cannot promise to deliver either anytime soon.
I can only promise my support to anyone who wishes to participate in
the merge task.

> As far as proof goes, I think that the unfortunate burden of proof is on
> your shoulders to prove to us that we should take and maintain those new
> features given the often conflicting priorities :-)
>

What can I say, a Windows file server can display previous file
versions without using a costly storage array.
Can a RedHat server do that? Can LVM snapshots be used to do that?
The CTERA NAS appliances do that using Next3.

Amir.
