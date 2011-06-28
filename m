From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 3/4] Ext4: handle SEEK_HOLE/SEEK_DATA generically
Date: Tue, 28 Jun 2011 13:34:37 -0400
Message-ID: <4E0A10AD.3040905@redhat.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-3-git-send-email-josef@redhat.com> <40B8FEA5-D240-45CE-A903-946922CF449C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591Ab1F1Rek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jun 2011 13:34:40 -0400
In-Reply-To: <40B8FEA5-D240-45CE-A903-946922CF449C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/28/2011 12:29 PM, Andreas Dilger wrote:
> On 2011-06-28, at 9:33 AM, Josef Bacik wrote:
>> Since Ext4 has its own lseek we need to make sure it handles
>> SEEK_HOLE/SEEK_DATA.  For now just do the same thing that is done in the generic
>> case, somebody else can come along and make it do fancy things later.  Thanks,
> 
> Josef,
> are you planning to add an ext4-based version of this in the future?
> Another possibility is to have a generic SEEK_{DATA,HOLE} -> FIEMAP
> converter, since there are several filesystems that already support
> FIEMAP (ext3, ext4, etc).

Probably not, I'm pretty tied up in Btrfs work.  I had thought about
doing a generic one that used fiemap but that's a lot of work and I'm
lazy :).  Plus everybody who does fiemap all have different answers on
what is a hole.  For example btrfs can safely say prealloc'ed space is a
hole, but xfs can't (and I *think* ext4 can't either but I'm not sure).
 So I figured just leaving it up to each individual fs'es instead of
hobbling together a generic fiemap->seek_hole/data translator was more
prudent, especially since everybody will eventually want to do their own
thing.  Thanks,

Josef
