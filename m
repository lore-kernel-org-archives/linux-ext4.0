From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Need of revoke mechanism in JBD
Date: Sun, 1 May 2011 18:28:13 -0400
Message-ID: <20110501222813.GD2819@thunk.org>
References: <4DB68257.4070407@gmail.com>
 <BANLkTikuNB8m3-X8BXVcL2OCqQiZwRCbQA@mail.gmail.com>
 <BANLkTikV4nU4Zc4OxNa6q8wDtM7cLUF_ig@mail.gmail.com>
 <20110426122558.GF9486@thunk.org>
 <BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ding Dinghua <dingdinghua85@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Niraj Kulkarni <kulkarniniraj14@gmail.com>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53883 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab1EAW2O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 May 2011 18:28:14 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTin35yOg+ndy3i4vTT7RHxtFso+HCA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 29, 2011 at 10:45:23PM +0300, Amir Goldstein wrote:
> 
> Actually, the original paper has no mention of revoke records.
> I went out to look for useful documentation on journal forget/revoke
> and came back empty handed as well.

Stephen Tweedie gave a talk back in 2000 which covered revoke records.
There's a transcript of his talk here:

http://olstrans.sourceforge.net/release/OLS2000-ext3/OLS2000-ext3.html

The link to the audio file of the talk is dead, but I managed to find
a copy of the mp3 file on Google.  To make sure it doesn't get lost
I've made a copy of it.  The original and the copy can be found at:

http://ftp.gnumonks.org/pub/congress-talks/ols2000/high/cd1/2000-07-20_15-05-22_A_64.mp3
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/presentations/2000-07-20_15-05-22_A_64.mp3

						- Ted
