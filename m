From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Mon, 3 May 2010 12:47:58 +0300
Message-ID: <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63586 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab0ECJsB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 May 2010 05:48:01 -0400
Received: by bwz19 with SMTP id 19so1179743bwz.21
        for <linux-ext4@vger.kernel.org>; Mon, 03 May 2010 02:47:59 -0700 (PDT)
In-Reply-To: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 18, 2010 at 6:41 PM, Amir G. wrote:
> Hi All,
>
> For over a year, Next3 has been developed in-house by CTERA networks,
> as part of its NAS appliances.
> Now that the appliances are out in the market, Next3 project can
> finally be shared with the world.
>
> Main Next3 features:
> - Backward and forward compatible with Ext3
> - Incremental, volume level, read-only snapshots
> - Snapshots use available file system disk space
> - Snapshot deletion frees up disk space
> - Retains Ext3 stability including journaling and fsck
> - Minimal performance overhead (in average usage scenarios)
> - No upper limit on number or size of snapshots
>
> Please visit Next3 wiki page:
> http://sourceforge.net/apps/mediawiki/next3/
>
> Next3 project is looking for code reviewers, beta testers and public attention.
>
> Would love to read your comments on Next3-users mailing list:
> https://lists.sourceforge.net/lists/listinfo/next3-users
>
> Amir.
>

Hi Ted,

Next3 project was introduced 2 weeks ago. I hope you've had a chance
to visit the wiki page.

Since the snapshot support patches do not fall into standard patch
categories (feature/bug fix),
I would like to request your advise on the best way to move forward
with code review.

There are 2 patch series available for download from:
http://sourceforge.net/projects/next3/files/Latest%20patch%20series

e2fsprogs-1.41.11-next3-020510_patches.tar.gz contains a "small and
simple" patch series (1350 lines/8 patches),
which adds Next3 snapshots awareness to e2fsprogs.

next3_snapshot-020510_patches.tar.gz contains a "large and complex"
patch series (7000 lines/38 patches),
which adds Next3 built-in snapshots support to an Ext3 clone.

In my opinion, accepting the Next3 patches to e2fsprogs makes sense
for 3 reasons:
1. It is "small and simple" (mostly harmless).
2. It will help finalizing the Next3 on-disk format, so the sooner the better.
3. It will be of service for all those who would like to start
using/testing Next3 and still want to be up-to-date with latest
e2fsprogs.

Please let me know what you think.
Your blessing means a lot to me (and to potential reviewers I should hope so).

And now for a few personal requests from the list:
- For those of you who didn't visit the wiki yet, please find the time
to visit, it is very friendly.
- For those of you who have read the wiki and found it interesting (or
not), please send me some comments to feed my ego (or not).
- For those of you who will be willing to pick up one of the code
review gloves above (small or large size), please let me know if you
need anything else from me and I will provide.

Thanks in advance,
Amir.
