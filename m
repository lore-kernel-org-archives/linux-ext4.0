From: Andi Kleen <andi@halobates.de>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Fri, 07 May 2010 17:12:35 +0200
Message-ID: <87vdaz21b0.fsf@basil.nowhere.org>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>
	<s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>
	<20100504224226.GE6344@thunk.org>
	<p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:48211 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab0EGPMh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 May 2010 11:12:37 -0400
In-Reply-To: <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com> (Amir G.'s message of "Wed, 5 May 2010 04:05:11 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Amir G." <amir73il@users.sourceforge.net> writes:
>
> Yes, of course, I realize that. This is the reason I chose to
> introduce Next3 as a new f/s,
> which was branched from Ext3 and not as a new feature to Ext3.
> Unfortunately, merging Next3 snapshots feature into Ext4 is not an easy task,
> because extent mapped files break the design concepts of Next3 snapshots.

As I understand it the ext4 code base still supports not having
extents enabled in the super block (although I'm not sure how well
that variant is tested in practice)

So in theory you could have a feature that requires disabling extents.

It might not make users very happy though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
